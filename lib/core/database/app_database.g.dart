// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SessionsTable extends Sessions
    with TableInfo<$SessionsTable, SessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courtCountMeta = const VerificationMeta(
    'courtCount',
  );
  @override
  late final GeneratedColumn<int> courtCount = GeneratedColumn<int>(
    'court_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetPointsMeta = const VerificationMeta(
    'targetPoints',
  );
  @override
  late final GeneratedColumn<int> targetPoints = GeneratedColumn<int>(
    'target_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    courtCount,
    targetPoints,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('court_count')) {
      context.handle(
        _courtCountMeta,
        courtCount.isAcceptableOrUnknown(data['court_count']!, _courtCountMeta),
      );
    } else if (isInserting) {
      context.missing(_courtCountMeta);
    }
    if (data.containsKey('target_points')) {
      context.handle(
        _targetPointsMeta,
        targetPoints.isAcceptableOrUnknown(
          data['target_points']!,
          _targetPointsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetPointsMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      courtCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}court_count'],
      )!,
      targetPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_points'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class SessionRow extends DataClass implements Insertable<SessionRow> {
  final String id;
  final String name;
  final int courtCount;
  final int targetPoints;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SessionRow({
    required this.id,
    required this.name,
    required this.courtCount,
    required this.targetPoints,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['court_count'] = Variable<int>(courtCount);
    map['target_points'] = Variable<int>(targetPoints);
    map['status'] = Variable<int>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      name: Value(name),
      courtCount: Value(courtCount),
      targetPoints: Value(targetPoints),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      courtCount: serializer.fromJson<int>(json['courtCount']),
      targetPoints: serializer.fromJson<int>(json['targetPoints']),
      status: serializer.fromJson<int>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'courtCount': serializer.toJson<int>(courtCount),
      'targetPoints': serializer.toJson<int>(targetPoints),
      'status': serializer.toJson<int>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SessionRow copyWith({
    String? id,
    String? name,
    int? courtCount,
    int? targetPoints,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SessionRow(
    id: id ?? this.id,
    name: name ?? this.name,
    courtCount: courtCount ?? this.courtCount,
    targetPoints: targetPoints ?? this.targetPoints,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SessionRow copyWithCompanion(SessionsCompanion data) {
    return SessionRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      courtCount: data.courtCount.present
          ? data.courtCount.value
          : this.courtCount,
      targetPoints: data.targetPoints.present
          ? data.targetPoints.value
          : this.targetPoints,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('courtCount: $courtCount, ')
          ..write('targetPoints: $targetPoints, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    courtCount,
    targetPoints,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.courtCount == this.courtCount &&
          other.targetPoints == this.targetPoints &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SessionsCompanion extends UpdateCompanion<SessionRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> courtCount;
  final Value<int> targetPoints;
  final Value<int> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.courtCount = const Value.absent(),
    this.targetPoints = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String id,
    required String name,
    required int courtCount,
    required int targetPoints,
    required int status,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       courtCount = Value(courtCount),
       targetPoints = Value(targetPoints),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SessionRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? courtCount,
    Expression<int>? targetPoints,
    Expression<int>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (courtCount != null) 'court_count': courtCount,
      if (targetPoints != null) 'target_points': targetPoints,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? courtCount,
    Value<int>? targetPoints,
    Value<int>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      courtCount: courtCount ?? this.courtCount,
      targetPoints: targetPoints ?? this.targetPoints,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (courtCount.present) {
      map['court_count'] = Variable<int>(courtCount.value);
    }
    if (targetPoints.present) {
      map['target_points'] = Variable<int>(targetPoints.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('courtCount: $courtCount, ')
          ..write('targetPoints: $targetPoints, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlayersTable extends Players with TableInfo<$PlayersTable, PlayerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _arrivalOrderMeta = const VerificationMeta(
    'arrivalOrder',
  );
  @override
  late final GeneratedColumn<int> arrivalOrder = GeneratedColumn<int>(
    'arrival_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    name,
    arrivalOrder,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'players';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('arrival_order')) {
      context.handle(
        _arrivalOrderMeta,
        arrivalOrder.isAcceptableOrUnknown(
          data['arrival_order']!,
          _arrivalOrderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_arrivalOrderMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      arrivalOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}arrival_order'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $PlayersTable createAlias(String alias) {
    return $PlayersTable(attachedDatabase, alias);
  }
}

class PlayerRow extends DataClass implements Insertable<PlayerRow> {
  final String id;
  final String sessionId;
  final String name;
  final int arrivalOrder;
  final int status;
  const PlayerRow({
    required this.id,
    required this.sessionId,
    required this.name,
    required this.arrivalOrder,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['name'] = Variable<String>(name);
    map['arrival_order'] = Variable<int>(arrivalOrder);
    map['status'] = Variable<int>(status);
    return map;
  }

  PlayersCompanion toCompanion(bool nullToAbsent) {
    return PlayersCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      name: Value(name),
      arrivalOrder: Value(arrivalOrder),
      status: Value(status),
    );
  }

  factory PlayerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerRow(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      name: serializer.fromJson<String>(json['name']),
      arrivalOrder: serializer.fromJson<int>(json['arrivalOrder']),
      status: serializer.fromJson<int>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'name': serializer.toJson<String>(name),
      'arrivalOrder': serializer.toJson<int>(arrivalOrder),
      'status': serializer.toJson<int>(status),
    };
  }

  PlayerRow copyWith({
    String? id,
    String? sessionId,
    String? name,
    int? arrivalOrder,
    int? status,
  }) => PlayerRow(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    name: name ?? this.name,
    arrivalOrder: arrivalOrder ?? this.arrivalOrder,
    status: status ?? this.status,
  );
  PlayerRow copyWithCompanion(PlayersCompanion data) {
    return PlayerRow(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      name: data.name.present ? data.name.value : this.name,
      arrivalOrder: data.arrivalOrder.present
          ? data.arrivalOrder.value
          : this.arrivalOrder,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerRow(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('name: $name, ')
          ..write('arrivalOrder: $arrivalOrder, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, name, arrivalOrder, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerRow &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.name == this.name &&
          other.arrivalOrder == this.arrivalOrder &&
          other.status == this.status);
}

class PlayersCompanion extends UpdateCompanion<PlayerRow> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> name;
  final Value<int> arrivalOrder;
  final Value<int> status;
  final Value<int> rowid;
  const PlayersCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.name = const Value.absent(),
    this.arrivalOrder = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlayersCompanion.insert({
    required String id,
    required String sessionId,
    required String name,
    required int arrivalOrder,
    required int status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       name = Value(name),
       arrivalOrder = Value(arrivalOrder),
       status = Value(status);
  static Insertable<PlayerRow> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? name,
    Expression<int>? arrivalOrder,
    Expression<int>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (name != null) 'name': name,
      if (arrivalOrder != null) 'arrival_order': arrivalOrder,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlayersCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? name,
    Value<int>? arrivalOrder,
    Value<int>? status,
    Value<int>? rowid,
  }) {
    return PlayersCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      name: name ?? this.name,
      arrivalOrder: arrivalOrder ?? this.arrivalOrder,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (arrivalOrder.present) {
      map['arrival_order'] = Variable<int>(arrivalOrder.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayersCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('name: $name, ')
          ..write('arrivalOrder: $arrivalOrder, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlayerQueueEntriesTable extends PlayerQueueEntries
    with TableInfo<$PlayerQueueEntriesTable, PlayerQueueEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerQueueEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<String> playerId = GeneratedColumn<String>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [sessionId, playerId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_queue_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayerQueueEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId, playerId};
  @override
  PlayerQueueEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerQueueEntryRow(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}player_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $PlayerQueueEntriesTable createAlias(String alias) {
    return $PlayerQueueEntriesTable(attachedDatabase, alias);
  }
}

class PlayerQueueEntryRow extends DataClass
    implements Insertable<PlayerQueueEntryRow> {
  final String sessionId;
  final String playerId;
  final int position;
  const PlayerQueueEntryRow({
    required this.sessionId,
    required this.playerId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['player_id'] = Variable<String>(playerId);
    map['position'] = Variable<int>(position);
    return map;
  }

  PlayerQueueEntriesCompanion toCompanion(bool nullToAbsent) {
    return PlayerQueueEntriesCompanion(
      sessionId: Value(sessionId),
      playerId: Value(playerId),
      position: Value(position),
    );
  }

  factory PlayerQueueEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerQueueEntryRow(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      playerId: serializer.fromJson<String>(json['playerId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'playerId': serializer.toJson<String>(playerId),
      'position': serializer.toJson<int>(position),
    };
  }

  PlayerQueueEntryRow copyWith({
    String? sessionId,
    String? playerId,
    int? position,
  }) => PlayerQueueEntryRow(
    sessionId: sessionId ?? this.sessionId,
    playerId: playerId ?? this.playerId,
    position: position ?? this.position,
  );
  PlayerQueueEntryRow copyWithCompanion(PlayerQueueEntriesCompanion data) {
    return PlayerQueueEntryRow(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerQueueEntryRow(')
          ..write('sessionId: $sessionId, ')
          ..write('playerId: $playerId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(sessionId, playerId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerQueueEntryRow &&
          other.sessionId == this.sessionId &&
          other.playerId == this.playerId &&
          other.position == this.position);
}

class PlayerQueueEntriesCompanion extends UpdateCompanion<PlayerQueueEntryRow> {
  final Value<String> sessionId;
  final Value<String> playerId;
  final Value<int> position;
  final Value<int> rowid;
  const PlayerQueueEntriesCompanion({
    this.sessionId = const Value.absent(),
    this.playerId = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlayerQueueEntriesCompanion.insert({
    required String sessionId,
    required String playerId,
    required int position,
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       playerId = Value(playerId),
       position = Value(position);
  static Insertable<PlayerQueueEntryRow> custom({
    Expression<String>? sessionId,
    Expression<String>? playerId,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (playerId != null) 'player_id': playerId,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlayerQueueEntriesCompanion copyWith({
    Value<String>? sessionId,
    Value<String>? playerId,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return PlayerQueueEntriesCompanion(
      sessionId: sessionId ?? this.sessionId,
      playerId: playerId ?? this.playerId,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<String>(playerId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerQueueEntriesCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('playerId: $playerId, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PairsTable extends Pairs with TableInfo<$PairsTable, PairRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PairsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _playerOneIdMeta = const VerificationMeta(
    'playerOneId',
  );
  @override
  late final GeneratedColumn<String> playerOneId = GeneratedColumn<String>(
    'player_one_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _playerTwoIdMeta = const VerificationMeta(
    'playerTwoId',
  );
  @override
  late final GeneratedColumn<String> playerTwoId = GeneratedColumn<String>(
    'player_two_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<int> origin = GeneratedColumn<int>(
    'origin',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _queueOrderMeta = const VerificationMeta(
    'queueOrder',
  );
  @override
  late final GeneratedColumn<int> queueOrder = GeneratedColumn<int>(
    'queue_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    playerOneId,
    playerTwoId,
    origin,
    status,
    queueOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pairs';
  @override
  VerificationContext validateIntegrity(
    Insertable<PairRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('player_one_id')) {
      context.handle(
        _playerOneIdMeta,
        playerOneId.isAcceptableOrUnknown(
          data['player_one_id']!,
          _playerOneIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_playerOneIdMeta);
    }
    if (data.containsKey('player_two_id')) {
      context.handle(
        _playerTwoIdMeta,
        playerTwoId.isAcceptableOrUnknown(
          data['player_two_id']!,
          _playerTwoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_playerTwoIdMeta);
    }
    if (data.containsKey('origin')) {
      context.handle(
        _originMeta,
        origin.isAcceptableOrUnknown(data['origin']!, _originMeta),
      );
    } else if (isInserting) {
      context.missing(_originMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('queue_order')) {
      context.handle(
        _queueOrderMeta,
        queueOrder.isAcceptableOrUnknown(data['queue_order']!, _queueOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_queueOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PairRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PairRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      playerOneId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}player_one_id'],
      )!,
      playerTwoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}player_two_id'],
      )!,
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}origin'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      queueOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}queue_order'],
      )!,
    );
  }

  @override
  $PairsTable createAlias(String alias) {
    return $PairsTable(attachedDatabase, alias);
  }
}

class PairRow extends DataClass implements Insertable<PairRow> {
  final String id;
  final String sessionId;
  final String playerOneId;
  final String playerTwoId;
  final int origin;
  final int status;
  final int queueOrder;
  const PairRow({
    required this.id,
    required this.sessionId,
    required this.playerOneId,
    required this.playerTwoId,
    required this.origin,
    required this.status,
    required this.queueOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['player_one_id'] = Variable<String>(playerOneId);
    map['player_two_id'] = Variable<String>(playerTwoId);
    map['origin'] = Variable<int>(origin);
    map['status'] = Variable<int>(status);
    map['queue_order'] = Variable<int>(queueOrder);
    return map;
  }

  PairsCompanion toCompanion(bool nullToAbsent) {
    return PairsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      playerOneId: Value(playerOneId),
      playerTwoId: Value(playerTwoId),
      origin: Value(origin),
      status: Value(status),
      queueOrder: Value(queueOrder),
    );
  }

  factory PairRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PairRow(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      playerOneId: serializer.fromJson<String>(json['playerOneId']),
      playerTwoId: serializer.fromJson<String>(json['playerTwoId']),
      origin: serializer.fromJson<int>(json['origin']),
      status: serializer.fromJson<int>(json['status']),
      queueOrder: serializer.fromJson<int>(json['queueOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'playerOneId': serializer.toJson<String>(playerOneId),
      'playerTwoId': serializer.toJson<String>(playerTwoId),
      'origin': serializer.toJson<int>(origin),
      'status': serializer.toJson<int>(status),
      'queueOrder': serializer.toJson<int>(queueOrder),
    };
  }

  PairRow copyWith({
    String? id,
    String? sessionId,
    String? playerOneId,
    String? playerTwoId,
    int? origin,
    int? status,
    int? queueOrder,
  }) => PairRow(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    playerOneId: playerOneId ?? this.playerOneId,
    playerTwoId: playerTwoId ?? this.playerTwoId,
    origin: origin ?? this.origin,
    status: status ?? this.status,
    queueOrder: queueOrder ?? this.queueOrder,
  );
  PairRow copyWithCompanion(PairsCompanion data) {
    return PairRow(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      playerOneId: data.playerOneId.present
          ? data.playerOneId.value
          : this.playerOneId,
      playerTwoId: data.playerTwoId.present
          ? data.playerTwoId.value
          : this.playerTwoId,
      origin: data.origin.present ? data.origin.value : this.origin,
      status: data.status.present ? data.status.value : this.status,
      queueOrder: data.queueOrder.present
          ? data.queueOrder.value
          : this.queueOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PairRow(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('playerOneId: $playerOneId, ')
          ..write('playerTwoId: $playerTwoId, ')
          ..write('origin: $origin, ')
          ..write('status: $status, ')
          ..write('queueOrder: $queueOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    playerOneId,
    playerTwoId,
    origin,
    status,
    queueOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PairRow &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.playerOneId == this.playerOneId &&
          other.playerTwoId == this.playerTwoId &&
          other.origin == this.origin &&
          other.status == this.status &&
          other.queueOrder == this.queueOrder);
}

class PairsCompanion extends UpdateCompanion<PairRow> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> playerOneId;
  final Value<String> playerTwoId;
  final Value<int> origin;
  final Value<int> status;
  final Value<int> queueOrder;
  final Value<int> rowid;
  const PairsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.playerOneId = const Value.absent(),
    this.playerTwoId = const Value.absent(),
    this.origin = const Value.absent(),
    this.status = const Value.absent(),
    this.queueOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PairsCompanion.insert({
    required String id,
    required String sessionId,
    required String playerOneId,
    required String playerTwoId,
    required int origin,
    required int status,
    required int queueOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       playerOneId = Value(playerOneId),
       playerTwoId = Value(playerTwoId),
       origin = Value(origin),
       status = Value(status),
       queueOrder = Value(queueOrder);
  static Insertable<PairRow> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? playerOneId,
    Expression<String>? playerTwoId,
    Expression<int>? origin,
    Expression<int>? status,
    Expression<int>? queueOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (playerOneId != null) 'player_one_id': playerOneId,
      if (playerTwoId != null) 'player_two_id': playerTwoId,
      if (origin != null) 'origin': origin,
      if (status != null) 'status': status,
      if (queueOrder != null) 'queue_order': queueOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PairsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? playerOneId,
    Value<String>? playerTwoId,
    Value<int>? origin,
    Value<int>? status,
    Value<int>? queueOrder,
    Value<int>? rowid,
  }) {
    return PairsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      playerOneId: playerOneId ?? this.playerOneId,
      playerTwoId: playerTwoId ?? this.playerTwoId,
      origin: origin ?? this.origin,
      status: status ?? this.status,
      queueOrder: queueOrder ?? this.queueOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (playerOneId.present) {
      map['player_one_id'] = Variable<String>(playerOneId.value);
    }
    if (playerTwoId.present) {
      map['player_two_id'] = Variable<String>(playerTwoId.value);
    }
    if (origin.present) {
      map['origin'] = Variable<int>(origin.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (queueOrder.present) {
      map['queue_order'] = Variable<int>(queueOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PairsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('playerOneId: $playerOneId, ')
          ..write('playerTwoId: $playerTwoId, ')
          ..write('origin: $origin, ')
          ..write('status: $status, ')
          ..write('queueOrder: $queueOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CourtsTable extends Courts with TableInfo<$CourtsTable, CourtRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CourtsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _homePairIdMeta = const VerificationMeta(
    'homePairId',
  );
  @override
  late final GeneratedColumn<String> homePairId = GeneratedColumn<String>(
    'home_pair_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _challengerPairIdMeta = const VerificationMeta(
    'challengerPairId',
  );
  @override
  late final GeneratedColumn<String> challengerPairId = GeneratedColumn<String>(
    'challenger_pair_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _matchIdMeta = const VerificationMeta(
    'matchId',
  );
  @override
  late final GeneratedColumn<String> matchId = GeneratedColumn<String>(
    'match_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    name,
    level,
    status,
    homePairId,
    challengerPairId,
    matchId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'courts';
  @override
  VerificationContext validateIntegrity(
    Insertable<CourtRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('home_pair_id')) {
      context.handle(
        _homePairIdMeta,
        homePairId.isAcceptableOrUnknown(
          data['home_pair_id']!,
          _homePairIdMeta,
        ),
      );
    }
    if (data.containsKey('challenger_pair_id')) {
      context.handle(
        _challengerPairIdMeta,
        challengerPairId.isAcceptableOrUnknown(
          data['challenger_pair_id']!,
          _challengerPairIdMeta,
        ),
      );
    }
    if (data.containsKey('match_id')) {
      context.handle(
        _matchIdMeta,
        matchId.isAcceptableOrUnknown(data['match_id']!, _matchIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CourtRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CourtRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      homePairId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}home_pair_id'],
      ),
      challengerPairId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}challenger_pair_id'],
      ),
      matchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}match_id'],
      ),
    );
  }

  @override
  $CourtsTable createAlias(String alias) {
    return $CourtsTable(attachedDatabase, alias);
  }
}

class CourtRow extends DataClass implements Insertable<CourtRow> {
  final String id;
  final String sessionId;
  final String name;
  final int level;
  final int status;
  final String? homePairId;
  final String? challengerPairId;
  final String? matchId;
  const CourtRow({
    required this.id,
    required this.sessionId,
    required this.name,
    required this.level,
    required this.status,
    this.homePairId,
    this.challengerPairId,
    this.matchId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['name'] = Variable<String>(name);
    map['level'] = Variable<int>(level);
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || homePairId != null) {
      map['home_pair_id'] = Variable<String>(homePairId);
    }
    if (!nullToAbsent || challengerPairId != null) {
      map['challenger_pair_id'] = Variable<String>(challengerPairId);
    }
    if (!nullToAbsent || matchId != null) {
      map['match_id'] = Variable<String>(matchId);
    }
    return map;
  }

  CourtsCompanion toCompanion(bool nullToAbsent) {
    return CourtsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      name: Value(name),
      level: Value(level),
      status: Value(status),
      homePairId: homePairId == null && nullToAbsent
          ? const Value.absent()
          : Value(homePairId),
      challengerPairId: challengerPairId == null && nullToAbsent
          ? const Value.absent()
          : Value(challengerPairId),
      matchId: matchId == null && nullToAbsent
          ? const Value.absent()
          : Value(matchId),
    );
  }

  factory CourtRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CourtRow(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      name: serializer.fromJson<String>(json['name']),
      level: serializer.fromJson<int>(json['level']),
      status: serializer.fromJson<int>(json['status']),
      homePairId: serializer.fromJson<String?>(json['homePairId']),
      challengerPairId: serializer.fromJson<String?>(json['challengerPairId']),
      matchId: serializer.fromJson<String?>(json['matchId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'name': serializer.toJson<String>(name),
      'level': serializer.toJson<int>(level),
      'status': serializer.toJson<int>(status),
      'homePairId': serializer.toJson<String?>(homePairId),
      'challengerPairId': serializer.toJson<String?>(challengerPairId),
      'matchId': serializer.toJson<String?>(matchId),
    };
  }

  CourtRow copyWith({
    String? id,
    String? sessionId,
    String? name,
    int? level,
    int? status,
    Value<String?> homePairId = const Value.absent(),
    Value<String?> challengerPairId = const Value.absent(),
    Value<String?> matchId = const Value.absent(),
  }) => CourtRow(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    name: name ?? this.name,
    level: level ?? this.level,
    status: status ?? this.status,
    homePairId: homePairId.present ? homePairId.value : this.homePairId,
    challengerPairId: challengerPairId.present
        ? challengerPairId.value
        : this.challengerPairId,
    matchId: matchId.present ? matchId.value : this.matchId,
  );
  CourtRow copyWithCompanion(CourtsCompanion data) {
    return CourtRow(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      name: data.name.present ? data.name.value : this.name,
      level: data.level.present ? data.level.value : this.level,
      status: data.status.present ? data.status.value : this.status,
      homePairId: data.homePairId.present
          ? data.homePairId.value
          : this.homePairId,
      challengerPairId: data.challengerPairId.present
          ? data.challengerPairId.value
          : this.challengerPairId,
      matchId: data.matchId.present ? data.matchId.value : this.matchId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CourtRow(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('name: $name, ')
          ..write('level: $level, ')
          ..write('status: $status, ')
          ..write('homePairId: $homePairId, ')
          ..write('challengerPairId: $challengerPairId, ')
          ..write('matchId: $matchId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    name,
    level,
    status,
    homePairId,
    challengerPairId,
    matchId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CourtRow &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.name == this.name &&
          other.level == this.level &&
          other.status == this.status &&
          other.homePairId == this.homePairId &&
          other.challengerPairId == this.challengerPairId &&
          other.matchId == this.matchId);
}

class CourtsCompanion extends UpdateCompanion<CourtRow> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> name;
  final Value<int> level;
  final Value<int> status;
  final Value<String?> homePairId;
  final Value<String?> challengerPairId;
  final Value<String?> matchId;
  final Value<int> rowid;
  const CourtsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.name = const Value.absent(),
    this.level = const Value.absent(),
    this.status = const Value.absent(),
    this.homePairId = const Value.absent(),
    this.challengerPairId = const Value.absent(),
    this.matchId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CourtsCompanion.insert({
    required String id,
    required String sessionId,
    required String name,
    required int level,
    required int status,
    this.homePairId = const Value.absent(),
    this.challengerPairId = const Value.absent(),
    this.matchId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       name = Value(name),
       level = Value(level),
       status = Value(status);
  static Insertable<CourtRow> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? name,
    Expression<int>? level,
    Expression<int>? status,
    Expression<String>? homePairId,
    Expression<String>? challengerPairId,
    Expression<String>? matchId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (name != null) 'name': name,
      if (level != null) 'level': level,
      if (status != null) 'status': status,
      if (homePairId != null) 'home_pair_id': homePairId,
      if (challengerPairId != null) 'challenger_pair_id': challengerPairId,
      if (matchId != null) 'match_id': matchId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CourtsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? name,
    Value<int>? level,
    Value<int>? status,
    Value<String?>? homePairId,
    Value<String?>? challengerPairId,
    Value<String?>? matchId,
    Value<int>? rowid,
  }) {
    return CourtsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      name: name ?? this.name,
      level: level ?? this.level,
      status: status ?? this.status,
      homePairId: homePairId ?? this.homePairId,
      challengerPairId: challengerPairId ?? this.challengerPairId,
      matchId: matchId ?? this.matchId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (homePairId.present) {
      map['home_pair_id'] = Variable<String>(homePairId.value);
    }
    if (challengerPairId.present) {
      map['challenger_pair_id'] = Variable<String>(challengerPairId.value);
    }
    if (matchId.present) {
      map['match_id'] = Variable<String>(matchId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CourtsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('name: $name, ')
          ..write('level: $level, ')
          ..write('status: $status, ')
          ..write('homePairId: $homePairId, ')
          ..write('challengerPairId: $challengerPairId, ')
          ..write('matchId: $matchId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MatchesTable extends Matches with TableInfo<$MatchesTable, MatchRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courtIdMeta = const VerificationMeta(
    'courtId',
  );
  @override
  late final GeneratedColumn<String> courtId = GeneratedColumn<String>(
    'court_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pairOneIdMeta = const VerificationMeta(
    'pairOneId',
  );
  @override
  late final GeneratedColumn<String> pairOneId = GeneratedColumn<String>(
    'pair_one_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pairTwoIdMeta = const VerificationMeta(
    'pairTwoId',
  );
  @override
  late final GeneratedColumn<String> pairTwoId = GeneratedColumn<String>(
    'pair_two_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _winnerPairIdMeta = const VerificationMeta(
    'winnerPairId',
  );
  @override
  late final GeneratedColumn<String> winnerPairId = GeneratedColumn<String>(
    'winner_pair_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loserPairIdMeta = const VerificationMeta(
    'loserPairId',
  );
  @override
  late final GeneratedColumn<String> loserPairId = GeneratedColumn<String>(
    'loser_pair_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    courtId,
    pairOneId,
    pairTwoId,
    winnerPairId,
    loserPairId,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'matches';
  @override
  VerificationContext validateIntegrity(
    Insertable<MatchRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('court_id')) {
      context.handle(
        _courtIdMeta,
        courtId.isAcceptableOrUnknown(data['court_id']!, _courtIdMeta),
      );
    } else if (isInserting) {
      context.missing(_courtIdMeta);
    }
    if (data.containsKey('pair_one_id')) {
      context.handle(
        _pairOneIdMeta,
        pairOneId.isAcceptableOrUnknown(data['pair_one_id']!, _pairOneIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pairOneIdMeta);
    }
    if (data.containsKey('pair_two_id')) {
      context.handle(
        _pairTwoIdMeta,
        pairTwoId.isAcceptableOrUnknown(data['pair_two_id']!, _pairTwoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pairTwoIdMeta);
    }
    if (data.containsKey('winner_pair_id')) {
      context.handle(
        _winnerPairIdMeta,
        winnerPairId.isAcceptableOrUnknown(
          data['winner_pair_id']!,
          _winnerPairIdMeta,
        ),
      );
    }
    if (data.containsKey('loser_pair_id')) {
      context.handle(
        _loserPairIdMeta,
        loserPairId.isAcceptableOrUnknown(
          data['loser_pair_id']!,
          _loserPairIdMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MatchRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MatchRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      courtId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}court_id'],
      )!,
      pairOneId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pair_one_id'],
      )!,
      pairTwoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pair_two_id'],
      )!,
      winnerPairId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}winner_pair_id'],
      ),
      loserPairId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}loser_pair_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $MatchesTable createAlias(String alias) {
    return $MatchesTable(attachedDatabase, alias);
  }
}

class MatchRow extends DataClass implements Insertable<MatchRow> {
  final String id;
  final String sessionId;
  final String courtId;
  final String pairOneId;
  final String pairTwoId;
  final String? winnerPairId;
  final String? loserPairId;
  final int status;
  const MatchRow({
    required this.id,
    required this.sessionId,
    required this.courtId,
    required this.pairOneId,
    required this.pairTwoId,
    this.winnerPairId,
    this.loserPairId,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['court_id'] = Variable<String>(courtId);
    map['pair_one_id'] = Variable<String>(pairOneId);
    map['pair_two_id'] = Variable<String>(pairTwoId);
    if (!nullToAbsent || winnerPairId != null) {
      map['winner_pair_id'] = Variable<String>(winnerPairId);
    }
    if (!nullToAbsent || loserPairId != null) {
      map['loser_pair_id'] = Variable<String>(loserPairId);
    }
    map['status'] = Variable<int>(status);
    return map;
  }

  MatchesCompanion toCompanion(bool nullToAbsent) {
    return MatchesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      courtId: Value(courtId),
      pairOneId: Value(pairOneId),
      pairTwoId: Value(pairTwoId),
      winnerPairId: winnerPairId == null && nullToAbsent
          ? const Value.absent()
          : Value(winnerPairId),
      loserPairId: loserPairId == null && nullToAbsent
          ? const Value.absent()
          : Value(loserPairId),
      status: Value(status),
    );
  }

  factory MatchRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MatchRow(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      courtId: serializer.fromJson<String>(json['courtId']),
      pairOneId: serializer.fromJson<String>(json['pairOneId']),
      pairTwoId: serializer.fromJson<String>(json['pairTwoId']),
      winnerPairId: serializer.fromJson<String?>(json['winnerPairId']),
      loserPairId: serializer.fromJson<String?>(json['loserPairId']),
      status: serializer.fromJson<int>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'courtId': serializer.toJson<String>(courtId),
      'pairOneId': serializer.toJson<String>(pairOneId),
      'pairTwoId': serializer.toJson<String>(pairTwoId),
      'winnerPairId': serializer.toJson<String?>(winnerPairId),
      'loserPairId': serializer.toJson<String?>(loserPairId),
      'status': serializer.toJson<int>(status),
    };
  }

  MatchRow copyWith({
    String? id,
    String? sessionId,
    String? courtId,
    String? pairOneId,
    String? pairTwoId,
    Value<String?> winnerPairId = const Value.absent(),
    Value<String?> loserPairId = const Value.absent(),
    int? status,
  }) => MatchRow(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    courtId: courtId ?? this.courtId,
    pairOneId: pairOneId ?? this.pairOneId,
    pairTwoId: pairTwoId ?? this.pairTwoId,
    winnerPairId: winnerPairId.present ? winnerPairId.value : this.winnerPairId,
    loserPairId: loserPairId.present ? loserPairId.value : this.loserPairId,
    status: status ?? this.status,
  );
  MatchRow copyWithCompanion(MatchesCompanion data) {
    return MatchRow(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      courtId: data.courtId.present ? data.courtId.value : this.courtId,
      pairOneId: data.pairOneId.present ? data.pairOneId.value : this.pairOneId,
      pairTwoId: data.pairTwoId.present ? data.pairTwoId.value : this.pairTwoId,
      winnerPairId: data.winnerPairId.present
          ? data.winnerPairId.value
          : this.winnerPairId,
      loserPairId: data.loserPairId.present
          ? data.loserPairId.value
          : this.loserPairId,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MatchRow(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('courtId: $courtId, ')
          ..write('pairOneId: $pairOneId, ')
          ..write('pairTwoId: $pairTwoId, ')
          ..write('winnerPairId: $winnerPairId, ')
          ..write('loserPairId: $loserPairId, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    courtId,
    pairOneId,
    pairTwoId,
    winnerPairId,
    loserPairId,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MatchRow &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.courtId == this.courtId &&
          other.pairOneId == this.pairOneId &&
          other.pairTwoId == this.pairTwoId &&
          other.winnerPairId == this.winnerPairId &&
          other.loserPairId == this.loserPairId &&
          other.status == this.status);
}

class MatchesCompanion extends UpdateCompanion<MatchRow> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> courtId;
  final Value<String> pairOneId;
  final Value<String> pairTwoId;
  final Value<String?> winnerPairId;
  final Value<String?> loserPairId;
  final Value<int> status;
  final Value<int> rowid;
  const MatchesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.courtId = const Value.absent(),
    this.pairOneId = const Value.absent(),
    this.pairTwoId = const Value.absent(),
    this.winnerPairId = const Value.absent(),
    this.loserPairId = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MatchesCompanion.insert({
    required String id,
    required String sessionId,
    required String courtId,
    required String pairOneId,
    required String pairTwoId,
    this.winnerPairId = const Value.absent(),
    this.loserPairId = const Value.absent(),
    required int status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       courtId = Value(courtId),
       pairOneId = Value(pairOneId),
       pairTwoId = Value(pairTwoId),
       status = Value(status);
  static Insertable<MatchRow> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? courtId,
    Expression<String>? pairOneId,
    Expression<String>? pairTwoId,
    Expression<String>? winnerPairId,
    Expression<String>? loserPairId,
    Expression<int>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (courtId != null) 'court_id': courtId,
      if (pairOneId != null) 'pair_one_id': pairOneId,
      if (pairTwoId != null) 'pair_two_id': pairTwoId,
      if (winnerPairId != null) 'winner_pair_id': winnerPairId,
      if (loserPairId != null) 'loser_pair_id': loserPairId,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MatchesCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? courtId,
    Value<String>? pairOneId,
    Value<String>? pairTwoId,
    Value<String?>? winnerPairId,
    Value<String?>? loserPairId,
    Value<int>? status,
    Value<int>? rowid,
  }) {
    return MatchesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      courtId: courtId ?? this.courtId,
      pairOneId: pairOneId ?? this.pairOneId,
      pairTwoId: pairTwoId ?? this.pairTwoId,
      winnerPairId: winnerPairId ?? this.winnerPairId,
      loserPairId: loserPairId ?? this.loserPairId,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (courtId.present) {
      map['court_id'] = Variable<String>(courtId.value);
    }
    if (pairOneId.present) {
      map['pair_one_id'] = Variable<String>(pairOneId.value);
    }
    if (pairTwoId.present) {
      map['pair_two_id'] = Variable<String>(pairTwoId.value);
    }
    if (winnerPairId.present) {
      map['winner_pair_id'] = Variable<String>(winnerPairId.value);
    }
    if (loserPairId.present) {
      map['loser_pair_id'] = Variable<String>(loserPairId.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MatchesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('courtId: $courtId, ')
          ..write('pairOneId: $pairOneId, ')
          ..write('pairTwoId: $pairTwoId, ')
          ..write('winnerPairId: $winnerPairId, ')
          ..write('loserPairId: $loserPairId, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HistoryEventsTable extends HistoryEvents
    with TableInfo<$HistoryEventsTable, HistoryEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoryEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    type,
    description,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'history_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistoryEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistoryEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoryEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $HistoryEventsTable createAlias(String alias) {
    return $HistoryEventsTable(attachedDatabase, alias);
  }
}

class HistoryEventRow extends DataClass implements Insertable<HistoryEventRow> {
  final String id;
  final String sessionId;
  final int type;
  final String description;
  final DateTime createdAt;
  const HistoryEventRow({
    required this.id,
    required this.sessionId,
    required this.type,
    required this.description,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['type'] = Variable<int>(type);
    map['description'] = Variable<String>(description);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HistoryEventsCompanion toCompanion(bool nullToAbsent) {
    return HistoryEventsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      type: Value(type),
      description: Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory HistoryEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoryEventRow(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      type: serializer.fromJson<int>(json['type']),
      description: serializer.fromJson<String>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'type': serializer.toJson<int>(type),
      'description': serializer.toJson<String>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HistoryEventRow copyWith({
    String? id,
    String? sessionId,
    int? type,
    String? description,
    DateTime? createdAt,
  }) => HistoryEventRow(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    type: type ?? this.type,
    description: description ?? this.description,
    createdAt: createdAt ?? this.createdAt,
  );
  HistoryEventRow copyWithCompanion(HistoryEventsCompanion data) {
    return HistoryEventRow(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      type: data.type.present ? data.type.value : this.type,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoryEventRow(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, type, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoryEventRow &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.type == this.type &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class HistoryEventsCompanion extends UpdateCompanion<HistoryEventRow> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<int> type;
  final Value<String> description;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const HistoryEventsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HistoryEventsCompanion.insert({
    required String id,
    required String sessionId,
    required int type,
    required String description,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       type = Value(type),
       description = Value(description),
       createdAt = Value(createdAt);
  static Insertable<HistoryEventRow> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<int>? type,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HistoryEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<int>? type,
    Value<String>? description,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return HistoryEventsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      type: type ?? this.type,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoryEventsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $PlayersTable players = $PlayersTable(this);
  late final $PlayerQueueEntriesTable playerQueueEntries =
      $PlayerQueueEntriesTable(this);
  late final $PairsTable pairs = $PairsTable(this);
  late final $CourtsTable courts = $CourtsTable(this);
  late final $MatchesTable matches = $MatchesTable(this);
  late final $HistoryEventsTable historyEvents = $HistoryEventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sessions,
    players,
    playerQueueEntries,
    pairs,
    courts,
    matches,
    historyEvents,
  ];
}

typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      required String id,
      required String name,
      required int courtCount,
      required int targetPoints,
      required int status,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> courtCount,
      Value<int> targetPoints,
      Value<int> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get courtCount => $composableBuilder(
    column: $table.courtCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetPoints => $composableBuilder(
    column: $table.targetPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get courtCount => $composableBuilder(
    column: $table.courtCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetPoints => $composableBuilder(
    column: $table.targetPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get courtCount => $composableBuilder(
    column: $table.courtCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetPoints => $composableBuilder(
    column: $table.targetPoints,
    builder: (column) => column,
  );

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          SessionRow,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (
            SessionRow,
            BaseReferences<_$AppDatabase, $SessionsTable, SessionRow>,
          ),
          SessionRow,
          PrefetchHooks Function()
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> courtCount = const Value.absent(),
                Value<int> targetPoints = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                name: name,
                courtCount: courtCount,
                targetPoints: targetPoints,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int courtCount,
                required int targetPoints,
                required int status,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                name: name,
                courtCount: courtCount,
                targetPoints: targetPoints,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      SessionRow,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (SessionRow, BaseReferences<_$AppDatabase, $SessionsTable, SessionRow>),
      SessionRow,
      PrefetchHooks Function()
    >;
typedef $$PlayersTableCreateCompanionBuilder =
    PlayersCompanion Function({
      required String id,
      required String sessionId,
      required String name,
      required int arrivalOrder,
      required int status,
      Value<int> rowid,
    });
typedef $$PlayersTableUpdateCompanionBuilder =
    PlayersCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> name,
      Value<int> arrivalOrder,
      Value<int> status,
      Value<int> rowid,
    });

class $$PlayersTableFilterComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get arrivalOrder => $composableBuilder(
    column: $table.arrivalOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get arrivalOrder => $composableBuilder(
    column: $table.arrivalOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get arrivalOrder => $composableBuilder(
    column: $table.arrivalOrder,
    builder: (column) => column,
  );

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$PlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayersTable,
          PlayerRow,
          $$PlayersTableFilterComposer,
          $$PlayersTableOrderingComposer,
          $$PlayersTableAnnotationComposer,
          $$PlayersTableCreateCompanionBuilder,
          $$PlayersTableUpdateCompanionBuilder,
          (PlayerRow, BaseReferences<_$AppDatabase, $PlayersTable, PlayerRow>),
          PlayerRow,
          PrefetchHooks Function()
        > {
  $$PlayersTableTableManager(_$AppDatabase db, $PlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> arrivalOrder = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlayersCompanion(
                id: id,
                sessionId: sessionId,
                name: name,
                arrivalOrder: arrivalOrder,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String name,
                required int arrivalOrder,
                required int status,
                Value<int> rowid = const Value.absent(),
              }) => PlayersCompanion.insert(
                id: id,
                sessionId: sessionId,
                name: name,
                arrivalOrder: arrivalOrder,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayersTable,
      PlayerRow,
      $$PlayersTableFilterComposer,
      $$PlayersTableOrderingComposer,
      $$PlayersTableAnnotationComposer,
      $$PlayersTableCreateCompanionBuilder,
      $$PlayersTableUpdateCompanionBuilder,
      (PlayerRow, BaseReferences<_$AppDatabase, $PlayersTable, PlayerRow>),
      PlayerRow,
      PrefetchHooks Function()
    >;
typedef $$PlayerQueueEntriesTableCreateCompanionBuilder =
    PlayerQueueEntriesCompanion Function({
      required String sessionId,
      required String playerId,
      required int position,
      Value<int> rowid,
    });
typedef $$PlayerQueueEntriesTableUpdateCompanionBuilder =
    PlayerQueueEntriesCompanion Function({
      Value<String> sessionId,
      Value<String> playerId,
      Value<int> position,
      Value<int> rowid,
    });

class $$PlayerQueueEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $PlayerQueueEntriesTable> {
  $$PlayerQueueEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get playerId => $composableBuilder(
    column: $table.playerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlayerQueueEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayerQueueEntriesTable> {
  $$PlayerQueueEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get playerId => $composableBuilder(
    column: $table.playerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlayerQueueEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayerQueueEntriesTable> {
  $$PlayerQueueEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get playerId =>
      $composableBuilder(column: $table.playerId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$PlayerQueueEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayerQueueEntriesTable,
          PlayerQueueEntryRow,
          $$PlayerQueueEntriesTableFilterComposer,
          $$PlayerQueueEntriesTableOrderingComposer,
          $$PlayerQueueEntriesTableAnnotationComposer,
          $$PlayerQueueEntriesTableCreateCompanionBuilder,
          $$PlayerQueueEntriesTableUpdateCompanionBuilder,
          (
            PlayerQueueEntryRow,
            BaseReferences<
              _$AppDatabase,
              $PlayerQueueEntriesTable,
              PlayerQueueEntryRow
            >,
          ),
          PlayerQueueEntryRow,
          PrefetchHooks Function()
        > {
  $$PlayerQueueEntriesTableTableManager(
    _$AppDatabase db,
    $PlayerQueueEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayerQueueEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayerQueueEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayerQueueEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<String> playerId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlayerQueueEntriesCompanion(
                sessionId: sessionId,
                playerId: playerId,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required String playerId,
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => PlayerQueueEntriesCompanion.insert(
                sessionId: sessionId,
                playerId: playerId,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlayerQueueEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayerQueueEntriesTable,
      PlayerQueueEntryRow,
      $$PlayerQueueEntriesTableFilterComposer,
      $$PlayerQueueEntriesTableOrderingComposer,
      $$PlayerQueueEntriesTableAnnotationComposer,
      $$PlayerQueueEntriesTableCreateCompanionBuilder,
      $$PlayerQueueEntriesTableUpdateCompanionBuilder,
      (
        PlayerQueueEntryRow,
        BaseReferences<
          _$AppDatabase,
          $PlayerQueueEntriesTable,
          PlayerQueueEntryRow
        >,
      ),
      PlayerQueueEntryRow,
      PrefetchHooks Function()
    >;
typedef $$PairsTableCreateCompanionBuilder =
    PairsCompanion Function({
      required String id,
      required String sessionId,
      required String playerOneId,
      required String playerTwoId,
      required int origin,
      required int status,
      required int queueOrder,
      Value<int> rowid,
    });
typedef $$PairsTableUpdateCompanionBuilder =
    PairsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> playerOneId,
      Value<String> playerTwoId,
      Value<int> origin,
      Value<int> status,
      Value<int> queueOrder,
      Value<int> rowid,
    });

class $$PairsTableFilterComposer extends Composer<_$AppDatabase, $PairsTable> {
  $$PairsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get playerOneId => $composableBuilder(
    column: $table.playerOneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get playerTwoId => $composableBuilder(
    column: $table.playerTwoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get queueOrder => $composableBuilder(
    column: $table.queueOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PairsTableOrderingComposer
    extends Composer<_$AppDatabase, $PairsTable> {
  $$PairsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get playerOneId => $composableBuilder(
    column: $table.playerOneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get playerTwoId => $composableBuilder(
    column: $table.playerTwoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get queueOrder => $composableBuilder(
    column: $table.queueOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PairsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PairsTable> {
  $$PairsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get playerOneId => $composableBuilder(
    column: $table.playerOneId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get playerTwoId => $composableBuilder(
    column: $table.playerTwoId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get queueOrder => $composableBuilder(
    column: $table.queueOrder,
    builder: (column) => column,
  );
}

class $$PairsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PairsTable,
          PairRow,
          $$PairsTableFilterComposer,
          $$PairsTableOrderingComposer,
          $$PairsTableAnnotationComposer,
          $$PairsTableCreateCompanionBuilder,
          $$PairsTableUpdateCompanionBuilder,
          (PairRow, BaseReferences<_$AppDatabase, $PairsTable, PairRow>),
          PairRow,
          PrefetchHooks Function()
        > {
  $$PairsTableTableManager(_$AppDatabase db, $PairsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PairsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PairsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PairsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> playerOneId = const Value.absent(),
                Value<String> playerTwoId = const Value.absent(),
                Value<int> origin = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> queueOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PairsCompanion(
                id: id,
                sessionId: sessionId,
                playerOneId: playerOneId,
                playerTwoId: playerTwoId,
                origin: origin,
                status: status,
                queueOrder: queueOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String playerOneId,
                required String playerTwoId,
                required int origin,
                required int status,
                required int queueOrder,
                Value<int> rowid = const Value.absent(),
              }) => PairsCompanion.insert(
                id: id,
                sessionId: sessionId,
                playerOneId: playerOneId,
                playerTwoId: playerTwoId,
                origin: origin,
                status: status,
                queueOrder: queueOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PairsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PairsTable,
      PairRow,
      $$PairsTableFilterComposer,
      $$PairsTableOrderingComposer,
      $$PairsTableAnnotationComposer,
      $$PairsTableCreateCompanionBuilder,
      $$PairsTableUpdateCompanionBuilder,
      (PairRow, BaseReferences<_$AppDatabase, $PairsTable, PairRow>),
      PairRow,
      PrefetchHooks Function()
    >;
typedef $$CourtsTableCreateCompanionBuilder =
    CourtsCompanion Function({
      required String id,
      required String sessionId,
      required String name,
      required int level,
      required int status,
      Value<String?> homePairId,
      Value<String?> challengerPairId,
      Value<String?> matchId,
      Value<int> rowid,
    });
typedef $$CourtsTableUpdateCompanionBuilder =
    CourtsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> name,
      Value<int> level,
      Value<int> status,
      Value<String?> homePairId,
      Value<String?> challengerPairId,
      Value<String?> matchId,
      Value<int> rowid,
    });

class $$CourtsTableFilterComposer
    extends Composer<_$AppDatabase, $CourtsTable> {
  $$CourtsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get homePairId => $composableBuilder(
    column: $table.homePairId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get challengerPairId => $composableBuilder(
    column: $table.challengerPairId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get matchId => $composableBuilder(
    column: $table.matchId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CourtsTableOrderingComposer
    extends Composer<_$AppDatabase, $CourtsTable> {
  $$CourtsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get homePairId => $composableBuilder(
    column: $table.homePairId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get challengerPairId => $composableBuilder(
    column: $table.challengerPairId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matchId => $composableBuilder(
    column: $table.matchId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CourtsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CourtsTable> {
  $$CourtsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get homePairId => $composableBuilder(
    column: $table.homePairId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get challengerPairId => $composableBuilder(
    column: $table.challengerPairId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get matchId =>
      $composableBuilder(column: $table.matchId, builder: (column) => column);
}

class $$CourtsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CourtsTable,
          CourtRow,
          $$CourtsTableFilterComposer,
          $$CourtsTableOrderingComposer,
          $$CourtsTableAnnotationComposer,
          $$CourtsTableCreateCompanionBuilder,
          $$CourtsTableUpdateCompanionBuilder,
          (CourtRow, BaseReferences<_$AppDatabase, $CourtsTable, CourtRow>),
          CourtRow,
          PrefetchHooks Function()
        > {
  $$CourtsTableTableManager(_$AppDatabase db, $CourtsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CourtsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CourtsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CourtsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<String?> homePairId = const Value.absent(),
                Value<String?> challengerPairId = const Value.absent(),
                Value<String?> matchId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CourtsCompanion(
                id: id,
                sessionId: sessionId,
                name: name,
                level: level,
                status: status,
                homePairId: homePairId,
                challengerPairId: challengerPairId,
                matchId: matchId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String name,
                required int level,
                required int status,
                Value<String?> homePairId = const Value.absent(),
                Value<String?> challengerPairId = const Value.absent(),
                Value<String?> matchId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CourtsCompanion.insert(
                id: id,
                sessionId: sessionId,
                name: name,
                level: level,
                status: status,
                homePairId: homePairId,
                challengerPairId: challengerPairId,
                matchId: matchId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CourtsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CourtsTable,
      CourtRow,
      $$CourtsTableFilterComposer,
      $$CourtsTableOrderingComposer,
      $$CourtsTableAnnotationComposer,
      $$CourtsTableCreateCompanionBuilder,
      $$CourtsTableUpdateCompanionBuilder,
      (CourtRow, BaseReferences<_$AppDatabase, $CourtsTable, CourtRow>),
      CourtRow,
      PrefetchHooks Function()
    >;
typedef $$MatchesTableCreateCompanionBuilder =
    MatchesCompanion Function({
      required String id,
      required String sessionId,
      required String courtId,
      required String pairOneId,
      required String pairTwoId,
      Value<String?> winnerPairId,
      Value<String?> loserPairId,
      required int status,
      Value<int> rowid,
    });
typedef $$MatchesTableUpdateCompanionBuilder =
    MatchesCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> courtId,
      Value<String> pairOneId,
      Value<String> pairTwoId,
      Value<String?> winnerPairId,
      Value<String?> loserPairId,
      Value<int> status,
      Value<int> rowid,
    });

class $$MatchesTableFilterComposer
    extends Composer<_$AppDatabase, $MatchesTable> {
  $$MatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get courtId => $composableBuilder(
    column: $table.courtId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pairOneId => $composableBuilder(
    column: $table.pairOneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pairTwoId => $composableBuilder(
    column: $table.pairTwoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get winnerPairId => $composableBuilder(
    column: $table.winnerPairId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loserPairId => $composableBuilder(
    column: $table.loserPairId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $MatchesTable> {
  $$MatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get courtId => $composableBuilder(
    column: $table.courtId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pairOneId => $composableBuilder(
    column: $table.pairOneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pairTwoId => $composableBuilder(
    column: $table.pairTwoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get winnerPairId => $composableBuilder(
    column: $table.winnerPairId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loserPairId => $composableBuilder(
    column: $table.loserPairId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MatchesTable> {
  $$MatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get courtId =>
      $composableBuilder(column: $table.courtId, builder: (column) => column);

  GeneratedColumn<String> get pairOneId =>
      $composableBuilder(column: $table.pairOneId, builder: (column) => column);

  GeneratedColumn<String> get pairTwoId =>
      $composableBuilder(column: $table.pairTwoId, builder: (column) => column);

  GeneratedColumn<String> get winnerPairId => $composableBuilder(
    column: $table.winnerPairId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get loserPairId => $composableBuilder(
    column: $table.loserPairId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$MatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MatchesTable,
          MatchRow,
          $$MatchesTableFilterComposer,
          $$MatchesTableOrderingComposer,
          $$MatchesTableAnnotationComposer,
          $$MatchesTableCreateCompanionBuilder,
          $$MatchesTableUpdateCompanionBuilder,
          (MatchRow, BaseReferences<_$AppDatabase, $MatchesTable, MatchRow>),
          MatchRow,
          PrefetchHooks Function()
        > {
  $$MatchesTableTableManager(_$AppDatabase db, $MatchesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> courtId = const Value.absent(),
                Value<String> pairOneId = const Value.absent(),
                Value<String> pairTwoId = const Value.absent(),
                Value<String?> winnerPairId = const Value.absent(),
                Value<String?> loserPairId = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MatchesCompanion(
                id: id,
                sessionId: sessionId,
                courtId: courtId,
                pairOneId: pairOneId,
                pairTwoId: pairTwoId,
                winnerPairId: winnerPairId,
                loserPairId: loserPairId,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String courtId,
                required String pairOneId,
                required String pairTwoId,
                Value<String?> winnerPairId = const Value.absent(),
                Value<String?> loserPairId = const Value.absent(),
                required int status,
                Value<int> rowid = const Value.absent(),
              }) => MatchesCompanion.insert(
                id: id,
                sessionId: sessionId,
                courtId: courtId,
                pairOneId: pairOneId,
                pairTwoId: pairTwoId,
                winnerPairId: winnerPairId,
                loserPairId: loserPairId,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MatchesTable,
      MatchRow,
      $$MatchesTableFilterComposer,
      $$MatchesTableOrderingComposer,
      $$MatchesTableAnnotationComposer,
      $$MatchesTableCreateCompanionBuilder,
      $$MatchesTableUpdateCompanionBuilder,
      (MatchRow, BaseReferences<_$AppDatabase, $MatchesTable, MatchRow>),
      MatchRow,
      PrefetchHooks Function()
    >;
typedef $$HistoryEventsTableCreateCompanionBuilder =
    HistoryEventsCompanion Function({
      required String id,
      required String sessionId,
      required int type,
      required String description,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$HistoryEventsTableUpdateCompanionBuilder =
    HistoryEventsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<int> type,
      Value<String> description,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$HistoryEventsTableFilterComposer
    extends Composer<_$AppDatabase, $HistoryEventsTable> {
  $$HistoryEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HistoryEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $HistoryEventsTable> {
  $$HistoryEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HistoryEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistoryEventsTable> {
  $$HistoryEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$HistoryEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HistoryEventsTable,
          HistoryEventRow,
          $$HistoryEventsTableFilterComposer,
          $$HistoryEventsTableOrderingComposer,
          $$HistoryEventsTableAnnotationComposer,
          $$HistoryEventsTableCreateCompanionBuilder,
          $$HistoryEventsTableUpdateCompanionBuilder,
          (
            HistoryEventRow,
            BaseReferences<_$AppDatabase, $HistoryEventsTable, HistoryEventRow>,
          ),
          HistoryEventRow,
          PrefetchHooks Function()
        > {
  $$HistoryEventsTableTableManager(_$AppDatabase db, $HistoryEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoryEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoryEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistoryEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HistoryEventsCompanion(
                id: id,
                sessionId: sessionId,
                type: type,
                description: description,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required int type,
                required String description,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => HistoryEventsCompanion.insert(
                id: id,
                sessionId: sessionId,
                type: type,
                description: description,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HistoryEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HistoryEventsTable,
      HistoryEventRow,
      $$HistoryEventsTableFilterComposer,
      $$HistoryEventsTableOrderingComposer,
      $$HistoryEventsTableAnnotationComposer,
      $$HistoryEventsTableCreateCompanionBuilder,
      $$HistoryEventsTableUpdateCompanionBuilder,
      (
        HistoryEventRow,
        BaseReferences<_$AppDatabase, $HistoryEventsTable, HistoryEventRow>,
      ),
      HistoryEventRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$PlayersTableTableManager get players =>
      $$PlayersTableTableManager(_db, _db.players);
  $$PlayerQueueEntriesTableTableManager get playerQueueEntries =>
      $$PlayerQueueEntriesTableTableManager(_db, _db.playerQueueEntries);
  $$PairsTableTableManager get pairs =>
      $$PairsTableTableManager(_db, _db.pairs);
  $$CourtsTableTableManager get courts =>
      $$CourtsTableTableManager(_db, _db.courts);
  $$MatchesTableTableManager get matches =>
      $$MatchesTableTableManager(_db, _db.matches);
  $$HistoryEventsTableTableManager get historyEvents =>
      $$HistoryEventsTableTableManager(_db, _db.historyEvents);
}
