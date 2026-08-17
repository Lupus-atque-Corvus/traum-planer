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

## Lizenz

Noch nicht festgelegt.
