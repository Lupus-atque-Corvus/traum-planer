import 'dart:convert';

import '../data/database.dart';

/// JSON-Export/Import für Backups (Phase 6). Enthält den kompletten
/// Datenbestand aller Tabellen, versioniert über `schemaVersion`, damit
/// künftige Migrationen einen Importpfad haben.
class BackupService {
  final AppDatabase db;
  const BackupService(this.db);

  Future<String> exportieren() async {
    final daten = {
      'schemaVersion': db.schemaVersion,
      'exportiertAm': DateTime.now().toIso8601String(),
      'plaene': (await db.select(db.plaene).get()).map((e) => e.toJson()).toList(),
      'wiederholungsregeln':
          (await db.select(db.wiederholungsregeln).get()).map((e) => e.toJson()).toList(),
      'aufgaben': (await db.select(db.aufgaben).get()).map((e) => e.toJson()).toList(),
      'erledigt': (await db.select(db.erledigt).get()).map((e) => e.toJson()).toList(),
      'termine': (await db.select(db.termine).get()).map((e) => e.toJson()).toList(),
      'ausnahmen': (await db.select(db.ausnahmen).get()).map((e) => e.toJson()).toList(),
      'einstellungen': (await db.select(db.einstellungen).get()).map((e) => e.toJson()).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(daten);
  }

  Future<void> importieren(String jsonInhalt) async {
    final daten = jsonDecode(jsonInhalt) as Map<String, dynamic>;

    await db.transaction(() async {
      await db.delete(db.ausnahmen).go();
      await db.delete(db.erledigt).go();
      await db.delete(db.aufgaben).go();
      await db.delete(db.wiederholungsregeln).go();
      await db.delete(db.termine).go();
      await db.delete(db.plaene).go();
      await db.delete(db.einstellungen).go();

      await db.batch((b) {
        b.insertAll(
          db.plaene,
          (daten['plaene'] as List).map((e) => Plan.fromJson(e as Map<String, dynamic>)).toList(),
        );
        b.insertAll(
          db.wiederholungsregeln,
          (daten['wiederholungsregeln'] as List)
              .map((e) => Wiederholungsregel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
        b.insertAll(
          db.aufgaben,
          (daten['aufgaben'] as List)
              .map((e) => Aufgabe.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
        b.insertAll(
          db.erledigt,
          (daten['erledigt'] as List)
              .map((e) => ErledigtEintrag.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
        b.insertAll(
          db.termine,
          (daten['termine'] as List)
              .map((e) => Termin.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
        b.insertAll(
          db.ausnahmen,
          (daten['ausnahmen'] as List)
              .map((e) => Ausnahme.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
        b.insertAll(
          db.einstellungen,
          (daten['einstellungen'] as List)
              .map((e) => EinstellungEintrag.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      });
    });
  }
}
