# TRAUM Planer — Gesamtspezifikation

Ein Dokument: Datenmodell, Design-System, Phasen-Checkliste, offene Fragen. Ersetzt die getrennten Dateien `wochenplan-app-claude-code-liste.md` und `wochenplan-ui-design.md` als Referenz für die Umsetzung — beide bleiben zusätzlich als Einzeldateien erhalten, hier steht alles zusammen an einem Ort.

---

## 1. Einordnung

App-Name: **TRAUM Planer**. Eigenständiges neues Projekt, eigenes GitHub-Repo, keine Verbindung zur mobilen TRAUM-App — kein gemeinsamer Code, keine gemeinsame Datenbank, kein gemeinsames Repo. Der Name teilt bewusst das Wort "TRAUM" als persönliche Markenklammer, ändert aber nichts an der technischen Trennung, die vorher festgelegt wurde.

Vorschlag für Repo- und Package-Namen, passend zur bestehenden Konvention (`de.traum.traum` für die Mobile-App): Repo `traum-planer`, Package `de.<name>.traumplaner` — beides eine Annahme, frei überschreibbar.

Einzige technische Übertragung: die Sprache/das Framework. Flutter/Dart ist aus dem TRAUM-Projekt bereits bekannt und baut nativ für Windows und Linux aus einer Codebasis. Ebenfalls übernommen: die Konvention "kein hartcodierter sichtbarer String, alles über ARB (de/en)" — dort bereits bewährt.

## 2. Harte Anforderungen (neu, gelten für alle Phasen)

- **Zweisprachig, Deutsch und Englisch**, inklusive des Sprachmodells (Text, Spracheingabe, Sprachausgabe) — nicht nur die UI.
- **Vollständig offline lauffähig.** Keine Funktion darf beim normalen Gebrauch eine Internetverbindung voraussetzen. Ausnahme, die unten als offene Frage markiert ist: ein möglicher einmaliger Download bei der Ersteinrichtung der LLM-/Spracherweiterung.
- **Funktioniert beim ersten Start ohne manuelles Nacharbeiten.** Das betrifft vor allem zwei Stellen, an denen die bisherige Planung sonst stillschweigend Internet vorausgesetzt hätte — siehe Abschnitt 6, "Korrekturen für Offline".

## 3. Architektur / Tech-Stack

| Bereich | Wahl |
|---|---|
| Framework | Flutter/Dart, Ziel-Plattformen Windows + Linux |
| Datenbank | Drift (SQLite) über `sqlite3_flutter_libs`, lokal, keine Cloud |
| State/Routing | Riverpod + GoRouter |
| Lokalisierung | `flutter_localizations` + ARB-Dateien für `de` und `en`, kein hartcodierter String |
| Schriftarten | Inter (400/500/600) + IBM Plex Mono (500), **lokal als Asset gebündelt**, nicht über `google_fonts`-Laufzeitabruf |
| Diagramme | `fl_chart` (Phase 4) |
| Tray/Autostart | `tray_manager` oder `system_tray` (Phase 6), plattformspezifische Autostart-Einträge |
| Fenster-Chrome | `window_manager` oder vergleichbar, für eigene Titelleiste ohne OS-Standardrahmen |
| STT (Phase 8) | `whisper.cpp` via FFI, mehrsprachiges Modell, lokal |
| TTS (Phase 8) | plattformabhängig: Windows SAPI, Linux `espeak-ng` o. ä. |
| LLM (Phase 8) | lokal via Ollama, zweisprachig fähiges Modell |

## 4. Datenmodell

