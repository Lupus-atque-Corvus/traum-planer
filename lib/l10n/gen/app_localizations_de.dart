// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'TRAUM Planer';

  @override
  String get navHeute => 'Heute';

  @override
  String get navWoche => 'Woche';

  @override
  String get navMonat => 'Monat';

  @override
  String get navVerlauf => 'Verlauf';

  @override
  String get navPlaene => 'Pläne';

  @override
  String get navEinstellungen => 'Einstellungen';

  @override
  String get fensterMinimieren => 'Minimieren';

  @override
  String get fensterMaximieren => 'Maximieren';

  @override
  String get fensterSchliessen => 'Schließen';

  @override
  String get terminLabel => 'Termin';

  @override
  String heuteNochOffen(int anzahl) {
    return 'Noch offen ($anzahl)';
  }

  @override
  String heuteBereitsErledigt(int anzahl) {
    return 'Bereits erledigt ($anzahl)';
  }

  @override
  String get heuteNochNichtsErledigt => 'Noch nichts erledigt';

  @override
  String get heuteAllesErledigt => 'Alles für heute erledigt';

  @override
  String get heuteKeinEintrag => 'Für heute ist nichts geplant.';

  @override
  String get heuteZurWoche => 'Zur Wochenansicht';

  @override
  String heuteStreakTageInFolge(int anzahl) {
    return '$anzahl Tage in Folge';
  }

  @override
  String get statusVerspaetet => 'verspätet';

  @override
  String get wocheTitel => 'Woche';

  @override
  String get wocheDiese => 'Diese Woche';

  @override
  String get wocheVorherige => 'Vorherige Woche';

  @override
  String get wocheNaechste => 'Nächste Woche';

  @override
  String get monatTitel => 'Monat';

  @override
  String get monatVorheriger => 'Vorheriger Monat';

  @override
  String get monatNaechster => 'Nächster Monat';

  @override
  String get monatLegendePuenktlich => 'Pünktlich erledigt';

  @override
  String get monatLegendeVerspaetet => 'Verspätet erledigt';

  @override
  String get monatLegendeOffen => 'Offen';

  @override
  String get monatLegendeVerpasst => 'Verpasst';

  @override
  String get verlaufTitel => 'Verlauf';

  @override
  String get verlaufZeitraumWoche => 'Woche';

  @override
  String get verlaufZeitraumMonat => 'Monat';

  @override
  String get verlaufZeitraumJahr => 'Jahr';

  @override
  String verlaufStreakTage(int anzahl) {
    return '$anzahl Tage Streak';
  }

  @override
  String get verlaufLegendePuenktlich => 'Pünktlich';

  @override
  String get verlaufLegendeVerspaetet => 'Verspätet nachgeholt';

  @override
  String get verlaufKeineDaten => 'Noch keine Daten für diesen Zeitraum.';

  @override
  String get einstellungenTitel => 'Einstellungen';

  @override
  String get einstellungenSprache => 'Sprache';

  @override
  String get einstellungenSpracheSystem => 'Systemsprache';

  @override
  String get einstellungenSpracheDeutsch => 'Deutsch';

  @override
  String get einstellungenSpracheEnglisch => 'Englisch';

  @override
  String get einstellungenZeitformat => 'Zeitformat';

  @override
  String get einstellungenZeitformat12h => '12-Stunden (AM/PM)';

  @override
  String get einstellungenZeitformat24h => '24-Stunden';

  @override
  String get plaeneTitel => 'Pläne';

  @override
  String get plaeneKeineEintraege => 'Noch keine Pläne angelegt.';

  @override
  String get planNeu => 'Neuer Plan';

  @override
  String get planBearbeiten => 'Plan bearbeiten';

  @override
  String get planTitelFeld => 'Titel';

  @override
  String get planKategorieFeld => 'Kategorie';

  @override
  String get planAkzentfarbeFeld => 'Akzentfarbe';

  @override
  String get planLoeschen => 'Plan löschen';

  @override
  String get planLoeschenBestaetigung =>
      'Plan wirklich löschen? Alle zugehörigen Aufgaben werden ebenfalls gelöscht. Das kann nicht rückgängig gemacht werden.';

  @override
  String get aufgabeNeu => 'Neue Aufgabe';

  @override
  String get aufgabeBearbeiten => 'Aufgabe bearbeiten';

  @override
  String get aufgabeTitelFeld => 'Titel';

  @override
  String get aufgabeUhrzeitFestlegen => 'Uhrzeit festlegen';

  @override
  String get aufgabeWiederholungTaeglich => 'Täglich';

  @override
  String get aufgabeWiederholungWoechentlich => 'Wöchentlich';

  @override
  String get aufgabeWiederholungMonatlich => 'Monatlich';

  @override
  String get aufgabeLoeschen => 'Löschen';

  @override
  String get aufgabeLoeschenBestaetigung =>
      'Aufgabe wirklich löschen? Das kann nicht rückgängig gemacht werden.';

  @override
  String get aufgabeMontag => 'Mo';

  @override
  String get aufgabeDienstag => 'Di';

  @override
  String get aufgabeMittwoch => 'Mi';

  @override
  String get aufgabeDonnerstag => 'Do';

  @override
  String get aufgabeFreitag => 'Fr';

  @override
  String get aufgabeSamstag => 'Sa';

  @override
  String get aufgabeSonntag => 'So';

  @override
  String get aenderungsUmfangTitel => 'Diese Änderung gilt für…';

  @override
  String get aenderungsUmfangNurWoche => 'Nur diese Woche';

  @override
  String get aenderungsUmfangNurWocheSubtext =>
      'Ändert nur den Termin in der aktuellen Woche, die Serie bleibt unverändert.';

  @override
  String get aenderungsUmfangImmer => 'Immer ändern';

  @override
  String get aenderungsUmfangImmerSubtext =>
      'Ändert die Wiederholungsregel dauerhaft für alle zukünftigen Wochen.';

  @override
  String get terminNeu => 'Termin erstellen';

  @override
  String get terminBearbeiten => 'Termin bearbeiten';

  @override
  String get terminTitelFeld => 'Titel';

  @override
  String get terminDatumFeld => 'Datum';

  @override
  String get terminUhrzeitFeld => 'Uhrzeit';

  @override
  String get terminOrtFeld => 'Ort';

  @override
  String get aktionAbbrechen => 'Abbrechen';

  @override
  String get aktionSpeichern => 'Speichern';

  @override
  String get aktionLoeschen => 'Löschen';

  @override
  String get trayFensterOeffnen => 'Fenster öffnen';

  @override
  String get trayHeuteAnzeigen => 'Heute anzeigen';

  @override
  String get trayBeenden => 'Beenden';

  @override
  String get assistentTitel => 'Assistent';

  @override
  String get einstellungenAutostart => 'Mit dem System starten';

  @override
  String get einstellungenBenachrichtigungen => 'Benachrichtigungen';

  @override
  String einstellungenBenachrichtigungenVorlauf(int minuten) {
    return 'Erinnerung $minuten Minuten vorher';
  }

  @override
  String get einstellungenExport => 'Export & Sicherung';

  @override
  String get einstellungenExportHtml => 'Als druckbares HTML exportieren';

  @override
  String get einstellungenExportJson => 'Als JSON sichern';

  @override
  String get einstellungenImportJson => 'Aus JSON wiederherstellen';

  @override
  String get einstellungenImportBestaetigung =>
      'Import überschreibt alle vorhandenen Daten. Fortfahren?';

  @override
  String get einstellungenExportErfolgreich =>
      'Export erfolgreich gespeichert.';

  @override
  String get einstellungenImportErfolgreich =>
      'Daten erfolgreich wiederhergestellt.';

  @override
  String benachrichtigungAufgabeFaelligTitel(String titel) {
    return '$titel steht an';
  }

  @override
  String benachrichtigungAufgabeFaelligKoerper(String uhrzeit) {
    return 'Geplant für $uhrzeit';
  }

  @override
  String get exportDruckTitel => 'Wochenplan';

  @override
  String exportDruckErstelltAm(Object datum) {
    return 'Erstellt am $datum';
  }

  @override
  String get assistentOeffnen => 'Assistent öffnen';

  @override
  String get assistentSchliessen => 'Schließen';

  @override
  String get assistentPlatzhalterHinweis =>
      'Der Sprach-/LLM-Assistent ist für eine spätere Version geplant (Phase 8) — vollständig offline, zweisprachig. Noch nicht aktiv.';

  @override
  String get assistentEingabePlatzhalter => 'Nachricht eingeben…';

  @override
  String get assistentMikrofonHinweis => 'Spracheingabe noch nicht verfügbar';
}
