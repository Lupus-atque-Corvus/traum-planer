import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:record/record.dart';

import 'wakeword_features.dart';
import 'wakeword_matcher.dart';

/// Hört kontinuierlich auf ein zuvor eingesprochenes Aktivierungswort
/// (eigenes Muster-Matching gegen 3 Proben, kein durchgehendes Whisper —
/// siehe Plan "Aktivierungswort für den Sprachassistenten", Abschnitt 1).
///
/// Muss vollständig gestoppt werden, bevor ein anderer Teil der App das
/// Mikrofon belegt (Anfrage-Aufnahme nach einem Treffer, Aufnahme-Dialog
/// in den Einstellungen) — ein Gerät, kein gleichzeitiger Zugriff. Diese
/// Reihenfolge wird vom Lifecycle-Controller in `wakeword_provider.dart`
/// sichergestellt, nicht von dieser Klasse selbst.
class WakeWordService {
  final AudioRecorder _recorder = AudioRecorder();
  StreamSubscription<Uint8List>? _abo;

  List<List<Float64List>> _vorlagenMerkmale = [];
  double _schwellwert = double.infinity;
  int _minFrames = 8;
  int _maxFrames = 300;

  final _treffer = StreamController<void>.broadcast();

  /// Feuert, sobald ein Segment der laufenden Aufnahme als Aktivierungswort
  /// erkannt wurde. Der Aufrufer muss danach [stoppen] rufen, bevor das
  /// Mikrofon anderweitig genutzt wird.
  Stream<void> get treffer => _treffer.stream;

  bool get istAktiv => _abo != null;

  final List<double> _restSamples = [];
  final List<Float64List> _segmentMerkmale = [];
  bool _sprichtGerade = false;
  int _stilleZaehler = 0;

  static const _rmsEinsatzSchwelle = 0.02;
  static const _rmsEndeSchwelle = 0.012;
  static const _stilleFramesBisEnde = 20; // ~200 ms bei 10 ms Hop

  /// Berechnet die Vorlagen-Merkmale aus den aufgenommenen Proben (Roh-
  /// samples, normalisiert auf [-1, 1]) und kalibriert den Schwellwert aus
  /// den paarweisen Abständen der Proben untereinander — siehe Plan,
  /// Abschnitt 1, Punkt 6. [empfindlichkeit] ist ein Nutzer-einstellbarer
  /// Faktor auf diesen Basiswert (kleiner = strenger).
  void vorlagenSetzen(List<Float64List> proben, {required double empfindlichkeit}) {
    _vorlagenMerkmale = proben.map(_merkmaleAusSamples).where((m) => m.isNotEmpty).toList();
    if (_vorlagenMerkmale.isEmpty) {
      _schwellwert = double.infinity;
      return;
    }

    final paarAbstaende = <double>[];
    for (var i = 0; i < _vorlagenMerkmale.length; i++) {
      for (var j = i + 1; j < _vorlagenMerkmale.length; j++) {
        paarAbstaende.add(WakeWordMatcher.distanz(_vorlagenMerkmale[i], _vorlagenMerkmale[j]));
      }
    }
    paarAbstaende.sort();
    final basis = paarAbstaende.isEmpty ? 0.6 : paarAbstaende[paarAbstaende.length ~/ 2];
    _schwellwert = basis * empfindlichkeit;

    final laengen = _vorlagenMerkmale.map((v) => v.length).toList()..sort();
    final median = laengen[laengen.length ~/ 2];
    _minFrames = math.max(8, (median * 0.5).round());
    _maxFrames = (median * 1.8).round() + 30;
  }

  List<Float64List> _merkmaleAusSamples(Float64List samples) {
    final merkmale = <Float64List>[];
    var pos = 0;
    while (pos + WakeWordFeatures.frameSize <= samples.length) {
      merkmale.add(WakeWordFeatures.logMel(
        Float64List.sublistView(samples, pos, pos + WakeWordFeatures.frameSize),
      ));
      pos += WakeWordFeatures.hopSize;
    }
    return merkmale;
  }

  Future<void> starten() async {
    if (istAktiv || _vorlagenMerkmale.isEmpty) return;
    final stream = await _recorder.startStream(const RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: WakeWordFeatures.sampleRate,
      numChannels: 1,
    ));
    _restSamples.clear();
    _segmentMerkmale.clear();
    _sprichtGerade = false;
    _stilleZaehler = 0;
    _abo = stream.listen(_pcmVerarbeiten);
  }

  Future<void> stoppen() async {
    final abo = _abo;
    _abo = null;
    await abo?.cancel();
    if (await _recorder.isRecording()) {
      await _recorder.stop();
    }
  }

  void _pcmVerarbeiten(Uint8List bytes) {
    final byteData = ByteData.sublistView(bytes);
    final anzahlSamples = bytes.length ~/ 2;
    for (var i = 0; i < anzahlSamples; i++) {
      _restSamples.add(byteData.getInt16(i * 2, Endian.little) / 32768.0);
    }

    while (_restSamples.length >= WakeWordFeatures.frameSize) {
      final frame = Float64List.fromList(_restSamples.sublist(0, WakeWordFeatures.frameSize));
      _restSamples.removeRange(0, WakeWordFeatures.hopSize);
      _frameVerarbeiten(frame);
    }
  }

  void _frameVerarbeiten(Float64List frame) {
    final energie = WakeWordFeatures.rms(frame);
    final schwelle = _sprichtGerade ? _rmsEndeSchwelle : _rmsEinsatzSchwelle;
    final spricht = energie > schwelle;

    if (spricht) {
      _sprichtGerade = true;
      _stilleZaehler = 0;
      _segmentMerkmale.add(WakeWordFeatures.logMel(frame));
      if (_segmentMerkmale.length > _maxFrames) {
        _segmentAuswerten();
      }
      return;
    }

    if (!_sprichtGerade) return;

    _stilleZaehler++;
    if (_stilleZaehler >= _stilleFramesBisEnde) {
      _segmentAuswerten();
    } else {
      _segmentMerkmale.add(WakeWordFeatures.logMel(frame));
    }
  }

  void _segmentAuswerten() {
    final segment = List<Float64List>.from(_segmentMerkmale);
    _segmentMerkmale.clear();
    _sprichtGerade = false;
    _stilleZaehler = 0;

    if (segment.length < _minFrames || _vorlagenMerkmale.isEmpty || !istAktiv) return;

    var besterAbstand = double.infinity;
    for (final vorlage in _vorlagenMerkmale) {
      final d = WakeWordMatcher.distanz(segment, vorlage);
      if (d < besterAbstand) besterAbstand = d;
    }

    if (besterAbstand < _schwellwert) {
      _treffer.add(null);
    }
  }

  void dispose() {
    _abo?.cancel();
    _treffer.close();
    _recorder.dispose();
  }
}
