// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppDatabase.dart';

// ignore_for_file: type=lint
class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [name, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String name;
  final String value;
  const Setting({required this.name, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(name: Value(name), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      name: serializer.fromJson<String>(json['name']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? name, String? value}) =>
      Setting(name: name ?? this.name, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      name: data.name.present ? data.name.value : this.name,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('name: $name, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(name, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.name == this.name &&
          other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> name;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.name = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String name,
    required String value,
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? name,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? name,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      name: name ?? this.name,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrackRecordsTable extends TrackRecords
    with TableInfo<$TrackRecordsTable, TrackRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, createdAt, isCompleted, source];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'track_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isCompletedMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
    );
  }

  @override
  $TrackRecordsTable createAlias(String alias) {
    return $TrackRecordsTable(attachedDatabase, alias);
  }
}

class TrackRecord extends DataClass implements Insertable<TrackRecord> {
  final int id;
  final DateTime createdAt;
  final bool isCompleted;
  final String? source;
  const TrackRecord({
    required this.id,
    required this.createdAt,
    required this.isCompleted,
    this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    return map;
  }

  TrackRecordsCompanion toCompanion(bool nullToAbsent) {
    return TrackRecordsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      isCompleted: Value(isCompleted),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
    );
  }

  factory TrackRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackRecord(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      source: serializer.fromJson<String?>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'source': serializer.toJson<String?>(source),
    };
  }

  TrackRecord copyWith({
    int? id,
    DateTime? createdAt,
    bool? isCompleted,
    Value<String?> source = const Value.absent(),
  }) => TrackRecord(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    isCompleted: isCompleted ?? this.isCompleted,
    source: source.present ? source.value : this.source,
  );
  TrackRecord copyWithCompanion(TrackRecordsCompanion data) {
    return TrackRecord(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackRecord(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, isCompleted, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackRecord &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.isCompleted == this.isCompleted &&
          other.source == this.source);
}

class TrackRecordsCompanion extends UpdateCompanion<TrackRecord> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<bool> isCompleted;
  final Value<String?> source;
  const TrackRecordsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.source = const Value.absent(),
  });
  TrackRecordsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime createdAt,
    required bool isCompleted,
    this.source = const Value.absent(),
  }) : createdAt = Value(createdAt),
       isCompleted = Value(isCompleted);
  static Insertable<TrackRecord> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<bool>? isCompleted,
    Expression<String>? source,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (source != null) 'source': source,
    });
  }

  TrackRecordsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<bool>? isCompleted,
    Value<String?>? source,
  }) {
    return TrackRecordsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      source: source ?? this.source,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackRecordsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }
}

