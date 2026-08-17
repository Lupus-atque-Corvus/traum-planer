# Wochenplan — UI-Design

Eigenständiges Desktop-UI für die Flutter-App (Windows/Linux, Tray-Resident). Referenz für die 1:1-Umsetzung in Flutter-Widgets.

## Design-Identität & Begründung

**Dunkles Theme als Standard.** Die App läuft dauerhaft im Hintergrund und wird mehrmals täglich für Sekunden aufgerufen — sie soll sich wie ein ruhiger, immer verfügbarer Begleiter anfühlen, nicht wie eine grelle Arbeitsanwendung. Ein dunkler, leicht blaugrauer Grund ermöglicht kräftige, eindeutige Status- und Kategoriefarben mit hohem Kontrast, ohne dass die Oberfläche selbst Aufmerksamkeit zieht. Kein Material-Default: keine Ripple-Effekte, keine erhabenen FABs, keine violette Standardpalette — stattdessen flache Flächen, dünne Trennlinien, eine eigene schmale Titelleiste (die App zeichnet ihr eigenes Fenster-Chrome) und eine kompakte Seitenleiste statt Bottom-Nav.

**Prinzip:** Funktion vor Dekoration. Farbe wird ausschließlich zur Bedeutungsvermittlung eingesetzt (Status, Kategorie) — nirgends dekorativ. Jede Ansicht muss ihren Zustand in unter einer Sekunde lesbar machen.

## Design-Tokens

### Farben — Neutral (Basis)

| Token | Hex | Verwendung |
|---|---|---|
| `bg.base` | `#14161C` | Fensterhintergrund, Content-Grund |
| `bg.surface` | `#1B1E26` | Karten, Zeilen, Seitenleiste |
| `bg.surfaceRaised` | `#232630` | Hover, aktive Karten, Dialoge |
| `bg.overlay` | `#2A2E3A` | Aktiver Nav-Eintrag, gedrückte Zustände |
| `border.subtle` | `#262A34` | Trennlinien, Kartenrand |
| `border.strong` | `#3A4050` | Eingabefelder, Fokusrahmen-Kontur |
| `text.primary` | `#ECEEF2` | Haupttext |
| `text.secondary` | `#A6ACBB` | Metadaten, Sekundärlabels |
| `text.tertiary` | `#6B7180` | Deaktiviert, Platzhalter, erledigt-durchgestrichen |

### Farben — Status (konsistent in allen Ansichten)

| Token | Hex | Bedeutung |
|---|---|---|
| `status.open` | `#7A8194` | Offen — neutraler Umriss, keine Auffälligkeit |
| `status.doneOnTime` | `#57C97F` | Erledigt, pünktlich |
| `status.doneLate` | `#EAAE49` | Erledigt, verspätet nachgeholt |
| `status.missed` | `#4A4F5C` | Vergangen ohne Eintrag / verpasst (gedämpft, keine Warnfarbe — kein Vorwurfscharakter) |

### Farben — Kategorie-Akzente (frei erweiterbar, gleiche Helligkeit/Sättigung, Hue variiert)

| Kategorie | Hex |
|---|---|
| Ernährung | `#E8735A` |
| Morgen | `#F0C550` |
| Abend | `#8B7CF0` |
| Haushalt | `#4FB8D6` |
| Frei 1 | `#E876B8` |
| Frei 2 | `#52C79A` |

Neue Kategorien erhalten beim Erstellen eine der nicht belegten Farben aus dieser Reihe (Rotation), Nutzer kann frei überschreiben.

### Marke / Interaktion

| Token | Hex | Verwendung |
|---|---|---|
| `brand.primary` | `#6C8EF5` | Primärbuttons, Fokusring, aktiver Nav-Indikator — bewusst kein Kategorie-Ton, damit UI-Chrome nie mit einer Kategorie verwechselt wird |
| `brand.primaryHover` | `#7E9CF7` | Hover auf Primärbutton |

### Typografie

- **UI-Schrift:** Inter (via `google_fonts`), Schnitte 400/500/600
- **Zahlen/Uhrzeiten:** IBM Plex Mono 500 — Uhrzeiten, Prozentwerte, Streak-Zähler, damit Ziffern in Listen sauber untereinanderstehen

| Rolle | Größe | Schnitt |
|---|---|---|
| Fenstertitel | 13px | 500 |
| Bildschirmtitel (H1) | 22px | 600 |
| Abschnittstitel (H2) | 15px | 600 |
| Body | 14px | 400 |
| Meta / sekundär | 12px | 400 |
| Mikro (Badges, Legenden) | 11px | 500 |

### Abstände

`4 · 8 · 12 · 16 · 24 · 32 · 48` px — Innenabstand von Karten 12–16px, Abschnittsabstand 24–32px.