| Tabelle | Felder | Zweck |
|---|---|---|
| `Plaene` | id, titel, kategorie, akzentfarbe, sortierindex | Ernährung/Morgen/Abend/Haushalt/frei definierbar |
| `Aufgaben` | id, planId, titel, beschreibung, uhrzeit (optional), wiederholungsregel, sortierindex | Eine Zeile pro Vorkommen — mehrmals-am-Tag-Aufgaben (z. B. "Zähne putzen morgens"/"…abends") als getrennte Einträge, kein Zähler-Feld |
| `Wiederholungsregeln` | Typ (täglich/bestimmte Wochentage/wöchentlich/monatlich), Wochentag-Bitmaske | Steuert Fälligkeit |
| `Erledigt` | aufgabeId, **faelligDatum**, erledigt (bool), **erledigtAm** (Zeitstempel, nullable) | Geplantes und tatsächliches Datum getrennt — an einem anderen Tag nachgeholt zählt als "erledigt, verspätet", nicht als Fehltag |
| `Termine` | id, titel, beschreibung, datum, uhrzeit (optional), ort (optional) | Einmalige Ereignisse ohne Plan-Bezug |
| `Ausnahmen` | aufgabeId, datum, typ (verschoben/geändert/ausgefallen), neueUhrzeit (optional), neuerTitel (optional) | Überschreibt die Wiederholungsregel für ein einzelnes Datum, ohne die Vorlage anzufassen |
| `Einstellungen` | Key-Value (z. B. `sprache`, `zeitformat`) | Nutzerpräferenzen: Sprache (de/en/system), Zeitformat (12h/24h), lokal gespeichert, kein Cloud-Bezug |

Migrationsstrategie ab `schemaVersion` 1 dokumentieren (Drift-Konvention wie in TRAUM).

**Hinweis zu Nutzerinhalten:** Titel/Beschreibungen, die der Nutzer selbst einträgt (Aufgaben, Termine), werden nicht übersetzt und nicht lokalisiert — die Zweisprachigkeit betrifft ausschließlich System-Strings (Menüs, Labels, Dialoge, Sprachmodell-Antworten), nicht Nutzereingaben.

## 5. Design-System

### Identität
Dunkles Theme als Standard, eigenes Fenster-Chrome (40px Titelleiste, App zeichnet Minimieren/Maximieren/Schließen selbst), Seitenleiste (224px) statt Bottom-Nav. Kein Material-Default: keine Ripple-Effekte, keine erhabenen FABs, keine violette Standardpalette. Funktion vor Dekoration — Farbe ausschließlich zur Bedeutungsvermittlung (Status, Kategorie).

### Design-Tokens

| Kategorie | Token | Hex |
|---|---|---|
| Neutral | bg.base / bg.surface / bg.surfaceRaised / bg.overlay | `#14161C` / `#1B1E26` / `#232630` / `#2A2E3A` |
| Neutral | border.subtle / border.strong | `#262A34` / `#3A4050` |
| Neutral | text.primary / secondary / tertiary | `#ECEEF2` / `#A6ACBB` / `#6B7180` |
| Status | open / doneOnTime / doneLate / missed | `#7A8194` / `#57C97F` / `#EAAE49` / `#4A4F5C` |
| Kategorie | Ernährung / Morgen / Abend / Haushalt / Frei 1 / Frei 2 | `#E8735A` / `#F0C550` / `#8B7CF0` / `#4FB8D6` / `#E876B8` / `#52C79A` |
| Marke | brand.primary / primaryHover | `#6C8EF5` / `#7E9CF7` |

Radius: 8px (Buttons/Chips/Zeilen), 12px (Karten), 16px (Dialoge), 999px (Pills). Abstandsskala: 4·8·12·16·24·32·48px. Icons: Strichzeichnung 1.5px, 18–20px, keine Emoji.

Typografie: Fenstertitel 13px/500, H1 22px/600, H2 15px/600, Body 14px/400, Meta 12px/400, Mikro 11px/500. Zahlen/Uhrzeiten in IBM Plex Mono für sauberen Ziffernblock in Listen.

### Bildschirme (10, alle mit Zuständen im Design-Dokument spezifiziert)

1. **Heute-Ansicht** (Start) — Abschnitte "Noch offen (n)" / "Bereits erledigt (n)", Kategorie-Farbleiste, Statuskreis (Ring offen / Haken pünktlich / Haken mit Uhr-Glyph verspätet), Termine mit gestrichelter Leiste. Zustände: gemischt, alles offen, alles erledigt, kein Eintrag.
2. **Wochenansicht** — 7-Spalten-Grid, heutige Spalte hervorgehoben, Chips pro Aufgabe (Kategoriefarbe als Kante), Status über Deckkraft + Haken-Symbol statt Farbe.
3. **Monatsansicht** — Kachel pro Tag, schmaler Segmentbalken statt Vollflächenfärbung, "vergangen ohne Eintrag" über gedämpften Kachel-Hintergrund erkennbar.
4. **Verlauf und Statistik** — Zeitraum-Umschalter (Woche/Monat/Jahr), links Erfolgsquote + Streak pro Aufgabe/Plan, rechts gestapelter Balkenverlauf (pünktlich unten, verspätet oben, hellerer Ton).
5. **Plan erstellen/bearbeiten** — Dialog, Titel/Kategorie/Akzentfarbe.
6. **Aufgabe erstellen/bearbeiten** — Dialog, Wochentag-Chip-Picker + Schnellwahl täglich/wöchentlich/monatlich, Löschen mit Bestätigung.
7. **"Nur diese Woche" vs. "Immer ändern"** — zwei Karten **untereinander**, kein vorfokussierter Zustand, bewusst gegen Fehlklicks.
8. **Termin erstellen** — Titel, Datum, Uhrzeit optional, Ort optional, kein Kategoriefeld.
9. **Tray-Menü** — nativ, minimal: Fenster öffnen · Heute anzeigen · Beenden.
10. **Chat-/Sprachfenster** (Platzhalter, Phase 8) — schwebendes Panel, Nachrichtenverlauf, Eingabezeile mit Mikrofon-Button.

