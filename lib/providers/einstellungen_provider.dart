import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:launch_at_startup/launch_at_startup.dart';

import 'database_provider.dart';

/// Schlüssel der `Einstellungen`-Tabelle (Key-Value).
class EinstellungenSchluessel {
  const EinstellungenSchluessel._();

  static const sprache = 'sprache'; // 'de' | 'en' | 'system'
  static const zeitformat = 'zeitformat'; // '12h' | '24h'
  static const autostart = 'autostart'; // 'ein' | 'aus'
  static const benachrichtigungVorlauf = 'benachrichtigungVorlaufMinuten'; // int als String

  // Aktivierungswort (siehe Plan "Aktivierungswort für den Sprachassistenten")
  static const aktivierungswortAktiv = 'aktivierungswortAktiv'; // 'ein' | 'aus'
  static const aktivierungswortHintergrundModus = 'aktivierungswortHintergrund'; // 'nurFenster' | 'auchTray'
  static const aktivierungswortAufgenommenAm = 'aktivierungswortAufgenommenAm'; // ISO 8601 oder leer
  static const aktivierungswortEmpfindlichkeit = 'aktivierungswortEmpfindlichkeit'; // double als String
  static const textChatPanelAktiv = 'textChatPanelAktiv'; // 'ein' | 'aus'
}

/// Aktuell gewählte Sprache: 'de', 'en' oder 'system' (Default).
final spracheProvider = StreamProvider<String>((ref) {
  final db = ref.watch(databaseProvider);
  return db.einstellungBeobachten(EinstellungenSchluessel.sprache).map((v) => v ?? 'system');
});

/// Zeitformat: '12h' oder '24h'. Unabhängig von der UI-Sprache wählbar
/// (siehe Spec Abschnitt 7) — Default '24h'.
final zeitformatProvider = StreamProvider<String>((ref) {
  final db = ref.watch(databaseProvider);
  return db.einstellungBeobachten(EinstellungenSchluessel.zeitformat).map((v) => v ?? '24h');
});

/// Autostart-Präferenz: 'ein' oder 'aus' (Default 'aus').
final autostartProvider = StreamProvider<bool>((ref) {
  final db = ref.watch(databaseProvider);
  return db.einstellungBeobachten(EinstellungenSchluessel.autostart).map((v) => v == 'ein');
});

/// Erinnerungsvorlauf in Minuten vor Fälligkeit (Default 10).
final benachrichtigungVorlaufProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  return db
      .einstellungBeobachten(EinstellungenSchluessel.benachrichtigungVorlauf)
      .map((v) => int.tryParse(v ?? '') ?? 10);
});

/// Ob das Aktivierungswort aktiv ist (Default 'aus' — Opt-in, siehe Plan
/// Risiken/Tuning-Hinweis zu dauerhafter Mikrofonaufnahme).
final aktivierungswortAktivProvider = StreamProvider<bool>((ref) {
  final db = ref.watch(databaseProvider);
  return db.einstellungBeobachten(EinstellungenSchluessel.aktivierungswortAktiv).map((v) => v == 'ein');
});

/// 'nurFenster' (Default) oder 'auchTray'.
final aktivierungswortHintergrundModusProvider = StreamProvider<String>((ref) {
  final db = ref.watch(databaseProvider);
  return db
      .einstellungBeobachten(EinstellungenSchluessel.aktivierungswortHintergrundModus)
      .map((v) => v ?? 'nurFenster');
});

/// Zeitpunkt der letzten vollständigen Aufnahme (3 Proben), oder `null`.
final aktivierungswortAufgenommenAmProvider = StreamProvider<DateTime?>((ref) {
  final db = ref.watch(databaseProvider);
  return db
      .einstellungBeobachten(EinstellungenSchluessel.aktivierungswortAufgenommenAm)
      .map((v) => v == null || v.isEmpty ? null : DateTime.tryParse(v));
});

/// Faktor auf den selbstkalibrierten DTW-Schwellwert (Default 1.4, siehe
/// `WakeWordService.vorlagenSetzen`) — kleiner = strenger/weniger Treffer.
final aktivierungswortEmpfindlichkeitProvider = StreamProvider<double>((ref) {
  final db = ref.watch(databaseProvider);
  return db
      .einstellungBeobachten(EinstellungenSchluessel.aktivierungswortEmpfindlichkeit)
      .map((v) => double.tryParse(v ?? '') ?? 1.4);
});

/// Ob das bisherige Text-Chat-Panel zusätzlich zum Aktivierungswort-Overlay
/// verfügbar ist (Default 'ein' — bestehendes Verhalten bleibt erhalten).
final textChatPanelAktivProvider = StreamProvider<bool>((ref) {
  final db = ref.watch(databaseProvider);
  return db.einstellungBeobachten(EinstellungenSchluessel.textChatPanelAktiv).map((v) => v != 'aus');
});

final einstellungenControllerProvider = Provider((ref) => EinstellungenController(ref));

class EinstellungenController {
  final Ref ref;
  EinstellungenController(this.ref);

  Future<void> spracheSetzen(String wert) => ref
      .read(databaseProvider)
      .einstellungSpeichern(EinstellungenSchluessel.sprache, wert);

  Future<void> zeitformatSetzen(String wert) => ref
      .read(databaseProvider)
      .einstellungSpeichern(EinstellungenSchluessel.zeitformat, wert);

  Future<void> autostartSetzen(bool aktiv) async {
    await ref
        .read(databaseProvider)
        .einstellungSpeichern(EinstellungenSchluessel.autostart, aktiv ? 'ein' : 'aus');
    if (aktiv) {
      await launchAtStartup.enable();
    } else {
      await launchAtStartup.disable();
    }
  }

  Future<void> benachrichtigungVorlaufSetzen(int minuten) => ref
      .read(databaseProvider)
      .einstellungSpeichern(EinstellungenSchluessel.benachrichtigungVorlauf, '$minuten');

  Future<void> aktivierungswortAktivSetzen(bool aktiv) => ref
      .read(databaseProvider)
      .einstellungSpeichern(EinstellungenSchluessel.aktivierungswortAktiv, aktiv ? 'ein' : 'aus');

  Future<void> aktivierungswortHintergrundModusSetzen(String wert) => ref
      .read(databaseProvider)
      .einstellungSpeichern(EinstellungenSchluessel.aktivierungswortHintergrundModus, wert);

  Future<void> aktivierungswortAufgenommenAmSetzen(DateTime zeitpunkt) => ref
      .read(databaseProvider)
      .einstellungSpeichern(
        EinstellungenSchluessel.aktivierungswortAufgenommenAm,
        zeitpunkt.toIso8601String(),
      );

  Future<void> aktivierungswortAufgenommenAmLoeschen() => ref
      .read(databaseProvider)
      .einstellungSpeichern(EinstellungenSchluessel.aktivierungswortAufgenommenAm, '');

  Future<void> aktivierungswortEmpfindlichkeitSetzen(double wert) => ref
      .read(databaseProvider)
      .einstellungSpeichern(EinstellungenSchluessel.aktivierungswortEmpfindlichkeit, '$wert');

  Future<void> textChatPanelAktivSetzen(bool aktiv) => ref
      .read(databaseProvider)
      .einstellungSpeichern(EinstellungenSchluessel.textChatPanelAktiv, aktiv ? 'ein' : 'aus');
}
