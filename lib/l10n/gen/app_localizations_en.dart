// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'TRAUM Planer';

  @override
  String get navHeute => 'Today';

  @override
  String get navWoche => 'Week';

  @override
  String get navMonat => 'Month';

  @override
  String get navVerlauf => 'History';

  @override
  String get navPlaene => 'Plans';

  @override
  String get navEinstellungen => 'Settings';

  @override
  String get fensterMinimieren => 'Minimize';

  @override
  String get fensterMaximieren => 'Maximize';

  @override
  String get fensterSchliessen => 'Close';

  @override
  String get terminLabel => 'Event';

  @override
  String heuteNochOffen(int anzahl) {
    return 'Still open ($anzahl)';
  }

  @override
  String heuteBereitsErledigt(int anzahl) {
    return 'Already done ($anzahl)';
  }

  @override
  String get heuteNochNichtsErledigt => 'Nothing done yet';

  @override
  String get heuteAllesErledigt => 'Everything done for today';

  @override
  String get heuteKeinEintrag => 'Nothing planned for today.';

  @override
  String get heuteZurWoche => 'Go to week view';

  @override
  String heuteStreakTageInFolge(int anzahl) {
    return '$anzahl days in a row';
  }

  @override
  String get statusVerspaetet => 'late';

  @override
  String get wocheTitel => 'Week';

  @override
  String get wocheDiese => 'This week';

  @override
  String get wocheVorherige => 'Previous week';

  @override
  String get wocheNaechste => 'Next week';

  @override
  String get monatTitel => 'Month';

  @override
  String get monatVorheriger => 'Previous month';

  @override
  String get monatNaechster => 'Next month';

  @override
  String get monatLegendePuenktlich => 'Done on time';

  @override
  String get monatLegendeVerspaetet => 'Done late';

  @override
  String get monatLegendeOffen => 'Open';

  @override
  String get monatLegendeVerpasst => 'Missed';

  @override
  String get verlaufTitel => 'History';

  @override
  String get verlaufZeitraumWoche => 'Week';

  @override
  String get verlaufZeitraumMonat => 'Month';

  @override
  String get verlaufZeitraumJahr => 'Year';

  @override
  String verlaufStreakTage(int anzahl) {
    return '$anzahl-day streak';
  }

  @override
  String get verlaufLegendePuenktlich => 'On time';

  @override
  String get verlaufLegendeVerspaetet => 'Made up late';

  @override
  String get verlaufKeineDaten => 'No data for this period yet.';

  @override
  String get einstellungenTitel => 'Settings';

  @override
  String get einstellungenSprache => 'Language';

  @override
  String get einstellungenSpracheSystem => 'System language';

  @override
  String get einstellungenSpracheDeutsch => 'German';

  @override
  String get einstellungenSpracheEnglisch => 'English';

  @override
  String get einstellungenZeitformat => 'Time format';

  @override
  String get einstellungenZeitformat12h => '12-hour (AM/PM)';

  @override
  String get einstellungenZeitformat24h => '24-hour';

  @override
  String get plaeneTitel => 'Plans';

  @override
  String get plaeneKeineEintraege => 'No plans yet.';

  @override
  String get planNeu => 'New plan';

  @override
  String get planBearbeiten => 'Edit plan';

  @override
  String get planTitelFeld => 'Title';

  @override
  String get planKategorieFeld => 'Category';

  @override
  String get planAkzentfarbeFeld => 'Accent color';

  @override
  String get planLoeschen => 'Delete plan';

  @override
  String get planLoeschenBestaetigung =>
      'Really delete this plan? All its tasks will be deleted too. This cannot be undone.';

  @override
  String get aufgabeNeu => 'New task';

  @override
  String get aufgabeBearbeiten => 'Edit task';

  @override
  String get aufgabeTitelFeld => 'Title';

  @override
  String get aufgabeUhrzeitFestlegen => 'Set a time';

  @override
  String get aufgabeWiederholungTaeglich => 'Daily';

  @override
  String get aufgabeWiederholungWoechentlich => 'Weekly';

  @override
  String get aufgabeWiederholungMonatlich => 'Monthly';

  @override
  String get aufgabeLoeschen => 'Delete';

  @override
  String get aufgabeLoeschenBestaetigung =>
      'Really delete this task? This cannot be undone.';

  @override
  String get aufgabeMontag => 'Mon';

  @override
  String get aufgabeDienstag => 'Tue';

  @override
  String get aufgabeMittwoch => 'Wed';

  @override
  String get aufgabeDonnerstag => 'Thu';

  @override
  String get aufgabeFreitag => 'Fri';

  @override
  String get aufgabeSamstag => 'Sat';

  @override
  String get aufgabeSonntag => 'Sun';

  @override
  String get aenderungsUmfangTitel => 'This change applies to…';

  @override
  String get aenderungsUmfangNurWoche => 'This week only';

  @override
  String get aenderungsUmfangNurWocheSubtext =>
      'Changes only the occurrence in the current week, the recurring series stays unchanged.';

  @override
  String get aenderungsUmfangImmer => 'Change always';

  @override
  String get aenderungsUmfangImmerSubtext =>
      'Permanently changes the recurrence rule for all future weeks.';

  @override
  String get terminNeu => 'Create event';

  @override
  String get terminBearbeiten => 'Edit event';

  @override
  String get terminTitelFeld => 'Title';

  @override
  String get terminDatumFeld => 'Date';

  @override
  String get terminUhrzeitFeld => 'Time';

  @override
  String get terminOrtFeld => 'Location';

  @override
  String get aktionAbbrechen => 'Cancel';

  @override
  String get aktionSpeichern => 'Save';

  @override
  String get aktionLoeschen => 'Delete';

  @override
  String get trayFensterOeffnen => 'Open window';

  @override
  String get trayHeuteAnzeigen => 'Show today';

  @override
  String get trayBeenden => 'Quit';

  @override
  String get assistentTitel => 'Assistant';
}