Vollständige Zustandsbeschreibungen und vier HTML-Mockups (Heute/Woche/Monat/Verlauf) liegen in `docs/design/`.

## 6. Korrekturen für Offline (Ergebnis der Prüfung)

Zwei Stellen in der bisherigen Planung setzten stillschweigend Internet voraus — beide jetzt korrigiert:

- **Schriftarten.** Das Design-Dokument referenziert Inter/IBM Plex Mono über `fonts.googleapis.com` (nur als visuelle Mockup-Referenz gedacht). Für die App: Schriftdateien lokal unter `assets/fonts/` bündeln, `google_fonts`-Laufzeitabruf **nicht** verwenden — sonst schlägt der allererste Start ohne Internetverbindung fehl oder zeigt Fallback-Schriften. Gleiche Lösung wie in TRAUM (dort DM Sans lokal eingebettet).
- **LLM-/STT-Modell (Phase 8).** Ollama-Modelle und Whisper-Gewichte werden normalerweise per Netzwerk-Pull geladen. Für Offline-Betrieb ab dem ersten Start müssten diese Modelle im Installer gebündelt sein — betrifft die Installer-Größe erheblich (mehrere hundert MB bis wenige GB). Nicht automatisch gelöst, siehe offene Frage 2 unten.

## 7. Phasen-Checkliste

### Phase 0 — Projekt-Setup
- [ ] GitHub-Repo `traum-planer` anlegen — Annahme: **privat**, da persönliches Planungstool, jederzeit später in den Einstellungen auf öffentlich umstellbar. Über `gh repo create traum-planer --private --source=. --remote=origin` (setzt authentifizierte GitHub-CLI voraus) oder manuell auf github.com plus `git remote add origin`
- [ ] `README.md` mit Kurzbeschreibung des Projekts (Name TRAUM Planer, Zweck, Plattformen) anlegen
- [ ] Bestehende Projektdokumente hochladen: `docs/spec.md` (Inhalt aus `wochenplan-app-spec-gesamt.md`), `docs/design/` mit `wochenplan-ui-design.md` und den vier HTML-Mockups
- [ ] `.gitignore` für Flutter/Dart ergänzen (`.dart_tool/`, Build-Ordner, IDE-Dateien)
- [ ] Ersten Commit + Push nach `origin/main`
- [ ] Ersten Release-Tag setzen, z. B. `v0.1.0-planning`, Release-Notes: "Projektspezifikation und UI-Design abgeschlossen, Code-Umsetzung beginnt mit Phase 0." **Enthält noch keine lauffähige Anwendung** — vor Abschluss von Phase 3 gibt es keinen Build. Ein Release mit echten Windows-/Linux-Binaries ist sinnvollerweise erst nach den ersten nutzbaren Kernansichten fällig
- [ ] `flutter create --platforms=windows,linux <projektname>` (kann in dasselbe Repo oder als Folge-Commit erfolgen)
- [ ] Ordnerstruktur: `lib/models`, `lib/data`, `lib/screens`, `lib/widgets`, `lib/theme`, `lib/l10n`
- [ ] Drift + `sqlite3_flutter_libs` für Desktop, eigene neue Datenbankdatei
- [ ] Riverpod + GoRouter
- [ ] `flutter_localizations` + ARB-Grundgerüst für `de` und `en` anlegen — ab dem ersten Screen konsequent nutzen, nicht nachträglich
- [ ] Locale-Logik: Systemsprache als Default, manuell umschaltbar, Fallback Englisch falls Systemsprache weder de noch en
- [ ] Inter + IBM Plex Mono als lokale Font-Assets einbinden (kein `google_fonts`-Laufzeitabruf)
- [ ] `window_manager` (oder vergleichbar) für eigenes Fenster-Chrome
- [ ] Pakete für Phase 4 (`fl_chart`) und Phase 6 (`tray_manager`/`system_tray`) einplanen