class $TrackRecordPositionPointsTable extends TrackRecordPositionPoints
    with TableInfo<$TrackRecordPositionPointsTable, TrackRecordPositionPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackRecordPositionPointsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _trackRecordIdMeta = const VerificationMeta(
    'trackRecordId',
  );
  @override
  late final GeneratedColumn<int> trackRecordId = GeneratedColumn<int>(
    'track_record_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES track_records (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _altitudeMeta = const VerificationMeta(
    'altitude',
  );
  @override
  late final GeneratedColumn<double> altitude = GeneratedColumn<double>(
    'altitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    trackRecordId,
    createdAt,
    latitude,
    longitude,
    altitude,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'track_record_position_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackRecordPositionPoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('track_record_id')) {
      context.handle(
        _trackRecordIdMeta,
        trackRecordId.isAcceptableOrUnknown(
          data['track_record_id']!,
          _trackRecordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trackRecordIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('altitude')) {
      context.handle(
        _altitudeMeta,
        altitude.isAcceptableOrUnknown(data['altitude']!, _altitudeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackRecordPositionPoint map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackRecordPositionPoint(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      trackRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_record_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      altitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altitude'],
      ),
    );
  }

  @override
  $TrackRecordPositionPointsTable createAlias(String alias) {
    return $TrackRecordPositionPointsTable(attachedDatabase, alias);
  }
}

class TrackRecordPositionPoint extends DataClass
    implements Insertable<TrackRecordPositionPoint> {
  final int id;
  final int trackRecordId;
  final DateTime createdAt;

  /// From the equator. The latitude of this position in degrees normalized to the interval -90.0
  /// to +90.0 (both inclusive).
  final double? latitude;

  /// From the Greenwich meridian. The longitude of the position in degrees normalized to the interval -180
  /// (exclusive) to +180 (inclusive).
  final double? longitude;

  /// The altitude of the device in meters.
  final double? altitude;
  const TrackRecordPositionPoint({
    required this.id,
    required this.trackRecordId,
    required this.createdAt,
    this.latitude,
    this.longitude,
    this.altitude,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['track_record_id'] = Variable<int>(trackRecordId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || altitude != null) {
      map['altitude'] = Variable<double>(altitude);
    }
    return map;
  }

  TrackRecordPositionPointsCompanion toCompanion(bool nullToAbsent) {
    return TrackRecordPositionPointsCompanion(
      id: Value(id),
      trackRecordId: Value(trackRecordId),
      createdAt: Value(createdAt),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      altitude: altitude == null && nullToAbsent
          ? const Value.absent()
          : Value(altitude),
    );
  }

  factory TrackRecordPositionPoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackRecordPositionPoint(
      id: serializer.fromJson<int>(json['id']),
      trackRecordId: serializer.fromJson<int>(json['trackRecordId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      altitude: serializer.fromJson<double?>(json['altitude']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'trackRecordId': serializer.toJson<int>(trackRecordId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'altitude': serializer.toJson<double?>(altitude),
    };
  }

  TrackRecordPositionPoint copyWith({
    int? id,
    int? trackRecordId,
    DateTime? createdAt,
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<double?> altitude = const Value.absent(),
  }) => TrackRecordPositionPoint(
    id: id ?? this.id,
    trackRecordId: trackRecordId ?? this.trackRecordId,
    createdAt: createdAt ?? this.createdAt,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    altitude: altitude.present ? altitude.value : this.altitude,
  );
  TrackRecordPositionPoint copyWithCompanion(
    TrackRecordPositionPointsCompanion data,
  ) {
    return TrackRecordPositionPoint(
      id: data.id.present ? data.id.value : this.id,
      trackRecordId: data.trackRecordId.present
          ? data.trackRecordId.value
          : this.trackRecordId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      altitude: data.altitude.present ? data.altitude.value : this.altitude,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackRecordPositionPoint(')
          ..write('id: $id, ')
          ..write('trackRecordId: $trackRecordId, ')
          ..write('createdAt: $createdAt, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitude: $altitude')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, trackRecordId, createdAt, latitude, longitude, altitude);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackRecordPositionPoint &&
          other.id == this.id &&
          other.trackRecordId == this.trackRecordId &&
          other.createdAt == this.createdAt &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.altitude == this.altitude);
}

class TrackRecordPositionPointsCompanion
    extends UpdateCompanion<TrackRecordPositionPoint> {
  final Value<int> id;
  final Value<int> trackRecordId;
  final Value<DateTime> createdAt;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<double?> altitude;
  const TrackRecordPositionPointsCompanion({
    this.id = const Value.absent(),
    this.trackRecordId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.altitude = const Value.absent(),
  });
  TrackRecordPositionPointsCompanion.insert({
    this.id = const Value.absent(),
    required int trackRecordId,
    required DateTime createdAt,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.altitude = const Value.absent(),
  }) : trackRecordId = Value(trackRecordId),
       createdAt = Value(createdAt);
  static Insertable<TrackRecordPositionPoint> custom({
    Expression<int>? id,
    Expression<int>? trackRecordId,
    Expression<DateTime>? createdAt,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? altitude,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackRecordId != null) 'track_record_id': trackRecordId,
      if (createdAt != null) 'created_at': createdAt,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (altitude != null) 'altitude': altitude,
    });
  }

  TrackRecordPositionPointsCompanion copyWith({
    Value<int>? id,
    Value<int>? trackRecordId,
    Value<DateTime>? createdAt,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<double?>? altitude,
  }) {
    return TrackRecordPositionPointsCompanion(
      id: id ?? this.id,
      trackRecordId: trackRecordId ?? this.trackRecordId,
      createdAt: createdAt ?? this.createdAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (trackRecordId.present) {
      map['track_record_id'] = Variable<int>(trackRecordId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (altitude.present) {
      map['altitude'] = Variable<double>(altitude.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackRecordPositionPointsCompanion(')
          ..write('id: $id, ')
          ..write('trackRecordId: $trackRecordId, ')
          ..write('createdAt: $createdAt, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitude: $altitude')
          ..write(')'))
        .toString();
  }
}

class $TrackRecordPointsTable extends TrackRecordPoints
    with TableInfo<$TrackRecordPointsTable, TrackRecordPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackRecordPointsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _trackRecordIdMeta = const VerificationMeta(
    'trackRecordId',
  );
  @override
  late final GeneratedColumn<int> trackRecordId = GeneratedColumn<int>(
    'track_record_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES track_records (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PointType, String> discriminator =
      GeneratedColumn<String>(
        'discriminator',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PointType>(
        $TrackRecordPointsTable.$converterdiscriminator,
      );
  static const VerificationMeta _paylodMeta = const VerificationMeta('paylod');
  @override
  late final GeneratedColumn<String> paylod = GeneratedColumn<String>(
    'paylod',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    trackRecordId,
    createdAt,
    discriminator,
    paylod,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'track_record_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackRecordPoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('track_record_id')) {
      context.handle(
        _trackRecordIdMeta,
        trackRecordId.isAcceptableOrUnknown(
          data['track_record_id']!,
          _trackRecordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trackRecordIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('paylod')) {
      context.handle(
        _paylodMeta,
        paylod.isAcceptableOrUnknown(data['paylod']!, _paylodMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackRecordPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackRecordPoint(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      trackRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_record_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      discriminator: $TrackRecordPointsTable.$converterdiscriminator.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}discriminator'],
        )!,
      ),
      paylod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paylod'],
      ),
    );
  }

  @override
  $TrackRecordPointsTable createAlias(String alias) {
    return $TrackRecordPointsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PointType, String, String> $converterdiscriminator =
      const EnumNameConverter<PointType>(PointType.values);
}

class TrackRecordPoint extends DataClass
    implements Insertable<TrackRecordPoint> {
  final int id;
  final int trackRecordId;
  final DateTime createdAt;
  final PointType discriminator;
  final String? paylod;
  const TrackRecordPoint({
    required this.id,
    required this.trackRecordId,
    required this.createdAt,
    required this.discriminator,
    this.paylod,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['track_record_id'] = Variable<int>(trackRecordId);
    map['created_at'] = Variable<DateTime>(createdAt);
    {
      map['discriminator'] = Variable<String>(
        $TrackRecordPointsTable.$converterdiscriminator.toSql(discriminator),
      );
    }
    if (!nullToAbsent || paylod != null) {
      map['paylod'] = Variable<String>(paylod);
    }
    return map;
  }

  TrackRecordPointsCompanion toCompanion(bool nullToAbsent) {
    return TrackRecordPointsCompanion(
      id: Value(id),
      trackRecordId: Value(trackRecordId),
      createdAt: Value(createdAt),
      discriminator: Value(discriminator),
      paylod: paylod == null && nullToAbsent
          ? const Value.absent()
          : Value(paylod),
    );
  }

  factory TrackRecordPoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackRecordPoint(
      id: serializer.fromJson<int>(json['id']),
      trackRecordId: serializer.fromJson<int>(json['trackRecordId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      discriminator: $TrackRecordPointsTable.$converterdiscriminator.fromJson(
        serializer.fromJson<String>(json['discriminator']),
      ),
      paylod: serializer.fromJson<String?>(json['paylod']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'trackRecordId': serializer.toJson<int>(trackRecordId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'discriminator': serializer.toJson<String>(
        $TrackRecordPointsTable.$converterdiscriminator.toJson(discriminator),
      ),
      'paylod': serializer.toJson<String?>(paylod),
    };
  }

  TrackRecordPoint copyWith({
    int? id,
    int? trackRecordId,
    DateTime? createdAt,
    PointType? discriminator,
    Value<String?> paylod = const Value.absent(),
  }) => TrackRecordPoint(
    id: id ?? this.id,
    trackRecordId: trackRecordId ?? this.trackRecordId,
    createdAt: createdAt ?? this.createdAt,
    discriminator: discriminator ?? this.discriminator,
    paylod: paylod.present ? paylod.value : this.paylod,
  );
  TrackRecordPoint copyWithCompanion(TrackRecordPointsCompanion data) {
    return TrackRecordPoint(
      id: data.id.present ? data.id.value : this.id,
      trackRecordId: data.trackRecordId.present
          ? data.trackRecordId.value
          : this.trackRecordId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      discriminator: data.discriminator.present
          ? data.discriminator.value
          : this.discriminator,
      paylod: data.paylod.present ? data.paylod.value : this.paylod,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackRecordPoint(')
          ..write('id: $id, ')
          ..write('trackRecordId: $trackRecordId, ')
          ..write('createdAt: $createdAt, ')
          ..write('discriminator: $discriminator, ')
          ..write('paylod: $paylod')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, trackRecordId, createdAt, discriminator, paylod);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackRecordPoint &&
          other.id == this.id &&
          other.trackRecordId == this.trackRecordId &&
          other.createdAt == this.createdAt &&
          other.discriminator == this.discriminator &&
          other.paylod == this.paylod);
}

class TrackRecordPointsCompanion extends UpdateCompanion<TrackRecordPoint> {
  final Value<int> id;
  final Value<int> trackRecordId;
  final Value<DateTime> createdAt;
  final Value<PointType> discriminator;
  final Value<String?> paylod;
  const TrackRecordPointsCompanion({
    this.id = const Value.absent(),
    this.trackRecordId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.discriminator = const Value.absent(),
    this.paylod = const Value.absent(),
  });
  TrackRecordPointsCompanion.insert({
    this.id = const Value.absent(),
    required int trackRecordId,
    required DateTime createdAt,
    required PointType discriminator,
    this.paylod = const Value.absent(),
  }) : trackRecordId = Value(trackRecordId),
       createdAt = Value(createdAt),
       discriminator = Value(discriminator);
  static Insertable<TrackRecordPoint> custom({
    Expression<int>? id,
    Expression<int>? trackRecordId,
    Expression<DateTime>? createdAt,
    Expression<String>? discriminator,
    Expression<String>? paylod,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackRecordId != null) 'track_record_id': trackRecordId,
      if (createdAt != null) 'created_at': createdAt,
      if (discriminator != null) 'discriminator': discriminator,
      if (paylod != null) 'paylod': paylod,
    });
  }

  TrackRecordPointsCompanion copyWith({
    Value<int>? id,
    Value<int>? trackRecordId,
    Value<DateTime>? createdAt,
    Value<PointType>? discriminator,
    Value<String?>? paylod,
  }) {
    return TrackRecordPointsCompanion(
      id: id ?? this.id,
      trackRecordId: trackRecordId ?? this.trackRecordId,
      createdAt: createdAt ?? this.createdAt,
      discriminator: discriminator ?? this.discriminator,
      paylod: paylod ?? this.paylod,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (trackRecordId.present) {
      map['track_record_id'] = Variable<int>(trackRecordId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (discriminator.present) {
      map['discriminator'] = Variable<String>(
        $TrackRecordPointsTable.$converterdiscriminator.toSql(
          discriminator.value,
        ),
      );
    }
    if (paylod.present) {
      map['paylod'] = Variable<String>(paylod.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackRecordPointsCompanion(')
          ..write('id: $id, ')
          ..write('trackRecordId: $trackRecordId, ')
          ..write('createdAt: $createdAt, ')
          ..write('discriminator: $discriminator, ')
          ..write('paylod: $paylod')
          ..write(')'))
        .toString();
  }
}

class $TrackRecordSummariesTable extends TrackRecordSummaries
    with TableInfo<$TrackRecordSummariesTable, TrackRecordSummary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackRecordSummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _trackRecordIdMeta = const VerificationMeta(
    'trackRecordId',
  );
  @override
  late final GeneratedColumn<int> trackRecordId = GeneratedColumn<int>(
    'track_record_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES track_records (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startMeta = const VerificationMeta('start');
  @override
  late final GeneratedColumn<DateTime> start = GeneratedColumn<DateTime>(
    'start',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endMeta = const VerificationMeta('end');
  @override
  late final GeneratedColumn<DateTime> end = GeneratedColumn<DateTime>(
    'end',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Duration?, int> activeDuration =
      GeneratedColumn<int>(
        'active_duration',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<Duration?>(
        $TrackRecordSummariesTable.$converteractiveDurationn,
      );
  @override
  late final GeneratedColumnWithTypeConverter<Distance?, double>
  activeDistance =
      GeneratedColumn<double>(
        'active_distance',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      ).withConverter<Distance?>(
        $TrackRecordSummariesTable.$converteractiveDistancen,
      );
  @override
  late final GeneratedColumnWithTypeConverter<Duration?, int>
  activePositioningDuration =
      GeneratedColumn<int>(
        'active_positioning_duration',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<Duration?>(
        $TrackRecordSummariesTable.$converteractivePositioningDurationn,
      );
  static const VerificationMeta _averagePulseMeta = const VerificationMeta(
    'averagePulse',
  );
  @override
  late final GeneratedColumn<double> averagePulse = GeneratedColumn<double>(
    'average_pulse',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    trackRecordId,
    start,
    end,
    activeDuration,
    activeDistance,
    activePositioningDuration,
    averagePulse,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'track_record_summaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackRecordSummary> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('track_record_id')) {
      context.handle(
        _trackRecordIdMeta,
        trackRecordId.isAcceptableOrUnknown(
          data['track_record_id']!,
          _trackRecordIdMeta,
        ),
      );
    }
    if (data.containsKey('start')) {
      context.handle(
        _startMeta,
        start.isAcceptableOrUnknown(data['start']!, _startMeta),
      );
    }
    if (data.containsKey('end')) {
      context.handle(
        _endMeta,
        end.isAcceptableOrUnknown(data['end']!, _endMeta),
      );
    }
    if (data.containsKey('average_pulse')) {
      context.handle(
        _averagePulseMeta,
        averagePulse.isAcceptableOrUnknown(
          data['average_pulse']!,
          _averagePulseMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {trackRecordId};
  @override
  TrackRecordSummary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackRecordSummary(
      trackRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_record_id'],
      )!,
      start: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start'],
      ),
      end: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end'],
      ),
      activeDuration: $TrackRecordSummariesTable.$converteractiveDurationn
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.int,
              data['${effectivePrefix}active_duration'],
            ),
          ),
      activeDistance: $TrackRecordSummariesTable.$converteractiveDistancen
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.double,
              data['${effectivePrefix}active_distance'],
            ),
          ),
      activePositioningDuration: $TrackRecordSummariesTable
          .$converteractivePositioningDurationn
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.int,
              data['${effectivePrefix}active_positioning_duration'],
            ),
          ),
      averagePulseBPM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}average_pulse'],
      ),
    );
  }

  @override
  $TrackRecordSummariesTable createAlias(String alias) {
    return $TrackRecordSummariesTable(attachedDatabase, alias);
  }

  static TypeConverter<Duration, int> $converteractiveDuration =
      const DurationConverter();
  static TypeConverter<Duration?, int?> $converteractiveDurationn =
      NullAwareTypeConverter.wrap($converteractiveDuration);
  static TypeConverter<Distance, double> $converteractiveDistance =
      const DistanceConverter();
  static TypeConverter<Distance?, double?> $converteractiveDistancen =
      NullAwareTypeConverter.wrap($converteractiveDistance);
  static TypeConverter<Duration, int> $converteractivePositioningDuration =
      const DurationConverter();
  static TypeConverter<Duration?, int?> $converteractivePositioningDurationn =
      NullAwareTypeConverter.wrap($converteractivePositioningDuration);
}

class TrackRecordSummary extends DataClass
    implements Insertable<TrackRecordSummary> {
  final int trackRecordId;
  final DateTime? start;
  final DateTime? end;
  final Duration? activeDuration;
  final Distance? activeDistance;
  final Duration? activePositioningDuration;
  final double? averagePulseBPM;
  const TrackRecordSummary({
    required this.trackRecordId,
    this.start,
    this.end,
    this.activeDuration,
    this.activeDistance,
    this.activePositioningDuration,
    this.averagePulseBPM,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['track_record_id'] = Variable<int>(trackRecordId);
    if (!nullToAbsent || start != null) {
      map['start'] = Variable<DateTime>(start);
    }
    if (!nullToAbsent || end != null) {
      map['end'] = Variable<DateTime>(end);
    }
    if (!nullToAbsent || activeDuration != null) {
      map['active_duration'] = Variable<int>(
        $TrackRecordSummariesTable.$converteractiveDurationn.toSql(
          activeDuration,
        ),
      );
    }
    if (!nullToAbsent || activeDistance != null) {
      map['active_distance'] = Variable<double>(
        $TrackRecordSummariesTable.$converteractiveDistancen.toSql(
          activeDistance,
        ),
      );
    }
    if (!nullToAbsent || activePositioningDuration != null) {
      map['active_positioning_duration'] = Variable<int>(
        $TrackRecordSummariesTable.$converteractivePositioningDurationn.toSql(
          activePositioningDuration,
        ),
      );
    }
    if (!nullToAbsent || averagePulseBPM != null) {
      map['average_pulse'] = Variable<double>(averagePulseBPM);
    }
    return map;
  }

  TrackRecordSummariesCompanion toCompanion(bool nullToAbsent) {
    return TrackRecordSummariesCompanion(
      trackRecordId: Value(trackRecordId),
      start: start == null && nullToAbsent
          ? const Value.absent()
          : Value(start),
      end: end == null && nullToAbsent ? const Value.absent() : Value(end),
      activeDuration: activeDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(activeDuration),
      activeDistance: activeDistance == null && nullToAbsent
          ? const Value.absent()
          : Value(activeDistance),
      activePositioningDuration:
          activePositioningDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(activePositioningDuration),
      averagePulse: averagePulseBPM == null && nullToAbsent
          ? const Value.absent()
          : Value(averagePulseBPM),
    );
  }

  factory TrackRecordSummary.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackRecordSummary(
      trackRecordId: serializer.fromJson<int>(json['trackRecordId']),
      start: serializer.fromJson<DateTime?>(json['start']),
      end: serializer.fromJson<DateTime?>(json['end']),
      activeDuration: serializer.fromJson<Duration?>(json['activeDuration']),
      activeDistance: serializer.fromJson<Distance?>(json['activeDistance']),
      activePositioningDuration: serializer.fromJson<Duration?>(
        json['activePositioningDuration'],
      ),
      averagePulseBPM: serializer.fromJson<double?>(json['averagePulse']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'trackRecordId': serializer.toJson<int>(trackRecordId),
      'start': serializer.toJson<DateTime?>(start),
      'end': serializer.toJson<DateTime?>(end),
      'activeDuration': serializer.toJson<Duration?>(activeDuration),
      'activeDistance': serializer.toJson<Distance?>(activeDistance),
      'activePositioningDuration': serializer.toJson<Duration?>(
        activePositioningDuration,
      ),
      'averagePulse': serializer.toJson<double?>(averagePulseBPM),
    };
  }

  TrackRecordSummary copyWith({
    int? trackRecordId,
    Value<DateTime?> start = const Value.absent(),
    Value<DateTime?> end = const Value.absent(),
    Value<Duration?> activeDuration = const Value.absent(),
    Value<Distance?> activeDistance = const Value.absent(),
    Value<Duration?> activePositioningDuration = const Value.absent(),
    Value<double?> averagePulse = const Value.absent(),
  }) => TrackRecordSummary(
    trackRecordId: trackRecordId ?? this.trackRecordId,
    start: start.present ? start.value : this.start,
    end: end.present ? end.value : this.end,
    activeDuration: activeDuration.present
        ? activeDuration.value
        : this.activeDuration,
    activeDistance: activeDistance.present
        ? activeDistance.value
        : this.activeDistance,
    activePositioningDuration: activePositioningDuration.present
        ? activePositioningDuration.value
        : this.activePositioningDuration,
    averagePulseBPM: averagePulse.present ? averagePulse.value : this.averagePulseBPM,
  );
  TrackRecordSummary copyWithCompanion(TrackRecordSummariesCompanion data) {
    return TrackRecordSummary(
      trackRecordId: data.trackRecordId.present
          ? data.trackRecordId.value
          : this.trackRecordId,
      start: data.start.present ? data.start.value : this.start,
      end: data.end.present ? data.end.value : this.end,
      activeDuration: data.activeDuration.present
          ? data.activeDuration.value
          : this.activeDuration,
      activeDistance: data.activeDistance.present
          ? data.activeDistance.value
          : this.activeDistance,
      activePositioningDuration: data.activePositioningDuration.present
          ? data.activePositioningDuration.value
          : this.activePositioningDuration,
      averagePulseBPM: data.averagePulse.present
          ? data.averagePulse.value
          : this.averagePulseBPM,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackRecordSummary(')
          ..write('trackRecordId: $trackRecordId, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('activeDuration: $activeDuration, ')
          ..write('activeDistance: $activeDistance, ')
          ..write('activePositioningDuration: $activePositioningDuration, ')
          ..write('averagePulse: $averagePulseBPM')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    trackRecordId,
    start,
    end,
    activeDuration,
    activeDistance,
    activePositioningDuration,
    averagePulseBPM,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackRecordSummary &&
          other.trackRecordId == this.trackRecordId &&
          other.start == this.start &&
          other.end == this.end &&
          other.activeDuration == this.activeDuration &&
          other.activeDistance == this.activeDistance &&
          other.activePositioningDuration == this.activePositioningDuration &&
          other.averagePulseBPM == this.averagePulseBPM);
}

class TrackRecordSummariesCompanion
    extends UpdateCompanion<TrackRecordSummary> {
  final Value<int> trackRecordId;
  final Value<DateTime?> start;
  final Value<DateTime?> end;
  final Value<Duration?> activeDuration;
  final Value<Distance?> activeDistance;
  final Value<Duration?> activePositioningDuration;
  final Value<double?> averagePulse;
  const TrackRecordSummariesCompanion({
    this.trackRecordId = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.activeDuration = const Value.absent(),
    this.activeDistance = const Value.absent(),
    this.activePositioningDuration = const Value.absent(),
    this.averagePulse = const Value.absent(),
  });
  TrackRecordSummariesCompanion.insert({
    this.trackRecordId = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.activeDuration = const Value.absent(),
    this.activeDistance = const Value.absent(),
    this.activePositioningDuration = const Value.absent(),
    this.averagePulse = const Value.absent(),
  });
  static Insertable<TrackRecordSummary> custom({
    Expression<int>? trackRecordId,
    Expression<DateTime>? start,
    Expression<DateTime>? end,
    Expression<int>? activeDuration,
    Expression<double>? activeDistance,
    Expression<int>? activePositioningDuration,
    Expression<double>? averagePulse,
  }) {
    return RawValuesInsertable({
      if (trackRecordId != null) 'track_record_id': trackRecordId,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (activeDuration != null) 'active_duration': activeDuration,
      if (activeDistance != null) 'active_distance': activeDistance,
      if (activePositioningDuration != null)
        'active_positioning_duration': activePositioningDuration,
      if (averagePulse != null) 'average_pulse': averagePulse,
    });
  }

  TrackRecordSummariesCompanion copyWith({
    Value<int>? trackRecordId,
    Value<DateTime?>? start,
    Value<DateTime?>? end,
    Value<Duration?>? activeDuration,
    Value<Distance?>? activeDistance,
    Value<Duration?>? activePositioningDuration,
    Value<double?>? averagePulse,
  }) {
    return TrackRecordSummariesCompanion(
      trackRecordId: trackRecordId ?? this.trackRecordId,
      start: start ?? this.start,
      end: end ?? this.end,
      activeDuration: activeDuration ?? this.activeDuration,
      activeDistance: activeDistance ?? this.activeDistance,
      activePositioningDuration:
          activePositioningDuration ?? this.activePositioningDuration,
      averagePulse: averagePulse ?? this.averagePulse,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (trackRecordId.present) {
      map['track_record_id'] = Variable<int>(trackRecordId.value);
    }
    if (start.present) {
      map['start'] = Variable<DateTime>(start.value);
    }
    if (end.present) {
      map['end'] = Variable<DateTime>(end.value);
    }
    if (activeDuration.present) {
      map['active_duration'] = Variable<int>(
        $TrackRecordSummariesTable.$converteractiveDurationn.toSql(
          activeDuration.value,
        ),
      );
    }
    if (activeDistance.present) {
      map['active_distance'] = Variable<double>(
        $TrackRecordSummariesTable.$converteractiveDistancen.toSql(
          activeDistance.value,
        ),
      );
    }
    if (activePositioningDuration.present) {
      map['active_positioning_duration'] = Variable<int>(
        $TrackRecordSummariesTable.$converteractivePositioningDurationn.toSql(
          activePositioningDuration.value,
        ),
      );
    }
    if (averagePulse.present) {
      map['average_pulse'] = Variable<double>(averagePulse.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackRecordSummariesCompanion(')
          ..write('trackRecordId: $trackRecordId, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('activeDuration: $activeDuration, ')
          ..write('activeDistance: $activeDistance, ')
          ..write('activePositioningDuration: $activePositioningDuration, ')
          ..write('averagePulse: $averagePulse')
          ..write(')'))
        .toString();
  }
}

class $PulseMeasurementsTable extends PulseMeasurements
    with TableInfo<$PulseMeasurementsTable, PulseMeasurement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PulseMeasurementsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _trackRecordIdMeta = const VerificationMeta(
    'trackRecordId',
  );
  @override
  late final GeneratedColumn<int> trackRecordId = GeneratedColumn<int>(
    'track_record_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES track_records (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _measuredAtMeta = const VerificationMeta(
    'measuredAt',
  );
  @override
  late final GeneratedColumn<DateTime> measuredAt = GeneratedColumn<DateTime>(
    'measured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pulseBPMMeta = const VerificationMeta(
    'pulseBPM',
  );
  @override
  late final GeneratedColumn<double> pulseBPM = GeneratedColumn<double>(
    'pulse_b_p_m',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PulseMeasureKind, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PulseMeasureKind>(
        $PulseMeasurementsTable.$convertersource,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    trackRecordId,
    measuredAt,
    pulseBPM,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pulse_measurements';
  @override
  VerificationContext validateIntegrity(
    Insertable<PulseMeasurement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('track_record_id')) {
      context.handle(
        _trackRecordIdMeta,
        trackRecordId.isAcceptableOrUnknown(
          data['track_record_id']!,
          _trackRecordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trackRecordIdMeta);
    }
    if (data.containsKey('measured_at')) {
      context.handle(
        _measuredAtMeta,
        measuredAt.isAcceptableOrUnknown(data['measured_at']!, _measuredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_measuredAtMeta);
    }
    if (data.containsKey('pulse_b_p_m')) {
      context.handle(
        _pulseBPMMeta,
        pulseBPM.isAcceptableOrUnknown(data['pulse_b_p_m']!, _pulseBPMMeta),
      );
    } else if (isInserting) {
      context.missing(_pulseBPMMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PulseMeasurement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PulseMeasurement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      trackRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_record_id'],
      )!,
      measuredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}measured_at'],
      )!,
      pulseBPM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pulse_b_p_m'],
      )!,
      source: $PulseMeasurementsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
    );
  }

  @override
  $PulseMeasurementsTable createAlias(String alias) {
    return $PulseMeasurementsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PulseMeasureKind, String, String> $convertersource =
      const EnumNameConverter<PulseMeasureKind>(PulseMeasureKind.values);
}

class PulseMeasurement extends DataClass
    implements Insertable<PulseMeasurement> {
  final int id;
  final int trackRecordId;
  final DateTime measuredAt;
  final double pulseBPM;
  final PulseMeasureKind source;
  const PulseMeasurement({
    required this.id,
    required this.trackRecordId,
    required this.measuredAt,
    required this.pulseBPM,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['track_record_id'] = Variable<int>(trackRecordId);
    map['measured_at'] = Variable<DateTime>(measuredAt);
    map['pulse_b_p_m'] = Variable<double>(pulseBPM);
    {
      map['source'] = Variable<String>(
        $PulseMeasurementsTable.$convertersource.toSql(source),
      );
    }
    return map;
  }

  PulseMeasurementsCompanion toCompanion(bool nullToAbsent) {
    return PulseMeasurementsCompanion(
      id: Value(id),
      trackRecordId: Value(trackRecordId),
      measuredAt: Value(measuredAt),
      pulseBPM: Value(pulseBPM),
      source: Value(source),
    );
  }

  factory PulseMeasurement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PulseMeasurement(
      id: serializer.fromJson<int>(json['id']),
      trackRecordId: serializer.fromJson<int>(json['trackRecordId']),
      measuredAt: serializer.fromJson<DateTime>(json['measuredAt']),
      pulseBPM: serializer.fromJson<double>(json['pulseBPM']),
      source: $PulseMeasurementsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'trackRecordId': serializer.toJson<int>(trackRecordId),
      'measuredAt': serializer.toJson<DateTime>(measuredAt),
      'pulseBPM': serializer.toJson<double>(pulseBPM),
      'source': serializer.toJson<String>(
        $PulseMeasurementsTable.$convertersource.toJson(source),
      ),
    };
  }

  PulseMeasurement copyWith({
    int? id,
    int? trackRecordId,
    DateTime? measuredAt,
    double? pulseBPM,
    PulseMeasureKind? source,
  }) => PulseMeasurement(
    id: id ?? this.id,
    trackRecordId: trackRecordId ?? this.trackRecordId,
    measuredAt: measuredAt ?? this.measuredAt,
    pulseBPM: pulseBPM ?? this.pulseBPM,
    source: source ?? this.source,
  );
  PulseMeasurement copyWithCompanion(PulseMeasurementsCompanion data) {
    return PulseMeasurement(
      id: data.id.present ? data.id.value : this.id,
      trackRecordId: data.trackRecordId.present
          ? data.trackRecordId.value
          : this.trackRecordId,
      measuredAt: data.measuredAt.present
          ? data.measuredAt.value
          : this.measuredAt,
      pulseBPM: data.pulseBPM.present ? data.pulseBPM.value : this.pulseBPM,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PulseMeasurement(')
          ..write('id: $id, ')
          ..write('trackRecordId: $trackRecordId, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('pulseBPM: $pulseBPM, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, trackRecordId, measuredAt, pulseBPM, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PulseMeasurement &&
          other.id == this.id &&
          other.trackRecordId == this.trackRecordId &&
          other.measuredAt == this.measuredAt &&
          other.pulseBPM == this.pulseBPM &&
          other.source == this.source);
}

class PulseMeasurementsCompanion extends UpdateCompanion<PulseMeasurement> {
  final Value<int> id;
  final Value<int> trackRecordId;
  final Value<DateTime> measuredAt;
  final Value<double> pulseBPM;
  final Value<PulseMeasureKind> source;
  const PulseMeasurementsCompanion({
    this.id = const Value.absent(),
    this.trackRecordId = const Value.absent(),
    this.measuredAt = const Value.absent(),
    this.pulseBPM = const Value.absent(),
    this.source = const Value.absent(),
  });
  PulseMeasurementsCompanion.insert({
    this.id = const Value.absent(),
    required int trackRecordId,
    required DateTime measuredAt,
    required double pulseBPM,
    required PulseMeasureKind source,
  }) : trackRecordId = Value(trackRecordId),
       measuredAt = Value(measuredAt),
       pulseBPM = Value(pulseBPM),
       source = Value(source);
  static Insertable<PulseMeasurement> custom({
    Expression<int>? id,
    Expression<int>? trackRecordId,
    Expression<DateTime>? measuredAt,
    Expression<double>? pulseBPM,
    Expression<String>? source,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackRecordId != null) 'track_record_id': trackRecordId,
      if (measuredAt != null) 'measured_at': measuredAt,
      if (pulseBPM != null) 'pulse_b_p_m': pulseBPM,
      if (source != null) 'source': source,
    });
  }

  PulseMeasurementsCompanion copyWith({
    Value<int>? id,
    Value<int>? trackRecordId,
    Value<DateTime>? measuredAt,
    Value<double>? pulseBPM,
    Value<PulseMeasureKind>? source,
  }) {
    return PulseMeasurementsCompanion(
      id: id ?? this.id,
      trackRecordId: trackRecordId ?? this.trackRecordId,
      measuredAt: measuredAt ?? this.measuredAt,
      pulseBPM: pulseBPM ?? this.pulseBPM,
      source: source ?? this.source,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (trackRecordId.present) {
      map['track_record_id'] = Variable<int>(trackRecordId.value);
    }
    if (measuredAt.present) {
      map['measured_at'] = Variable<DateTime>(measuredAt.value);
    }
    if (pulseBPM.present) {
      map['pulse_b_p_m'] = Variable<double>(pulseBPM.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $PulseMeasurementsTable.$convertersource.toSql(source.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PulseMeasurementsCompanion(')
          ..write('id: $id, ')
          ..write('trackRecordId: $trackRecordId, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('pulseBPM: $pulseBPM, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $TrackRecordsTable trackRecords = $TrackRecordsTable(this);
  late final $TrackRecordPositionPointsTable trackRecordPositionPoints =
      $TrackRecordPositionPointsTable(this);
  late final $TrackRecordPointsTable trackRecordPoints =
      $TrackRecordPointsTable(this);
  late final $TrackRecordSummariesTable trackRecordSummaries =
      $TrackRecordSummariesTable(this);
  late final $PulseMeasurementsTable pulseMeasurements =
      $PulseMeasurementsTable(this);
  late final Index trackRecordCreatedAtIndex = Index(
    'TrackRecord_CreatedAt_Index',
    'CREATE INDEX TrackRecord_CreatedAt_Index ON track_records (created_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    settings,
    trackRecords,
    trackRecordPositionPoints,
    trackRecordPoints,
    trackRecordSummaries,
    pulseMeasurements,
    trackRecordCreatedAtIndex,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'track_records',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('track_record_position_points', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'track_records',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('track_record_points', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'track_records',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('track_record_summaries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'track_records',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('pulse_measurements', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String name,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> name,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> name = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(name: name, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String name,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                name: name,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$TrackRecordsTableCreateCompanionBuilder =
    TrackRecordsCompanion Function({
      Value<int> id,
      required DateTime createdAt,
      required bool isCompleted,
      Value<String?> source,
    });
typedef $$TrackRecordsTableUpdateCompanionBuilder =
    TrackRecordsCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<bool> isCompleted,
      Value<String?> source,
    });

final class $$TrackRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $TrackRecordsTable, TrackRecord> {
  $$TrackRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $TrackRecordPositionPointsTable,
    List<TrackRecordPositionPoint>
  >
  _trackRecordPositionPointsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.trackRecordPositionPoints,
        aliasName: $_aliasNameGenerator(
          db.trackRecords.id,
          db.trackRecordPositionPoints.trackRecordId,
        ),
      );

  $$TrackRecordPositionPointsTableProcessedTableManager
  get trackRecordPositionPointsRefs {
    final manager = $$TrackRecordPositionPointsTableTableManager(
      $_db,
      $_db.trackRecordPositionPoints,
    ).filter((f) => f.trackRecordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _trackRecordPositionPointsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TrackRecordPointsTable, List<TrackRecordPoint>>
  _trackRecordPointsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.trackRecordPoints,
        aliasName: $_aliasNameGenerator(
          db.trackRecords.id,
          db.trackRecordPoints.trackRecordId,
        ),
      );

  $$TrackRecordPointsTableProcessedTableManager get trackRecordPointsRefs {
    final manager = $$TrackRecordPointsTableTableManager(
      $_db,
      $_db.trackRecordPoints,
    ).filter((f) => f.trackRecordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _trackRecordPointsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TrackRecordSummariesTable,
    List<TrackRecordSummary>
  >
  _trackRecordSummariesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.trackRecordSummaries,
        aliasName: $_aliasNameGenerator(
          db.trackRecords.id,
          db.trackRecordSummaries.trackRecordId,
        ),
      );

  $$TrackRecordSummariesTableProcessedTableManager
  get trackRecordSummariesRefs {
    final manager = $$TrackRecordSummariesTableTableManager(
      $_db,
      $_db.trackRecordSummaries,
    ).filter((f) => f.trackRecordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _trackRecordSummariesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PulseMeasurementsTable, List<PulseMeasurement>>
  _pulseMeasurementsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.pulseMeasurements,
        aliasName: $_aliasNameGenerator(
          db.trackRecords.id,
          db.pulseMeasurements.trackRecordId,
        ),
      );

  $$PulseMeasurementsTableProcessedTableManager get pulseMeasurementsRefs {
    final manager = $$PulseMeasurementsTableTableManager(
      $_db,
      $_db.pulseMeasurements,
    ).filter((f) => f.trackRecordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _pulseMeasurementsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TrackRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $TrackRecordsTable> {
  $$TrackRecordsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> trackRecordPositionPointsRefs(
    Expression<bool> Function($$TrackRecordPositionPointsTableFilterComposer f)
    f,
  ) {
    final $$TrackRecordPositionPointsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.trackRecordPositionPoints,
          getReferencedColumn: (t) => t.trackRecordId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TrackRecordPositionPointsTableFilterComposer(
                $db: $db,
                $table: $db.trackRecordPositionPoints,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> trackRecordPointsRefs(
    Expression<bool> Function($$TrackRecordPointsTableFilterComposer f) f,
  ) {
    final $$TrackRecordPointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackRecordPoints,
      getReferencedColumn: (t) => t.trackRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackRecordPointsTableFilterComposer(
            $db: $db,
            $table: $db.trackRecordPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> trackRecordSummariesRefs(
    Expression<bool> Function($$TrackRecordSummariesTableFilterComposer f) f,
  ) {
    final $$TrackRecordSummariesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackRecordSummaries,
      getReferencedColumn: (t) => t.trackRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackRecordSummariesTableFilterComposer(
            $db: $db,
            $table: $db.trackRecordSummaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pulseMeasurementsRefs(
    Expression<bool> Function($$PulseMeasurementsTableFilterComposer f) f,
  ) {
    final $$PulseMeasurementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pulseMeasurements,
      getReferencedColumn: (t) => t.trackRecordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PulseMeasurementsTableFilterComposer(
            $db: $db,
            $table: $db.pulseMeasurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TrackRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackRecordsTable> {
  $$TrackRecordsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrackRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackRecordsTable> {
  $$TrackRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  Expression<T> trackRecordPositionPointsRefs<T extends Object>(
    Expression<T> Function($$TrackRecordPositionPointsTableAnnotationComposer a)
    f,
  ) {
    final $$TrackRecordPositionPointsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.trackRecordPositionPoints,
          getReferencedColumn: (t) => t.trackRecordId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TrackRecordPositionPointsTableAnnotationComposer(
                $db: $db,
                $table: $db.trackRecordPositionPoints,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> trackRecordPointsRefs<T extends Object>(
    Expression<T> Function($$TrackRecordPointsTableAnnotationComposer a) f,
  ) {
    final $$TrackRecordPointsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.trackRecordPoints,
          getReferencedColumn: (t) => t.trackRecordId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TrackRecordPointsTableAnnotationComposer(
                $db: $db,
                $table: $db.trackRecordPoints,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> trackRecordSummariesRefs<T extends Object>(
    Expression<T> Function($$TrackRecordSummariesTableAnnotationComposer a) f,
  ) {
    final $$TrackRecordSummariesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.trackRecordSummaries,
          getReferencedColumn: (t) => t.trackRecordId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TrackRecordSummariesTableAnnotationComposer(
                $db: $db,
                $table: $db.trackRecordSummaries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> pulseMeasurementsRefs<T extends Object>(
    Expression<T> Function($$PulseMeasurementsTableAnnotationComposer a) f,
  ) {
    final $$PulseMeasurementsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.pulseMeasurements,
          getReferencedColumn: (t) => t.trackRecordId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PulseMeasurementsTableAnnotationComposer(
                $db: $db,
                $table: $db.pulseMeasurements,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TrackRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackRecordsTable,
          TrackRecord,
          $$TrackRecordsTableFilterComposer,
          $$TrackRecordsTableOrderingComposer,
          $$TrackRecordsTableAnnotationComposer,
          $$TrackRecordsTableCreateCompanionBuilder,
          $$TrackRecordsTableUpdateCompanionBuilder,
          (TrackRecord, $$TrackRecordsTableReferences),
          TrackRecord,
          PrefetchHooks Function({
            bool trackRecordPositionPointsRefs,
            bool trackRecordPointsRefs,
            bool trackRecordSummariesRefs,
            bool pulseMeasurementsRefs,
          })
        > {
  $$TrackRecordsTableTableManager(_$AppDatabase db, $TrackRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String?> source = const Value.absent(),
              }) => TrackRecordsCompanion(
                id: id,
                createdAt: createdAt,
                isCompleted: isCompleted,
                source: source,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime createdAt,
                required bool isCompleted,
                Value<String?> source = const Value.absent(),
              }) => TrackRecordsCompanion.insert(
                id: id,
                createdAt: createdAt,
                isCompleted: isCompleted,
                source: source,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TrackRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                trackRecordPositionPointsRefs = false,
                trackRecordPointsRefs = false,
                trackRecordSummariesRefs = false,
                pulseMeasurementsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (trackRecordPositionPointsRefs)
                      db.trackRecordPositionPoints,
                    if (trackRecordPointsRefs) db.trackRecordPoints,
                    if (trackRecordSummariesRefs) db.trackRecordSummaries,
                    if (pulseMeasurementsRefs) db.pulseMeasurements,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (trackRecordPositionPointsRefs)
                        await $_getPrefetchedData<
                          TrackRecord,
                          $TrackRecordsTable,
                          TrackRecordPositionPoint
                        >(
                          currentTable: table,
                          referencedTable: $$TrackRecordsTableReferences
                              ._trackRecordPositionPointsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TrackRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).trackRecordPositionPointsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.trackRecordId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (trackRecordPointsRefs)
                        await $_getPrefetchedData<
                          TrackRecord,
                          $TrackRecordsTable,
                          TrackRecordPoint
                        >(
                          currentTable: table,
                          referencedTable: $$TrackRecordsTableReferences
                              ._trackRecordPointsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TrackRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).trackRecordPointsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.trackRecordId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (trackRecordSummariesRefs)
                        await $_getPrefetchedData<
                          TrackRecord,
                          $TrackRecordsTable,
                          TrackRecordSummary
                        >(
                          currentTable: table,
                          referencedTable: $$TrackRecordsTableReferences
                              ._trackRecordSummariesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TrackRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).trackRecordSummariesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.trackRecordId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pulseMeasurementsRefs)
                        await $_getPrefetchedData<
                          TrackRecord,
                          $TrackRecordsTable,
                          PulseMeasurement
                        >(
                          currentTable: table,
                          referencedTable: $$TrackRecordsTableReferences
                              ._pulseMeasurementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TrackRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).pulseMeasurementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.trackRecordId == item.id,
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

typedef $$TrackRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackRecordsTable,
      TrackRecord,
      $$TrackRecordsTableFilterComposer,
      $$TrackRecordsTableOrderingComposer,
      $$TrackRecordsTableAnnotationComposer,
      $$TrackRecordsTableCreateCompanionBuilder,
      $$TrackRecordsTableUpdateCompanionBuilder,
      (TrackRecord, $$TrackRecordsTableReferences),
      TrackRecord,
      PrefetchHooks Function({
        bool trackRecordPositionPointsRefs,
        bool trackRecordPointsRefs,
        bool trackRecordSummariesRefs,
        bool pulseMeasurementsRefs,
      })
    >;
typedef $$TrackRecordPositionPointsTableCreateCompanionBuilder =
    TrackRecordPositionPointsCompanion Function({
      Value<int> id,
      required int trackRecordId,
      required DateTime createdAt,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<double?> altitude,
    });
typedef $$TrackRecordPositionPointsTableUpdateCompanionBuilder =
    TrackRecordPositionPointsCompanion Function({
      Value<int> id,
      Value<int> trackRecordId,
      Value<DateTime> createdAt,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<double?> altitude,
    });

final class $$TrackRecordPositionPointsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TrackRecordPositionPointsTable,
          TrackRecordPositionPoint
        > {
  $$TrackRecordPositionPointsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TrackRecordsTable _trackRecordIdTable(_$AppDatabase db) =>
      db.trackRecords.createAlias(
        $_aliasNameGenerator(
          db.trackRecordPositionPoints.trackRecordId,
          db.trackRecords.id,
        ),
      );

  $$TrackRecordsTableProcessedTableManager get trackRecordId {
    final $_column = $_itemColumn<int>('track_record_id')!;

    final manager = $$TrackRecordsTableTableManager(
      $_db,
      $_db.trackRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrackRecordPositionPointsTableFilterComposer
    extends Composer<_$AppDatabase, $TrackRecordPositionPointsTable> {
  $$TrackRecordPositionPointsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get altitude => $composableBuilder(
    column: $table.altitude,
    builder: (column) => ColumnFilters(column),
  );

  $$TrackRecordsTableFilterComposer get trackRecordId {
    final $$TrackRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackRecordId,
      referencedTable: $db.trackRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackRecordsTableFilterComposer(
            $db: $db,
            $table: $db.trackRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackRecordPositionPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackRecordPositionPointsTable> {
  $$TrackRecordPositionPointsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get altitude => $composableBuilder(
    column: $table.altitude,
    builder: (column) => ColumnOrderings(column),
  );

  $$TrackRecordsTableOrderingComposer get trackRecordId {
    final $$TrackRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackRecordId,
      referencedTable: $db.trackRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.trackRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackRecordPositionPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackRecordPositionPointsTable> {
  $$TrackRecordPositionPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get altitude =>
      $composableBuilder(column: $table.altitude, builder: (column) => column);

  $$TrackRecordsTableAnnotationComposer get trackRecordId {
    final $$TrackRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackRecordId,
      referencedTable: $db.trackRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.trackRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackRecordPositionPointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackRecordPositionPointsTable,
          TrackRecordPositionPoint,
          $$TrackRecordPositionPointsTableFilterComposer,
          $$TrackRecordPositionPointsTableOrderingComposer,
          $$TrackRecordPositionPointsTableAnnotationComposer,
          $$TrackRecordPositionPointsTableCreateCompanionBuilder,
          $$TrackRecordPositionPointsTableUpdateCompanionBuilder,
          (
            TrackRecordPositionPoint,
            $$TrackRecordPositionPointsTableReferences,
          ),
          TrackRecordPositionPoint,
          PrefetchHooks Function({bool trackRecordId})
        > {
  $$TrackRecordPositionPointsTableTableManager(
    _$AppDatabase db,
    $TrackRecordPositionPointsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackRecordPositionPointsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$TrackRecordPositionPointsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TrackRecordPositionPointsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> trackRecordId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<double?> altitude = const Value.absent(),
              }) => TrackRecordPositionPointsCompanion(
                id: id,
                trackRecordId: trackRecordId,
                createdAt: createdAt,
                latitude: latitude,
                longitude: longitude,
                altitude: altitude,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int trackRecordId,
                required DateTime createdAt,
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<double?> altitude = const Value.absent(),
              }) => TrackRecordPositionPointsCompanion.insert(
                id: id,
                trackRecordId: trackRecordId,
                createdAt: createdAt,
                latitude: latitude,
                longitude: longitude,
                altitude: altitude,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TrackRecordPositionPointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({trackRecordId = false}) {
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
                    if (trackRecordId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.trackRecordId,
                                referencedTable:
                                    $$TrackRecordPositionPointsTableReferences
                                        ._trackRecordIdTable(db),
                                referencedColumn:
                                    $$TrackRecordPositionPointsTableReferences
                                        ._trackRecordIdTable(db)
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

typedef $$TrackRecordPositionPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackRecordPositionPointsTable,
      TrackRecordPositionPoint,
      $$TrackRecordPositionPointsTableFilterComposer,
      $$TrackRecordPositionPointsTableOrderingComposer,
      $$TrackRecordPositionPointsTableAnnotationComposer,
      $$TrackRecordPositionPointsTableCreateCompanionBuilder,
      $$TrackRecordPositionPointsTableUpdateCompanionBuilder,
      (TrackRecordPositionPoint, $$TrackRecordPositionPointsTableReferences),
      TrackRecordPositionPoint,
      PrefetchHooks Function({bool trackRecordId})
    >;
typedef $$TrackRecordPointsTableCreateCompanionBuilder =
    TrackRecordPointsCompanion Function({
      Value<int> id,
      required int trackRecordId,
      required DateTime createdAt,
      required PointType discriminator,
      Value<String?> paylod,
    });
typedef $$TrackRecordPointsTableUpdateCompanionBuilder =
    TrackRecordPointsCompanion Function({
      Value<int> id,
      Value<int> trackRecordId,
      Value<DateTime> createdAt,
      Value<PointType> discriminator,
      Value<String?> paylod,
    });

final class $$TrackRecordPointsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TrackRecordPointsTable,
          TrackRecordPoint
        > {
  $$TrackRecordPointsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TrackRecordsTable _trackRecordIdTable(_$AppDatabase db) =>
      db.trackRecords.createAlias(
        $_aliasNameGenerator(
          db.trackRecordPoints.trackRecordId,
          db.trackRecords.id,
        ),
      );

  $$TrackRecordsTableProcessedTableManager get trackRecordId {
    final $_column = $_itemColumn<int>('track_record_id')!;

    final manager = $$TrackRecordsTableTableManager(
      $_db,
      $_db.trackRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrackRecordPointsTableFilterComposer
    extends Composer<_$AppDatabase, $TrackRecordPointsTable> {
  $$TrackRecordPointsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PointType, PointType, String>
  get discriminator => $composableBuilder(
    column: $table.discriminator,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get paylod => $composableBuilder(
    column: $table.paylod,
    builder: (column) => ColumnFilters(column),
  );

  $$TrackRecordsTableFilterComposer get trackRecordId {
    final $$TrackRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackRecordId,
      referencedTable: $db.trackRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackRecordsTableFilterComposer(
            $db: $db,
            $table: $db.trackRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackRecordPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackRecordPointsTable> {
  $$TrackRecordPointsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discriminator => $composableBuilder(
    column: $table.discriminator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paylod => $composableBuilder(
    column: $table.paylod,
    builder: (column) => ColumnOrderings(column),
  );

  $$TrackRecordsTableOrderingComposer get trackRecordId {
    final $$TrackRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackRecordId,
      referencedTable: $db.trackRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.trackRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackRecordPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackRecordPointsTable> {
  $$TrackRecordPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PointType, String> get discriminator =>
      $composableBuilder(
        column: $table.discriminator,
        builder: (column) => column,
      );

  GeneratedColumn<String> get paylod =>
      $composableBuilder(column: $table.paylod, builder: (column) => column);

  $$TrackRecordsTableAnnotationComposer get trackRecordId {
    final $$TrackRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackRecordId,
      referencedTable: $db.trackRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.trackRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackRecordPointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackRecordPointsTable,
          TrackRecordPoint,
          $$TrackRecordPointsTableFilterComposer,
          $$TrackRecordPointsTableOrderingComposer,
          $$TrackRecordPointsTableAnnotationComposer,
          $$TrackRecordPointsTableCreateCompanionBuilder,
          $$TrackRecordPointsTableUpdateCompanionBuilder,
          (TrackRecordPoint, $$TrackRecordPointsTableReferences),
          TrackRecordPoint,
          PrefetchHooks Function({bool trackRecordId})
        > {
  $$TrackRecordPointsTableTableManager(
    _$AppDatabase db,
    $TrackRecordPointsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackRecordPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackRecordPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackRecordPointsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> trackRecordId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<PointType> discriminator = const Value.absent(),
                Value<String?> paylod = const Value.absent(),
              }) => TrackRecordPointsCompanion(
                id: id,
                trackRecordId: trackRecordId,
                createdAt: createdAt,
                discriminator: discriminator,
                paylod: paylod,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int trackRecordId,
                required DateTime createdAt,
                required PointType discriminator,
                Value<String?> paylod = const Value.absent(),
              }) => TrackRecordPointsCompanion.insert(
                id: id,
                trackRecordId: trackRecordId,
                createdAt: createdAt,
                discriminator: discriminator,
                paylod: paylod,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TrackRecordPointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({trackRecordId = false}) {
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
                    if (trackRecordId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.trackRecordId,
                                referencedTable:
                                    $$TrackRecordPointsTableReferences
                                        ._trackRecordIdTable(db),
                                referencedColumn:
                                    $$TrackRecordPointsTableReferences
                                        ._trackRecordIdTable(db)
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

typedef $$TrackRecordPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackRecordPointsTable,
      TrackRecordPoint,
      $$TrackRecordPointsTableFilterComposer,
      $$TrackRecordPointsTableOrderingComposer,
      $$TrackRecordPointsTableAnnotationComposer,
      $$TrackRecordPointsTableCreateCompanionBuilder,
      $$TrackRecordPointsTableUpdateCompanionBuilder,
      (TrackRecordPoint, $$TrackRecordPointsTableReferences),
      TrackRecordPoint,
      PrefetchHooks Function({bool trackRecordId})
    >;
typedef $$TrackRecordSummariesTableCreateCompanionBuilder =
    TrackRecordSummariesCompanion Function({
      Value<int> trackRecordId,
      Value<DateTime?> start,
      Value<DateTime?> end,
      Value<Duration?> activeDuration,
      Value<Distance?> activeDistance,
      Value<Duration?> activePositioningDuration,
      Value<double?> averagePulse,
    });
typedef $$TrackRecordSummariesTableUpdateCompanionBuilder =
    TrackRecordSummariesCompanion Function({
      Value<int> trackRecordId,
      Value<DateTime?> start,
      Value<DateTime?> end,
      Value<Duration?> activeDuration,
      Value<Distance?> activeDistance,
      Value<Duration?> activePositioningDuration,
      Value<double?> averagePulse,
    });

final class $$TrackRecordSummariesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TrackRecordSummariesTable,
          TrackRecordSummary
        > {
  $$TrackRecordSummariesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TrackRecordsTable _trackRecordIdTable(_$AppDatabase db) =>
      db.trackRecords.createAlias(
        $_aliasNameGenerator(
          db.trackRecordSummaries.trackRecordId,
          db.trackRecords.id,
        ),
      );

  $$TrackRecordsTableProcessedTableManager get trackRecordId {
    final $_column = $_itemColumn<int>('track_record_id')!;

    final manager = $$TrackRecordsTableTableManager(
      $_db,
      $_db.trackRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrackRecordSummariesTableFilterComposer
    extends Composer<_$AppDatabase, $TrackRecordSummariesTable> {
  $$TrackRecordSummariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Duration?, Duration, int> get activeDuration =>
      $composableBuilder(
        column: $table.activeDuration,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Distance?, Distance, double>
  get activeDistance => $composableBuilder(
    column: $table.activeDistance,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Duration?, Duration, int>
  get activePositioningDuration => $composableBuilder(
    column: $table.activePositioningDuration,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get averagePulse => $composableBuilder(
    column: $table.averagePulse,
    builder: (column) => ColumnFilters(column),
  );

  $$TrackRecordsTableFilterComposer get trackRecordId {
    final $$TrackRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackRecordId,
      referencedTable: $db.trackRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackRecordsTableFilterComposer(
            $db: $db,
            $table: $db.trackRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackRecordSummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackRecordSummariesTable> {
  $$TrackRecordSummariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activeDuration => $composableBuilder(
    column: $table.activeDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get activeDistance => $composableBuilder(
    column: $table.activeDistance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activePositioningDuration => $composableBuilder(
    column: $table.activePositioningDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get averagePulse => $composableBuilder(
    column: $table.averagePulse,
    builder: (column) => ColumnOrderings(column),
  );

  $$TrackRecordsTableOrderingComposer get trackRecordId {
    final $$TrackRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackRecordId,
      referencedTable: $db.trackRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.trackRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackRecordSummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackRecordSummariesTable> {
  $$TrackRecordSummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get start =>
      $composableBuilder(column: $table.start, builder: (column) => column);

  GeneratedColumn<DateTime> get end =>
      $composableBuilder(column: $table.end, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Duration?, int> get activeDuration =>
      $composableBuilder(
        column: $table.activeDuration,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Distance?, double> get activeDistance =>
      $composableBuilder(
        column: $table.activeDistance,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Duration?, int>
  get activePositioningDuration => $composableBuilder(
    column: $table.activePositioningDuration,
    builder: (column) => column,
  );

  GeneratedColumn<double> get averagePulse => $composableBuilder(
    column: $table.averagePulse,
    builder: (column) => column,
  );

  $$TrackRecordsTableAnnotationComposer get trackRecordId {
    final $$TrackRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackRecordId,
      referencedTable: $db.trackRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.trackRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackRecordSummariesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackRecordSummariesTable,
          TrackRecordSummary,
          $$TrackRecordSummariesTableFilterComposer,
          $$TrackRecordSummariesTableOrderingComposer,
          $$TrackRecordSummariesTableAnnotationComposer,
          $$TrackRecordSummariesTableCreateCompanionBuilder,
          $$TrackRecordSummariesTableUpdateCompanionBuilder,
          (TrackRecordSummary, $$TrackRecordSummariesTableReferences),
          TrackRecordSummary,
          PrefetchHooks Function({bool trackRecordId})
        > {
  $$TrackRecordSummariesTableTableManager(
    _$AppDatabase db,
    $TrackRecordSummariesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackRecordSummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackRecordSummariesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TrackRecordSummariesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> trackRecordId = const Value.absent(),
                Value<DateTime?> start = const Value.absent(),
                Value<DateTime?> end = const Value.absent(),
                Value<Duration?> activeDuration = const Value.absent(),
                Value<Distance?> activeDistance = const Value.absent(),
                Value<Duration?> activePositioningDuration =
                    const Value.absent(),
                Value<double?> averagePulse = const Value.absent(),
              }) => TrackRecordSummariesCompanion(
                trackRecordId: trackRecordId,
                start: start,
                end: end,
                activeDuration: activeDuration,
                activeDistance: activeDistance,
                activePositioningDuration: activePositioningDuration,
                averagePulse: averagePulse,
              ),
          createCompanionCallback:
              ({
                Value<int> trackRecordId = const Value.absent(),
                Value<DateTime?> start = const Value.absent(),
                Value<DateTime?> end = const Value.absent(),
                Value<Duration?> activeDuration = const Value.absent(),
                Value<Distance?> activeDistance = const Value.absent(),
                Value<Duration?> activePositioningDuration =
                    const Value.absent(),
                Value<double?> averagePulse = const Value.absent(),
              }) => TrackRecordSummariesCompanion.insert(
                trackRecordId: trackRecordId,
                start: start,
                end: end,
                activeDuration: activeDuration,
                activeDistance: activeDistance,
                activePositioningDuration: activePositioningDuration,
                averagePulse: averagePulse,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TrackRecordSummariesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({trackRecordId = false}) {
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
                    if (trackRecordId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.trackRecordId,
                                referencedTable:
                                    $$TrackRecordSummariesTableReferences
                                        ._trackRecordIdTable(db),
                                referencedColumn:
                                    $$TrackRecordSummariesTableReferences
                                        ._trackRecordIdTable(db)
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

typedef $$TrackRecordSummariesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackRecordSummariesTable,
      TrackRecordSummary,
      $$TrackRecordSummariesTableFilterComposer,
      $$TrackRecordSummariesTableOrderingComposer,
      $$TrackRecordSummariesTableAnnotationComposer,
      $$TrackRecordSummariesTableCreateCompanionBuilder,
      $$TrackRecordSummariesTableUpdateCompanionBuilder,
      (TrackRecordSummary, $$TrackRecordSummariesTableReferences),
      TrackRecordSummary,
      PrefetchHooks Function({bool trackRecordId})
    >;
typedef $$PulseMeasurementsTableCreateCompanionBuilder =
    PulseMeasurementsCompanion Function({
      Value<int> id,
      required int trackRecordId,
      required DateTime measuredAt,
      required double pulseBPM,
      required PulseMeasureKind source,
    });
typedef $$PulseMeasurementsTableUpdateCompanionBuilder =
    PulseMeasurementsCompanion Function({
      Value<int> id,
      Value<int> trackRecordId,
      Value<DateTime> measuredAt,
      Value<double> pulseBPM,
      Value<PulseMeasureKind> source,
    });

final class $$PulseMeasurementsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PulseMeasurementsTable,
          PulseMeasurement
        > {
  $$PulseMeasurementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TrackRecordsTable _trackRecordIdTable(_$AppDatabase db) =>
      db.trackRecords.createAlias(
        $_aliasNameGenerator(
          db.pulseMeasurements.trackRecordId,
          db.trackRecords.id,
        ),
      );

  $$TrackRecordsTableProcessedTableManager get trackRecordId {
    final $_column = $_itemColumn<int>('track_record_id')!;

    final manager = $$TrackRecordsTableTableManager(
      $_db,
      $_db.trackRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackRecordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PulseMeasurementsTableFilterComposer
    extends Composer<_$AppDatabase, $PulseMeasurementsTable> {
  $$PulseMeasurementsTableFilterComposer({
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

  ColumnFilters<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pulseBPM => $composableBuilder(
    column: $table.pulseBPM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PulseMeasureKind, PulseMeasureKind, String>
  get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$TrackRecordsTableFilterComposer get trackRecordId {
    final $$TrackRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackRecordId,
      referencedTable: $db.trackRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackRecordsTableFilterComposer(
            $db: $db,
            $table: $db.trackRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PulseMeasurementsTableOrderingComposer
    extends Composer<_$AppDatabase, $PulseMeasurementsTable> {
  $$PulseMeasurementsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pulseBPM => $composableBuilder(
    column: $table.pulseBPM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  $$TrackRecordsTableOrderingComposer get trackRecordId {
    final $$TrackRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackRecordId,
      referencedTable: $db.trackRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.trackRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PulseMeasurementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PulseMeasurementsTable> {
  $$PulseMeasurementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pulseBPM =>
      $composableBuilder(column: $table.pulseBPM, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PulseMeasureKind, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  $$TrackRecordsTableAnnotationComposer get trackRecordId {
    final $$TrackRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackRecordId,
      referencedTable: $db.trackRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.trackRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PulseMeasurementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PulseMeasurementsTable,
          PulseMeasurement,
          $$PulseMeasurementsTableFilterComposer,
          $$PulseMeasurementsTableOrderingComposer,
          $$PulseMeasurementsTableAnnotationComposer,
          $$PulseMeasurementsTableCreateCompanionBuilder,
          $$PulseMeasurementsTableUpdateCompanionBuilder,
          (PulseMeasurement, $$PulseMeasurementsTableReferences),
          PulseMeasurement,
          PrefetchHooks Function({bool trackRecordId})
        > {
  $$PulseMeasurementsTableTableManager(
    _$AppDatabase db,
    $PulseMeasurementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PulseMeasurementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PulseMeasurementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PulseMeasurementsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> trackRecordId = const Value.absent(),
                Value<DateTime> measuredAt = const Value.absent(),
                Value<double> pulseBPM = const Value.absent(),
                Value<PulseMeasureKind> source = const Value.absent(),
              }) => PulseMeasurementsCompanion(
                id: id,
                trackRecordId: trackRecordId,
                measuredAt: measuredAt,
                pulseBPM: pulseBPM,
                source: source,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int trackRecordId,
                required DateTime measuredAt,
                required double pulseBPM,
                required PulseMeasureKind source,
              }) => PulseMeasurementsCompanion.insert(
                id: id,
                trackRecordId: trackRecordId,
                measuredAt: measuredAt,
                pulseBPM: pulseBPM,
                source: source,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PulseMeasurementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({trackRecordId = false}) {
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
                    if (trackRecordId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.trackRecordId,
                                referencedTable:
                                    $$PulseMeasurementsTableReferences
                                        ._trackRecordIdTable(db),
                                referencedColumn:
                                    $$PulseMeasurementsTableReferences
                                        ._trackRecordIdTable(db)
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

typedef $$PulseMeasurementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PulseMeasurementsTable,
      PulseMeasurement,
      $$PulseMeasurementsTableFilterComposer,
      $$PulseMeasurementsTableOrderingComposer,
      $$PulseMeasurementsTableAnnotationComposer,
      $$PulseMeasurementsTableCreateCompanionBuilder,
      $$PulseMeasurementsTableUpdateCompanionBuilder,
      (PulseMeasurement, $$PulseMeasurementsTableReferences),
      PulseMeasurement,
      PrefetchHooks Function({bool trackRecordId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$TrackRecordsTableTableManager get trackRecords =>
      $$TrackRecordsTableTableManager(_db, _db.trackRecords);
  $$TrackRecordPositionPointsTableTableManager get trackRecordPositionPoints =>
      $$TrackRecordPositionPointsTableTableManager(
        _db,
        _db.trackRecordPositionPoints,
      );
  $$TrackRecordPointsTableTableManager get trackRecordPoints =>
      $$TrackRecordPointsTableTableManager(_db, _db.trackRecordPoints);
  $$TrackRecordSummariesTableTableManager get trackRecordSummaries =>
      $$TrackRecordSummariesTableTableManager(_db, _db.trackRecordSummaries);
  $$PulseMeasurementsTableTableManager get pulseMeasurements =>
      $$PulseMeasurementsTableTableManager(_db, _db.pulseMeasurements);
}
