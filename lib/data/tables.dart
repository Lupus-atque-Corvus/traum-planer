import 'package:drift/drift.dart';

/// Ein Wochentag als Bit in der Bitmaske: Montag = 1 << 0 ... Sonntag = 1 << 6.
class Wochentag {
  static const montag = 1 << 0;
  static const dienstag = 1 << 1;
  static const mittwoch = 1 << 2;
  static const donnerstag = 1 << 3;
  static const freitag = 1 << 4;
  static const samstag = 1 << 5;
  static const sonntag = 1 << 6;
  static const alle = 0x7F;
}

enum WiederholungsTyp { taeglich, wochentage, woechentlich, monatlich }

enum AusnahmeTyp { verschoben, geaendert, ausgefallen }

@DataClassName('Plan')
class Plaene extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get titel => text().withLength(min: 1, max: 200)();
  TextColumn get kategorie => text()();
  IntColumn get akzentfarbe => integer()(); // ARGB
  IntColumn get sortierindex => integer().withDefault(const Constant(0))();
}

@DataClassName('Wiederholungsregel')
class Wiederholungsregeln extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get typ => intEnum<WiederholungsTyp>()();
  // Bitmaske der Wochentage; bei 'taeglich' faktisch = alle, bei
  // 'woechentlich' genau ein Bit gesetzt (der Erstellungs-Wochentag).
  IntColumn get wochentagBitmaske => integer().nullable()();
  // Nur relevant bei Typ 'monatlich': Tag im Monat (1-31).
  IntColumn get monatsTag => integer().nullable()();
}

@DataClassName('Aufgabe')
class Aufgaben extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planId => integer().references(Plaene, #id, onDelete: KeyAction.cascade)();
  TextColumn get titel => text().withLength(min: 1, max: 200)();
  TextColumn get beschreibung => text().nullable()();
  // Minuten seit Mitternacht (0-1439), nullable = keine feste Uhrzeit.
  IntColumn get uhrzeitMinuten => integer().nullable()();
  IntColumn get wiederholungsregelId =>
      integer().references(Wiederholungsregeln, #id, onDelete: KeyAction.cascade)();
  IntColumn get sortierindex => integer().withDefault(const Constant(0))();
}

@DataClassName('ErledigtEintrag')
class Erledigt extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get aufgabeId => integer().references(Aufgaben, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get faelligDatum => dateTime()();
  BoolColumn get erledigt => boolean().withDefault(const Constant(true))();
  DateTimeColumn get erledigtAm => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {aufgabeId, faelligDatum},
      ];
}

@DataClassName('Termin')
class Termine extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get titel => text().withLength(min: 1, max: 200)();
  TextColumn get beschreibung => text().nullable()();
  DateTimeColumn get datum => dateTime()();
  IntColumn get uhrzeitMinuten => integer().nullable()();
  TextColumn get ort => text().nullable()();
}

@DataClassName('Ausnahme')
class Ausnahmen extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get aufgabeId => integer().references(Aufgaben, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get datum => dateTime()();
  IntColumn get typ => intEnum<AusnahmeTyp>()();
  IntColumn get neueUhrzeitMinuten => integer().nullable()();
  TextColumn get neuerTitel => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {aufgabeId, datum},
      ];
}

@DataClassName('EinstellungEintrag')
class Einstellungen extends Table {
  TextColumn get schluessel => text()();
  TextColumn get wert => text()();

  @override
  Set<Column> get primaryKey => {schluessel};
}