### Phase 1 — Datenmodell
- [ ] Tabellen wie in Abschnitt 4 anlegen: `Plaene`, `Aufgaben`, `Wiederholungsregeln`, `Erledigt`, `Termine`, `Ausnahmen`, `Einstellungen`
- [ ] Migrationsstrategie ab schemaVersion 1 dokumentieren

### Phase 2 — UI-Design ✅ abgeschlossen
- [x] Design-Tokens, 10 Bildschirme mit Zuständen, 4 HTML-Mockups vorhanden (siehe Abschnitt 5, Volltext in `docs/design/`)
- [ ] Design-Dokument + Mockups im Repo ablegen unter `docs/design/`
- [ ] Design-Tokens als Flutter-`ThemeData`/`ColorScheme` übertragen

### Phase 3 — Kernansichten: Tag, Woche, Monat
- [ ] Heute-Ansicht: Abschnitte "Offen"/"Erledigt", Abhaken wandert zwischen Abschnitten
- [ ] Wochenansicht: Raster Mo–So, Pläne + Termine kombiniert
- [ ] Monatsansicht: Kachel pro Tag, Segmentbalken nach Erledigungsgrad
- [ ] Zentraler Umschalter Tag/Woche/Monat
- [ ] Navigation vor/zurück, auch in die Vergangenheit
- [ ] Tageswechsel um Mitternacht automatisch

### Phase 4 — Verlauf und Statistik
- [ ] Vergangene Zeiträume aufrufbar, offen für rückwirkendes Abhaken
- [ ] Rückwirkendes Abhaken schreibt `erledigtAm`, `faelligDatum` bleibt unverändert
- [ ] Filteransicht "erledigt in diesem Zeitraum" (Woche/Monat/gesamt)
- [ ] Erfolgsquote pro Aufgabe/Plan über wählbaren Zeitraum
- [ ] Streak-Berechnung aus vorhandenen Daten, keine zusätzliche Tabelle
- [ ] Grafische Übersicht (`fl_chart`), pünktlich vs. verspätet farblich unterschieden

### Phase 5 — Bearbeiten
- [ ] Plan erstellen: Titel, Kategorie, Akzentfarbe
- [ ] Aufgabe hinzufügen/bearbeiten/löschen, Wiederholungsregel als Chip-Picker
- [ ] "Nur diese Woche" vs. "Immer ändern"-Dialog bei wiederkehrenden Aufgaben
- [ ] Termin erstellen (Titel, Datum, Uhrzeit optional, Ort optional)
- [ ] Reihenfolge per Drag & Drop
- [ ] Plan löschen mit Bestätigung
- [ ] Einstellungsbildschirm (aus der Seitenleiste erreichbar, siehe Design-Gerüst): Zeitformat 12h/24h als Umschalter, Sprachumschalter (siehe Phase 7)

### Phase 6 — Dauerbetrieb und Systemintegration
- [ ] Autostart mit dem System (Windows: Autostart-Ordner/Registry, Linux: `.desktop` in `~/.config/autostart/`)
- [ ] Tray-Icon statt Beenden, Tray-Menü (Fenster öffnen, Heute anzeigen, Beenden)
- [ ] Ressourcenschonender Hintergrundbetrieb (kein Polling, nur Mitternachts- und Benachrichtigungs-Timer)
- [ ] Lokale Desktop-Benachrichtigung X Minuten vor Aufgabe
- [ ] Export als druckbares HTML im bisherigen A3-Design
- [ ] JSON-Export/Import für Backup

### Phase 7 — Lokalisierung DE/EN (neu)
- [ ] Alle UI-Strings aus Phase 3–6 vollständig in ARB (de, en) nachziehen, keine Lücken
- [ ] Datum-/Uhrzeitformat: **12h/24h als Nutzereinstellung wählbar** (gespeichert in `Einstellungen`), unabhängig von der UI-Sprache — kein Automatismus, Nutzer entscheidet selbst
- [ ] Sprachumschalter in Einstellungen, Wechsel wirksam ohne Neustart
- [ ] HTML-Export (aus Phase 6) ebenfalls zweisprachig, abhängig von aktueller App-Spracheinstellung, Zeitformat im Export folgt derselben Einstellung

