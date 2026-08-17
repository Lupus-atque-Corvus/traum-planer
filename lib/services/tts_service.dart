import 'dart:io';

/// Lokales TTS (Phase 8): Windows über SAPI (`System.Speech`, per
/// PowerShell-Subprozess — keine zusätzliche native Kompilierung nötig,
/// auf jedem Windows vorinstalliert), Linux über `espeak-ng` als
/// dokumentierte Abhängigkeit (siehe README). Kein Netzwerkzugriff in
/// beiden Fällen.
class TtsService {
  const TtsService();

  bool get istVerfuegbar => Platform.isWindows || Platform.isLinux;

  /// [sprache] 'de' oder 'en' — wählt die passende SAPI-/espeak-Stimme.
  Future<void> sprechen(String text, {required String sprache}) async {
    if (text.trim().isEmpty) return;

    if (Platform.isWindows) {
      await _sapiSprechen(text, sprache);
    } else if (Platform.isLinux) {
      await _espeakSprechen(text, sprache);
    }
  }

  Future<void> _sapiSprechen(String text, String sprache) async {
    final stimmenPraefix = sprache == 'de' ? 'German' : 'English';
    // Einfache PowerShell-Escaping: einfache Anführungszeichen verdoppeln.
    final escaped = text.replaceAll("'", "''");
    final script = '''
Add-Type -AssemblyName System.Speech
\$synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
try {
  \$stimme = \$synth.GetInstalledVoices() |
    Where-Object { \$_.VoiceInfo.Culture.EnglishName -like '*$stimmenPraefix*' } |
    Select-Object -First 1
  if (\$stimme) { \$synth.SelectVoice(\$stimme.VoiceInfo.Name) }
} catch {}
\$synth.Speak('$escaped')
''';
    await Process.run('powershell', ['-NoProfile', '-Command', script]);
  }

  Future<void> _espeakSprechen(String text, String sprache) async {
    final stimme = sprache == 'de' ? 'de' : 'en-us';
    await Process.run('espeak-ng', ['-v', stimme, text]);
  }
}
