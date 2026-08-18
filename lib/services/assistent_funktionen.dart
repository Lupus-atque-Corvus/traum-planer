import 'package:drift/drift.dart' show Value;

import '../data/database.dart';
import '../data/tables.dart';
import '../data/vorkommen_repository.dart';
import '../data/wiederholung_logik.dart';
import '../models/eintrag_status.dart';
import '../models/vorkommen.dart';

/// Funktionsaufruf-Schnittstelle für die künftige lokale LLM-Erweiterung
/// (Phase 8). Jede Funktion entspricht 1:1 einem Eintrag aus der
/// Spezifikation (Abschnitt 7, Phase 8) und arbeitet ausschließlich über
/// die bestehenden Repositories — unabhängig davon, ob tatsächlich ein LLM
/// angeschlossen ist. Das eigentliche Sprachmodell (Ollama) und die
/// Anbindung von Funktionsaufrufen an dessen Tool-Calling-Format sind noch
/// nicht Teil dieser Datei, siehe `docs/spec.md` Abschnitt 7 Phase 8.
class AssistentFunktionen {
  final AppDatabase db;
  final VorkommenRepository vorkommenRepository;

  const AssistentFunktionen(this.db, this.vorkommenRepository);

  /// `plaene_abfragen` — damit das Modell gültige `planId`-Werte kennt,
  /// bevor es `aufgabe_hinzufuegen` aufruft.
  Future<List<Plan>> planeAbfragen() => db.alleplaeneLaden();

  /// `heute_offen_abfragen`
  Future<List<Vorkommen>> heuteOffenAbfragen() async {
    final heute = nurDatum(DateTime.now());
    final alle = await vorkommenRepository.beobachteZeitraum(heute, heute).first;
    return alle.where((v) => v.status == EintragStatus.offen).toList();
  }

  /// `heute_erledigt_abfragen`
  Future<List<Vorkommen>> heuteErledigtAbfragen() async {
    final heute = nurDatum(DateTime.now());
    final alle = await vorkommenRepository.beobachteZeitraum(heute, heute).first;
    return alle.where((v) => v.istErledigt).toList();
  }

  /// `zeitraum_erledigt_abfragen(von, bis)`
  Future<List<Vorkommen>> zeitraumErledigtAbfragen(DateTime von, DateTime bis) async {
    final alle = await vorkommenRepository.beobachteZeitraum(von, bis).first;
    return alle.where((v) => v.istErledigt).toList();
  }

  /// `aufgabe_hinzufuegen(plan, titel, uhrzeit, wiederholung)`
  ///
  /// [planId] muss auf einen vorhandenen Plan verweisen. [uhrzeitMinuten]
  /// optional (Minuten seit Mitternacht). [wochentagBitmaske] bestimmt bei
  /// täglicher/wochentagsbasierter Wiederholung die aktiven Tage; bei
  /// [typ] == monatlich wird stattdessen [monatsTag] verwendet.
  Future<Aufgabe> aufgabeHinzufuegen({
    required int planId,
    required String titel,
    int? uhrzeitMinuten,
    required WiederholungsTyp typ,
    int? wochentagBitmaske,
    int? monatsTag,
  }) async {
    final regelId = await db.regelSpeichern(WiederholungsregelnCompanion.insert(
      typ: typ,
      wochentagBitmaske: Value(typ == WiederholungsTyp.monatlich ? null : (wochentagBitmaske ?? Wochentag.alle)),
      monatsTag: Value(typ == WiederholungsTyp.monatlich ? monatsTag : null),
    ));

    final aufgabeId = await db.aufgabeSpeichern(AufgabenCompanion.insert(
      planId: planId,
      titel: titel,
      uhrzeitMinuten: Value(uhrzeitMinuten),
      wiederholungsregelId: regelId,
    ));

    return (await db.alleAufgabenLaden()).firstWhere((a) => a.id == aufgabeId);
  }

  /// `termin_hinzufuegen(titel, datum, uhrzeit)`
  Future<Termin> terminHinzufuegen({
    required String titel,
    required DateTime datum,
    int? uhrzeitMinuten,
  }) async {
    final id = await db.terminSpeichern(TermineCompanion.insert(
      titel: titel,
      datum: nurDatum(datum),
      uhrzeitMinuten: Value(uhrzeitMinuten),
    ));
    return (await (db.select(db.termine)..where((t) => t.id.equals(id))).getSingle());
  }

  /// `aufgabe_rueckwirkend_abhaken(aufgabe, datum)`
  ///
  /// Schreibt `erledigtAm` = jetzt, `faelligDatum` bleibt unverändert —
  /// zählt damit als "erledigt, verspätet" statt als Fehltag (Spec
  /// Abschnitt 4, Tabelle `Erledigt`).
  Future<void> aufgabeRueckwirkendAbhaken({required int aufgabeId, required DateTime datum}) {
    return db.alsErledigtMarkieren(aufgabeId, nurDatum(datum));
  }

  /// `aufgabe_loeschen(aufgabe)` — löscht die Aufgabe und alle künftigen
  /// Vorkommen (nicht nur ein einzelnes Datum), siehe `planLoeschen`-Pattern
  /// in `einstellungen_screen.dart`/`plaene_screen.dart` für die gleiche
  /// Semantik im UI.
  Future<void> aufgabeLoeschen(int aufgabeId) => db.aufgabeLoeschen(aufgabeId);

  /// `termin_loeschen(termin)`
  Future<void> terminLoeschen(int terminId) => db.terminLoeschen(terminId);
}
