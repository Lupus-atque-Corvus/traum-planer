import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Aufnahme- und Speicher-Logik für die 3 Aktivierungswort-Proben (siehe
/// Plan "Aktivierungswort für den Sprachassistenten", Abschnitt 2).
/// Verwendet einen eigenen kurzlebigen [AudioRecorder], unabhängig von
/// `SttService` — läuft nur, während der Aufnahme-Dialog in den
/// Einstellungen offen ist. Die 1,2-s-Whisper-Absturz-Guard aus
/// `SttService` gilt hier nicht, da nie `whisper_ggml` aufgerufen wird —
/// nur eine eigene, kürzere Mindestdauer für die Aufnahmequalität.
class WakeWordEnrollmentService {
  static const anzahlProben = 3;
  static const _mindestdauer = Duration(milliseconds: 300);

  final AudioRecorder _recorder = AudioRecorder();
  DateTime? _aufnahmeStart;

  Future<bool> mikrofonBerechtigungVorhanden() => _recorder.hasPermission();

  Stream<Amplitude> pegelStream({Duration intervall = const Duration(milliseconds: 150)}) =>
      _recorder.onAmplitudeChanged(intervall);

  Future<Directory> _verzeichnis() async {
    final basis = await getApplicationSupportDirectory();
    final ziel = Directory(p.join(basis.path, 'wakeword'));
    if (!await ziel.exists()) await ziel.create(recursive: true);
    return ziel;
  }

  Future<String> _pfad(int index) async {
    final verzeichnis = await _verzeichnis();
    return p.join(verzeichnis.path, 'sample_$index.wav');
  }

  Future<void> aufnahmeStarten() async {
    _aufnahmeStart = DateTime.now();
    final tempPfad = p.join(
      (await getTemporaryDirectory()).path,
      'traum_planer_wakeword_aufnahme.wav',
    );
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.wav, sampleRate: 16000, numChannels: 1),
      path: tempPfad,
    );
  }

  /// Stoppt die Aufnahme für Probe [index] (1-basiert) und speichert sie
  /// dauerhaft, falls sie lang genug war. Gibt zurück, ob sie übernommen
  /// wurde (`false` bei zu kurzer/leerer Aufnahme — Nutzer sollte es erneut
  /// versuchen, statt eine unbrauchbare Vorlage zu speichern).
  Future<bool> aufnahmeStoppenUndSpeichern(int index) async {
    final start = _aufnahmeStart;
    final quellPfad = await _recorder.stop();
    if (quellPfad == null || start == null) return false;

    final dauer = DateTime.now().difference(start);
    if (dauer < _mindestdauer) return false;

    final zielPfad = await _pfad(index);
    await File(quellPfad).copy(zielPfad);
    return true;
  }

  Future<void> aufnahmeAbbrechen() => _recorder.cancel();

  Future<bool> alleProbenVorhanden() async {
    for (var i = 1; i <= anzahlProben; i++) {
      if (!await File(await _pfad(i)).exists()) return false;
    }
    return true;
  }

  Future<void> probenLoeschen() async {
    final verzeichnis = await _verzeichnis();
    if (await verzeichnis.exists()) {
      await verzeichnis.delete(recursive: true);
    }
  }

  /// Lädt die 3 gespeicherten Proben als normalisierte PCM-Samples (für
  /// `WakeWordService.vorlagenSetzen`). Leere Liste, falls (noch) nicht
  /// alle 3 Proben vorhanden sind.
  Future<List<Float64List>> probenLaden() async {
    final proben = <Float64List>[];
    for (var i = 1; i <= anzahlProben; i++) {
      final datei = File(await _pfad(i));
      if (!await datei.exists()) return [];
      proben.add(_wavLesen(await datei.readAsBytes()));
    }
    return proben;
  }

  /// Minimaler WAV-Parser (PCM16 mono, wie von `AudioEncoder.wav` erzeugt)
  /// — sucht den `data`-Chunk statt einen festen 44-Byte-Header
  /// anzunehmen, robust gegenüber abweichenden Chunk-Reihenfolgen.
  Float64List _wavLesen(Uint8List bytes) {
    final view = ByteData.sublistView(bytes);
    var pos = 12; // nach "RIFF" + Größe + "WAVE"
    while (pos + 8 <= bytes.length) {
      final chunkId = String.fromCharCodes(bytes.sublist(pos, pos + 4));
      final chunkGroesse = view.getUint32(pos + 4, Endian.little);
      final datenStart = pos + 8;
      if (chunkId == 'data') {
        final anzahlSamples = chunkGroesse ~/ 2;
        final samples = Float64List(anzahlSamples);
        for (var i = 0; i < anzahlSamples; i++) {
          if (datenStart + i * 2 + 1 >= bytes.length) break;
          samples[i] = view.getInt16(datenStart + i * 2, Endian.little) / 32768.0;
        }
        return samples;
      }
      pos = datenStart + chunkGroesse + (chunkGroesse.isOdd ? 1 : 0);
    }
    return Float64List(0);
  }

  void dispose() {
    _recorder.dispose();
  }
}
