// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PlaeneTable extends Plaene with TableInfo<$PlaeneTable, Plan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaeneTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titelMeta = const VerificationMeta('titel');
  @override
  late final GeneratedColumn<String> titel = GeneratedColumn<String>(
    'titel',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kategorieMeta = const VerificationMeta(
    'kategorie',
  );
  @override
  late final GeneratedColumn<String> kategorie = GeneratedColumn<String>(
    'kategorie',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _akzentfarbeMeta = const VerificationMeta(
    'akzentfarbe',
  );
  @override
  late final GeneratedColumn<int> akzentfarbe = GeneratedColumn<int>(
    'akzentfarbe',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortierindexMeta = const VerificationMeta(
    'sortierindex',
  );
  @override
  late final GeneratedColumn<int> sortierindex = GeneratedColumn<int>(
    'sortierindex',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    titel,
    kategorie,
    akzentfarbe,
    sortierindex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plaene';
  @override
  VerificationContext validateIntegrity(
    Insertable<Plan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('titel')) {
      context.handle(
        _titelMeta,
        titel.isAcceptableOrUnknown(data['titel']!, _titelMeta),
      );
    } else if (isInserting) {
      context.missing(_titelMeta);
    }
    if (data.containsKey('kategorie')) {
      context.handle(
        _kategorieMeta,
        kategorie.isAcceptableOrUnknown(data['kategorie']!, _kategorieMeta),
      );
    } else if (isInserting) {
      context.missing(_kategorieMeta);
    }
    if (data.containsKey('akzentfarbe')) {
      context.handle(
        _akzentfarbeMeta,
        akzentfarbe.isAcceptableOrUnknown(
          data['akzentfarbe']!,
          _akzentfarbeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_akzentfarbeMeta);
    }
    if (data.containsKey('sortierindex')) {
      context.handle(
        _sortierindexMeta,
        sortierindex.isAcceptableOrUnknown(
          data['sortierindex']!,
          _sortierindexMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Plan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Plan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      titel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titel'],
      )!,
      kategorie: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kategorie'],
      )!,
      akzentfarbe: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}akzentfarbe'],
      )!,
      sortierindex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sortierindex'],
      )!,
    );
  }

  @override
  $PlaeneTable createAlias(String alias) {
    return $PlaeneTable(attachedDatabase, alias);
  }
}

