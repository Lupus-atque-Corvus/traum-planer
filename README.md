# TRAUM Planer

Ein eigenständiger, vollständig offline lauffähiger Wochenplaner für Windows und Linux — Aufgaben, wiederkehrende Pläne, Termine, Verlauf/Statistik, später eine lokale, zweisprachige Sprach-/LLM-Erweiterung.

Kein Bezug zur mobilen TRAUM-App — eigenes Repo, eigener Code, eigene Datenbank. Der Name teilt bewusst nur das Wort "TRAUM" als persönliche Markenklammer.

## Eigenschaften

- **Zweisprachig** (Deutsch/Englisch), inklusive der geplanten Sprach-/LLM-Erweiterung
- **Vollständig offline** — keine Funktion setzt beim normalen Gebrauch eine Internetverbindung voraus
- **Plattformen:** Windows, Linux (Flutter Desktop, aus einer Codebasis)
- **Lokale Datenhaltung:** SQLite via Drift, keine Cloud-Synchronisation

## Tech-Stack

Flutter/Dart · Drift (SQLite) · Riverpod · GoRouter · `flutter_localizations` (ARB, de/en)

## Status

Projekt befindet sich im Aufbau. Vollständige Spezifikation: [`docs/spec.md`](docs/spec.md).

## Entwicklung

```sh
flutter pub get
flutter run -d windows   # oder: -d linux
```

Generierte Dateien (`lib/data/database.g.dart`, `lib/l10n/gen/`) sind eingecheckt, damit ein frischer Checkout sofort läuft. Nach Änderungen an `lib/data/tables.dart` oder den ARB-Dateien neu generieren:

```sh
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

## Sprach-/LLM-Assistent (Phase 8, optional)

Der Assistent (Roboter-Icon in der Titelleiste) läuft komplett lokal und ist optional — ohne ihn ist die App voll nutzbar. Voraussetzungen, falls gewünscht:

- **LLM:** [Ollama](https://ollama.com) lokal installieren und einmalig `ollama pull qwen2.5:3b` ausführen (App spricht `http://localhost:11434`, siehe `lib/services/ollama_service.dart`). Läuft Ollama nicht, blendet das Panel automatisch einen entsprechenden Hinweis ein.
- **STT:** Whisper-Modell einmalig laden: `bash tool/fetch_models.sh` (lädt `assets/whisper/ggml-small.bin`, ~465 MB, wird als Flutter-Asset gebündelt). Die Spracherkennung (`whisper_ggml`, mehrsprachig, automatische Spracherkennung) lädt das Modell und erkennt die Sprache zuverlässig. **Bekannter Randfall:** Sehr kurze/nahezu leere Aufnahmen (unter ca. 1,2 Sekunden) lassen den nativen Dekodier-Schritt reproduzierbar abstürzen — vermutlich eine Randfall-Indexierung bei sehr wenigen Mel-Frames in `whisper.cpp` selbst (getestet über AVX2- und Baseline-SSE2-Build sowie zwei `whisper_ggml`-Versionen hinweg, tritt in beiden identisch auf). Die App wehrt das jetzt defensiv ab (`lib/services/stt_service.dart`: Aufnahmen unter 1,2 s werden verworfen, bevor `whisper.cpp` überhaupt aufgerufen wird) — mit normaler Sprachdauer (mehr als ein, zwei Worte) tritt der Absturz in Tests nicht mehr auf. Ohne AVX2 (CMake-Option `WHISPER_GGML_AVX2=OFF`) läuft die Dekodierung auf dieser Testhardware zudem spürbar langsamer.
- **TTS:** Windows nutzt die vorinstallierte SAPI (`System.Speech`, kein zusätzliches Setup). Linux benötigt `espeak-ng` (`apt install espeak-ng` o. ä.).

## Windows-Installer

```powershell
flutter build windows --release
& "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe" installer\traum-planer.iss
```

Ergebnis: `installer\output\traum-planer-setup-<version>.exe`. Installiert pro
Benutzerkonto (`%LOCALAPPDATA%\Programs\TRAUM Planer`, kein Adminrecht/UAC
nötig), legt Start-Menü- und Desktop-Verknüpfung an, bündelt die App inkl.
Whisper-Modell (~500 MB). Getestet: kompilieren → installieren → starten →
läuft.

Optionale zweite Komponente bündelt Ollama + `qwen2.5:3b` vollständig
offline mit (kein Download bei der Ersteinrichtung) — dafür müssen erst die
Vendor-Dateien lokal befüllt werden, siehe
[`installer/vendor/ollama/README.md`](installer/vendor/ollama/README.md).
Ohne diese Dateien überspringt der Installer die Komponente automatisch statt
mit einem Fehler abzubrechen.

## Lizenz

Noch nicht festgelegt.
