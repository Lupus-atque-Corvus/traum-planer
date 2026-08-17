import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Plaene, Wiederholungsregeln, Aufgaben, Erledigt, Termine, Ausnahmen, Einstellungen],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  // Bei Schemaänderungen: Version erhöhen und in `onUpgrade` die Migration
  // von jeder vorherigen Version auf die neue Version beschreiben.
  // Aktuell: Version 1, Ersteinrichtung des Schemas aus der Spezifikation.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // Platz für künftige Migrationsschritte, z. B.:
          // if (from < 2) { await m.addColumn(...); }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // ---- Pläne ----
  Future<List<Plan>> alleplaeneLaden() =>
      (select(plaene)..orderBy([(t) => OrderingTerm(expression: t.sortierindex)])).get();

  Stream<List<Plan>> alleplaeneBeobachten() =>
      (select(plaene)..orderBy([(t) => OrderingTerm(expression: t.sortierindex)])).watch();

  Future<int> planSpeichern(PlaeneCompanion plan) => into(plaene).insertOnConflictUpdate(plan);

  Future<void> planLoeschen(int id) => (delete(plaene)..where((t) => t.id.equals(id))).go();

  // ---- Wiederholungsregeln ----
  Future<int> regelSpeichern(WiederholungsregelnCompanion regel) =>
      into(wiederholungsregeln).insertOnConflictUpdate(regel);

  Stream<List<Wiederholungsregel>> alleRegelnBeobachten() => select(wiederholungsregeln).watch();

  // ---- Aufgaben ----
  Stream<List<Aufgabe>> aufgabenFuerPlanBeobachten(int planId) =>
      (select(aufgaben)..where((t) => t.planId.equals(planId))).watch();

  Future<List<Aufgabe>> alleAufgabenLaden() => select(aufgaben).get();

  Stream<List<Aufgabe>> alleAufgabenBeobachten() => select(aufgaben).watch();

  Future<Wiederholungsregel?> regelLaden(int id) =>
      (select(wiederholungsregeln)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> aufgabeSpeichern(AufgabenCompanion aufgabe) =>
      into(aufgaben).insertOnConflictUpdate(aufgabe);

  Future<void> aufgabeLoeschen(int id) => (delete(aufgaben)..where((t) => t.id.equals(id))).go();

  // ---- Erledigt ----
  Stream<List<ErledigtEintrag>> erledigtImZeitraumBeobachten(DateTime von, DateTime bis) =>
      (select(erledigt)
            ..where((t) => t.faelligDatum.isBetweenValues(von, bis)))
          .watch();

  Future<ErledigtEintrag?> erledigtEintragLaden(int aufgabeId, DateTime faelligDatum) =>
      (select(erledigt)
            ..where((t) => t.aufgabeId.equals(aufgabeId) & t.faelligDatum.equals(faelligDatum)))
          .getSingleOrNull();

  Future<void> alsErledigtMarkieren(int aufgabeId, DateTime faelligDatum, {DateTime? erledigtAm}) =>
      into(erledigt).insertOnConflictUpdate(
        ErledigtCompanion.insert(
          aufgabeId: aufgabeId,
          faelligDatum: faelligDatum,
          erledigt: const Value(true),
          erledigtAm: Value(erledigtAm ?? DateTime.now()),
        ),
      );

  Future<void> erledigtRueckgaengigMachen(int aufgabeId, DateTime faelligDatum) =>
      (delete(erledigt)
            ..where((t) => t.aufgabeId.equals(aufgabeId) & t.faelligDatum.equals(faelligDatum)))
          .go();

  // ---- Termine ----
  Stream<List<Termin>> termineImZeitraumBeobachten(DateTime von, DateTime bis) =>
      (select(termine)..where((t) => t.datum.isBetweenValues(von, bis))).watch();

  Future<int> terminSpeichern(TermineCompanion termin) =>
      into(termine).insertOnConflictUpdate(termin);

  Future<void> terminLoeschen(int id) => (delete(termine)..where((t) => t.id.equals(id))).go();

  // ---- Ausnahmen ----
  Future<Ausnahme?> ausnahmeLaden(int aufgabeId, DateTime datum) =>
      (select(ausnahmen)
            ..where((t) => t.aufgabeId.equals(aufgabeId) & t.datum.equals(datum)))
          .getSingleOrNull();

  Future<int> ausnahmeSpeichern(AusnahmenCompanion ausnahme) =>
      into(ausnahmen).insertOnConflictUpdate(ausnahme);

  Stream<List<Ausnahme>> ausnahmenImZeitraumBeobachten(DateTime von, DateTime bis) =>
      (select(ausnahmen)..where((t) => t.datum.isBetweenValues(von, bis))).watch();

  // ---- Einstellungen ----
  Future<String?> einstellungLaden(String schluessel) async {
    final zeile = await (select(einstellungen)..where((t) => t.schluessel.equals(schluessel)))
        .getSingleOrNull();
    return zeile?.wert;
  }

  Stream<String?> einstellungBeobachten(String schluessel) =>
      (select(einstellungen)..where((t) => t.schluessel.equals(schluessel)))
          .watchSingleOrNull()
          .map((z) => z?.wert);

  Future<void> einstellungSpeichern(String schluessel, String wert) =>
      into(einstellungen).insertOnConflictUpdate(
        EinstellungenCompanion.insert(schluessel: schluessel, wert: wert),
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final verzeichnis = await getApplicationSupportDirectory();
    final dbDatei = File(p.join(verzeichnis.path, 'traum_planer.sqlite'));
    return NativeDatabase.createInBackground(dbDatei);
  });
}
