import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In de, this message translates to:
  /// **'TRAUM Planer'**
  String get appName;

  /// No description provided for @navHeute.
  ///
  /// In de, this message translates to:
  /// **'Heute'**
  String get navHeute;

  /// No description provided for @navWoche.
  ///
  /// In de, this message translates to:
  /// **'Woche'**
  String get navWoche;

  /// No description provided for @navMonat.
  ///
  /// In de, this message translates to:
  /// **'Monat'**
  String get navMonat;

  /// No description provided for @navVerlauf.
  ///
  /// In de, this message translates to:
  /// **'Verlauf'**
  String get navVerlauf;

  /// No description provided for @navPlaene.
  ///
  /// In de, this message translates to:
  /// **'Pläne'**
  String get navPlaene;

  /// No description provided for @navEinstellungen.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get navEinstellungen;

  /// No description provided for @fensterMinimieren.
  ///
  /// In de, this message translates to:
  /// **'Minimieren'**
  String get fensterMinimieren;

  /// No description provided for @fensterMaximieren.
  ///
  /// In de, this message translates to:
  /// **'Maximieren'**
  String get fensterMaximieren;

  /// No description provided for @fensterSchliessen.
  ///
  /// In de, this message translates to:
  /// **'Schließen'**
  String get fensterSchliessen;

  /// No description provided for @terminLabel.
  ///
  /// In de, this message translates to:
  /// **'Termin'**
  String get terminLabel;

  /// No description provided for @heuteNochOffen.
  ///
  /// In de, this message translates to:
  /// **'Noch offen ({anzahl})'**
  String heuteNochOffen(int anzahl);

  /// No description provided for @heuteBereitsErledigt.
  ///
  /// In de, this message translates to:
  /// **'Bereits erledigt ({anzahl})'**
  String heuteBereitsErledigt(int anzahl);

  /// No description provided for @heuteNochNichtsErledigt.
  ///
  /// In de, this message translates to:
  /// **'Noch nichts erledigt'**
  String get heuteNochNichtsErledigt;

  /// No description provided for @heuteAllesErledigt.
  ///
  /// In de, this message translates to:
  /// **'Alles für heute erledigt'**
  String get heuteAllesErledigt;

  /// No description provided for @heuteKeinEintrag.
  ///
  /// In de, this message translates to:
  /// **'Für heute ist nichts geplant.'**
  String get heuteKeinEintrag;

  /// No description provided for @heuteZurWoche.
  ///
  /// In de, this message translates to:
  /// **'Zur Wochenansicht'**
  String get heuteZurWoche;

  /// No description provided for @heuteStreakTageInFolge.
  ///
  /// In de, this message translates to:
  /// **'{anzahl} Tage in Folge'**
  String heuteStreakTageInFolge(int anzahl);

  /// No description provided for @statusVerspaetet.
  ///
  /// In de, this message translates to:
  /// **'verspätet'**
  String get statusVerspaetet;

  /// No description provided for @wocheTitel.
  ///
  /// In de, this message translates to:
  /// **'Woche'**
  String get wocheTitel;

  /// No description provided for @wocheDiese.
  ///
  /// In de, this message translates to:
  /// **'Diese Woche'**
  String get wocheDiese;

  /// No description provided for @wocheVorherige.
  ///
  /// In de, this message translates to:
  /// **'Vorherige Woche'**
  String get wocheVorherige;

  /// No description provided for @wocheNaechste.
  ///
  /// In de, this message translates to:
  /// **'Nächste Woche'**
  String get wocheNaechste;

  /// No description provided for @monatTitel.
  ///
  /// In de, this message translates to:
  /// **'Monat'**
  String get monatTitel;

  /// No description provided for @monatVorheriger.
  ///
  /// In de, this message translates to:
  /// **'Vorheriger Monat'**
  String get monatVorheriger;

  /// No description provided for @monatNaechster.
  ///
  /// In de, this message translates to:
  /// **'Nächster Monat'**
  String get monatNaechster;

  /// No description provided for @monatLegendePuenktlich.
  ///
  /// In de, this message translates to:
  /// **'Pünktlich erledigt'**
  String get monatLegendePuenktlich;

  /// No description provided for @monatLegendeVerspaetet.
  ///
  /// In de, this message translates to:
  /// **'Verspätet erledigt'**
  String get monatLegendeVerspaetet;

  /// No description provided for @monatLegendeOffen.
  ///
  /// In de, this message translates to:
  /// **'Offen'**
  String get monatLegendeOffen;

  /// No description provided for @monatLegendeVerpasst.
  ///
  /// In de, this message translates to:
  /// **'Verpasst'**
  String get monatLegendeVerpasst;

  /// No description provided for @verlaufTitel.
  ///
  /// In de, this message translates to:
  /// **'Verlauf'**
  String get verlaufTitel;

  /// No description provided for @verlaufZeitraumWoche.
  ///
  /// In de, this message translates to:
  /// **'Woche'**
  String get verlaufZeitraumWoche;

  /// No description provided for @verlaufZeitraumMonat.
  ///
  /// In de, this message translates to:
  /// **'Monat'**
  String get verlaufZeitraumMonat;

  /// No description provided for @verlaufZeitraumJahr.
  ///
  /// In de, this message translates to:
  /// **'Jahr'**
  String get verlaufZeitraumJahr;

  /// No description provided for @verlaufStreakTage.
  ///
  /// In de, this message translates to:
  /// **'{anzahl} Tage Streak'**
  String verlaufStreakTage(int anzahl);

  /// No description provided for @verlaufLegendePuenktlich.
  ///
  /// In de, this message translates to:
  /// **'Pünktlich'**
  String get verlaufLegendePuenktlich;

  /// No description provided for @verlaufLegendeVerspaetet.
  ///
  /// In de, this message translates to:
  /// **'Verspätet nachgeholt'**
  String get verlaufLegendeVerspaetet;

  /// No description provided for @verlaufKeineDaten.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Daten für diesen Zeitraum.'**
  String get verlaufKeineDaten;

  /// No description provided for @einstellungenTitel.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get einstellungenTitel;

  /// No description provided for @einstellungenSprache.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get einstellungenSprache;

  /// No description provided for @einstellungenSpracheSystem.
  ///
  /// In de, this message translates to:
  /// **'Systemsprache'**
  String get einstellungenSpracheSystem;

  /// No description provided for @einstellungenSpracheDeutsch.
  ///
  /// In de, this message translates to:
  /// **'Deutsch'**
  String get einstellungenSpracheDeutsch;

  /// No description provided for @einstellungenSpracheEnglisch.
  ///
  /// In de, this message translates to:
  /// **'Englisch'**
  String get einstellungenSpracheEnglisch;

  /// No description provided for @einstellungenZeitformat.
  ///
  /// In de, this message translates to:
  /// **'Zeitformat'**
  String get einstellungenZeitformat;

  /// No description provided for @einstellungenZeitformat12h.
  ///
  /// In de, this message translates to:
  /// **'12-Stunden (AM/PM)'**
  String get einstellungenZeitformat12h;

  /// No description provided for @einstellungenZeitformat24h.
  ///
  /// In de, this message translates to:
  /// **'24-Stunden'**
  String get einstellungenZeitformat24h;

  /// No description provided for @plaeneTitel.
  ///
  /// In de, this message translates to:
  /// **'Pläne'**
  String get plaeneTitel;

  /// No description provided for @plaeneKeineEintraege.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Pläne angelegt.'**
  String get plaeneKeineEintraege;

  /// No description provided for @planNeu.
  ///
  /// In de, this message translates to:
  /// **'Neuer Plan'**
  String get planNeu;

  /// No description provided for @planBearbeiten.
  ///
  /// In de, this message translates to:
  /// **'Plan bearbeiten'**
  String get planBearbeiten;

  /// No description provided for @planTitelFeld.
  ///
  /// In de, this message translates to:
  /// **'Titel'**
  String get planTitelFeld;

  /// No description provided for @planKategorieFeld.
  ///
  /// In de, this message translates to:
  /// **'Kategorie'**
  String get planKategorieFeld;

  /// No description provided for @planAkzentfarbeFeld.
  ///
  /// In de, this message translates to:
  /// **'Akzentfarbe'**
  String get planAkzentfarbeFeld;

  /// No description provided for @planLoeschen.
  ///
  /// In de, this message translates to:
  /// **'Plan löschen'**
  String get planLoeschen;

  /// No description provided for @planLoeschenBestaetigung.
  ///
  /// In de, this message translates to:
  /// **'Plan wirklich löschen? Alle zugehörigen Aufgaben werden ebenfalls gelöscht. Das kann nicht rückgängig gemacht werden.'**
  String get planLoeschenBestaetigung;

  /// No description provided for @aufgabeNeu.
  ///
  /// In de, this message translates to:
  /// **'Neue Aufgabe'**
  String get aufgabeNeu;

  /// No description provided for @aufgabeBearbeiten.
  ///
  /// In de, this message translates to:
  /// **'Aufgabe bearbeiten'**
  String get aufgabeBearbeiten;

  /// No description provided for @aufgabeTitelFeld.
  ///
  /// In de, this message translates to:
  /// **'Titel'**
  String get aufgabeTitelFeld;

  /// No description provided for @aufgabeUhrzeitFestlegen.
  ///
  /// In de, this message translates to:
  /// **'Uhrzeit festlegen'**
  String get aufgabeUhrzeitFestlegen;

  /// No description provided for @aufgabeWiederholungTaeglich.
  ///
  /// In de, this message translates to:
  /// **'Täglich'**
  String get aufgabeWiederholungTaeglich;

  /// No description provided for @aufgabeWiederholungWoechentlich.
  ///
  /// In de, this message translates to:
  /// **'Wöchentlich'**
  String get aufgabeWiederholungWoechentlich;

  /// No description provided for @aufgabeWiederholungMonatlich.
  ///
  /// In de, this message translates to:
  /// **'Monatlich'**
  String get aufgabeWiederholungMonatlich;

  /// No description provided for @aufgabeLoeschen.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get aufgabeLoeschen;

  /// No description provided for @aufgabeLoeschenBestaetigung.
  ///
  /// In de, this message translates to:
  /// **'Aufgabe wirklich löschen? Das kann nicht rückgängig gemacht werden.'**
  String get aufgabeLoeschenBestaetigung;

  /// No description provided for @aufgabeMontag.
  ///
  /// In de, this message translates to:
  /// **'Mo'**
  String get aufgabeMontag;

  /// No description provided for @aufgabeDienstag.
  ///
  /// In de, this message translates to:
  /// **'Di'**
  String get aufgabeDienstag;

  /// No description provided for @aufgabeMittwoch.
  ///
  /// In de, this message translates to:
  /// **'Mi'**
  String get aufgabeMittwoch;

  /// No description provided for @aufgabeDonnerstag.
  ///
  /// In de, this message translates to:
  /// **'Do'**
  String get aufgabeDonnerstag;

  /// No description provided for @aufgabeFreitag.
  ///
  /// In de, this message translates to:
  /// **'Fr'**
  String get aufgabeFreitag;

  /// No description provided for @aufgabeSamstag.
  ///
  /// In de, this message translates to:
  /// **'Sa'**
  String get aufgabeSamstag;

  /// No description provided for @aufgabeSonntag.
  ///
  /// In de, this message translates to:
  /// **'So'**
  String get aufgabeSonntag;

  /// No description provided for @aenderungsUmfangTitel.
  ///
  /// In de, this message translates to:
  /// **'Diese Änderung gilt für…'**
  String get aenderungsUmfangTitel;

  /// No description provided for @aenderungsUmfangNurWoche.
  ///
  /// In de, this message translates to:
  /// **'Nur diese Woche'**
  String get aenderungsUmfangNurWoche;

  /// No description provided for @aenderungsUmfangNurWocheSubtext.
  ///
  /// In de, this message translates to:
  /// **'Ändert nur den Termin in der aktuellen Woche, die Serie bleibt unverändert.'**
  String get aenderungsUmfangNurWocheSubtext;

  /// No description provided for @aenderungsUmfangImmer.
  ///
  /// In de, this message translates to:
  /// **'Immer ändern'**
  String get aenderungsUmfangImmer;

  /// No description provided for @aenderungsUmfangImmerSubtext.
  ///
  /// In de, this message translates to:
  /// **'Ändert die Wiederholungsregel dauerhaft für alle zukünftigen Wochen.'**
  String get aenderungsUmfangImmerSubtext;

  /// No description provided for @terminNeu.
  ///
  /// In de, this message translates to:
  /// **'Termin erstellen'**
  String get terminNeu;

  /// No description provided for @terminBearbeiten.
  ///
  /// In de, this message translates to:
  /// **'Termin bearbeiten'**
  String get terminBearbeiten;

  /// No description provided for @terminTitelFeld.
  ///
  /// In de, this message translates to:
  /// **'Titel'**
  String get terminTitelFeld;

  /// No description provided for @terminDatumFeld.
  ///
  /// In de, this message translates to:
  /// **'Datum'**
  String get terminDatumFeld;

  /// No description provided for @terminUhrzeitFeld.
  ///
  /// In de, this message translates to:
  /// **'Uhrzeit'**
  String get terminUhrzeitFeld;

  /// No description provided for @terminOrtFeld.
  ///
  /// In de, this message translates to:
  /// **'Ort'**
  String get terminOrtFeld;

  /// No description provided for @aktionAbbrechen.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get aktionAbbrechen;

  /// No description provided for @aktionSpeichern.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get aktionSpeichern;

  /// No description provided for @aktionLoeschen.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get aktionLoeschen;

  /// No description provided for @trayFensterOeffnen.
  ///
  /// In de, this message translates to:
  /// **'Fenster öffnen'**
  String get trayFensterOeffnen;

  /// No description provided for @trayHeuteAnzeigen.
  ///
  /// In de, this message translates to:
  /// **'Heute anzeigen'**
  String get trayHeuteAnzeigen;

  /// No description provided for @trayBeenden.
  ///
  /// In de, this message translates to:
  /// **'Beenden'**
  String get trayBeenden;

  /// No description provided for @assistentTitel.
  ///
  /// In de, this message translates to:
  /// **'Assistent'**
  String get assistentTitel;

  /// No description provided for @einstellungenAutostart.
  ///
  /// In de, this message translates to:
  /// **'Mit dem System starten'**
  String get einstellungenAutostart;

  /// No description provided for @einstellungenBenachrichtigungen.
  ///
  /// In de, this message translates to:
  /// **'Benachrichtigungen'**
  String get einstellungenBenachrichtigungen;

  /// No description provided for @einstellungenBenachrichtigungenVorlauf.
  ///
  /// In de, this message translates to:
  /// **'Erinnerung {minuten} Minuten vorher'**
  String einstellungenBenachrichtigungenVorlauf(int minuten);

  /// No description provided for @einstellungenExport.
  ///
  /// In de, this message translates to:
  /// **'Export & Sicherung'**
  String get einstellungenExport;

  /// No description provided for @einstellungenExportHtml.
  ///
  /// In de, this message translates to:
  /// **'Als druckbares HTML exportieren'**
  String get einstellungenExportHtml;

  /// No description provided for @einstellungenExportJson.
  ///
  /// In de, this message translates to:
  /// **'Als JSON sichern'**
  String get einstellungenExportJson;

  /// No description provided for @einstellungenImportJson.
  ///
  /// In de, this message translates to:
  /// **'Aus JSON wiederherstellen'**
  String get einstellungenImportJson;

  /// No description provided for @einstellungenImportBestaetigung.
  ///
  /// In de, this message translates to:
  /// **'Import überschreibt alle vorhandenen Daten. Fortfahren?'**
  String get einstellungenImportBestaetigung;

  /// No description provided for @einstellungenExportErfolgreich.
  ///
  /// In de, this message translates to:
  /// **'Export erfolgreich gespeichert.'**
  String get einstellungenExportErfolgreich;

  /// No description provided for @einstellungenImportErfolgreich.
  ///
  /// In de, this message translates to:
  /// **'Daten erfolgreich wiederhergestellt.'**
  String get einstellungenImportErfolgreich;

  /// No description provided for @benachrichtigungAufgabeFaelligTitel.
  ///
  /// In de, this message translates to:
  /// **'{titel} steht an'**
  String benachrichtigungAufgabeFaelligTitel(String titel);

  /// No description provided for @benachrichtigungAufgabeFaelligKoerper.
  ///
  /// In de, this message translates to:
  /// **'Geplant für {uhrzeit}'**
  String benachrichtigungAufgabeFaelligKoerper(String uhrzeit);

  /// No description provided for @exportDruckTitel.
  ///
  /// In de, this message translates to:
  /// **'Wochenplan'**
  String get exportDruckTitel;

  /// No description provided for @exportDruckErstelltAm.
  ///
  /// In de, this message translates to:
  /// **'Erstellt am {datum}'**
  String exportDruckErstelltAm(Object datum);

  /// No description provided for @assistentOeffnen.
  ///
  /// In de, this message translates to:
  /// **'Assistent öffnen'**
  String get assistentOeffnen;

  /// No description provided for @assistentSchliessen.
  ///
  /// In de, this message translates to:
  /// **'Schließen'**
  String get assistentSchliessen;

  /// No description provided for @assistentEingabePlatzhalter.
  ///
  /// In de, this message translates to:
  /// **'Nachricht eingeben…'**
  String get assistentEingabePlatzhalter;

  /// No description provided for @assistentMikrofonHinweis.
  ///
  /// In de, this message translates to:
  /// **'Spracheingabe'**
  String get assistentMikrofonHinweis;

  /// No description provided for @assistentTtsEin.
  ///
  /// In de, this message translates to:
  /// **'Antworten vorlesen: an'**
  String get assistentTtsEin;

  /// No description provided for @assistentTtsAus.
  ///
  /// In de, this message translates to:
  /// **'Antworten vorlesen: aus'**
  String get assistentTtsAus;

  /// No description provided for @assistentOllamaNichtErreichbar.
  ///
  /// In de, this message translates to:
  /// **'Der lokale Assistent (Ollama) läuft gerade nicht. Die App bleibt ohne ihn voll nutzbar.'**
  String get assistentOllamaNichtErreichbar;

  /// No description provided for @einstellungenAktivierungswort.
  ///
  /// In de, this message translates to:
  /// **'Aktivierungswort'**
  String get einstellungenAktivierungswort;

  /// No description provided for @einstellungenAktivierungswortBeschreibung.
  ///
  /// In de, this message translates to:
  /// **'Sprich ein Wort ein, mit dem du den Assistenten aktivierst, ohne die Maus zu benutzen.'**
  String get einstellungenAktivierungswortBeschreibung;

  /// No description provided for @einstellungenAktivierungswortAktiv.
  ///
  /// In de, this message translates to:
  /// **'Aktivierungswort aktiv'**
  String get einstellungenAktivierungswortAktiv;

  /// No description provided for @einstellungenAktivierungswortAufnehmen.
  ///
  /// In de, this message translates to:
  /// **'Aufnehmen'**
  String get einstellungenAktivierungswortAufnehmen;

  /// No description provided for @einstellungenAktivierungswortNeuAufnehmen.
  ///
  /// In de, this message translates to:
  /// **'Neu aufnehmen'**
  String get einstellungenAktivierungswortNeuAufnehmen;

  /// No description provided for @einstellungenAktivierungswortLoeschen.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get einstellungenAktivierungswortLoeschen;

  /// No description provided for @einstellungenAktivierungswortLoeschenBestaetigung.
  ///
  /// In de, this message translates to:
  /// **'Aktivierungswort wirklich löschen? Die 3 aufgenommenen Proben werden entfernt und das Aktivierungswort deaktiviert.'**
  String get einstellungenAktivierungswortLoeschenBestaetigung;

  /// No description provided for @einstellungenAktivierungswortStatusFehlt.
  ///
  /// In de, this message translates to:
  /// **'Noch nicht aufgenommen'**
  String get einstellungenAktivierungswortStatusFehlt;

  /// No description provided for @einstellungenAktivierungswortStatusVorhanden.
  ///
  /// In de, this message translates to:
  /// **'Aufgenommen am {datum}'**
  String einstellungenAktivierungswortStatusVorhanden(String datum);

  /// No description provided for @einstellungenAktivierungswortSchritt.
  ///
  /// In de, this message translates to:
  /// **'Schritt {n} von 3: Sprich dein Aktivierungswort'**
  String einstellungenAktivierungswortSchritt(int n);

  /// No description provided for @einstellungenAktivierungswortAufnahmeStarten.
  ///
  /// In de, this message translates to:
  /// **'Aufnahme starten'**
  String get einstellungenAktivierungswortAufnahmeStarten;

  /// No description provided for @einstellungenAktivierungswortAufnahmeStoppen.
  ///
  /// In de, this message translates to:
  /// **'Aufnahme beenden'**
  String get einstellungenAktivierungswortAufnahmeStoppen;

  /// No description provided for @einstellungenAktivierungswortZuKurz.
  ///
  /// In de, this message translates to:
  /// **'Zu kurz — bitte noch einmal versuchen.'**
  String get einstellungenAktivierungswortZuKurz;

  /// No description provided for @einstellungenAktivierungswortWeiter.
  ///
  /// In de, this message translates to:
  /// **'Weiter'**
  String get einstellungenAktivierungswortWeiter;

  /// No description provided for @einstellungenAktivierungswortFertig.
  ///
  /// In de, this message translates to:
  /// **'Fertig'**
  String get einstellungenAktivierungswortFertig;

  /// No description provided for @einstellungenAktivierungswortAbbrechen.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get einstellungenAktivierungswortAbbrechen;

  /// No description provided for @einstellungenAktivierungswortHintergrund.
  ///
  /// In de, this message translates to:
  /// **'Hintergrund-Lauschen'**
  String get einstellungenAktivierungswortHintergrund;

  /// No description provided for @einstellungenAktivierungswortHintergrundNurFenster.
  ///
  /// In de, this message translates to:
  /// **'Nur bei geöffnetem Fenster'**
  String get einstellungenAktivierungswortHintergrundNurFenster;

  /// No description provided for @einstellungenAktivierungswortHintergrundAuchTray.
  ///
  /// In de, this message translates to:
  /// **'Auch minimiert/im Tray'**
  String get einstellungenAktivierungswortHintergrundAuchTray;

  /// No description provided for @einstellungenAktivierungswortEmpfindlichkeit.
  ///
  /// In de, this message translates to:
  /// **'Empfindlichkeit'**
  String get einstellungenAktivierungswortEmpfindlichkeit;

  /// No description provided for @einstellungenTextchatPanel.
  ///
  /// In de, this message translates to:
  /// **'Textchat-Fenster'**
  String get einstellungenTextchatPanel;

  /// No description provided for @einstellungenTextchatPanelBeschreibung.
  ///
  /// In de, this message translates to:
  /// **'Das bisherige schwebende Chat-Fenster zusätzlich zum Aktivierungswort-Overlay anzeigen.'**
  String get einstellungenTextchatPanelBeschreibung;

  /// No description provided for @wakewortUeberlagerungHoert.
  ///
  /// In de, this message translates to:
  /// **'Ich höre zu…'**
  String get wakewortUeberlagerungHoert;

  /// No description provided for @wakewortUeberlagerungDenkt.
  ///
  /// In de, this message translates to:
  /// **'Einen Moment…'**
  String get wakewortUeberlagerungDenkt;

  /// No description provided for @wakewortUeberlagerungNichtsVerstanden.
  ///
  /// In de, this message translates to:
  /// **'Nichts verstanden.'**
  String get wakewortUeberlagerungNichtsVerstanden;

  /// No description provided for @wakewortUeberlagerungSchliessenHinweis.
  ///
  /// In de, this message translates to:
  /// **'Esc oder Klick daneben zum Schließen'**
  String get wakewortUeberlagerungSchliessenHinweis;

  /// No description provided for @wakewortUeberlagerungFolgefrage.
  ///
  /// In de, this message translates to:
  /// **'Noch eine Frage?'**
  String get wakewortUeberlagerungFolgefrage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
