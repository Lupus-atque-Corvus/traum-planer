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
- **STT:** Whisper-Modell einmalig laden: `bash tool/fetch_models.sh` (lädt `assets/whisper/ggml-small.bin`, ~465 MB, wird als Flutter-Asset gebündelt). Die Spracherkennung (`whisper_ggml`, mehrsprachig, automatische Spracherkennung) lädt das Modell und erkennt die Sprache zuverlässig; **auf mindestens einer getesteten AMD-Ryzen-CPU stürzt der native Dekodier-Schritt danach ab** — ein Bug in der nativen `whisper_ggml`/`ggml`-CPU-Bibliothek selbst (kein Bug im App-Code), reproduzierbar über mehrere Paketversionen hinweg. Vor produktivem Einsatz auf der Zielhardware testen; ggf. auf ein Update von `whisper_ggml` oder eine GPU-fähige Umgebung warten.
- **TTS:** Windows nutzt die vorinstallierte SAPI (`System.Speech`, kein zusätzliches Setup). Linux benötigt `espeak-ng` (`apt install espeak-ng` o. ä.).

## Lizenz

Noch nicht festgelegt.