class Plan extends DataClass implements Insertable<Plan> {
  final int id;
  final String titel;
  final String kategorie;
  final int akzentfarbe;
  final int sortierindex;
  const Plan({
    required this.id,
    required this.titel,
    required this.kategorie,
    required this.akzentfarbe,
    required this.sortierindex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['titel'] = Variable<String>(titel);
    map['kategorie'] = Variable<String>(kategorie);
    map['akzentfarbe'] = Variable<int>(akzentfarbe);
    map['sortierindex'] = Variable<int>(sortierindex);
    return map;
  }

  PlaeneCompanion toCompanion(bool nullToAbsent) {
    return PlaeneCompanion(
      id: Value(id),
      titel: Value(titel),
      kategorie: Value(kategorie),
      akzentfarbe: Value(akzentfarbe),
      sortierindex: Value(sortierindex),
    );
  }

  factory Plan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Plan(
      id: serializer.fromJson<int>(json['id']),
      titel: serializer.fromJson<String>(json['titel']),
      kategorie: serializer.fromJson<String>(json['kategorie']),
      akzentfarbe: serializer.fromJson<int>(json['akzentfarbe']),
      sortierindex: serializer.fromJson<int>(json['sortierindex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'titel': serializer.toJson<String>(titel),
      'kategorie': serializer.toJson<String>(kategorie),
      'akzentfarbe': serializer.toJson<int>(akzentfarbe),
      'sortierindex': serializer.toJson<int>(sortierindex),
    };
  }

  Plan copyWith({
    int? id,
    String? titel,
    String? kategorie,
    int? akzentfarbe,
    int? sortierindex,
  }) => Plan(
    id: id ?? this.id,
    titel: titel ?? this.titel,
    kategorie: kategorie ?? this.kategorie,
    akzentfarbe: akzentfarbe ?? this.akzentfarbe,
    sortierindex: sortierindex ?? this.sortierindex,
  );
  Plan copyWithCompanion(PlaeneCompanion data) {
    return Plan(
      id: data.id.present ? data.id.value : this.id,
      titel: data.titel.present ? data.titel.value : this.titel,
      kategorie: data.kategorie.present ? data.kategorie.value : this.kategorie,
      akzentfarbe: data.akzentfarbe.present
          ? data.akzentfarbe.value
          : this.akzentfarbe,
      sortierindex: data.sortierindex.present
          ? data.sortierindex.value
          : this.sortierindex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Plan(')
          ..write('id: $id, ')
          ..write('titel: $titel, ')
          ..write('kategorie: $kategorie, ')
          ..write('akzentfarbe: $akzentfarbe, ')
          ..write('sortierindex: $sortierindex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, titel, kategorie, akzentfarbe, sortierindex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Plan &&
          other.id == this.id &&
          other.titel == this.titel &&
          other.kategorie == this.kategorie &&
          other.akzentfarbe == this.akzentfarbe &&
          other.sortierindex == this.sortierindex);
}

class PlaeneCompanion extends UpdateCompanion<Plan> {
  final Value<int> id;
  final Value<String> titel;
  final Value<String> kategorie;
  final Value<int> akzentfarbe;
  final Value<int> sortierindex;
  const PlaeneCompanion({
    this.id = const Value.absent(),
    this.titel = const Value.absent(),
    this.kategorie = const Value.absent(),
    this.akzentfarbe = const Value.absent(),
    this.sortierindex = const Value.absent(),
  });
  PlaeneCompanion.insert({
    this.id = const Value.absent(),
    required String titel,
    required String kategorie,
    required int akzentfarbe,
    this.sortierindex = const Value.absent(),
  }) : titel = Value(titel),
       kategorie = Value(kategorie),
       akzentfarbe = Value(akzentfarbe);
  static Insertable<Plan> custom({
    Expression<int>? id,
    Expression<String>? titel,
    Expression<String>? kategorie,
    Expression<int>? akzentfarbe,
    Expression<int>? sortierindex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titel != null) 'titel': titel,
      if (kategorie != null) 'kategorie': kategorie,
      if (akzentfarbe != null) 'akzentfarbe': akzentfarbe,
      if (sortierindex != null) 'sortierindex': sortierindex,
    });
  }

  PlaeneCompanion copyWith({
    Value<int>? id,
    Value<String>? titel,
    Value<String>? kategorie,
    Value<int>? akzentfarbe,
    Value<int>? sortierindex,
  }) {
    return PlaeneCompanion(
      id: id ?? this.id,
      titel: titel ?? this.titel,
      kategorie: kategorie ?? this.kategorie,
      akzentfarbe: akzentfarbe ?? this.akzentfarbe,
      sortierindex: sortierindex ?? this.sortierindex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (titel.present) {
      map['titel'] = Variable<String>(titel.value);
    }
    if (kategorie.present) {
      map['kategorie'] = Variable<String>(kategorie.value);
    }
    if (akzentfarbe.present) {
      map['akzentfarbe'] = Variable<int>(akzentfarbe.value);
    }
    if (sortierindex.present) {
      map['sortierindex'] = Variable<int>(sortierindex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaeneCompanion(')
          ..write('id: $id, ')
          ..write('titel: $titel, ')
          ..write('kategorie: $kategorie, ')
          ..write('akzentfarbe: $akzentfarbe, ')
          ..write('sortierindex: $sortierindex')
          ..write(')'))
        .toString();
  }
}

class $WiederholungsregelnTable extends Wiederholungsregeln
    with TableInfo<$WiederholungsregelnTable, Wiederholungsregel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WiederholungsregelnTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<WiederholungsTyp, int> typ =
      GeneratedColumn<int>(
        'typ',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<WiederholungsTyp>(
        $WiederholungsregelnTable.$convertertyp,
      );
  static const VerificationMeta _wochentagBitmaskeMeta = const VerificationMeta(
    'wochentagBitmaske',
  );
  @override
  late final GeneratedColumn<int> wochentagBitmaske = GeneratedColumn<int>(
    'wochentag_bitmaske',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _monatsTagMeta = const VerificationMeta(
    'monatsTag',
  );
  @override
  late final GeneratedColumn<int> monatsTag = GeneratedColumn<int>(
    'monats_tag',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, typ, wochentagBitmaske, monatsTag];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wiederholungsregeln';
  @override
  VerificationContext validateIntegrity(
    Insertable<Wiederholungsregel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wochentag_bitmaske')) {
      context.handle(
        _wochentagBitmaskeMeta,
        wochentagBitmaske.isAcceptableOrUnknown(
          data['wochentag_bitmaske']!,
          _wochentagBitmaskeMeta,
        ),
      );
    }
    if (data.containsKey('monats_tag')) {
      context.handle(
        _monatsTagMeta,
        monatsTag.isAcceptableOrUnknown(data['monats_tag']!, _monatsTagMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Wiederholungsregel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Wiederholungsregel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      typ: $WiederholungsregelnTable.$convertertyp.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}typ'],
        )!,
      ),
      wochentagBitmaske: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wochentag_bitmaske'],
      ),
      monatsTag: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monats_tag'],
      ),
    );
  }

  @override
  $WiederholungsregelnTable createAlias(String alias) {
    return $WiederholungsregelnTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WiederholungsTyp, int, int> $convertertyp =
      const EnumIndexConverter<WiederholungsTyp>(WiederholungsTyp.values);
}

class Wiederholungsregel extends DataClass
    implements Insertable<Wiederholungsregel> {
  final int id;
  final WiederholungsTyp typ;
  final int? wochentagBitmaske;
  final int? monatsTag;
  const Wiederholungsregel({
    required this.id,
    required this.typ,
    this.wochentagBitmaske,
    this.monatsTag,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['typ'] = Variable<int>(
        $WiederholungsregelnTable.$convertertyp.toSql(typ),
      );
    }
    if (!nullToAbsent || wochentagBitmaske != null) {
      map['wochentag_bitmaske'] = Variable<int>(wochentagBitmaske);
    }
    if (!nullToAbsent || monatsTag != null) {
      map['monats_tag'] = Variable<int>(monatsTag);
    }
    return map;
  }

  WiederholungsregelnCompanion toCompanion(bool nullToAbsent) {
    return WiederholungsregelnCompanion(
      id: Value(id),
      typ: Value(typ),
      wochentagBitmaske: wochentagBitmaske == null && nullToAbsent
          ? const Value.absent()
          : Value(wochentagBitmaske),
      monatsTag: monatsTag == null && nullToAbsent
          ? const Value.absent()
          : Value(monatsTag),
    );
  }

  factory Wiederholungsregel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Wiederholungsregel(
      id: serializer.fromJson<int>(json['id']),
      typ: $WiederholungsregelnTable.$convertertyp.fromJson(
        serializer.fromJson<int>(json['typ']),
      ),
      wochentagBitmaske: serializer.fromJson<int?>(json['wochentagBitmaske']),
      monatsTag: serializer.fromJson<int?>(json['monatsTag']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'typ': serializer.toJson<int>(
        $WiederholungsregelnTable.$convertertyp.toJson(typ),
      ),
      'wochentagBitmaske': serializer.toJson<int?>(wochentagBitmaske),
      'monatsTag': serializer.toJson<int?>(monatsTag),
    };
  }

  Wiederholungsregel copyWith({
    int? id,
    WiederholungsTyp? typ,
    Value<int?> wochentagBitmaske = const Value.absent(),
    Value<int?> monatsTag = const Value.absent(),
  }) => Wiederholungsregel(
    id: id ?? this.id,
    typ: typ ?? this.typ,
    wochentagBitmaske: wochentagBitmaske.present
        ? wochentagBitmaske.value
        : this.wochentagBitmaske,
    monatsTag: monatsTag.present ? monatsTag.value : this.monatsTag,
  );
  Wiederholungsregel copyWithCompanion(WiederholungsregelnCompanion data) {
    return Wiederholungsregel(
      id: data.id.present ? data.id.value : this.id,
      typ: data.typ.present ? data.typ.value : this.typ,
      wochentagBitmaske: data.wochentagBitmaske.present
          ? data.wochentagBitmaske.value
          : this.wochentagBitmaske,
      monatsTag: data.monatsTag.present ? data.monatsTag.value : this.monatsTag,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Wiederholungsregel(')
          ..write('id: $id, ')
          ..write('typ: $typ, ')
          ..write('wochentagBitmaske: $wochentagBitmaske, ')
          ..write('monatsTag: $monatsTag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, typ, wochentagBitmaske, monatsTag);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Wiederholungsregel &&
          other.id == this.id &&
          other.typ == this.typ &&
          other.wochentagBitmaske == this.wochentagBitmaske &&
          other.monatsTag == this.monatsTag);
}

class WiederholungsregelnCompanion extends UpdateCompanion<Wiederholungsregel> {
  final Value<int> id;
  final Value<WiederholungsTyp> typ;
  final Value<int?> wochentagBitmaske;
  final Value<int?> monatsTag;
  const WiederholungsregelnCompanion({
    this.id = const Value.absent(),
    this.typ = const Value.absent(),
    this.wochentagBitmaske = const Value.absent(),
    this.monatsTag = const Value.absent(),
  });
  WiederholungsregelnCompanion.insert({
    this.id = const Value.absent(),
    required WiederholungsTyp typ,
    this.wochentagBitmaske = const Value.absent(),
    this.monatsTag = const Value.absent(),
  }) : typ = Value(typ);
  static Insertable<Wiederholungsregel> custom({
    Expression<int>? id,
    Expression<int>? typ,
    Expression<int>? wochentagBitmaske,
    Expression<int>? monatsTag,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (typ != null) 'typ': typ,
      if (wochentagBitmaske != null) 'wochentag_bitmaske': wochentagBitmaske,
      if (monatsTag != null) 'monats_tag': monatsTag,
    });
  }

  WiederholungsregelnCompanion copyWith({
    Value<int>? id,
    Value<WiederholungsTyp>? typ,
    Value<int?>? wochentagBitmaske,
    Value<int?>? monatsTag,
  }) {
    return WiederholungsregelnCompanion(
      id: id ?? this.id,
      typ: typ ?? this.typ,
      wochentagBitmaske: wochentagBitmaske ?? this.wochentagBitmaske,
      monatsTag: monatsTag ?? this.monatsTag,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (typ.present) {
      map['typ'] = Variable<int>(
        $WiederholungsregelnTable.$convertertyp.toSql(typ.value),
      );
    }
    if (wochentagBitmaske.present) {
      map['wochentag_bitmaske'] = Variable<int>(wochentagBitmaske.value);
    }
    if (monatsTag.present) {
      map['monats_tag'] = Variable<int>(monatsTag.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WiederholungsregelnCompanion(')
          ..write('id: $id, ')
          ..write('typ: $typ, ')
          ..write('wochentagBitmaske: $wochentagBitmaske, ')
          ..write('monatsTag: $monatsTag')
          ..write(')'))
        .toString();
  }
}

class $AufgabenTable extends Aufgaben with TableInfo<$AufgabenTable, Aufgabe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AufgabenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plaene (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titelMeta = const VerificationMeta('titel');
  @override
  late final GeneratedColumn<String> titel = GeneratedColumn<String>(
    'titel',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _beschreibungMeta = const VerificationMeta(
    'beschreibung',
  );
  @override
  late final GeneratedColumn<String> beschreibung = GeneratedColumn<String>(
    'beschreibung',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uhrzeitMinutenMeta = const VerificationMeta(
    'uhrzeitMinuten',
  );
  @override
  late final GeneratedColumn<int> uhrzeitMinuten = GeneratedColumn<int>(
    'uhrzeit_minuten',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wiederholungsregelIdMeta =
      const VerificationMeta('wiederholungsregelId');
  @override
  late final GeneratedColumn<int> wiederholungsregelId = GeneratedColumn<int>(
    'wiederholungsregel_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES wiederholungsregeln (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sortierindexMeta = const VerificationMeta(
    'sortierindex',
  );
  @override
  late final GeneratedColumn<int> sortierindex = GeneratedColumn<int>(
    'sortierindex',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planId,
    titel,
    beschreibung,
    uhrzeitMinuten,
    wiederholungsregelId,
    sortierindex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'aufgaben';
  @override
  VerificationContext validateIntegrity(
    Insertable<Aufgabe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('titel')) {
      context.handle(
        _titelMeta,
        titel.isAcceptableOrUnknown(data['titel']!, _titelMeta),
      );
    } else if (isInserting) {
      context.missing(_titelMeta);
    }
    if (data.containsKey('beschreibung')) {
      context.handle(
        _beschreibungMeta,
        beschreibung.isAcceptableOrUnknown(
          data['beschreibung']!,
          _beschreibungMeta,
        ),
      );
    }
    if (data.containsKey('uhrzeit_minuten')) {
      context.handle(
        _uhrzeitMinutenMeta,
        uhrzeitMinuten.isAcceptableOrUnknown(
          data['uhrzeit_minuten']!,
          _uhrzeitMinutenMeta,
        ),
      );
    }
    if (data.containsKey('wiederholungsregel_id')) {
      context.handle(
        _wiederholungsregelIdMeta,
        wiederholungsregelId.isAcceptableOrUnknown(
          data['wiederholungsregel_id']!,
          _wiederholungsregelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_wiederholungsregelIdMeta);
    }
    if (data.containsKey('sortierindex')) {
      context.handle(
        _sortierindexMeta,
        sortierindex.isAcceptableOrUnknown(
          data['sortierindex']!,
          _sortierindexMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Aufgabe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Aufgabe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_id'],
      )!,
      titel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titel'],
      )!,
      beschreibung: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}beschreibung'],
      ),
      uhrzeitMinuten: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uhrzeit_minuten'],
      ),
      wiederholungsregelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wiederholungsregel_id'],
      )!,
      sortierindex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sortierindex'],
      )!,
    );
  }

  @override
  $AufgabenTable createAlias(String alias) {
    return $AufgabenTable(attachedDatabase, alias);
  }
}

class Aufgabe extends DataClass implements Insertable<Aufgabe> {
  final int id;
  final int planId;
  final String titel;
  final String? beschreibung;
  final int? uhrzeitMinuten;
  final int wiederholungsregelId;
  final int sortierindex;
  const Aufgabe({
    required this.id,
    required this.planId,
    required this.titel,
    this.beschreibung,
    this.uhrzeitMinuten,
    required this.wiederholungsregelId,
    required this.sortierindex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_id'] = Variable<int>(planId);
    map['titel'] = Variable<String>(titel);
    if (!nullToAbsent || beschreibung != null) {
      map['beschreibung'] = Variable<String>(beschreibung);
    }
    if (!nullToAbsent || uhrzeitMinuten != null) {
      map['uhrzeit_minuten'] = Variable<int>(uhrzeitMinuten);
    }
    map['wiederholungsregel_id'] = Variable<int>(wiederholungsregelId);
    map['sortierindex'] = Variable<int>(sortierindex);
    return map;
  }

  AufgabenCompanion toCompanion(bool nullToAbsent) {
    return AufgabenCompanion(
      id: Value(id),
      planId: Value(planId),
      titel: Value(titel),
      beschreibung: beschreibung == null && nullToAbsent
          ? const Value.absent()
          : Value(beschreibung),
      uhrzeitMinuten: uhrzeitMinuten == null && nullToAbsent
          ? const Value.absent()
          : Value(uhrzeitMinuten),
      wiederholungsregelId: Value(wiederholungsregelId),
      sortierindex: Value(sortierindex),
    );
  }

  factory Aufgabe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Aufgabe(
      id: serializer.fromJson<int>(json['id']),
      planId: serializer.fromJson<int>(json['planId']),
      titel: serializer.fromJson<String>(json['titel']),
      beschreibung: serializer.fromJson<String?>(json['beschreibung']),
      uhrzeitMinuten: serializer.fromJson<int?>(json['uhrzeitMinuten']),
      wiederholungsregelId: serializer.fromJson<int>(
        json['wiederholungsregelId'],
      ),
      sortierindex: serializer.fromJson<int>(json['sortierindex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planId': serializer.toJson<int>(planId),
      'titel': serializer.toJson<String>(titel),
      'beschreibung': serializer.toJson<String?>(beschreibung),
      'uhrzeitMinuten': serializer.toJson<int?>(uhrzeitMinuten),
      'wiederholungsregelId': serializer.toJson<int>(wiederholungsregelId),
      'sortierindex': serializer.toJson<int>(sortierindex),
    };
  }

  Aufgabe copyWith({
    int? id,
    int? planId,
    String? titel,
    Value<String?> beschreibung = const Value.absent(),
    Value<int?> uhrzeitMinuten = const Value.absent(),
    int? wiederholungsregelId,
    int? sortierindex,
  }) => Aufgabe(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    titel: titel ?? this.titel,
    beschreibung: beschreibung.present ? beschreibung.value : this.beschreibung,
    uhrzeitMinuten: uhrzeitMinuten.present
        ? uhrzeitMinuten.value
        : this.uhrzeitMinuten,
    wiederholungsregelId: wiederholungsregelId ?? this.wiederholungsregelId,
    sortierindex: sortierindex ?? this.sortierindex,
  );
  Aufgabe copyWithCompanion(AufgabenCompanion data) {
    return Aufgabe(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      titel: data.titel.present ? data.titel.value : this.titel,
      beschreibung: data.beschreibung.present
          ? data.beschreibung.value
          : this.beschreibung,
      uhrzeitMinuten: data.uhrzeitMinuten.present
          ? data.uhrzeitMinuten.value
          : this.uhrzeitMinuten,
      wiederholungsregelId: data.wiederholungsregelId.present
          ? data.wiederholungsregelId.value
          : this.wiederholungsregelId,
      sortierindex: data.sortierindex.present
          ? data.sortierindex.value
          : this.sortierindex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Aufgabe(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('titel: $titel, ')
          ..write('beschreibung: $beschreibung, ')
          ..write('uhrzeitMinuten: $uhrzeitMinuten, ')
          ..write('wiederholungsregelId: $wiederholungsregelId, ')
          ..write('sortierindex: $sortierindex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    planId,
    titel,
    beschreibung,
    uhrzeitMinuten,
    wiederholungsregelId,
    sortierindex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Aufgabe &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.titel == this.titel &&
          other.beschreibung == this.beschreibung &&
          other.uhrzeitMinuten == this.uhrzeitMinuten &&
          other.wiederholungsregelId == this.wiederholungsregelId &&
          other.sortierindex == this.sortierindex);
}

class AufgabenCompanion extends UpdateCompanion<Aufgabe> {
  final Value<int> id;
  final Value<int> planId;
  final Value<String> titel;
  final Value<String?> beschreibung;
  final Value<int?> uhrzeitMinuten;
  final Value<int> wiederholungsregelId;
  final Value<int> sortierindex;
  const AufgabenCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.titel = const Value.absent(),
    this.beschreibung = const Value.absent(),
    this.uhrzeitMinuten = const Value.absent(),
    this.wiederholungsregelId = const Value.absent(),
    this.sortierindex = const Value.absent(),
  });
  AufgabenCompanion.insert({
    this.id = const Value.absent(),
    required int planId,
    required String titel,
    this.beschreibung = const Value.absent(),
    this.uhrzeitMinuten = const Value.absent(),
    required int wiederholungsregelId,
    this.sortierindex = const Value.absent(),
  }) : planId = Value(planId),
       titel = Value(titel),
       wiederholungsregelId = Value(wiederholungsregelId);
  static Insertable<Aufgabe> custom({
    Expression<int>? id,
    Expression<int>? planId,
    Expression<String>? titel,
    Expression<String>? beschreibung,
    Expression<int>? uhrzeitMinuten,
    Expression<int>? wiederholungsregelId,
    Expression<int>? sortierindex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (titel != null) 'titel': titel,
      if (beschreibung != null) 'beschreibung': beschreibung,
      if (uhrzeitMinuten != null) 'uhrzeit_minuten': uhrzeitMinuten,
      if (wiederholungsregelId != null)
        'wiederholungsregel_id': wiederholungsregelId,
      if (sortierindex != null) 'sortierindex': sortierindex,
    });
  }

  AufgabenCompanion copyWith({
    Value<int>? id,
    Value<int>? planId,
    Value<String>? titel,
    Value<String?>? beschreibung,
    Value<int?>? uhrzeitMinuten,
    Value<int>? wiederholungsregelId,
    Value<int>? sortierindex,
  }) {
    return AufgabenCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      titel: titel ?? this.titel,
      beschreibung: beschreibung ?? this.beschreibung,
      uhrzeitMinuten: uhrzeitMinuten ?? this.uhrzeitMinuten,
      wiederholungsregelId: wiederholungsregelId ?? this.wiederholungsregelId,
      sortierindex: sortierindex ?? this.sortierindex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (titel.present) {
      map['titel'] = Variable<String>(titel.value);
    }
    if (beschreibung.present) {
      map['beschreibung'] = Variable<String>(beschreibung.value);
    }
    if (uhrzeitMinuten.present) {
      map['uhrzeit_minuten'] = Variable<int>(uhrzeitMinuten.value);
    }
    if (wiederholungsregelId.present) {
      map['wiederholungsregel_id'] = Variable<int>(wiederholungsregelId.value);
    }
    if (sortierindex.present) {
      map['sortierindex'] = Variable<int>(sortierindex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AufgabenCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('titel: $titel, ')
          ..write('beschreibung: $beschreibung, ')
          ..write('uhrzeitMinuten: $uhrzeitMinuten, ')
          ..write('wiederholungsregelId: $wiederholungsregelId, ')
          ..write('sortierindex: $sortierindex')
          ..write(')'))
        .toString();
  }
}

class $ErledigtTable extends Erledigt
    with TableInfo<$ErledigtTable, ErledigtEintrag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ErledigtTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _aufgabeIdMeta = const VerificationMeta(
    'aufgabeId',
  );
  @override
  late final GeneratedColumn<int> aufgabeId = GeneratedColumn<int>(
    'aufgabe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES aufgaben (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _faelligDatumMeta = const VerificationMeta(
    'faelligDatum',
  );
  @override
  late final GeneratedColumn<DateTime> faelligDatum = GeneratedColumn<DateTime>(
    'faellig_datum',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _erledigtMeta = const VerificationMeta(
    'erledigt',
  );
  @override
  late final GeneratedColumn<bool> erledigt = GeneratedColumn<bool>(
    'erledigt',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("erledigt" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _erledigtAmMeta = const VerificationMeta(
    'erledigtAm',
  );
  @override
  late final GeneratedColumn<DateTime> erledigtAm = GeneratedColumn<DateTime>(
    'erledigt_am',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    aufgabeId,
    faelligDatum,
    erledigt,
    erledigtAm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'erledigt';
  @override
  VerificationContext validateIntegrity(
    Insertable<ErledigtEintrag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('aufgabe_id')) {
      context.handle(
        _aufgabeIdMeta,
        aufgabeId.isAcceptableOrUnknown(data['aufgabe_id']!, _aufgabeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_aufgabeIdMeta);
    }
    if (data.containsKey('faellig_datum')) {
      context.handle(
        _faelligDatumMeta,
        faelligDatum.isAcceptableOrUnknown(
          data['faellig_datum']!,
          _faelligDatumMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_faelligDatumMeta);
    }
    if (data.containsKey('erledigt')) {
      context.handle(
        _erledigtMeta,
        erledigt.isAcceptableOrUnknown(data['erledigt']!, _erledigtMeta),
      );
    }
    if (data.containsKey('erledigt_am')) {
      context.handle(
        _erledigtAmMeta,
        erledigtAm.isAcceptableOrUnknown(data['erledigt_am']!, _erledigtAmMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {aufgabeId, faelligDatum},
  ];
  @override
  ErledigtEintrag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ErledigtEintrag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      aufgabeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}aufgabe_id'],
      )!,
      faelligDatum: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}faellig_datum'],
      )!,
      erledigt: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}erledigt'],
      )!,
      erledigtAm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}erledigt_am'],
      ),
    );
  }

  @override
  $ErledigtTable createAlias(String alias) {
    return $ErledigtTable(attachedDatabase, alias);
  }
}

class ErledigtEintrag extends DataClass implements Insertable<ErledigtEintrag> {
  final int id;
  final int aufgabeId;
  final DateTime faelligDatum;
  final bool erledigt;
  final DateTime? erledigtAm;
  const ErledigtEintrag({
    required this.id,
    required this.aufgabeId,
    required this.faelligDatum,
    required this.erledigt,
    this.erledigtAm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['aufgabe_id'] = Variable<int>(aufgabeId);
    map['faellig_datum'] = Variable<DateTime>(faelligDatum);
    map['erledigt'] = Variable<bool>(erledigt);
    if (!nullToAbsent || erledigtAm != null) {
      map['erledigt_am'] = Variable<DateTime>(erledigtAm);
    }
    return map;
  }

  ErledigtCompanion toCompanion(bool nullToAbsent) {
    return ErledigtCompanion(
      id: Value(id),
      aufgabeId: Value(aufgabeId),
      faelligDatum: Value(faelligDatum),
      erledigt: Value(erledigt),
      erledigtAm: erledigtAm == null && nullToAbsent
          ? const Value.absent()
          : Value(erledigtAm),
    );
  }

  factory ErledigtEintrag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ErledigtEintrag(
      id: serializer.fromJson<int>(json['id']),
      aufgabeId: serializer.fromJson<int>(json['aufgabeId']),
      faelligDatum: serializer.fromJson<DateTime>(json['faelligDatum']),
      erledigt: serializer.fromJson<bool>(json['erledigt']),
      erledigtAm: serializer.fromJson<DateTime?>(json['erledigtAm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'aufgabeId': serializer.toJson<int>(aufgabeId),
      'faelligDatum': serializer.toJson<DateTime>(faelligDatum),
      'erledigt': serializer.toJson<bool>(erledigt),
      'erledigtAm': serializer.toJson<DateTime?>(erledigtAm),
    };
  }

  ErledigtEintrag copyWith({
    int? id,
    int? aufgabeId,
    DateTime? faelligDatum,
    bool? erledigt,
    Value<DateTime?> erledigtAm = const Value.absent(),
  }) => ErledigtEintrag(
    id: id ?? this.id,
    aufgabeId: aufgabeId ?? this.aufgabeId,
    faelligDatum: faelligDatum ?? this.faelligDatum,
    erledigt: erledigt ?? this.erledigt,
    erledigtAm: erledigtAm.present ? erledigtAm.value : this.erledigtAm,
  );
  ErledigtEintrag copyWithCompanion(ErledigtCompanion data) {
    return ErledigtEintrag(
      id: data.id.present ? data.id.value : this.id,
      aufgabeId: data.aufgabeId.present ? data.aufgabeId.value : this.aufgabeId,
      faelligDatum: data.faelligDatum.present
          ? data.faelligDatum.value
          : this.faelligDatum,
      erledigt: data.erledigt.present ? data.erledigt.value : this.erledigt,
      erledigtAm: data.erledigtAm.present
          ? data.erledigtAm.value
          : this.erledigtAm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ErledigtEintrag(')
          ..write('id: $id, ')
          ..write('aufgabeId: $aufgabeId, ')
          ..write('faelligDatum: $faelligDatum, ')
          ..write('erledigt: $erledigt, ')
          ..write('erledigtAm: $erledigtAm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, aufgabeId, faelligDatum, erledigt, erledigtAm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ErledigtEintrag &&
          other.id == this.id &&
          other.aufgabeId == this.aufgabeId &&
          other.faelligDatum == this.faelligDatum &&
          other.erledigt == this.erledigt &&
          other.erledigtAm == this.erledigtAm);
}

class ErledigtCompanion extends UpdateCompanion<ErledigtEintrag> {
  final Value<int> id;
  final Value<int> aufgabeId;
  final Value<DateTime> faelligDatum;
  final Value<bool> erledigt;
  final Value<DateTime?> erledigtAm;
  const ErledigtCompanion({
    this.id = const Value.absent(),
    this.aufgabeId = const Value.absent(),
    this.faelligDatum = const Value.absent(),
    this.erledigt = const Value.absent(),
    this.erledigtAm = const Value.absent(),
  });
  ErledigtCompanion.insert({
    this.id = const Value.absent(),
    required int aufgabeId,
    required DateTime faelligDatum,
    this.erledigt = const Value.absent(),
    this.erledigtAm = const Value.absent(),
  }) : aufgabeId = Value(aufgabeId),
       faelligDatum = Value(faelligDatum);
  static Insertable<ErledigtEintrag> custom({
    Expression<int>? id,
    Expression<int>? aufgabeId,
    Expression<DateTime>? faelligDatum,
    Expression<bool>? erledigt,
    Expression<DateTime>? erledigtAm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (aufgabeId != null) 'aufgabe_id': aufgabeId,
      if (faelligDatum != null) 'faellig_datum': faelligDatum,
      if (erledigt != null) 'erledigt': erledigt,
      if (erledigtAm != null) 'erledigt_am': erledigtAm,
    });
  }

  ErledigtCompanion copyWith({
    Value<int>? id,
    Value<int>? aufgabeId,
    Value<DateTime>? faelligDatum,
    Value<bool>? erledigt,
    Value<DateTime?>? erledigtAm,
  }) {
    return ErledigtCompanion(
      id: id ?? this.id,
      aufgabeId: aufgabeId ?? this.aufgabeId,
      faelligDatum: faelligDatum ?? this.faelligDatum,
      erledigt: erledigt ?? this.erledigt,
      erledigtAm: erledigtAm ?? this.erledigtAm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (aufgabeId.present) {
      map['aufgabe_id'] = Variable<int>(aufgabeId.value);
    }
    if (faelligDatum.present) {
      map['faellig_datum'] = Variable<DateTime>(faelligDatum.value);
    }
    if (erledigt.present) {
      map['erledigt'] = Variable<bool>(erledigt.value);
    }
    if (erledigtAm.present) {
      map['erledigt_am'] = Variable<DateTime>(erledigtAm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ErledigtCompanion(')
          ..write('id: $id, ')
          ..write('aufgabeId: $aufgabeId, ')
          ..write('faelligDatum: $faelligDatum, ')
          ..write('erledigt: $erledigt, ')
          ..write('erledigtAm: $erledigtAm')
          ..write(')'))
        .toString();
  }
}

class $TermineTable extends Termine with TableInfo<$TermineTable, Termin> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TermineTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titelMeta = const VerificationMeta('titel');
  @override
  late final GeneratedColumn<String> titel = GeneratedColumn<String>(
    'titel',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _beschreibungMeta = const VerificationMeta(
    'beschreibung',
  );
  @override
  late final GeneratedColumn<String> beschreibung = GeneratedColumn<String>(
    'beschreibung',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _datumMeta = const VerificationMeta('datum');
  @override
  late final GeneratedColumn<DateTime> datum = GeneratedColumn<DateTime>(
    'datum',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uhrzeitMinutenMeta = const VerificationMeta(
    'uhrzeitMinuten',
  );
  @override
  late final GeneratedColumn<int> uhrzeitMinuten = GeneratedColumn<int>(
    'uhrzeit_minuten',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ortMeta = const VerificationMeta('ort');
  @override
  late final GeneratedColumn<String> ort = GeneratedColumn<String>(
    'ort',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    titel,
    beschreibung,
    datum,
    uhrzeitMinuten,
    ort,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'termine';
  @override
  VerificationContext validateIntegrity(
    Insertable<Termin> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('titel')) {
      context.handle(
        _titelMeta,
        titel.isAcceptableOrUnknown(data['titel']!, _titelMeta),
      );
    } else if (isInserting) {
      context.missing(_titelMeta);
    }
    if (data.containsKey('beschreibung')) {
      context.handle(
        _beschreibungMeta,
        beschreibung.isAcceptableOrUnknown(
          data['beschreibung']!,
          _beschreibungMeta,
        ),
      );
    }
    if (data.containsKey('datum')) {
      context.handle(
        _datumMeta,
        datum.isAcceptableOrUnknown(data['datum']!, _datumMeta),
      );
    } else if (isInserting) {
      context.missing(_datumMeta);
    }
    if (data.containsKey('uhrzeit_minuten')) {
      context.handle(
        _uhrzeitMinutenMeta,
        uhrzeitMinuten.isAcceptableOrUnknown(
          data['uhrzeit_minuten']!,
          _uhrzeitMinutenMeta,
        ),
      );
    }
    if (data.containsKey('ort')) {
      context.handle(
        _ortMeta,
        ort.isAcceptableOrUnknown(data['ort']!, _ortMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Termin map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Termin(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      titel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titel'],
      )!,
      beschreibung: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}beschreibung'],
      ),
      datum: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}datum'],
      )!,
      uhrzeitMinuten: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uhrzeit_minuten'],
      ),
      ort: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ort'],
      ),
    );
  }

  @override
  $TermineTable createAlias(String alias) {
    return $TermineTable(attachedDatabase, alias);
  }
}

class Termin extends DataClass implements Insertable<Termin> {
  final int id;
  final String titel;
  final String? beschreibung;
  final DateTime datum;
  final int? uhrzeitMinuten;
  final String? ort;
  const Termin({
    required this.id,
    required this.titel,
    this.beschreibung,
    required this.datum,
    this.uhrzeitMinuten,
    this.ort,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['titel'] = Variable<String>(titel);
    if (!nullToAbsent || beschreibung != null) {
      map['beschreibung'] = Variable<String>(beschreibung);
    }
    map['datum'] = Variable<DateTime>(datum);
    if (!nullToAbsent || uhrzeitMinuten != null) {
      map['uhrzeit_minuten'] = Variable<int>(uhrzeitMinuten);
    }
    if (!nullToAbsent || ort != null) {
      map['ort'] = Variable<String>(ort);
    }
    return map;
  }

  TermineCompanion toCompanion(bool nullToAbsent) {
    return TermineCompanion(
      id: Value(id),
      titel: Value(titel),
      beschreibung: beschreibung == null && nullToAbsent
          ? const Value.absent()
          : Value(beschreibung),
      datum: Value(datum),
      uhrzeitMinuten: uhrzeitMinuten == null && nullToAbsent
          ? const Value.absent()
          : Value(uhrzeitMinuten),
      ort: ort == null && nullToAbsent ? const Value.absent() : Value(ort),
    );
  }

  factory Termin.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Termin(
      id: serializer.fromJson<int>(json['id']),
      titel: serializer.fromJson<String>(json['titel']),
      beschreibung: serializer.fromJson<String?>(json['beschreibung']),
      datum: serializer.fromJson<DateTime>(json['datum']),
      uhrzeitMinuten: serializer.fromJson<int?>(json['uhrzeitMinuten']),
      ort: serializer.fromJson<String?>(json['ort']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'titel': serializer.toJson<String>(titel),
      'beschreibung': serializer.toJson<String?>(beschreibung),
      'datum': serializer.toJson<DateTime>(datum),
      'uhrzeitMinuten': serializer.toJson<int?>(uhrzeitMinuten),
      'ort': serializer.toJson<String?>(ort),
    };
  }

  Termin copyWith({
    int? id,
    String? titel,
    Value<String?> beschreibung = const Value.absent(),
    DateTime? datum,
    Value<int?> uhrzeitMinuten = const Value.absent(),
    Value<String?> ort = const Value.absent(),
  }) => Termin(
    id: id ?? this.id,
    titel: titel ?? this.titel,
    beschreibung: beschreibung.present ? beschreibung.value : this.beschreibung,
    datum: datum ?? this.datum,
    uhrzeitMinuten: uhrzeitMinuten.present
        ? uhrzeitMinuten.value
        : this.uhrzeitMinuten,
    ort: ort.present ? ort.value : this.ort,
  );
  Termin copyWithCompanion(TermineCompanion data) {
    return Termin(
      id: data.id.present ? data.id.value : this.id,
      titel: data.titel.present ? data.titel.value : this.titel,
      beschreibung: data.beschreibung.present
          ? data.beschreibung.value
          : this.beschreibung,
      datum: data.datum.present ? data.datum.value : this.datum,
      uhrzeitMinuten: data.uhrzeitMinuten.present
          ? data.uhrzeitMinuten.value
          : this.uhrzeitMinuten,
      ort: data.ort.present ? data.ort.value : this.ort,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Termin(')
          ..write('id: $id, ')
          ..write('titel: $titel, ')
          ..write('beschreibung: $beschreibung, ')
          ..write('datum: $datum, ')
          ..write('uhrzeitMinuten: $uhrzeitMinuten, ')
          ..write('ort: $ort')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, titel, beschreibung, datum, uhrzeitMinuten, ort);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Termin &&
          other.id == this.id &&
          other.titel == this.titel &&
          other.beschreibung == this.beschreibung &&
          other.datum == this.datum &&
          other.uhrzeitMinuten == this.uhrzeitMinuten &&
          other.ort == this.ort);
}

class TermineCompanion extends UpdateCompanion<Termin> {
  final Value<int> id;
  final Value<String> titel;
  final Value<String?> beschreibung;
  final Value<DateTime> datum;
  final Value<int?> uhrzeitMinuten;
  final Value<String?> ort;
  const TermineCompanion({
    this.id = const Value.absent(),
    this.titel = const Value.absent(),
    this.beschreibung = const Value.absent(),
    this.datum = const Value.absent(),
    this.uhrzeitMinuten = const Value.absent(),
    this.ort = const Value.absent(),
  });
  TermineCompanion.insert({
    this.id = const Value.absent(),
    required String titel,
    this.beschreibung = const Value.absent(),
    required DateTime datum,
    this.uhrzeitMinuten = const Value.absent(),
    this.ort = const Value.absent(),
  }) : titel = Value(titel),
       datum = Value(datum);
  static Insertable<Termin> custom({
    Expression<int>? id,
    Expression<String>? titel,
    Expression<String>? beschreibung,
    Expression<DateTime>? datum,
    Expression<int>? uhrzeitMinuten,
    Expression<String>? ort,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titel != null) 'titel': titel,
      if (beschreibung != null) 'beschreibung': beschreibung,
      if (datum != null) 'datum': datum,
      if (uhrzeitMinuten != null) 'uhrzeit_minuten': uhrzeitMinuten,
      if (ort != null) 'ort': ort,
    });
  }

  TermineCompanion copyWith({
    Value<int>? id,
    Value<String>? titel,
    Value<String?>? beschreibung,
    Value<DateTime>? datum,
    Value<int?>? uhrzeitMinuten,
    Value<String?>? ort,
  }) {
    return TermineCompanion(
      id: id ?? this.id,
      titel: titel ?? this.titel,
      beschreibung: beschreibung ?? this.beschreibung,
      datum: datum ?? this.datum,
      uhrzeitMinuten: uhrzeitMinuten ?? this.uhrzeitMinuten,
      ort: ort ?? this.ort,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (titel.present) {
      map['titel'] = Variable<String>(titel.value);
    }
    if (beschreibung.present) {
      map['beschreibung'] = Variable<String>(beschreibung.value);
    }
    if (datum.present) {
      map['datum'] = Variable<DateTime>(datum.value);
    }
    if (uhrzeitMinuten.present) {
      map['uhrzeit_minuten'] = Variable<int>(uhrzeitMinuten.value);
    }
    if (ort.present) {
      map['ort'] = Variable<String>(ort.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TermineCompanion(')
          ..write('id: $id, ')
          ..write('titel: $titel, ')
          ..write('beschreibung: $beschreibung, ')
          ..write('datum: $datum, ')
          ..write('uhrzeitMinuten: $uhrzeitMinuten, ')
          ..write('ort: $ort')
          ..write(')'))
        .toString();
  }
}

class $AusnahmenTable extends Ausnahmen
    with TableInfo<$AusnahmenTable, Ausnahme> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AusnahmenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _aufgabeIdMeta = const VerificationMeta(
    'aufgabeId',
  );
  @override
  late final GeneratedColumn<int> aufgabeId = GeneratedColumn<int>(
    'aufgabe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES aufgaben (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _datumMeta = const VerificationMeta('datum');
  @override
  late final GeneratedColumn<DateTime> datum = GeneratedColumn<DateTime>(
    'datum',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AusnahmeTyp, int> typ =
      GeneratedColumn<int>(
        'typ',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<AusnahmeTyp>($AusnahmenTable.$convertertyp);
  static const VerificationMeta _neueUhrzeitMinutenMeta =
      const VerificationMeta('neueUhrzeitMinuten');
  @override
  late final GeneratedColumn<int> neueUhrzeitMinuten = GeneratedColumn<int>(
    'neue_uhrzeit_minuten',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _neuerTitelMeta = const VerificationMeta(
    'neuerTitel',
  );
  @override
  late final GeneratedColumn<String> neuerTitel = GeneratedColumn<String>(
    'neuer_titel',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    aufgabeId,
    datum,
    typ,
    neueUhrzeitMinuten,
    neuerTitel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ausnahmen';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ausnahme> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('aufgabe_id')) {
      context.handle(
        _aufgabeIdMeta,
        aufgabeId.isAcceptableOrUnknown(data['aufgabe_id']!, _aufgabeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_aufgabeIdMeta);
    }
    if (data.containsKey('datum')) {
      context.handle(
        _datumMeta,
        datum.isAcceptableOrUnknown(data['datum']!, _datumMeta),
      );
    } else if (isInserting) {
      context.missing(_datumMeta);
    }
    if (data.containsKey('neue_uhrzeit_minuten')) {
      context.handle(
        _neueUhrzeitMinutenMeta,
        neueUhrzeitMinuten.isAcceptableOrUnknown(
          data['neue_uhrzeit_minuten']!,
          _neueUhrzeitMinutenMeta,
        ),
      );
    }
    if (data.containsKey('neuer_titel')) {
      context.handle(
        _neuerTitelMeta,
        neuerTitel.isAcceptableOrUnknown(data['neuer_titel']!, _neuerTitelMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {aufgabeId, datum},
  ];
  @override
  Ausnahme map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ausnahme(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      aufgabeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}aufgabe_id'],
      )!,
      datum: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}datum'],
      )!,
      typ: $AusnahmenTable.$convertertyp.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}typ'],
        )!,
      ),
      neueUhrzeitMinuten: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}neue_uhrzeit_minuten'],
      ),
      neuerTitel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}neuer_titel'],
      ),
    );
  }

  @override
  $AusnahmenTable createAlias(String alias) {
    return $AusnahmenTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AusnahmeTyp, int, int> $convertertyp =
      const EnumIndexConverter<AusnahmeTyp>(AusnahmeTyp.values);
}

class Ausnahme extends DataClass implements Insertable<Ausnahme> {
  final int id;
  final int aufgabeId;
  final DateTime datum;
  final AusnahmeTyp typ;
  final int? neueUhrzeitMinuten;
  final String? neuerTitel;
  const Ausnahme({
    required this.id,
    required this.aufgabeId,
    required this.datum,
    required this.typ,
    this.neueUhrzeitMinuten,
    this.neuerTitel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['aufgabe_id'] = Variable<int>(aufgabeId);
    map['datum'] = Variable<DateTime>(datum);
    {
      map['typ'] = Variable<int>($AusnahmenTable.$convertertyp.toSql(typ));
    }
    if (!nullToAbsent || neueUhrzeitMinuten != null) {
      map['neue_uhrzeit_minuten'] = Variable<int>(neueUhrzeitMinuten);
    }
    if (!nullToAbsent || neuerTitel != null) {
      map['neuer_titel'] = Variable<String>(neuerTitel);
    }
    return map;
  }

  AusnahmenCompanion toCompanion(bool nullToAbsent) {
    return AusnahmenCompanion(
      id: Value(id),
      aufgabeId: Value(aufgabeId),
      datum: Value(datum),
      typ: Value(typ),
      neueUhrzeitMinuten: neueUhrzeitMinuten == null && nullToAbsent
          ? const Value.absent()
          : Value(neueUhrzeitMinuten),
      neuerTitel: neuerTitel == null && nullToAbsent
          ? const Value.absent()
          : Value(neuerTitel),
    );
  }

  factory Ausnahme.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ausnahme(
      id: serializer.fromJson<int>(json['id']),
      aufgabeId: serializer.fromJson<int>(json['aufgabeId']),
      datum: serializer.fromJson<DateTime>(json['datum']),
      typ: $AusnahmenTable.$convertertyp.fromJson(
        serializer.fromJson<int>(json['typ']),
      ),
      neueUhrzeitMinuten: serializer.fromJson<int?>(json['neueUhrzeitMinuten']),
      neuerTitel: serializer.fromJson<String?>(json['neuerTitel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'aufgabeId': serializer.toJson<int>(aufgabeId),
      'datum': serializer.toJson<DateTime>(datum),
      'typ': serializer.toJson<int>($AusnahmenTable.$convertertyp.toJson(typ)),
      'neueUhrzeitMinuten': serializer.toJson<int?>(neueUhrzeitMinuten),
      'neuerTitel': serializer.toJson<String?>(neuerTitel),
    };
  }

  Ausnahme copyWith({
    int? id,
    int? aufgabeId,
    DateTime? datum,
    AusnahmeTyp? typ,
    Value<int?> neueUhrzeitMinuten = const Value.absent(),
    Value<String?> neuerTitel = const Value.absent(),
  }) => Ausnahme(
    id: id ?? this.id,
    aufgabeId: aufgabeId ?? this.aufgabeId,
    datum: datum ?? this.datum,
    typ: typ ?? this.typ,
    neueUhrzeitMinuten: neueUhrzeitMinuten.present
        ? neueUhrzeitMinuten.value
        : this.neueUhrzeitMinuten,
    neuerTitel: neuerTitel.present ? neuerTitel.value : this.neuerTitel,
  );
  Ausnahme copyWithCompanion(AusnahmenCompanion data) {
    return Ausnahme(
      id: data.id.present ? data.id.value : this.id,
      aufgabeId: data.aufgabeId.present ? data.aufgabeId.value : this.aufgabeId,
      datum: data.datum.present ? data.datum.value : this.datum,
      typ: data.typ.present ? data.typ.value : this.typ,
      neueUhrzeitMinuten: data.neueUhrzeitMinuten.present
          ? data.neueUhrzeitMinuten.value
          : this.neueUhrzeitMinuten,
      neuerTitel: data.neuerTitel.present
          ? data.neuerTitel.value
          : this.neuerTitel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ausnahme(')
          ..write('id: $id, ')
          ..write('aufgabeId: $aufgabeId, ')
          ..write('datum: $datum, ')
          ..write('typ: $typ, ')
          ..write('neueUhrzeitMinuten: $neueUhrzeitMinuten, ')
          ..write('neuerTitel: $neuerTitel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, aufgabeId, datum, typ, neueUhrzeitMinuten, neuerTitel);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ausnahme &&
          other.id == this.id &&
          other.aufgabeId == this.aufgabeId &&
          other.datum == this.datum &&
          other.typ == this.typ &&
          other.neueUhrzeitMinuten == this.neueUhrzeitMinuten &&
          other.neuerTitel == this.neuerTitel);
}

class AusnahmenCompanion extends UpdateCompanion<Ausnahme> {
  final Value<int> id;
  final Value<int> aufgabeId;
  final Value<DateTime> datum;
  final Value<AusnahmeTyp> typ;
  final Value<int?> neueUhrzeitMinuten;
  final Value<String?> neuerTitel;
  const AusnahmenCompanion({
    this.id = const Value.absent(),
    this.aufgabeId = const Value.absent(),
    this.datum = const Value.absent(),
    this.typ = const Value.absent(),
    this.neueUhrzeitMinuten = const Value.absent(),
    this.neuerTitel = const Value.absent(),
  });
  AusnahmenCompanion.insert({
    this.id = const Value.absent(),
    required int aufgabeId,
    required DateTime datum,
    required AusnahmeTyp typ,
    this.neueUhrzeitMinuten = const Value.absent(),
    this.neuerTitel = const Value.absent(),
  }) : aufgabeId = Value(aufgabeId),
       datum = Value(datum),
       typ = Value(typ);
  static Insertable<Ausnahme> custom({
    Expression<int>? id,
    Expression<int>? aufgabeId,
    Expression<DateTime>? datum,
    Expression<int>? typ,
    Expression<int>? neueUhrzeitMinuten,
    Expression<String>? neuerTitel,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (aufgabeId != null) 'aufgabe_id': aufgabeId,
      if (datum != null) 'datum': datum,
      if (typ != null) 'typ': typ,
      if (neueUhrzeitMinuten != null)
        'neue_uhrzeit_minuten': neueUhrzeitMinuten,
      if (neuerTitel != null) 'neuer_titel': neuerTitel,
    });
  }

  AusnahmenCompanion copyWith({
    Value<int>? id,
    Value<int>? aufgabeId,
    Value<DateTime>? datum,
    Value<AusnahmeTyp>? typ,
    Value<int?>? neueUhrzeitMinuten,
    Value<String?>? neuerTitel,
  }) {
    return AusnahmenCompanion(
      id: id ?? this.id,
      aufgabeId: aufgabeId ?? this.aufgabeId,
      datum: datum ?? this.datum,
      typ: typ ?? this.typ,
      neueUhrzeitMinuten: neueUhrzeitMinuten ?? this.neueUhrzeitMinuten,
      neuerTitel: neuerTitel ?? this.neuerTitel,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (aufgabeId.present) {
      map['aufgabe_id'] = Variable<int>(aufgabeId.value);
    }
    if (datum.present) {
      map['datum'] = Variable<DateTime>(datum.value);
    }
    if (typ.present) {
      map['typ'] = Variable<int>(
        $AusnahmenTable.$convertertyp.toSql(typ.value),
      );
    }
    if (neueUhrzeitMinuten.present) {
      map['neue_uhrzeit_minuten'] = Variable<int>(neueUhrzeitMinuten.value);
    }
    if (neuerTitel.present) {
      map['neuer_titel'] = Variable<String>(neuerTitel.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AusnahmenCompanion(')
          ..write('id: $id, ')
          ..write('aufgabeId: $aufgabeId, ')
          ..write('datum: $datum, ')
          ..write('typ: $typ, ')
          ..write('neueUhrzeitMinuten: $neueUhrzeitMinuten, ')
          ..write('neuerTitel: $neuerTitel')
          ..write(')'))
        .toString();
  }
}

class $EinstellungenTable extends Einstellungen
    with TableInfo<$EinstellungenTable, EinstellungEintrag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EinstellungenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _schluesselMeta = const VerificationMeta(
    'schluessel',
  );
  @override
  late final GeneratedColumn<String> schluessel = GeneratedColumn<String>(
    'schluessel',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wertMeta = const VerificationMeta('wert');
  @override
  late final GeneratedColumn<String> wert = GeneratedColumn<String>(
    'wert',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [schluessel, wert];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'einstellungen';
  @override
  VerificationContext validateIntegrity(
    Insertable<EinstellungEintrag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('schluessel')) {
      context.handle(
        _schluesselMeta,
        schluessel.isAcceptableOrUnknown(data['schluessel']!, _schluesselMeta),
      );
    } else if (isInserting) {
      context.missing(_schluesselMeta);
    }
    if (data.containsKey('wert')) {
      context.handle(
        _wertMeta,
        wert.isAcceptableOrUnknown(data['wert']!, _wertMeta),
      );
    } else if (isInserting) {
      context.missing(_wertMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {schluessel};
  @override
  EinstellungEintrag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EinstellungEintrag(
      schluessel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schluessel'],
      )!,
      wert: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wert'],
      )!,
    );
  }

  @override
  $EinstellungenTable createAlias(String alias) {
    return $EinstellungenTable(attachedDatabase, alias);
  }
}

class EinstellungEintrag extends DataClass
    implements Insertable<EinstellungEintrag> {
  final String schluessel;
  final String wert;
  const EinstellungEintrag({required this.schluessel, required this.wert});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['schluessel'] = Variable<String>(schluessel);
    map['wert'] = Variable<String>(wert);
    return map;
  }

  EinstellungenCompanion toCompanion(bool nullToAbsent) {
    return EinstellungenCompanion(
      schluessel: Value(schluessel),
      wert: Value(wert),
    );
  }

  factory EinstellungEintrag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EinstellungEintrag(
      schluessel: serializer.fromJson<String>(json['schluessel']),
      wert: serializer.fromJson<String>(json['wert']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'schluessel': serializer.toJson<String>(schluessel),
      'wert': serializer.toJson<String>(wert),
    };
  }

  EinstellungEintrag copyWith({String? schluessel, String? wert}) =>
      EinstellungEintrag(
        schluessel: schluessel ?? this.schluessel,
        wert: wert ?? this.wert,
      );
  EinstellungEintrag copyWithCompanion(EinstellungenCompanion data) {
    return EinstellungEintrag(
      schluessel: data.schluessel.present
          ? data.schluessel.value
          : this.schluessel,
      wert: data.wert.present ? data.wert.value : this.wert,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EinstellungEintrag(')
          ..write('schluessel: $schluessel, ')
          ..write('wert: $wert')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(schluessel, wert);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EinstellungEintrag &&
          other.schluessel == this.schluessel &&
          other.wert == this.wert);
}

class EinstellungenCompanion extends UpdateCompanion<EinstellungEintrag> {
  final Value<String> schluessel;
  final Value<String> wert;
  final Value<int> rowid;
  const EinstellungenCompanion({
    this.schluessel = const Value.absent(),
    this.wert = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EinstellungenCompanion.insert({
    required String schluessel,
    required String wert,
    this.rowid = const Value.absent(),
  }) : schluessel = Value(schluessel),
       wert = Value(wert);
  static Insertable<EinstellungEintrag> custom({
    Expression<String>? schluessel,
    Expression<String>? wert,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (schluessel != null) 'schluessel': schluessel,
      if (wert != null) 'wert': wert,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EinstellungenCompanion copyWith({
    Value<String>? schluessel,
    Value<String>? wert,
    Value<int>? rowid,
  }) {
    return EinstellungenCompanion(
      schluessel: schluessel ?? this.schluessel,
      wert: wert ?? this.wert,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (schluessel.present) {
      map['schluessel'] = Variable<String>(schluessel.value);
    }
    if (wert.present) {
      map['wert'] = Variable<String>(wert.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EinstellungenCompanion(')
          ..write('schluessel: $schluessel, ')
          ..write('wert: $wert, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlaeneTable plaene = $PlaeneTable(this);
  late final $WiederholungsregelnTable wiederholungsregeln =
      $WiederholungsregelnTable(this);
  late final $AufgabenTable aufgaben = $AufgabenTable(this);
  late final $ErledigtTable erledigt = $ErledigtTable(this);
  late final $TermineTable termine = $TermineTable(this);
  late final $AusnahmenTable ausnahmen = $AusnahmenTable(this);
  late final $EinstellungenTable einstellungen = $EinstellungenTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    plaene,
    wiederholungsregeln,
    aufgaben,
    erledigt,
    termine,
    ausnahmen,
    einstellungen,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'plaene',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('aufgaben', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'wiederholungsregeln',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('aufgaben', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'aufgaben',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('erledigt', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'aufgaben',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ausnahmen', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$PlaeneTableCreateCompanionBuilder =
    PlaeneCompanion Function({
      Value<int> id,
      required String titel,
      required String kategorie,
      required int akzentfarbe,
      Value<int> sortierindex,
    });
typedef $$PlaeneTableUpdateCompanionBuilder =
    PlaeneCompanion Function({
      Value<int> id,
      Value<String> titel,
      Value<String> kategorie,
      Value<int> akzentfarbe,
      Value<int> sortierindex,
    });

final class $$PlaeneTableReferences
    extends BaseReferences<_$AppDatabase, $PlaeneTable, Plan> {
  $$PlaeneTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AufgabenTable, List<Aufgabe>> _aufgabenRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.aufgaben,
    aliasName: $_aliasNameGenerator(db.plaene.id, db.aufgaben.planId),
  );

  $$AufgabenTableProcessedTableManager get aufgabenRefs {
    final manager = $$AufgabenTableTableManager(
      $_db,
      $_db.aufgaben,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_aufgabenRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlaeneTableFilterComposer
    extends Composer<_$AppDatabase, $PlaeneTable> {
  $$PlaeneTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titel => $composableBuilder(
    column: $table.titel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kategorie => $composableBuilder(
    column: $table.kategorie,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get akzentfarbe => $composableBuilder(
    column: $table.akzentfarbe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortierindex => $composableBuilder(
    column: $table.sortierindex,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> aufgabenRefs(
    Expression<bool> Function($$AufgabenTableFilterComposer f) f,
  ) {
    final $$AufgabenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableFilterComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlaeneTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaeneTable> {
  $$PlaeneTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titel => $composableBuilder(
    column: $table.titel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kategorie => $composableBuilder(
    column: $table.kategorie,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get akzentfarbe => $composableBuilder(
    column: $table.akzentfarbe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortierindex => $composableBuilder(
    column: $table.sortierindex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlaeneTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaeneTable> {
  $$PlaeneTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titel =>
      $composableBuilder(column: $table.titel, builder: (column) => column);

  GeneratedColumn<String> get kategorie =>
      $composableBuilder(column: $table.kategorie, builder: (column) => column);

  GeneratedColumn<int> get akzentfarbe => $composableBuilder(
    column: $table.akzentfarbe,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortierindex => $composableBuilder(
    column: $table.sortierindex,
    builder: (column) => column,
  );

  Expression<T> aufgabenRefs<T extends Object>(
    Expression<T> Function($$AufgabenTableAnnotationComposer a) f,
  ) {
    final $$AufgabenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableAnnotationComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlaeneTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaeneTable,
          Plan,
          $$PlaeneTableFilterComposer,
          $$PlaeneTableOrderingComposer,
          $$PlaeneTableAnnotationComposer,
          $$PlaeneTableCreateCompanionBuilder,
          $$PlaeneTableUpdateCompanionBuilder,
          (Plan, $$PlaeneTableReferences),
          Plan,
          PrefetchHooks Function({bool aufgabenRefs})
        > {
  $$PlaeneTableTableManager(_$AppDatabase db, $PlaeneTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaeneTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaeneTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaeneTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> titel = const Value.absent(),
                Value<String> kategorie = const Value.absent(),
                Value<int> akzentfarbe = const Value.absent(),
                Value<int> sortierindex = const Value.absent(),
              }) => PlaeneCompanion(
                id: id,
                titel: titel,
                kategorie: kategorie,
                akzentfarbe: akzentfarbe,
                sortierindex: sortierindex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String titel,
                required String kategorie,
                required int akzentfarbe,
                Value<int> sortierindex = const Value.absent(),
              }) => PlaeneCompanion.insert(
                id: id,
                titel: titel,
                kategorie: kategorie,
                akzentfarbe: akzentfarbe,
                sortierindex: sortierindex,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PlaeneTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({aufgabenRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (aufgabenRefs) db.aufgaben],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (aufgabenRefs)
                    await $_getPrefetchedData<Plan, $PlaeneTable, Aufgabe>(
                      currentTable: table,
                      referencedTable: $$PlaeneTableReferences
                          ._aufgabenRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PlaeneTableReferences(db, table, p0).aufgabenRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.planId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlaeneTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaeneTable,
      Plan,
      $$PlaeneTableFilterComposer,
      $$PlaeneTableOrderingComposer,
      $$PlaeneTableAnnotationComposer,
      $$PlaeneTableCreateCompanionBuilder,
      $$PlaeneTableUpdateCompanionBuilder,
      (Plan, $$PlaeneTableReferences),
      Plan,
      PrefetchHooks Function({bool aufgabenRefs})
    >;
typedef $$WiederholungsregelnTableCreateCompanionBuilder =
    WiederholungsregelnCompanion Function({
      Value<int> id,
      required WiederholungsTyp typ,
      Value<int?> wochentagBitmaske,
      Value<int?> monatsTag,
    });
typedef $$WiederholungsregelnTableUpdateCompanionBuilder =
    WiederholungsregelnCompanion Function({
      Value<int> id,
      Value<WiederholungsTyp> typ,
      Value<int?> wochentagBitmaske,
      Value<int?> monatsTag,
    });

final class $$WiederholungsregelnTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WiederholungsregelnTable,
          Wiederholungsregel
        > {
  $$WiederholungsregelnTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$AufgabenTable, List<Aufgabe>> _aufgabenRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.aufgaben,
    aliasName: $_aliasNameGenerator(
      db.wiederholungsregeln.id,
      db.aufgaben.wiederholungsregelId,
    ),
  );

  $$AufgabenTableProcessedTableManager get aufgabenRefs {
    final manager = $$AufgabenTableTableManager($_db, $_db.aufgaben).filter(
      (f) => f.wiederholungsregelId.id.sqlEquals($_itemColumn<int>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_aufgabenRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WiederholungsregelnTableFilterComposer
    extends Composer<_$AppDatabase, $WiederholungsregelnTable> {
  $$WiederholungsregelnTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WiederholungsTyp, WiederholungsTyp, int>
  get typ => $composableBuilder(
    column: $table.typ,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get wochentagBitmaske => $composableBuilder(
    column: $table.wochentagBitmaske,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monatsTag => $composableBuilder(
    column: $table.monatsTag,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> aufgabenRefs(
    Expression<bool> Function($$AufgabenTableFilterComposer f) f,
  ) {
    final $$AufgabenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.wiederholungsregelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableFilterComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WiederholungsregelnTableOrderingComposer
    extends Composer<_$AppDatabase, $WiederholungsregelnTable> {
  $$WiederholungsregelnTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get typ => $composableBuilder(
    column: $table.typ,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wochentagBitmaske => $composableBuilder(
    column: $table.wochentagBitmaske,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monatsTag => $composableBuilder(
    column: $table.monatsTag,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WiederholungsregelnTableAnnotationComposer
    extends Composer<_$AppDatabase, $WiederholungsregelnTable> {
  $$WiederholungsregelnTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WiederholungsTyp, int> get typ =>
      $composableBuilder(column: $table.typ, builder: (column) => column);

  GeneratedColumn<int> get wochentagBitmaske => $composableBuilder(
    column: $table.wochentagBitmaske,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monatsTag =>
      $composableBuilder(column: $table.monatsTag, builder: (column) => column);

  Expression<T> aufgabenRefs<T extends Object>(
    Expression<T> Function($$AufgabenTableAnnotationComposer a) f,
  ) {
    final $$AufgabenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.wiederholungsregelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableAnnotationComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WiederholungsregelnTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WiederholungsregelnTable,
          Wiederholungsregel,
          $$WiederholungsregelnTableFilterComposer,
          $$WiederholungsregelnTableOrderingComposer,
          $$WiederholungsregelnTableAnnotationComposer,
          $$WiederholungsregelnTableCreateCompanionBuilder,
          $$WiederholungsregelnTableUpdateCompanionBuilder,
          (Wiederholungsregel, $$WiederholungsregelnTableReferences),
          Wiederholungsregel,
          PrefetchHooks Function({bool aufgabenRefs})
        > {
  $$WiederholungsregelnTableTableManager(
    _$AppDatabase db,
    $WiederholungsregelnTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WiederholungsregelnTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WiederholungsregelnTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WiederholungsregelnTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<WiederholungsTyp> typ = const Value.absent(),
                Value<int?> wochentagBitmaske = const Value.absent(),
                Value<int?> monatsTag = const Value.absent(),
              }) => WiederholungsregelnCompanion(
                id: id,
                typ: typ,
                wochentagBitmaske: wochentagBitmaske,
                monatsTag: monatsTag,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required WiederholungsTyp typ,
                Value<int?> wochentagBitmaske = const Value.absent(),
                Value<int?> monatsTag = const Value.absent(),
              }) => WiederholungsregelnCompanion.insert(
                id: id,
                typ: typ,
                wochentagBitmaske: wochentagBitmaske,
                monatsTag: monatsTag,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WiederholungsregelnTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({aufgabenRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (aufgabenRefs) db.aufgaben],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (aufgabenRefs)
                    await $_getPrefetchedData<
                      Wiederholungsregel,
                      $WiederholungsregelnTable,
                      Aufgabe
                    >(
                      currentTable: table,
                      referencedTable: $$WiederholungsregelnTableReferences
                          ._aufgabenRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WiederholungsregelnTableReferences(
                            db,
                            table,
                            p0,
                          ).aufgabenRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.wiederholungsregelId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WiederholungsregelnTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WiederholungsregelnTable,
      Wiederholungsregel,
      $$WiederholungsregelnTableFilterComposer,
      $$WiederholungsregelnTableOrderingComposer,
      $$WiederholungsregelnTableAnnotationComposer,
      $$WiederholungsregelnTableCreateCompanionBuilder,
      $$WiederholungsregelnTableUpdateCompanionBuilder,
      (Wiederholungsregel, $$WiederholungsregelnTableReferences),
      Wiederholungsregel,
      PrefetchHooks Function({bool aufgabenRefs})
    >;
typedef $$AufgabenTableCreateCompanionBuilder =
    AufgabenCompanion Function({
      Value<int> id,
      required int planId,
      required String titel,
      Value<String?> beschreibung,
      Value<int?> uhrzeitMinuten,
      required int wiederholungsregelId,
      Value<int> sortierindex,
    });
typedef $$AufgabenTableUpdateCompanionBuilder =
    AufgabenCompanion Function({
      Value<int> id,
      Value<int> planId,
      Value<String> titel,
      Value<String?> beschreibung,
      Value<int?> uhrzeitMinuten,
      Value<int> wiederholungsregelId,
      Value<int> sortierindex,
    });

final class $$AufgabenTableReferences
    extends BaseReferences<_$AppDatabase, $AufgabenTable, Aufgabe> {
  $$AufgabenTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlaeneTable _planIdTable(_$AppDatabase db) => db.plaene.createAlias(
    $_aliasNameGenerator(db.aufgaben.planId, db.plaene.id),
  );

  $$PlaeneTableProcessedTableManager get planId {
    final $_column = $_itemColumn<int>('plan_id')!;

    final manager = $$PlaeneTableTableManager(
      $_db,
      $_db.plaene,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WiederholungsregelnTable _wiederholungsregelIdTable(
    _$AppDatabase db,
  ) => db.wiederholungsregeln.createAlias(
    $_aliasNameGenerator(
      db.aufgaben.wiederholungsregelId,
      db.wiederholungsregeln.id,
    ),
  );

  $$WiederholungsregelnTableProcessedTableManager get wiederholungsregelId {
    final $_column = $_itemColumn<int>('wiederholungsregel_id')!;

    final manager = $$WiederholungsregelnTableTableManager(
      $_db,
      $_db.wiederholungsregeln,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _wiederholungsregelIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ErledigtTable, List<ErledigtEintrag>>
  _erledigtRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.erledigt,
    aliasName: $_aliasNameGenerator(db.aufgaben.id, db.erledigt.aufgabeId),
  );

  $$ErledigtTableProcessedTableManager get erledigtRefs {
    final manager = $$ErledigtTableTableManager(
      $_db,
      $_db.erledigt,
    ).filter((f) => f.aufgabeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_erledigtRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AusnahmenTable, List<Ausnahme>>
  _ausnahmenRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ausnahmen,
    aliasName: $_aliasNameGenerator(db.aufgaben.id, db.ausnahmen.aufgabeId),
  );

  $$AusnahmenTableProcessedTableManager get ausnahmenRefs {
    final manager = $$AusnahmenTableTableManager(
      $_db,
      $_db.ausnahmen,
    ).filter((f) => f.aufgabeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ausnahmenRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AufgabenTableFilterComposer
    extends Composer<_$AppDatabase, $AufgabenTable> {
  $$AufgabenTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titel => $composableBuilder(
    column: $table.titel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get beschreibung => $composableBuilder(
    column: $table.beschreibung,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get uhrzeitMinuten => $composableBuilder(
    column: $table.uhrzeitMinuten,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortierindex => $composableBuilder(
    column: $table.sortierindex,
    builder: (column) => ColumnFilters(column),
  );

  $$PlaeneTableFilterComposer get planId {
    final $$PlaeneTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plaene,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaeneTableFilterComposer(
            $db: $db,
            $table: $db.plaene,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WiederholungsregelnTableFilterComposer get wiederholungsregelId {
    final $$WiederholungsregelnTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wiederholungsregelId,
      referencedTable: $db.wiederholungsregeln,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WiederholungsregelnTableFilterComposer(
            $db: $db,
            $table: $db.wiederholungsregeln,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> erledigtRefs(
    Expression<bool> Function($$ErledigtTableFilterComposer f) f,
  ) {
    final $$ErledigtTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.erledigt,
      getReferencedColumn: (t) => t.aufgabeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ErledigtTableFilterComposer(
            $db: $db,
            $table: $db.erledigt,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ausnahmenRefs(
    Expression<bool> Function($$AusnahmenTableFilterComposer f) f,
  ) {
    final $$AusnahmenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ausnahmen,
      getReferencedColumn: (t) => t.aufgabeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AusnahmenTableFilterComposer(
            $db: $db,
            $table: $db.ausnahmen,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AufgabenTableOrderingComposer
    extends Composer<_$AppDatabase, $AufgabenTable> {
  $$AufgabenTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titel => $composableBuilder(
    column: $table.titel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get beschreibung => $composableBuilder(
    column: $table.beschreibung,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uhrzeitMinuten => $composableBuilder(
    column: $table.uhrzeitMinuten,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortierindex => $composableBuilder(
    column: $table.sortierindex,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlaeneTableOrderingComposer get planId {
    final $$PlaeneTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plaene,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaeneTableOrderingComposer(
            $db: $db,
            $table: $db.plaene,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WiederholungsregelnTableOrderingComposer get wiederholungsregelId {
    final $$WiederholungsregelnTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.wiederholungsregelId,
          referencedTable: $db.wiederholungsregeln,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WiederholungsregelnTableOrderingComposer(
                $db: $db,
                $table: $db.wiederholungsregeln,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$AufgabenTableAnnotationComposer
    extends Composer<_$AppDatabase, $AufgabenTable> {
  $$AufgabenTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titel =>
      $composableBuilder(column: $table.titel, builder: (column) => column);

  GeneratedColumn<String> get beschreibung => $composableBuilder(
    column: $table.beschreibung,
    builder: (column) => column,
  );

  GeneratedColumn<int> get uhrzeitMinuten => $composableBuilder(
    column: $table.uhrzeitMinuten,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortierindex => $composableBuilder(
    column: $table.sortierindex,
    builder: (column) => column,
  );

  $$PlaeneTableAnnotationComposer get planId {
    final $$PlaeneTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.plaene,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaeneTableAnnotationComposer(
            $db: $db,
            $table: $db.plaene,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WiederholungsregelnTableAnnotationComposer get wiederholungsregelId {
    final $$WiederholungsregelnTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.wiederholungsregelId,
          referencedTable: $db.wiederholungsregeln,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WiederholungsregelnTableAnnotationComposer(
                $db: $db,
                $table: $db.wiederholungsregeln,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> erledigtRefs<T extends Object>(
    Expression<T> Function($$ErledigtTableAnnotationComposer a) f,
  ) {
    final $$ErledigtTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.erledigt,
      getReferencedColumn: (t) => t.aufgabeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ErledigtTableAnnotationComposer(
            $db: $db,
            $table: $db.erledigt,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ausnahmenRefs<T extends Object>(
    Expression<T> Function($$AusnahmenTableAnnotationComposer a) f,
  ) {
    final $$AusnahmenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ausnahmen,
      getReferencedColumn: (t) => t.aufgabeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AusnahmenTableAnnotationComposer(
            $db: $db,
            $table: $db.ausnahmen,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AufgabenTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AufgabenTable,
          Aufgabe,
          $$AufgabenTableFilterComposer,
          $$AufgabenTableOrderingComposer,
          $$AufgabenTableAnnotationComposer,
          $$AufgabenTableCreateCompanionBuilder,
          $$AufgabenTableUpdateCompanionBuilder,
          (Aufgabe, $$AufgabenTableReferences),
          Aufgabe,
          PrefetchHooks Function({
            bool planId,
            bool wiederholungsregelId,
            bool erledigtRefs,
            bool ausnahmenRefs,
          })
        > {
  $$AufgabenTableTableManager(_$AppDatabase db, $AufgabenTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AufgabenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AufgabenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AufgabenTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> planId = const Value.absent(),
                Value<String> titel = const Value.absent(),
                Value<String?> beschreibung = const Value.absent(),
                Value<int?> uhrzeitMinuten = const Value.absent(),
                Value<int> wiederholungsregelId = const Value.absent(),
                Value<int> sortierindex = const Value.absent(),
              }) => AufgabenCompanion(
                id: id,
                planId: planId,
                titel: titel,
                beschreibung: beschreibung,
                uhrzeitMinuten: uhrzeitMinuten,
                wiederholungsregelId: wiederholungsregelId,
                sortierindex: sortierindex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int planId,
                required String titel,
                Value<String?> beschreibung = const Value.absent(),
                Value<int?> uhrzeitMinuten = const Value.absent(),
                required int wiederholungsregelId,
                Value<int> sortierindex = const Value.absent(),
              }) => AufgabenCompanion.insert(
                id: id,
                planId: planId,
                titel: titel,
                beschreibung: beschreibung,
                uhrzeitMinuten: uhrzeitMinuten,
                wiederholungsregelId: wiederholungsregelId,
                sortierindex: sortierindex,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AufgabenTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                planId = false,
                wiederholungsregelId = false,
                erledigtRefs = false,
                ausnahmenRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (erledigtRefs) db.erledigt,
                    if (ausnahmenRefs) db.ausnahmen,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (planId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.planId,
                                    referencedTable: $$AufgabenTableReferences
                                        ._planIdTable(db),
                                    referencedColumn: $$AufgabenTableReferences
                                        ._planIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (wiederholungsregelId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.wiederholungsregelId,
                                    referencedTable: $$AufgabenTableReferences
                                        ._wiederholungsregelIdTable(db),
                                    referencedColumn: $$AufgabenTableReferences
                                        ._wiederholungsregelIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (erledigtRefs)
                        await $_getPrefetchedData<
                          Aufgabe,
                          $AufgabenTable,
                          ErledigtEintrag
                        >(
                          currentTable: table,
                          referencedTable: $$AufgabenTableReferences
                              ._erledigtRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AufgabenTableReferences(
                                db,
                                table,
                                p0,
                              ).erledigtRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.aufgabeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ausnahmenRefs)
                        await $_getPrefetchedData<
                          Aufgabe,
                          $AufgabenTable,
                          Ausnahme
                        >(
                          currentTable: table,
                          referencedTable: $$AufgabenTableReferences
                              ._ausnahmenRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AufgabenTableReferences(
                                db,
                                table,
                                p0,
                              ).ausnahmenRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.aufgabeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AufgabenTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AufgabenTable,
      Aufgabe,
      $$AufgabenTableFilterComposer,
      $$AufgabenTableOrderingComposer,
      $$AufgabenTableAnnotationComposer,
      $$AufgabenTableCreateCompanionBuilder,
      $$AufgabenTableUpdateCompanionBuilder,
      (Aufgabe, $$AufgabenTableReferences),
      Aufgabe,
      PrefetchHooks Function({
        bool planId,
        bool wiederholungsregelId,
        bool erledigtRefs,
        bool ausnahmenRefs,
      })
    >;
typedef $$ErledigtTableCreateCompanionBuilder =
    ErledigtCompanion Function({
      Value<int> id,
      required int aufgabeId,
      required DateTime faelligDatum,
      Value<bool> erledigt,
      Value<DateTime?> erledigtAm,
    });
typedef $$ErledigtTableUpdateCompanionBuilder =
    ErledigtCompanion Function({
      Value<int> id,
      Value<int> aufgabeId,
      Value<DateTime> faelligDatum,
      Value<bool> erledigt,
      Value<DateTime?> erledigtAm,
    });

final class $$ErledigtTableReferences
    extends BaseReferences<_$AppDatabase, $ErledigtTable, ErledigtEintrag> {
  $$ErledigtTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AufgabenTable _aufgabeIdTable(_$AppDatabase db) => db.aufgaben
      .createAlias($_aliasNameGenerator(db.erledigt.aufgabeId, db.aufgaben.id));

  $$AufgabenTableProcessedTableManager get aufgabeId {
    final $_column = $_itemColumn<int>('aufgabe_id')!;

    final manager = $$AufgabenTableTableManager(
      $_db,
      $_db.aufgaben,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_aufgabeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ErledigtTableFilterComposer
    extends Composer<_$AppDatabase, $ErledigtTable> {
  $$ErledigtTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get faelligDatum => $composableBuilder(
    column: $table.faelligDatum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get erledigt => $composableBuilder(
    column: $table.erledigt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get erledigtAm => $composableBuilder(
    column: $table.erledigtAm,
    builder: (column) => ColumnFilters(column),
  );

  $$AufgabenTableFilterComposer get aufgabeId {
    final $$AufgabenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.aufgabeId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableFilterComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ErledigtTableOrderingComposer
    extends Composer<_$AppDatabase, $ErledigtTable> {
  $$ErledigtTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get faelligDatum => $composableBuilder(
    column: $table.faelligDatum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get erledigt => $composableBuilder(
    column: $table.erledigt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get erledigtAm => $composableBuilder(
    column: $table.erledigtAm,
    builder: (column) => ColumnOrderings(column),
  );

  $$AufgabenTableOrderingComposer get aufgabeId {
    final $$AufgabenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.aufgabeId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableOrderingComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ErledigtTableAnnotationComposer
    extends Composer<_$AppDatabase, $ErledigtTable> {
  $$ErledigtTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get faelligDatum => $composableBuilder(
    column: $table.faelligDatum,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get erledigt =>
      $composableBuilder(column: $table.erledigt, builder: (column) => column);

  GeneratedColumn<DateTime> get erledigtAm => $composableBuilder(
    column: $table.erledigtAm,
    builder: (column) => column,
  );

  $$AufgabenTableAnnotationComposer get aufgabeId {
    final $$AufgabenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.aufgabeId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableAnnotationComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ErledigtTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ErledigtTable,
          ErledigtEintrag,
          $$ErledigtTableFilterComposer,
          $$ErledigtTableOrderingComposer,
          $$ErledigtTableAnnotationComposer,
          $$ErledigtTableCreateCompanionBuilder,
          $$ErledigtTableUpdateCompanionBuilder,
          (ErledigtEintrag, $$ErledigtTableReferences),
          ErledigtEintrag,
          PrefetchHooks Function({bool aufgabeId})
        > {
  $$ErledigtTableTableManager(_$AppDatabase db, $ErledigtTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ErledigtTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ErledigtTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ErledigtTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> aufgabeId = const Value.absent(),
                Value<DateTime> faelligDatum = const Value.absent(),
                Value<bool> erledigt = const Value.absent(),
                Value<DateTime?> erledigtAm = const Value.absent(),
              }) => ErledigtCompanion(
                id: id,
                aufgabeId: aufgabeId,
                faelligDatum: faelligDatum,
                erledigt: erledigt,
                erledigtAm: erledigtAm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int aufgabeId,
                required DateTime faelligDatum,
                Value<bool> erledigt = const Value.absent(),
                Value<DateTime?> erledigtAm = const Value.absent(),
              }) => ErledigtCompanion.insert(
                id: id,
                aufgabeId: aufgabeId,
                faelligDatum: faelligDatum,
                erledigt: erledigt,
                erledigtAm: erledigtAm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ErledigtTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({aufgabeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (aufgabeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.aufgabeId,
                                referencedTable: $$ErledigtTableReferences
                                    ._aufgabeIdTable(db),
                                referencedColumn: $$ErledigtTableReferences
                                    ._aufgabeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ErledigtTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ErledigtTable,
      ErledigtEintrag,
      $$ErledigtTableFilterComposer,
      $$ErledigtTableOrderingComposer,
      $$ErledigtTableAnnotationComposer,
      $$ErledigtTableCreateCompanionBuilder,
      $$ErledigtTableUpdateCompanionBuilder,
      (ErledigtEintrag, $$ErledigtTableReferences),
      ErledigtEintrag,
      PrefetchHooks Function({bool aufgabeId})
    >;
typedef $$TermineTableCreateCompanionBuilder =
    TermineCompanion Function({
      Value<int> id,
      required String titel,
      Value<String?> beschreibung,
      required DateTime datum,
      Value<int?> uhrzeitMinuten,
      Value<String?> ort,
    });
typedef $$TermineTableUpdateCompanionBuilder =
    TermineCompanion Function({
      Value<int> id,
      Value<String> titel,
      Value<String?> beschreibung,
      Value<DateTime> datum,
      Value<int?> uhrzeitMinuten,
      Value<String?> ort,
    });

class $$TermineTableFilterComposer
    extends Composer<_$AppDatabase, $TermineTable> {
  $$TermineTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titel => $composableBuilder(
    column: $table.titel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get beschreibung => $composableBuilder(
    column: $table.beschreibung,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get datum => $composableBuilder(
    column: $table.datum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get uhrzeitMinuten => $composableBuilder(
    column: $table.uhrzeitMinuten,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ort => $composableBuilder(
    column: $table.ort,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TermineTableOrderingComposer
    extends Composer<_$AppDatabase, $TermineTable> {
  $$TermineTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titel => $composableBuilder(
    column: $table.titel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get beschreibung => $composableBuilder(
    column: $table.beschreibung,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get datum => $composableBuilder(
    column: $table.datum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uhrzeitMinuten => $composableBuilder(
    column: $table.uhrzeitMinuten,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ort => $composableBuilder(
    column: $table.ort,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TermineTableAnnotationComposer
    extends Composer<_$AppDatabase, $TermineTable> {
  $$TermineTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titel =>
      $composableBuilder(column: $table.titel, builder: (column) => column);

  GeneratedColumn<String> get beschreibung => $composableBuilder(
    column: $table.beschreibung,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get datum =>
      $composableBuilder(column: $table.datum, builder: (column) => column);

  GeneratedColumn<int> get uhrzeitMinuten => $composableBuilder(
    column: $table.uhrzeitMinuten,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ort =>
      $composableBuilder(column: $table.ort, builder: (column) => column);
}

class $$TermineTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TermineTable,
          Termin,
          $$TermineTableFilterComposer,
          $$TermineTableOrderingComposer,
          $$TermineTableAnnotationComposer,
          $$TermineTableCreateCompanionBuilder,
          $$TermineTableUpdateCompanionBuilder,
          (Termin, BaseReferences<_$AppDatabase, $TermineTable, Termin>),
          Termin,
          PrefetchHooks Function()
        > {
  $$TermineTableTableManager(_$AppDatabase db, $TermineTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TermineTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TermineTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TermineTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> titel = const Value.absent(),
                Value<String?> beschreibung = const Value.absent(),
                Value<DateTime> datum = const Value.absent(),
                Value<int?> uhrzeitMinuten = const Value.absent(),
                Value<String?> ort = const Value.absent(),
              }) => TermineCompanion(
                id: id,
                titel: titel,
                beschreibung: beschreibung,
                datum: datum,
                uhrzeitMinuten: uhrzeitMinuten,
                ort: ort,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String titel,
                Value<String?> beschreibung = const Value.absent(),
                required DateTime datum,
                Value<int?> uhrzeitMinuten = const Value.absent(),
                Value<String?> ort = const Value.absent(),
              }) => TermineCompanion.insert(
                id: id,
                titel: titel,
                beschreibung: beschreibung,
                datum: datum,
                uhrzeitMinuten: uhrzeitMinuten,
                ort: ort,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TermineTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TermineTable,
      Termin,
      $$TermineTableFilterComposer,
      $$TermineTableOrderingComposer,
      $$TermineTableAnnotationComposer,
      $$TermineTableCreateCompanionBuilder,
      $$TermineTableUpdateCompanionBuilder,
      (Termin, BaseReferences<_$AppDatabase, $TermineTable, Termin>),
      Termin,
      PrefetchHooks Function()
    >;
typedef $$AusnahmenTableCreateCompanionBuilder =
    AusnahmenCompanion Function({
      Value<int> id,
      required int aufgabeId,
      required DateTime datum,
      required AusnahmeTyp typ,
      Value<int?> neueUhrzeitMinuten,
      Value<String?> neuerTitel,
    });
typedef $$AusnahmenTableUpdateCompanionBuilder =
    AusnahmenCompanion Function({
      Value<int> id,
      Value<int> aufgabeId,
      Value<DateTime> datum,
      Value<AusnahmeTyp> typ,
      Value<int?> neueUhrzeitMinuten,
      Value<String?> neuerTitel,
    });

final class $$AusnahmenTableReferences
    extends BaseReferences<_$AppDatabase, $AusnahmenTable, Ausnahme> {
  $$AusnahmenTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AufgabenTable _aufgabeIdTable(_$AppDatabase db) =>
      db.aufgaben.createAlias(
        $_aliasNameGenerator(db.ausnahmen.aufgabeId, db.aufgaben.id),
      );

  $$AufgabenTableProcessedTableManager get aufgabeId {
    final $_column = $_itemColumn<int>('aufgabe_id')!;

    final manager = $$AufgabenTableTableManager(
      $_db,
      $_db.aufgaben,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_aufgabeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AusnahmenTableFilterComposer
    extends Composer<_$AppDatabase, $AusnahmenTable> {
  $$AusnahmenTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get datum => $composableBuilder(
    column: $table.datum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AusnahmeTyp, AusnahmeTyp, int> get typ =>
      $composableBuilder(
        column: $table.typ,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get neueUhrzeitMinuten => $composableBuilder(
    column: $table.neueUhrzeitMinuten,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get neuerTitel => $composableBuilder(
    column: $table.neuerTitel,
    builder: (column) => ColumnFilters(column),
  );

  $$AufgabenTableFilterComposer get aufgabeId {
    final $$AufgabenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.aufgabeId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableFilterComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AusnahmenTableOrderingComposer
    extends Composer<_$AppDatabase, $AusnahmenTable> {
  $$AusnahmenTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get datum => $composableBuilder(
    column: $table.datum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get typ => $composableBuilder(
    column: $table.typ,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get neueUhrzeitMinuten => $composableBuilder(
    column: $table.neueUhrzeitMinuten,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get neuerTitel => $composableBuilder(
    column: $table.neuerTitel,
    builder: (column) => ColumnOrderings(column),
  );

  $$AufgabenTableOrderingComposer get aufgabeId {
    final $$AufgabenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.aufgabeId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableOrderingComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AusnahmenTableAnnotationComposer
    extends Composer<_$AppDatabase, $AusnahmenTable> {
  $$AusnahmenTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get datum =>
      $composableBuilder(column: $table.datum, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AusnahmeTyp, int> get typ =>
      $composableBuilder(column: $table.typ, builder: (column) => column);

  GeneratedColumn<int> get neueUhrzeitMinuten => $composableBuilder(
    column: $table.neueUhrzeitMinuten,
    builder: (column) => column,
  );

  GeneratedColumn<String> get neuerTitel => $composableBuilder(
    column: $table.neuerTitel,
    builder: (column) => column,
  );

  $$AufgabenTableAnnotationComposer get aufgabeId {
    final $$AufgabenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.aufgabeId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableAnnotationComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AusnahmenTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AusnahmenTable,
          Ausnahme,
          $$AusnahmenTableFilterComposer,
          $$AusnahmenTableOrderingComposer,
          $$AusnahmenTableAnnotationComposer,
          $$AusnahmenTableCreateCompanionBuilder,
          $$AusnahmenTableUpdateCompanionBuilder,
          (Ausnahme, $$AusnahmenTableReferences),
          Ausnahme,
          PrefetchHooks Function({bool aufgabeId})
        > {
  $$AusnahmenTableTableManager(_$AppDatabase db, $AusnahmenTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AusnahmenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AusnahmenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AusnahmenTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> aufgabeId = const Value.absent(),
                Value<DateTime> datum = const Value.absent(),
                Value<AusnahmeTyp> typ = const Value.absent(),
                Value<int?> neueUhrzeitMinuten = const Value.absent(),
                Value<String?> neuerTitel = const Value.absent(),
              }) => AusnahmenCompanion(
                id: id,
                aufgabeId: aufgabeId,
                datum: datum,
                typ: typ,
                neueUhrzeitMinuten: neueUhrzeitMinuten,
                neuerTitel: neuerTitel,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int aufgabeId,
                required DateTime datum,
                required AusnahmeTyp typ,
                Value<int?> neueUhrzeitMinuten = const Value.absent(),
                Value<String?> neuerTitel = const Value.absent(),
              }) => AusnahmenCompanion.insert(
                id: id,
                aufgabeId: aufgabeId,
                datum: datum,
                typ: typ,
                neueUhrzeitMinuten: neueUhrzeitMinuten,
                neuerTitel: neuerTitel,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AusnahmenTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({aufgabeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (aufgabeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.aufgabeId,
                                referencedTable: $$AusnahmenTableReferences
                                    ._aufgabeIdTable(db),
                                referencedColumn: $$AusnahmenTableReferences
                                    ._aufgabeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AusnahmenTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AusnahmenTable,
      Ausnahme,
      $$AusnahmenTableFilterComposer,
      $$AusnahmenTableOrderingComposer,
      $$AusnahmenTableAnnotationComposer,
      $$AusnahmenTableCreateCompanionBuilder,
      $$AusnahmenTableUpdateCompanionBuilder,
      (Ausnahme, $$AusnahmenTableReferences),
      Ausnahme,
      PrefetchHooks Function({bool aufgabeId})
    >;
typedef $$EinstellungenTableCreateCompanionBuilder =
    EinstellungenCompanion Function({
      required String schluessel,
      required String wert,
      Value<int> rowid,
    });
typedef $$EinstellungenTableUpdateCompanionBuilder =
    EinstellungenCompanion Function({
      Value<String> schluessel,
      Value<String> wert,
      Value<int> rowid,
    });

class $$EinstellungenTableFilterComposer
    extends Composer<_$AppDatabase, $EinstellungenTable> {
  $$EinstellungenTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get schluessel => $composableBuilder(
    column: $table.schluessel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wert => $composableBuilder(
    column: $table.wert,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EinstellungenTableOrderingComposer
    extends Composer<_$AppDatabase, $EinstellungenTable> {
  $$EinstellungenTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get schluessel => $composableBuilder(
    column: $table.schluessel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wert => $composableBuilder(
    column: $table.wert,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EinstellungenTableAnnotationComposer
    extends Composer<_$AppDatabase, $EinstellungenTable> {
  $$EinstellungenTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get schluessel => $composableBuilder(
    column: $table.schluessel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get wert =>
      $composableBuilder(column: $table.wert, builder: (column) => column);
}

class $$EinstellungenTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EinstellungenTable,
          EinstellungEintrag,
          $$EinstellungenTableFilterComposer,
          $$EinstellungenTableOrderingComposer,
          $$EinstellungenTableAnnotationComposer,
          $$EinstellungenTableCreateCompanionBuilder,
          $$EinstellungenTableUpdateCompanionBuilder,
          (
            EinstellungEintrag,
            BaseReferences<
              _$AppDatabase,
              $EinstellungenTable,
              EinstellungEintrag
            >,
          ),
          EinstellungEintrag,
          PrefetchHooks Function()
        > {
  $$EinstellungenTableTableManager(_$AppDatabase db, $EinstellungenTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EinstellungenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EinstellungenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EinstellungenTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> schluessel = const Value.absent(),
                Value<String> wert = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EinstellungenCompanion(
                schluessel: schluessel,
                wert: wert,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String schluessel,
                required String wert,
                Value<int> rowid = const Value.absent(),
              }) => EinstellungenCompanion.insert(
                schluessel: schluessel,
                wert: wert,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EinstellungenTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EinstellungenTable,
      EinstellungEintrag,
      $$EinstellungenTableFilterComposer,
      $$EinstellungenTableOrderingComposer,
      $$EinstellungenTableAnnotationComposer,
      $$EinstellungenTableCreateCompanionBuilder,
      $$EinstellungenTableUpdateCompanionBuilder,
      (
        EinstellungEintrag,
        BaseReferences<_$AppDatabase, $EinstellungenTable, EinstellungEintrag>,
      ),
      EinstellungEintrag,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlaeneTableTableManager get plaene =>
      $$PlaeneTableTableManager(_db, _db.plaene);
  $$WiederholungsregelnTableTableManager get wiederholungsregeln =>
      $$WiederholungsregelnTableTableManager(_db, _db.wiederholungsregeln);
  $$AufgabenTableTableManager get aufgaben =>
      $$AufgabenTableTableManager(_db, _db.aufgaben);
  $$ErledigtTableTableManager get erledigt =>
      $$ErledigtTableTableManager(_db, _db.erledigt);
  $$TermineTableTableManager get termine =>
      $$TermineTableTableManager(_db, _db.termine);
  $$AusnahmenTableTableManager get ausnahmen =>
      $$AusnahmenTableTableManager(_db, _db.ausnahmen);
  $$EinstellungenTableTableManager get einstellungen =>
      $$EinstellungenTableTableManager(_db, _db.einstellungen);
}