### Phase 8 — Sprach- und LLM-Erweiterung (später, offline + zweisprachig)
- [ ] Lokales STT: `whisper.cpp`, mehrsprachiges Modell, **automatische Spracherkennung** (Deutsch/Englisch gemischt möglich, kein Umweg über UI-Sprache)
- [ ] Lokales TTS: Windows SAPI (de-DE/en-US), Linux `espeak-ng` o. ä. als dokumentierte Abhängigkeit
- [ ] Lokales LLM via Ollama, zweisprachig fähiges Modell
- [ ] **Modelle vollständig im Installer bündeln** — App ist ab dem ersten Start offline, keine Downloads bei Ersteinrichtung. Bei der Modellwahl auf kompakte, dennoch zweisprachig taugliche Varianten achten, da Installer-Größe direkt betroffen ist
- [ ] Funktionsaufruf-Schnittstelle, zweisprachig getestet:
  - `heute_offen_abfragen`
  - `heute_erledigt_abfragen`
  - `zeitraum_erledigt_abfragen(von, bis)`
  - `aufgabe_hinzufuegen(plan, titel, uhrzeit, wiederholung)`
  - `termin_hinzufuegen(titel, datum, uhrzeit)`
  - `aufgabe_rueckwirkend_abhaken(aufgabe, datum)`
- [ ] Chat-/Sprachfenster als abschaltbarer Bildschirm, App bleibt ohne LLM voll nutzbar

## 8. Offene Fragen

Vier Punkte entschieden, einer verbleibt informativ ohne nötige Entscheidung:

1. ~~STT-Spracherkennung~~ — **entschieden: automatisch erkennen.** Deutsch und Englisch gemischt möglich, kein Umweg über die UI-Sprache.
2. ~~Modell-Bündelung LLM/STT~~ — **entschieden: im Installer bündeln.** App ist ab dem ersten Start vollständig offline, kein Setup-Download nötig. Installer-Größe entsprechend höher (mehrere hundert MB bis wenige GB, abhängig von Modellwahl) — bei der Modellauswahl in Phase 8 gezielt auf kompakte, dennoch zweisprachig taugliche Modelle achten.
3. ~~Linux-Vertriebsformat~~ — **entschieden: AppImage.** Läuft auf den meisten Distributionen ohne Installation.
4. **Code-Signing:** unsignierte Programme lösen bei Windows beim ersten Start eine SmartScreen-Warnung aus ("Windows hat den Start dieser App verhindert") — normales Verhalten bei unsignierten Indie-Programmen, kein Bug. Zur Kenntnis, keine Entscheidung nötig, außer eine Signatur ist gewünscht (kostenpflichtig).
5. ~~Datumsformat~~ — **entschieden: nutzerwählbar.** 12h/24h als Einstellung, siehe `Einstellungen`-Tabelle und Phase 7.

Keine weiteren offenen Fragen, die die Umsetzung blockieren würden. Alle Phasen 0–8 sind mit den bisher getroffenen Entscheidungen konsistent durchführbar.

## 9. Nicht-Ziele

- Keine Cloud-Synchronisation zwischen Geräten
- Kein Mehrbenutzer-Betrieb
- Keine mobile Version — durch Flutter grundsätzlich portierbar, aber kein Ziel dieser Liste
- Kein Online-Zwang nach der Ersteinrichtung (Ausnahme siehe offene Frage 2)

---

## 10. Nutzung mit Claude Code

```
Lies C:\Users\Lupus\Desktop\wochenplan-app-spec-gesamt.md und führe Phase 0 und Phase 1 aus.
```

Phasenweise abarbeiten, nach jeder Phase kurz gegenprüfen. Repo-Erstellung und erster Release-Tag sind jetzt Teil von Phase 0, laufen also als Allererstes. Phase 2 ist bereits abgeschlossen, Design-Dateien liegen in `docs/design/`. Phase 7 (Lokalisierung) läuft am saubersten parallel zu Phase 3–6, nicht erst danach — sonst müssen hartcodierte Strings nachträglich durchsucht werden.
