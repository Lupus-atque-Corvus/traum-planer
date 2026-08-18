import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:whisper_ggml/whisper_ggml.dart';

/// Lokales STT (Phase 8): whisper.cpp über `whisper_ggml`, Modell
/// mehrsprachig (`small`), automatische Spracherkennung (`lang: 'auto'`)
/// — Deutsch/Englisch gemischt möglich, kein Umweg über die UI-Sprache.
/// Das Modell wird als Flutter-Asset gebündelt (siehe `tool/fetch_models.sh`
/// und `pubspec.yaml`), beim ersten Zugriff einmalig in ein beschreibbares
/// Verzeichnis kopiert — komplett offline, kein Download zur Laufzeit.
class SttService {
  static const _model = WhisperModel.small;

  // Sehr kurze/nahezu leere Aufnahmen (< ~1.2s) lassen den nativen
  // whisper.cpp-Dekodierschritt in Tests reproduzierbar abstürzen
  // (vermutlich eine Randfall-Division/Indexierung bei sehr wenigen
  // Mel-Frames — ein Bug in der nativen Bibliothek, nicht im App-Code,
  // siehe README). Kürzere Aufnahmen werden defensiv verworfen, statt
  // whisper.cpp überhaupt erst aufzurufen.
  static const _mindestAufnahmedauer = Duration(milliseconds: 1200);

  final WhisperController _controller = WhisperController();
  final AudioRecorder _recorder = AudioRecorder();
  bool _modellBereitgestellt = false;
  DateTime? _aufnahmeStart;

  Future<void> _modellSicherstellen() async {
    if (_modellBereitgestellt) return;
    final zielPfad = await _controller.getPath(_model);
    final zielDatei = File(zielPfad);
    if (!await zielDatei.exists()) {
      final bytes = await rootBundle.load('assets/whisper/ggml-${_model.modelName}.bin');
      await zielDatei.create(recursive: true);
      await zielDatei.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
        flush: true,
      );
    }
    _modellBereitgestellt = true;
  }

  Future<bool> mikrofonBerechtigungVorhanden() => _recorder.hasPermission();

  /// Lautstärke (dBFS) während einer laufenden Aufnahme, für die
  /// automatische Stille-Erkennung des Aktivierungswort-Overlays (siehe
  /// `wakeword_overlay_provider.dart`). Nutzt die bereits vorhandene
  /// `record`-Funktion, keine eigene Implementierung nötig.
  Stream<Amplitude> lautstaerkeStream({Duration intervall = const Duration(milliseconds: 150)}) =>
      _recorder.onAmplitudeChanged(intervall);

  Future<void> aufnahmeStarten() async {
    await _modellSicherstellen();
    final verzeichnis = await getTemporaryDirectory();
    final pfad = '${verzeichnis.path}/traum_planer_aufnahme.wav';
    _aufnahmeStart = DateTime.now();
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.wav, sampleRate: 16000, numChannels: 1),
      path: pfad,
    );
  }

  /// Stoppt die Aufnahme und liefert den erkannten Text zurück (leerer
  /// String, falls nichts verständlich war oder die Aufnahme zu kurz war).
  Future<String> aufnahmeStoppenUndErkennen() async {
    final start = _aufnahmeStart;
    final pfad = await _recorder.stop();
    if (pfad == null) return '';

    if (start != null && DateTime.now().difference(start) < _mindestAufnahmedauer) {
      return '';
    }

    final ergebnis = await _controller.transcribe(
      model: _model,
      audioPath: pfad,
      lang: 'auto',
    );
    return ergebnis?.transcription.text.trim() ?? '';
  }

  Future<void> aufnahmeAbbrechen() async {
    await _recorder.cancel();
  }

  void dispose() {
    _recorder.dispose();
  }
}