### Ecken & Icons

- Radius: 8px (Buttons, Chips, Zeilen), 12px (Karten), 16px (Dialoge), 999px (Pills, Status-Punkte)
- Icons: reine Strichzeichnung, 1.5px Stärke, 18–20px Standardgröße, gefüllte Variante nur für aktive/ausgewählte Zustände. Keine Emoji.

## Gemeinsames App-Gerüst

Eigene schmale Titelleiste (40px, `bg.base`, Bottom-Border `border.subtle`): links App-Name + kleiner Tray-Indikatorpunkt, rechts drei einfache Fenstersteuerungen (minimieren/maximieren/schließen).

Seitenleiste (224px, `bg.surface`, rechter Rand `border.subtle`): Logo-Mark + "Wochenplan", darunter Navigation *Heute · Woche · Monat · Verlauf*, Trenner, dann *Pläne · Einstellungen*. Aktiver Eintrag: `bg.overlay` + 3px linker Akzentstreifen in `brand.primary`.

---

## Bildschirme

### 1. Heute-Ansicht (Startbildschirm)

Kopfzeile: Wochentag + Datum ausgeschrieben (H1), rechts optional Streak-Badge ("🔥" wird **nicht** verwendet — stattdessen kleines Flammen-freies Pill mit Zahl + "Tage in Folge").

Zwei Abschnitte, je mit H2-Label und Zähler ("Noch offen (3)", "Bereits erledigt (5)"). Jede Aufgabenzeile: linke Kategoriefarbleiste (4×28px, `radius 4`), Statuskreis (20px: offener Ring `status.open` / gefüllter Haken `status.doneOnTime` / gefüllter Haken mit kleinem Uhr-Glyph `status.doneLate`), Titel, optionale Uhrzeit in Mono-Schrift als Meta, rechts Kategorie-Label. Erledigte Zeilen: Hintergrund einen Ton dunkler, Titel in `text.tertiary`, Icon zeigt erledigt-Zustand. Termine (einmalig) erscheinen im passenden Abschnitt mit gestrichelter statt farbiger Leiste und Label "Termin" statt Kategorie.

**Zustände:**
- *Gemischt* (Standard): beide Abschnitte gefüllt.
- *Alles offen*: Abschnitt "Bereits erledigt" zeigt eine ruhige Leerzeile "Noch nichts erledigt".
- *Alles erledigt*: Abschnitt "Noch offen" zeigt "Alles für heute erledigt ✓" (als Text, kein Emoji-Icon nötig) zentriert, gedämpft.
- *Kein Eintrag für heute*: einzelner zentrierter Hinweis "Für heute ist nichts geplant." mit Verweis-Link auf Wochenansicht.

### 2. Wochenansicht

Kopfzeile: "Woche" (H1) + Datumsspanne (z. B. "11.–17. Aug"), rechts Navigation `‹ Diese Woche ›`. 7-Spalten-Grid Montag–Sonntag, Spaltenkopf = Wochentag + Tagesnummer; heutige Spalte durch `brand.primary`-Unterstrich am Kopf hervorgehoben. Pro Zelle: kompakte Chips (Kategoriefarbe als linke Kante, Titel, Uhrzeit falls vorhanden), Termine als Chip mit gestrichelter Kante statt Kategoriefarbe. Erledigte Aufgaben im Chip durch reduzierte Deckkraft + kleines Haken-Symbol markiert (Farbcode bleibt Kategorie, nicht Status — Statusinfo ist hier sekundär zur Übersicht). Spalten scrollen unabhängig bei vielen Einträgen.

### 3. Monatsansicht

Kopfzeile: Monat + Jahr (H1), Navigation `‹ ›`. 7×5(6)-Kachelraster, Wochentagskopf oben. Jede Kachel: Tagesnummer oben links, am unteren Rand ein schmaler **Segmentbalken** (3–4px) statt Vollflächenfärbung — Segmente je nach Erledigungsanteil: `status.doneOnTime` / `status.doneLate` / `status.open` / `status.missed`, proportional zur Aufgabenzahl des Tages. Das hält die Fläche ruhig ("nicht überladen") und zeigt trotzdem sofort: **voll erledigt** = durchgehend grüner Balken, **teilweise** = gemischtes Segment, **offen** (heute/zukünftig, noch nichts fällig gewesen) = neutrale dünne Kontur ohne Balken, **vergangen ohne Eintrag** = Kachel-Hintergrund `bg.base` statt `bg.surface` (sichtbar "leerer" als Tage mit Einträgen). Heutige Kachel: `brand.primary`-Rahmen 1.5px. Kleine Legende unter dem Raster.

### 4. Verlauf und Statistik

Kopfzeile: "Verlauf" (H1), rechts Zeitraum-Umschalter (Segmented Control: *Woche · Monat · Jahr*). Zwei-Spalten-Layout:

- **Links (40%):** Liste aller Pläne/Aufgaben, je Zeile: Titel, Erfolgsquote in % (Mono-Schrift, groß), schmaler horizontaler Fortschrittsbalken darunter, Streak-Pill rechts ("12 Tage Streak").
- **Rechts (60%):** Balkenverlauf über den gewählten Zeitraum — je Balken (Tag oder Woche) gestapelt aus `status.doneOnTime` (unten) und `status.doneLate` (oben, hellerer Ton), Höhe = Gesamtanteil erledigt; fehlender Rest bis 100% bleibt `bg.surface`-Lücke. Legende darunter erklärt die zwei Farbtöne explizit.

### 5. Plan erstellen/bearbeiten

Dialog (480px, `radius 16`, `bg.surfaceRaised`). Felder von oben: Titel (Textfeld), Kategorie (Dropdown mit vordefinierten + "Neue Kategorie…"), Akzentfarbe (Swatch-Reihe der 6 Kategoriefarben + "Eigene…" öffnet Farbwähler). Footer: Sekundärbutton "Abbrechen", Primärbutton "Speichern" (deaktiviert bis Titel gefüllt).

### 6. Aufgabe erstellen/bearbeiten

Dialog (520px). Felder: Titel, Uhrzeit (optional, Toggle "Uhrzeit festlegen" blendet Zeitfeld ein), Wiederholung als Chip-Picker der 7 Wochentage (Mo–So, Mehrfachauswahl, aktive Chips in Plan-Akzentfarbe gefüllt) plus Schnellwahl-Chips "Täglich" / "Wöchentlich" / "Monatlich" darüber, die die Tagesauswahl vorbelegen bzw. durch ein Datumsfeld ersetzen (monatlich). Footer links: "Löschen" (nur im Bearbeiten-Modus, Textbutton in gedämpftem Rot `#D4695E`, öffnet Bestätigungsdialog "Aufgabe wirklich löschen? Das kann nicht rückgängig gemacht werden." mit Abbrechen/Löschen). Footer rechts: Abbrechen/Speichern.

### 7. Dialog "Nur diese Woche" vs. "Immer ändern"

Kompakter Dialog (400px), erscheint beim Bearbeiten einer wiederkehrenden Aufgabe. Titel: "Diese Änderung gilt für…". Zwei große, gleich große Auswahlkarten **untereinander** (nicht nebeneinander — verhindert Mo/Do-artige Fehlklicks durch klar getrennte Zeilen statt Spalten): Karte 1 "Nur diese Woche" mit Subtext "Ändert nur den Termin in der aktuellen Woche, die Serie bleibt unverändert."; Karte 2 "Immer ändern" mit Subtext "Ändert die Wiederholungsregel dauerhaft für alle zukünftigen Wochen." Jede Karte ist per Klick die gesamte Aktion (kein separater Button), Hover hebt `border.strong` hervor. Kein Default-fokussierter Zustand — erzwingt bewusste Wahl.

### 8. Termin erstellen

Dialog (480px). Felder: Titel, Datum (Datumsfeld mit Kalender-Popover), Uhrzeit (optional, gleicher Toggle wie bei Aufgaben), Ort (optional, Textfeld). Kein Kategoriefeld — Termine sind planunabhängig und erhalten visuell die neutrale gestrichelte Markierung statt einer Kategoriefarbe.

### 9. Tray-Menü

Natives, minimales Kontextmenü (system-gerendert, kein eigenes Styling nötig, nur Struktur vorgeben): **Fenster öffnen** · **Heute anzeigen** · Trennlinie · **Beenden**. Klick auf Tray-Icon selbst = Fenster öffnen/fokussieren (Standardaktion).

### 10. Chat-/Sprachfenster (Platzhalter, niedrige Priorität)

Grober Entwurf für spätere LLM-Erweiterung: schwebendes Panel (360×480px, gleiche `bg.surfaceRaised`/`radius 16`), Kopfzeile "Assistent", Nachrichtenverlauf (leer im Platzhalter), unten Eingabezeile mit Textfeld + Mikrofon-Icon-Button + Senden-Button. Wird in dieser Runde nicht weiter ausgearbeitet.

---

## HTML-Mockups

Visuelle Referenz für die vier zentralen Ansichten, im selben Projekt:

- Heute-Ansicht → `Heute-Ansicht.dc.html`
- Wochenansicht → `Wochenansicht.dc.html`
- Monatsansicht → `Monatsansicht.dc.html`
- Verlauf & Statistik → `Verlauf.dc.html`

Fenstergröße im Mockup: 1440×900 (Referenzgröße innerhalb 1280×800–1920×1080).
