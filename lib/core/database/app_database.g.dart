// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AccountsTableTable extends AccountsTable
    with TableInfo<$AccountsTableTable, AccountsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _initialBalanceMeta = const VerificationMeta(
    'initialBalance',
  );
  @override
  late final GeneratedColumn<int> initialBalance = GeneratedColumn<int>(
    'initial_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    initialBalance,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('initial_balance')) {
      context.handle(
        _initialBalanceMeta,
        initialBalance.isAcceptableOrUnknown(
          data['initial_balance']!,
          _initialBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_initialBalanceMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      initialBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}initial_balance'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $AccountsTableTable createAlias(String alias) {
    return $AccountsTableTable(attachedDatabase, alias);
  }
}

class AccountsTableData extends DataClass
    implements Insertable<AccountsTableData> {
  final int id;
  final String name;
  final String type;
  final int initialBalance;
  final bool archived;
  const AccountsTableData({
    required this.id,
    required this.name,
    required this.type,
    required this.initialBalance,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['initial_balance'] = Variable<int>(initialBalance);
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  AccountsTableCompanion toCompanion(bool nullToAbsent) {
    return AccountsTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      initialBalance: Value(initialBalance),
      archived: Value(archived),
    );
  }

  factory AccountsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountsTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      initialBalance: serializer.fromJson<int>(json['initialBalance']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'initialBalance': serializer.toJson<int>(initialBalance),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  AccountsTableData copyWith({
    int? id,
    String? name,
    String? type,
    int? initialBalance,
    bool? archived,
  }) => AccountsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    initialBalance: initialBalance ?? this.initialBalance,
    archived: archived ?? this.archived,
  );
  AccountsTableData copyWithCompanion(AccountsTableCompanion data) {
    return AccountsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      initialBalance: data.initialBalance.present
          ? data.initialBalance.value
          : this.initialBalance,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, initialBalance, archived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.initialBalance == this.initialBalance &&
          other.archived == this.archived);
}

class AccountsTableCompanion extends UpdateCompanion<AccountsTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<int> initialBalance;
  final Value<bool> archived;
  const AccountsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.initialBalance = const Value.absent(),
    this.archived = const Value.absent(),
  });
  AccountsTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    required int initialBalance,
    this.archived = const Value.absent(),
  }) : name = Value(name),
       type = Value(type),
       initialBalance = Value(initialBalance);
  static Insertable<AccountsTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? initialBalance,
    Expression<bool>? archived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (initialBalance != null) 'initial_balance': initialBalance,
      if (archived != null) 'archived': archived,
    });
  }

  AccountsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? type,
    Value<int>? initialBalance,
    Value<bool>? archived,
  }) {
    return AccountsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      initialBalance: initialBalance ?? this.initialBalance,
      archived: archived ?? this.archived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (initialBalance.present) {
      map['initial_balance'] = Variable<int>(initialBalance.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    key,
    name,
    kind,
    icon,
    color,
    isDefault,
    isActive,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoriesTableData extends DataClass
    implements Insertable<CategoriesTableData> {
  final int id;
  final String? key;
  final String? name;
  final String kind;
  final String icon;
  final int color;
  final bool isDefault;
  final bool isActive;
  final int sortOrder;
  const CategoriesTableData({
    required this.id,
    this.key,
    this.name,
    required this.kind,
    required this.icon,
    required this.color,
    required this.isDefault,
    required this.isActive,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || key != null) {
      map['key'] = Variable<String>(key);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['kind'] = Variable<String>(kind);
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<int>(color);
    map['is_default'] = Variable<bool>(isDefault);
    map['is_active'] = Variable<bool>(isActive);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      key: key == null && nullToAbsent ? const Value.absent() : Value(key),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      kind: Value(kind),
      icon: Value(icon),
      color: Value(color),
      isDefault: Value(isDefault),
      isActive: Value(isActive),
      sortOrder: Value(sortOrder),
    );
  }

  factory CategoriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesTableData(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String?>(json['key']),
      name: serializer.fromJson<String?>(json['name']),
      kind: serializer.fromJson<String>(json['kind']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String?>(key),
      'name': serializer.toJson<String?>(name),
      'kind': serializer.toJson<String>(kind),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<int>(color),
      'isDefault': serializer.toJson<bool>(isDefault),
      'isActive': serializer.toJson<bool>(isActive),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  CategoriesTableData copyWith({
    int? id,
    Value<String?> key = const Value.absent(),
    Value<String?> name = const Value.absent(),
    String? kind,
    String? icon,
    int? color,
    bool? isDefault,
    bool? isActive,
    int? sortOrder,
  }) => CategoriesTableData(
    id: id ?? this.id,
    key: key.present ? key.value : this.key,
    name: name.present ? name.value : this.name,
    kind: kind ?? this.kind,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    isDefault: isDefault ?? this.isDefault,
    isActive: isActive ?? this.isActive,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  CategoriesTableData copyWithCompanion(CategoriesTableCompanion data) {
    return CategoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableData(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isDefault: $isDefault, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    key,
    name,
    kind,
    icon,
    color,
    isDefault,
    isActive,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesTableData &&
          other.id == this.id &&
          other.key == this.key &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.isDefault == this.isDefault &&
          other.isActive == this.isActive &&
          other.sortOrder == this.sortOrder);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoriesTableData> {
  final Value<int> id;
  final Value<String?> key;
  final Value<String?> name;
  final Value<String> kind;
  final Value<String> icon;
  final Value<int> color;
  final Value<bool> isDefault;
  final Value<bool> isActive;
  final Value<int> sortOrder;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.name = const Value.absent(),
    required String kind,
    required String icon,
    required int color,
    this.isDefault = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : kind = Value(kind),
       icon = Value(icon),
       color = Value(color);
  static Insertable<CategoriesTableData> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<bool>? isDefault,
    Expression<bool>? isActive,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (isDefault != null) 'is_default': isDefault,
      if (isActive != null) 'is_active': isActive,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  CategoriesTableCompanion copyWith({
    Value<int>? id,
    Value<String?>? key,
    Value<String?>? name,
    Value<String>? kind,
    Value<String>? icon,
    Value<int>? color,
    Value<bool>? isDefault,
    Value<bool>? isActive,
    Value<int>? sortOrder,
  }) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isDefault: $isDefault, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $DebtsTableTable extends DebtsTable
    with TableInfo<$DebtsTableTable, DebtsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creditorMeta = const VerificationMeta(
    'creditor',
  );
  @override
  late final GeneratedColumn<String> creditor = GeneratedColumn<String>(
    'creditor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _initialAmountMeta = const VerificationMeta(
    'initialAmount',
  );
  @override
  late final GeneratedColumn<int> initialAmount = GeneratedColumn<int>(
    'initial_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _interestRateBpMeta = const VerificationMeta(
    'interestRateBp',
  );
  @override
  late final GeneratedColumn<int> interestRateBp = GeneratedColumn<int>(
    'interest_rate_bp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minPaymentMeta = const VerificationMeta(
    'minPayment',
  );
  @override
  late final GeneratedColumn<int> minPayment = GeneratedColumn<int>(
    'min_payment',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDayMeta = const VerificationMeta('dueDay');
  @override
  late final GeneratedColumn<int> dueDay = GeneratedColumn<int>(
    'due_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    creditor,
    initialAmount,
    interestRateBp,
    minPayment,
    dueDay,
    priority,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debts';
  @override
  VerificationContext validateIntegrity(
    Insertable<DebtsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('creditor')) {
      context.handle(
        _creditorMeta,
        creditor.isAcceptableOrUnknown(data['creditor']!, _creditorMeta),
      );
    } else if (isInserting) {
      context.missing(_creditorMeta);
    }
    if (data.containsKey('initial_amount')) {
      context.handle(
        _initialAmountMeta,
        initialAmount.isAcceptableOrUnknown(
          data['initial_amount']!,
          _initialAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_initialAmountMeta);
    }
    if (data.containsKey('interest_rate_bp')) {
      context.handle(
        _interestRateBpMeta,
        interestRateBp.isAcceptableOrUnknown(
          data['interest_rate_bp']!,
          _interestRateBpMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_interestRateBpMeta);
    }
    if (data.containsKey('min_payment')) {
      context.handle(
        _minPaymentMeta,
        minPayment.isAcceptableOrUnknown(data['min_payment']!, _minPaymentMeta),
      );
    } else if (isInserting) {
      context.missing(_minPaymentMeta);
    }
    if (data.containsKey('due_day')) {
      context.handle(
        _dueDayMeta,
        dueDay.isAcceptableOrUnknown(data['due_day']!, _dueDayMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDayMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DebtsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DebtsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      creditor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creditor'],
      )!,
      initialAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}initial_amount'],
      )!,
      interestRateBp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interest_rate_bp'],
      )!,
      minPayment: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_payment'],
      )!,
      dueDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_day'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $DebtsTableTable createAlias(String alias) {
    return $DebtsTableTable(attachedDatabase, alias);
  }
}

class DebtsTableData extends DataClass implements Insertable<DebtsTableData> {
  final int id;
  final String name;
  final String creditor;
  final int initialAmount;
  final int interestRateBp;
  final int minPayment;
  final int dueDay;
  final int priority;
  final bool archived;
  const DebtsTableData({
    required this.id,
    required this.name,
    required this.creditor,
    required this.initialAmount,
    required this.interestRateBp,
    required this.minPayment,
    required this.dueDay,
    required this.priority,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['creditor'] = Variable<String>(creditor);
    map['initial_amount'] = Variable<int>(initialAmount);
    map['interest_rate_bp'] = Variable<int>(interestRateBp);
    map['min_payment'] = Variable<int>(minPayment);
    map['due_day'] = Variable<int>(dueDay);
    map['priority'] = Variable<int>(priority);
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  DebtsTableCompanion toCompanion(bool nullToAbsent) {
    return DebtsTableCompanion(
      id: Value(id),
      name: Value(name),
      creditor: Value(creditor),
      initialAmount: Value(initialAmount),
      interestRateBp: Value(interestRateBp),
      minPayment: Value(minPayment),
      dueDay: Value(dueDay),
      priority: Value(priority),
      archived: Value(archived),
    );
  }

  factory DebtsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DebtsTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      creditor: serializer.fromJson<String>(json['creditor']),
      initialAmount: serializer.fromJson<int>(json['initialAmount']),
      interestRateBp: serializer.fromJson<int>(json['interestRateBp']),
      minPayment: serializer.fromJson<int>(json['minPayment']),
      dueDay: serializer.fromJson<int>(json['dueDay']),
      priority: serializer.fromJson<int>(json['priority']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'creditor': serializer.toJson<String>(creditor),
      'initialAmount': serializer.toJson<int>(initialAmount),
      'interestRateBp': serializer.toJson<int>(interestRateBp),
      'minPayment': serializer.toJson<int>(minPayment),
      'dueDay': serializer.toJson<int>(dueDay),
      'priority': serializer.toJson<int>(priority),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  DebtsTableData copyWith({
    int? id,
    String? name,
    String? creditor,
    int? initialAmount,
    int? interestRateBp,
    int? minPayment,
    int? dueDay,
    int? priority,
    bool? archived,
  }) => DebtsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    creditor: creditor ?? this.creditor,
    initialAmount: initialAmount ?? this.initialAmount,
    interestRateBp: interestRateBp ?? this.interestRateBp,
    minPayment: minPayment ?? this.minPayment,
    dueDay: dueDay ?? this.dueDay,
    priority: priority ?? this.priority,
    archived: archived ?? this.archived,
  );
  DebtsTableData copyWithCompanion(DebtsTableCompanion data) {
    return DebtsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      creditor: data.creditor.present ? data.creditor.value : this.creditor,
      initialAmount: data.initialAmount.present
          ? data.initialAmount.value
          : this.initialAmount,
      interestRateBp: data.interestRateBp.present
          ? data.interestRateBp.value
          : this.interestRateBp,
      minPayment: data.minPayment.present
          ? data.minPayment.value
          : this.minPayment,
      dueDay: data.dueDay.present ? data.dueDay.value : this.dueDay,
      priority: data.priority.present ? data.priority.value : this.priority,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DebtsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('creditor: $creditor, ')
          ..write('initialAmount: $initialAmount, ')
          ..write('interestRateBp: $interestRateBp, ')
          ..write('minPayment: $minPayment, ')
          ..write('dueDay: $dueDay, ')
          ..write('priority: $priority, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    creditor,
    initialAmount,
    interestRateBp,
    minPayment,
    dueDay,
    priority,
    archived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DebtsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.creditor == this.creditor &&
          other.initialAmount == this.initialAmount &&
          other.interestRateBp == this.interestRateBp &&
          other.minPayment == this.minPayment &&
          other.dueDay == this.dueDay &&
          other.priority == this.priority &&
          other.archived == this.archived);
}

class DebtsTableCompanion extends UpdateCompanion<DebtsTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> creditor;
  final Value<int> initialAmount;
  final Value<int> interestRateBp;
  final Value<int> minPayment;
  final Value<int> dueDay;
  final Value<int> priority;
  final Value<bool> archived;
  const DebtsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.creditor = const Value.absent(),
    this.initialAmount = const Value.absent(),
    this.interestRateBp = const Value.absent(),
    this.minPayment = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.priority = const Value.absent(),
    this.archived = const Value.absent(),
  });
  DebtsTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String creditor,
    required int initialAmount,
    required int interestRateBp,
    required int minPayment,
    required int dueDay,
    required int priority,
    this.archived = const Value.absent(),
  }) : name = Value(name),
       creditor = Value(creditor),
       initialAmount = Value(initialAmount),
       interestRateBp = Value(interestRateBp),
       minPayment = Value(minPayment),
       dueDay = Value(dueDay),
       priority = Value(priority);
  static Insertable<DebtsTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? creditor,
    Expression<int>? initialAmount,
    Expression<int>? interestRateBp,
    Expression<int>? minPayment,
    Expression<int>? dueDay,
    Expression<int>? priority,
    Expression<bool>? archived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (creditor != null) 'creditor': creditor,
      if (initialAmount != null) 'initial_amount': initialAmount,
      if (interestRateBp != null) 'interest_rate_bp': interestRateBp,
      if (minPayment != null) 'min_payment': minPayment,
      if (dueDay != null) 'due_day': dueDay,
      if (priority != null) 'priority': priority,
      if (archived != null) 'archived': archived,
    });
  }

  DebtsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? creditor,
    Value<int>? initialAmount,
    Value<int>? interestRateBp,
    Value<int>? minPayment,
    Value<int>? dueDay,
    Value<int>? priority,
    Value<bool>? archived,
  }) {
    return DebtsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      creditor: creditor ?? this.creditor,
      initialAmount: initialAmount ?? this.initialAmount,
      interestRateBp: interestRateBp ?? this.interestRateBp,
      minPayment: minPayment ?? this.minPayment,
      dueDay: dueDay ?? this.dueDay,
      priority: priority ?? this.priority,
      archived: archived ?? this.archived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (creditor.present) {
      map['creditor'] = Variable<String>(creditor.value);
    }
    if (initialAmount.present) {
      map['initial_amount'] = Variable<int>(initialAmount.value);
    }
    if (interestRateBp.present) {
      map['interest_rate_bp'] = Variable<int>(interestRateBp.value);
    }
    if (minPayment.present) {
      map['min_payment'] = Variable<int>(minPayment.value);
    }
    if (dueDay.present) {
      map['due_day'] = Variable<int>(dueDay.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('creditor: $creditor, ')
          ..write('initialAmount: $initialAmount, ')
          ..write('interestRateBp: $interestRateBp, ')
          ..write('minPayment: $minPayment, ')
          ..write('dueDay: $dueDay, ')
          ..write('priority: $priority, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }
}

class $ReceivablesTableTable extends ReceivablesTable
    with TableInfo<$ReceivablesTableTable, ReceivablesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceivablesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _personMeta = const VerificationMeta('person');
  @override
  late final GeneratedColumn<String> person = GeneratedColumn<String>(
    'person',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _initialAmountMeta = const VerificationMeta(
    'initialAmount',
  );
  @override
  late final GeneratedColumn<int> initialAmount = GeneratedColumn<int>(
    'initial_amount',
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
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    person,
    initialAmount,
    createdAt,
    note,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receivables';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReceivablesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('person')) {
      context.handle(
        _personMeta,
        person.isAcceptableOrUnknown(data['person']!, _personMeta),
      );
    } else if (isInserting) {
      context.missing(_personMeta);
    }
    if (data.containsKey('initial_amount')) {
      context.handle(
        _initialAmountMeta,
        initialAmount.isAcceptableOrUnknown(
          data['initial_amount']!,
          _initialAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_initialAmountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReceivablesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReceivablesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      person: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person'],
      )!,
      initialAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}initial_amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $ReceivablesTableTable createAlias(String alias) {
    return $ReceivablesTableTable(attachedDatabase, alias);
  }
}

class ReceivablesTableData extends DataClass
    implements Insertable<ReceivablesTableData> {
  final int id;
  final String person;
  final int initialAmount;
  final DateTime createdAt;
  final String note;
  final bool archived;
  const ReceivablesTableData({
    required this.id,
    required this.person,
    required this.initialAmount,
    required this.createdAt,
    required this.note,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['person'] = Variable<String>(person);
    map['initial_amount'] = Variable<int>(initialAmount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['note'] = Variable<String>(note);
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  ReceivablesTableCompanion toCompanion(bool nullToAbsent) {
    return ReceivablesTableCompanion(
      id: Value(id),
      person: Value(person),
      initialAmount: Value(initialAmount),
      createdAt: Value(createdAt),
      note: Value(note),
      archived: Value(archived),
    );
  }

  factory ReceivablesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReceivablesTableData(
      id: serializer.fromJson<int>(json['id']),
      person: serializer.fromJson<String>(json['person']),
      initialAmount: serializer.fromJson<int>(json['initialAmount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      note: serializer.fromJson<String>(json['note']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'person': serializer.toJson<String>(person),
      'initialAmount': serializer.toJson<int>(initialAmount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'note': serializer.toJson<String>(note),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  ReceivablesTableData copyWith({
    int? id,
    String? person,
    int? initialAmount,
    DateTime? createdAt,
    String? note,
    bool? archived,
  }) => ReceivablesTableData(
    id: id ?? this.id,
    person: person ?? this.person,
    initialAmount: initialAmount ?? this.initialAmount,
    createdAt: createdAt ?? this.createdAt,
    note: note ?? this.note,
    archived: archived ?? this.archived,
  );
  ReceivablesTableData copyWithCompanion(ReceivablesTableCompanion data) {
    return ReceivablesTableData(
      id: data.id.present ? data.id.value : this.id,
      person: data.person.present ? data.person.value : this.person,
      initialAmount: data.initialAmount.present
          ? data.initialAmount.value
          : this.initialAmount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      note: data.note.present ? data.note.value : this.note,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReceivablesTableData(')
          ..write('id: $id, ')
          ..write('person: $person, ')
          ..write('initialAmount: $initialAmount, ')
          ..write('createdAt: $createdAt, ')
          ..write('note: $note, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, person, initialAmount, createdAt, note, archived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReceivablesTableData &&
          other.id == this.id &&
          other.person == this.person &&
          other.initialAmount == this.initialAmount &&
          other.createdAt == this.createdAt &&
          other.note == this.note &&
          other.archived == this.archived);
}

class ReceivablesTableCompanion extends UpdateCompanion<ReceivablesTableData> {
  final Value<int> id;
  final Value<String> person;
  final Value<int> initialAmount;
  final Value<DateTime> createdAt;
  final Value<String> note;
  final Value<bool> archived;
  const ReceivablesTableCompanion({
    this.id = const Value.absent(),
    this.person = const Value.absent(),
    this.initialAmount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.note = const Value.absent(),
    this.archived = const Value.absent(),
  });
  ReceivablesTableCompanion.insert({
    this.id = const Value.absent(),
    required String person,
    required int initialAmount,
    required DateTime createdAt,
    this.note = const Value.absent(),
    this.archived = const Value.absent(),
  }) : person = Value(person),
       initialAmount = Value(initialAmount),
       createdAt = Value(createdAt);
  static Insertable<ReceivablesTableData> custom({
    Expression<int>? id,
    Expression<String>? person,
    Expression<int>? initialAmount,
    Expression<DateTime>? createdAt,
    Expression<String>? note,
    Expression<bool>? archived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (person != null) 'person': person,
      if (initialAmount != null) 'initial_amount': initialAmount,
      if (createdAt != null) 'created_at': createdAt,
      if (note != null) 'note': note,
      if (archived != null) 'archived': archived,
    });
  }

  ReceivablesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? person,
    Value<int>? initialAmount,
    Value<DateTime>? createdAt,
    Value<String>? note,
    Value<bool>? archived,
  }) {
    return ReceivablesTableCompanion(
      id: id ?? this.id,
      person: person ?? this.person,
      initialAmount: initialAmount ?? this.initialAmount,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
      archived: archived ?? this.archived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (person.present) {
      map['person'] = Variable<String>(person.value);
    }
    if (initialAmount.present) {
      map['initial_amount'] = Variable<int>(initialAmount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceivablesTableCompanion(')
          ..write('id: $id, ')
          ..write('person: $person, ')
          ..write('initialAmount: $initialAmount, ')
          ..write('createdAt: $createdAt, ')
          ..write('note: $note, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }
}

class $SavingsGoalsTableTable extends SavingsGoalsTable
    with TableInfo<$SavingsGoalsTableTable, SavingsGoalsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsGoalsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetAmountMeta = const VerificationMeta(
    'targetAmount',
  );
  @override
  late final GeneratedColumn<int> targetAmount = GeneratedColumn<int>(
    'target_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    targetAmount,
    targetDate,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsGoalsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_amount')) {
      context.handle(
        _targetAmountMeta,
        targetAmount.isAcceptableOrUnknown(
          data['target_amount']!,
          _targetAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsGoalsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsGoalsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_amount'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $SavingsGoalsTableTable createAlias(String alias) {
    return $SavingsGoalsTableTable(attachedDatabase, alias);
  }
}

class SavingsGoalsTableData extends DataClass
    implements Insertable<SavingsGoalsTableData> {
  final int id;
  final String name;
  final int targetAmount;
  final DateTime? targetDate;
  final bool archived;
  const SavingsGoalsTableData({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.targetDate,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['target_amount'] = Variable<int>(targetAmount);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  SavingsGoalsTableCompanion toCompanion(bool nullToAbsent) {
    return SavingsGoalsTableCompanion(
      id: Value(id),
      name: Value(name),
      targetAmount: Value(targetAmount),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      archived: Value(archived),
    );
  }

  factory SavingsGoalsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsGoalsTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      targetAmount: serializer.fromJson<int>(json['targetAmount']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'targetAmount': serializer.toJson<int>(targetAmount),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  SavingsGoalsTableData copyWith({
    int? id,
    String? name,
    int? targetAmount,
    Value<DateTime?> targetDate = const Value.absent(),
    bool? archived,
  }) => SavingsGoalsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    targetAmount: targetAmount ?? this.targetAmount,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    archived: archived ?? this.archived,
  );
  SavingsGoalsTableData copyWithCompanion(SavingsGoalsTableCompanion data) {
    return SavingsGoalsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, targetAmount, targetDate, archived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsGoalsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.targetAmount == this.targetAmount &&
          other.targetDate == this.targetDate &&
          other.archived == this.archived);
}

class SavingsGoalsTableCompanion
    extends UpdateCompanion<SavingsGoalsTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> targetAmount;
  final Value<DateTime?> targetDate;
  final Value<bool> archived;
  const SavingsGoalsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.archived = const Value.absent(),
  });
  SavingsGoalsTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int targetAmount,
    this.targetDate = const Value.absent(),
    this.archived = const Value.absent(),
  }) : name = Value(name),
       targetAmount = Value(targetAmount);
  static Insertable<SavingsGoalsTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? targetAmount,
    Expression<DateTime>? targetDate,
    Expression<bool>? archived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (targetDate != null) 'target_date': targetDate,
      if (archived != null) 'archived': archived,
    });
  }

  SavingsGoalsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? targetAmount,
    Value<DateTime?>? targetDate,
    Value<bool>? archived,
  }) {
    return SavingsGoalsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      targetDate: targetDate ?? this.targetDate,
      archived: archived ?? this.archived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<int>(targetAmount.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }
}

class $AllocationRulesTableTable extends AllocationRulesTable
    with TableInfo<$AllocationRulesTableTable, AllocationRulesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AllocationRulesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<String> target = GeneratedColumn<String>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _percentMeta = const VerificationMeta(
    'percent',
  );
  @override
  late final GeneratedColumn<int> percent = GeneratedColumn<int>(
    'percent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, target, percent];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'allocation_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<AllocationRulesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('percent')) {
      context.handle(
        _percentMeta,
        percent.isAcceptableOrUnknown(data['percent']!, _percentMeta),
      );
    } else if (isInserting) {
      context.missing(_percentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AllocationRulesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AllocationRulesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target'],
      )!,
      percent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}percent'],
      )!,
    );
  }

  @override
  $AllocationRulesTableTable createAlias(String alias) {
    return $AllocationRulesTableTable(attachedDatabase, alias);
  }
}

class AllocationRulesTableData extends DataClass
    implements Insertable<AllocationRulesTableData> {
  final int id;
  final String target;
  final int percent;
  const AllocationRulesTableData({
    required this.id,
    required this.target,
    required this.percent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['target'] = Variable<String>(target);
    map['percent'] = Variable<int>(percent);
    return map;
  }

  AllocationRulesTableCompanion toCompanion(bool nullToAbsent) {
    return AllocationRulesTableCompanion(
      id: Value(id),
      target: Value(target),
      percent: Value(percent),
    );
  }

  factory AllocationRulesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AllocationRulesTableData(
      id: serializer.fromJson<int>(json['id']),
      target: serializer.fromJson<String>(json['target']),
      percent: serializer.fromJson<int>(json['percent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'target': serializer.toJson<String>(target),
      'percent': serializer.toJson<int>(percent),
    };
  }

  AllocationRulesTableData copyWith({int? id, String? target, int? percent}) =>
      AllocationRulesTableData(
        id: id ?? this.id,
        target: target ?? this.target,
        percent: percent ?? this.percent,
      );
  AllocationRulesTableData copyWithCompanion(
    AllocationRulesTableCompanion data,
  ) {
    return AllocationRulesTableData(
      id: data.id.present ? data.id.value : this.id,
      target: data.target.present ? data.target.value : this.target,
      percent: data.percent.present ? data.percent.value : this.percent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AllocationRulesTableData(')
          ..write('id: $id, ')
          ..write('target: $target, ')
          ..write('percent: $percent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, target, percent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AllocationRulesTableData &&
          other.id == this.id &&
          other.target == this.target &&
          other.percent == this.percent);
}

class AllocationRulesTableCompanion
    extends UpdateCompanion<AllocationRulesTableData> {
  final Value<int> id;
  final Value<String> target;
  final Value<int> percent;
  const AllocationRulesTableCompanion({
    this.id = const Value.absent(),
    this.target = const Value.absent(),
    this.percent = const Value.absent(),
  });
  AllocationRulesTableCompanion.insert({
    this.id = const Value.absent(),
    required String target,
    required int percent,
  }) : target = Value(target),
       percent = Value(percent);
  static Insertable<AllocationRulesTableData> custom({
    Expression<int>? id,
    Expression<String>? target,
    Expression<int>? percent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (target != null) 'target': target,
      if (percent != null) 'percent': percent,
    });
  }

  AllocationRulesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? target,
    Value<int>? percent,
  }) {
    return AllocationRulesTableCompanion(
      id: id ?? this.id,
      target: target ?? this.target,
      percent: percent ?? this.percent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (target.present) {
      map['target'] = Variable<String>(target.value);
    }
    if (percent.present) {
      map['percent'] = Variable<int>(percent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AllocationRulesTableCompanion(')
          ..write('id: $id, ')
          ..write('target: $target, ')
          ..write('percent: $percent')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTableTable extends TransactionsTable
    with TableInfo<$TransactionsTableTable, TransactionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _toAccountIdMeta = const VerificationMeta(
    'toAccountId',
  );
  @override
  late final GeneratedColumn<int> toAccountId = GeneratedColumn<int>(
    'to_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _debtIdMeta = const VerificationMeta('debtId');
  @override
  late final GeneratedColumn<int> debtId = GeneratedColumn<int>(
    'debt_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES debts (id)',
    ),
  );
  static const VerificationMeta _receivableIdMeta = const VerificationMeta(
    'receivableId',
  );
  @override
  late final GeneratedColumn<int> receivableId = GeneratedColumn<int>(
    'receivable_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES receivables (id)',
    ),
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<int> goalId = GeneratedColumn<int>(
    'goal_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES savings_goals (id)',
    ),
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    amount,
    accountId,
    toAccountId,
    categoryId,
    debtId,
    receivableId,
    goalId,
    occurredAt,
    note,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('to_account_id')) {
      context.handle(
        _toAccountIdMeta,
        toAccountId.isAcceptableOrUnknown(
          data['to_account_id']!,
          _toAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('debt_id')) {
      context.handle(
        _debtIdMeta,
        debtId.isAcceptableOrUnknown(data['debt_id']!, _debtIdMeta),
      );
    }
    if (data.containsKey('receivable_id')) {
      context.handle(
        _receivableIdMeta,
        receivableId.isAcceptableOrUnknown(
          data['receivable_id']!,
          _receivableIdMeta,
        ),
      );
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      toAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_account_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      debtId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}debt_id'],
      ),
      receivableId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receivable_id'],
      ),
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_id'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $TransactionsTableTable createAlias(String alias) {
    return $TransactionsTableTable(attachedDatabase, alias);
  }
}

class TransactionsTableData extends DataClass
    implements Insertable<TransactionsTableData> {
  final int id;
  final String kind;
  final int amount;
  final int accountId;
  final int? toAccountId;
  final int? categoryId;
  final int? debtId;
  final int? receivableId;
  final int? goalId;
  final DateTime occurredAt;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const TransactionsTableData({
    required this.id,
    required this.kind,
    required this.amount,
    required this.accountId,
    this.toAccountId,
    this.categoryId,
    this.debtId,
    this.receivableId,
    this.goalId,
    required this.occurredAt,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kind'] = Variable<String>(kind);
    map['amount'] = Variable<int>(amount);
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || toAccountId != null) {
      map['to_account_id'] = Variable<int>(toAccountId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || debtId != null) {
      map['debt_id'] = Variable<int>(debtId);
    }
    if (!nullToAbsent || receivableId != null) {
      map['receivable_id'] = Variable<int>(receivableId);
    }
    if (!nullToAbsent || goalId != null) {
      map['goal_id'] = Variable<int>(goalId);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['note'] = Variable<String>(note);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  TransactionsTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionsTableCompanion(
      id: Value(id),
      kind: Value(kind),
      amount: Value(amount),
      accountId: Value(accountId),
      toAccountId: toAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(toAccountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      debtId: debtId == null && nullToAbsent
          ? const Value.absent()
          : Value(debtId),
      receivableId: receivableId == null && nullToAbsent
          ? const Value.absent()
          : Value(receivableId),
      goalId: goalId == null && nullToAbsent
          ? const Value.absent()
          : Value(goalId),
      occurredAt: Value(occurredAt),
      note: Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory TransactionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionsTableData(
      id: serializer.fromJson<int>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      amount: serializer.fromJson<int>(json['amount']),
      accountId: serializer.fromJson<int>(json['accountId']),
      toAccountId: serializer.fromJson<int?>(json['toAccountId']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      debtId: serializer.fromJson<int?>(json['debtId']),
      receivableId: serializer.fromJson<int?>(json['receivableId']),
      goalId: serializer.fromJson<int?>(json['goalId']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      note: serializer.fromJson<String>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(kind),
      'amount': serializer.toJson<int>(amount),
      'accountId': serializer.toJson<int>(accountId),
      'toAccountId': serializer.toJson<int?>(toAccountId),
      'categoryId': serializer.toJson<int?>(categoryId),
      'debtId': serializer.toJson<int?>(debtId),
      'receivableId': serializer.toJson<int?>(receivableId),
      'goalId': serializer.toJson<int?>(goalId),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'note': serializer.toJson<String>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  TransactionsTableData copyWith({
    int? id,
    String? kind,
    int? amount,
    int? accountId,
    Value<int?> toAccountId = const Value.absent(),
    Value<int?> categoryId = const Value.absent(),
    Value<int?> debtId = const Value.absent(),
    Value<int?> receivableId = const Value.absent(),
    Value<int?> goalId = const Value.absent(),
    DateTime? occurredAt,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => TransactionsTableData(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    amount: amount ?? this.amount,
    accountId: accountId ?? this.accountId,
    toAccountId: toAccountId.present ? toAccountId.value : this.toAccountId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    debtId: debtId.present ? debtId.value : this.debtId,
    receivableId: receivableId.present ? receivableId.value : this.receivableId,
    goalId: goalId.present ? goalId.value : this.goalId,
    occurredAt: occurredAt ?? this.occurredAt,
    note: note ?? this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  TransactionsTableData copyWithCompanion(TransactionsTableCompanion data) {
    return TransactionsTableData(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      amount: data.amount.present ? data.amount.value : this.amount,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      toAccountId: data.toAccountId.present
          ? data.toAccountId.value
          : this.toAccountId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      debtId: data.debtId.present ? data.debtId.value : this.debtId,
      receivableId: data.receivableId.present
          ? data.receivableId.value
          : this.receivableId,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableData(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('amount: $amount, ')
          ..write('accountId: $accountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('debtId: $debtId, ')
          ..write('receivableId: $receivableId, ')
          ..write('goalId: $goalId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    amount,
    accountId,
    toAccountId,
    categoryId,
    debtId,
    receivableId,
    goalId,
    occurredAt,
    note,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionsTableData &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.amount == this.amount &&
          other.accountId == this.accountId &&
          other.toAccountId == this.toAccountId &&
          other.categoryId == this.categoryId &&
          other.debtId == this.debtId &&
          other.receivableId == this.receivableId &&
          other.goalId == this.goalId &&
          other.occurredAt == this.occurredAt &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class TransactionsTableCompanion
    extends UpdateCompanion<TransactionsTableData> {
  final Value<int> id;
  final Value<String> kind;
  final Value<int> amount;
  final Value<int> accountId;
  final Value<int?> toAccountId;
  final Value<int?> categoryId;
  final Value<int?> debtId;
  final Value<int?> receivableId;
  final Value<int?> goalId;
  final Value<DateTime> occurredAt;
  final Value<String> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  const TransactionsTableCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.amount = const Value.absent(),
    this.accountId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.debtId = const Value.absent(),
    this.receivableId = const Value.absent(),
    this.goalId = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  TransactionsTableCompanion.insert({
    this.id = const Value.absent(),
    required String kind,
    required int amount,
    required int accountId,
    this.toAccountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.debtId = const Value.absent(),
    this.receivableId = const Value.absent(),
    this.goalId = const Value.absent(),
    required DateTime occurredAt,
    this.note = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
  }) : kind = Value(kind),
       amount = Value(amount),
       accountId = Value(accountId),
       occurredAt = Value(occurredAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TransactionsTableData> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<int>? amount,
    Expression<int>? accountId,
    Expression<int>? toAccountId,
    Expression<int>? categoryId,
    Expression<int>? debtId,
    Expression<int>? receivableId,
    Expression<int>? goalId,
    Expression<DateTime>? occurredAt,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (amount != null) 'amount': amount,
      if (accountId != null) 'account_id': accountId,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (categoryId != null) 'category_id': categoryId,
      if (debtId != null) 'debt_id': debtId,
      if (receivableId != null) 'receivable_id': receivableId,
      if (goalId != null) 'goal_id': goalId,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  TransactionsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? kind,
    Value<int>? amount,
    Value<int>? accountId,
    Value<int?>? toAccountId,
    Value<int?>? categoryId,
    Value<int?>? debtId,
    Value<int?>? receivableId,
    Value<int?>? goalId,
    Value<DateTime>? occurredAt,
    Value<String>? note,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
  }) {
    return TransactionsTableCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      amount: amount ?? this.amount,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId ?? this.toAccountId,
      categoryId: categoryId ?? this.categoryId,
      debtId: debtId ?? this.debtId,
      receivableId: receivableId ?? this.receivableId,
      goalId: goalId ?? this.goalId,
      occurredAt: occurredAt ?? this.occurredAt,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (toAccountId.present) {
      map['to_account_id'] = Variable<int>(toAccountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (debtId.present) {
      map['debt_id'] = Variable<int>(debtId.value);
    }
    if (receivableId.present) {
      map['receivable_id'] = Variable<int>(receivableId.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<int>(goalId.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('amount: $amount, ')
          ..write('accountId: $accountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('debtId: $debtId, ')
          ..write('receivableId: $receivableId, ')
          ..write('goalId: $goalId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
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
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
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
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsTableData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingsTableData extends DataClass
    implements Insertable<AppSettingsTableData> {
  final String key;
  final String value;
  const AppSettingsTableData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(key: Value(key), value: Value(value));
  }

  factory AppSettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsTableData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSettingsTableData copyWith({String? key, String? value}) =>
      AppSettingsTableData(key: key ?? this.key, value: value ?? this.value);
  AppSettingsTableData copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingsTableData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsTableData &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingsTableData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSettingsTableData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsTableCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
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
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTableTable extends RemindersTable
    with TableInfo<$RemindersTableTable, RemindersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatRuleMeta = const VerificationMeta(
    'repeatRule',
  );
  @override
  late final GeneratedColumn<String> repeatRule = GeneratedColumn<String>(
    'repeat_rule',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, dueAt, repeatRule, done];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<RemindersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('repeat_rule')) {
      context.handle(
        _repeatRuleMeta,
        repeatRule.isAcceptableOrUnknown(data['repeat_rule']!, _repeatRuleMeta),
      );
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RemindersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RemindersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      )!,
      repeatRule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_rule'],
      ),
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
    );
  }

  @override
  $RemindersTableTable createAlias(String alias) {
    return $RemindersTableTable(attachedDatabase, alias);
  }
}

class RemindersTableData extends DataClass
    implements Insertable<RemindersTableData> {
  final int id;
  final String title;
  final DateTime dueAt;
  final String? repeatRule;
  final bool done;
  const RemindersTableData({
    required this.id,
    required this.title,
    required this.dueAt,
    this.repeatRule,
    required this.done,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['due_at'] = Variable<DateTime>(dueAt);
    if (!nullToAbsent || repeatRule != null) {
      map['repeat_rule'] = Variable<String>(repeatRule);
    }
    map['done'] = Variable<bool>(done);
    return map;
  }

  RemindersTableCompanion toCompanion(bool nullToAbsent) {
    return RemindersTableCompanion(
      id: Value(id),
      title: Value(title),
      dueAt: Value(dueAt),
      repeatRule: repeatRule == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatRule),
      done: Value(done),
    );
  }

  factory RemindersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RemindersTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
      repeatRule: serializer.fromJson<String?>(json['repeatRule']),
      done: serializer.fromJson<bool>(json['done']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'dueAt': serializer.toJson<DateTime>(dueAt),
      'repeatRule': serializer.toJson<String?>(repeatRule),
      'done': serializer.toJson<bool>(done),
    };
  }

  RemindersTableData copyWith({
    int? id,
    String? title,
    DateTime? dueAt,
    Value<String?> repeatRule = const Value.absent(),
    bool? done,
  }) => RemindersTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    dueAt: dueAt ?? this.dueAt,
    repeatRule: repeatRule.present ? repeatRule.value : this.repeatRule,
    done: done ?? this.done,
  );
  RemindersTableData copyWithCompanion(RemindersTableCompanion data) {
    return RemindersTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      repeatRule: data.repeatRule.present
          ? data.repeatRule.value
          : this.repeatRule,
      done: data.done.present ? data.done.value : this.done,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RemindersTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('dueAt: $dueAt, ')
          ..write('repeatRule: $repeatRule, ')
          ..write('done: $done')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, dueAt, repeatRule, done);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RemindersTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.dueAt == this.dueAt &&
          other.repeatRule == this.repeatRule &&
          other.done == this.done);
}

class RemindersTableCompanion extends UpdateCompanion<RemindersTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> dueAt;
  final Value<String?> repeatRule;
  final Value<bool> done;
  const RemindersTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.repeatRule = const Value.absent(),
    this.done = const Value.absent(),
  });
  RemindersTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required DateTime dueAt,
    this.repeatRule = const Value.absent(),
    this.done = const Value.absent(),
  }) : title = Value(title),
       dueAt = Value(dueAt);
  static Insertable<RemindersTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<DateTime>? dueAt,
    Expression<String>? repeatRule,
    Expression<bool>? done,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (dueAt != null) 'due_at': dueAt,
      if (repeatRule != null) 'repeat_rule': repeatRule,
      if (done != null) 'done': done,
    });
  }

  RemindersTableCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<DateTime>? dueAt,
    Value<String?>? repeatRule,
    Value<bool>? done,
  }) {
    return RemindersTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      dueAt: dueAt ?? this.dueAt,
      repeatRule: repeatRule ?? this.repeatRule,
      done: done ?? this.done,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (repeatRule.present) {
      map['repeat_rule'] = Variable<String>(repeatRule.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('dueAt: $dueAt, ')
          ..write('repeatRule: $repeatRule, ')
          ..write('done: $done')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTableTable accountsTable = $AccountsTableTable(this);
  late final $CategoriesTableTable categoriesTable = $CategoriesTableTable(
    this,
  );
  late final $DebtsTableTable debtsTable = $DebtsTableTable(this);
  late final $ReceivablesTableTable receivablesTable = $ReceivablesTableTable(
    this,
  );
  late final $SavingsGoalsTableTable savingsGoalsTable =
      $SavingsGoalsTableTable(this);
  late final $AllocationRulesTableTable allocationRulesTable =
      $AllocationRulesTableTable(this);
  late final $TransactionsTableTable transactionsTable =
      $TransactionsTableTable(this);
  late final $AppSettingsTableTable appSettingsTable = $AppSettingsTableTable(
    this,
  );
  late final $RemindersTableTable remindersTable = $RemindersTableTable(this);
  late final Index idxTransactionsOccurredAt = Index(
    'idx_transactions_occurred_at',
    'CREATE INDEX idx_transactions_occurred_at ON transactions (occurred_at)',
  );
  late final Index idxTransactionsAccountId = Index(
    'idx_transactions_account_id',
    'CREATE INDEX idx_transactions_account_id ON transactions (account_id)',
  );
  late final Index idxTransactionsCategoryId = Index(
    'idx_transactions_category_id',
    'CREATE INDEX idx_transactions_category_id ON transactions (category_id)',
  );
  late final Index idxTransactionsDebtId = Index(
    'idx_transactions_debt_id',
    'CREATE INDEX idx_transactions_debt_id ON transactions (debt_id)',
  );
  late final Index idxTransactionsReceivableId = Index(
    'idx_transactions_receivable_id',
    'CREATE INDEX idx_transactions_receivable_id ON transactions (receivable_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accountsTable,
    categoriesTable,
    debtsTable,
    receivablesTable,
    savingsGoalsTable,
    allocationRulesTable,
    transactionsTable,
    appSettingsTable,
    remindersTable,
    idxTransactionsOccurredAt,
    idxTransactionsAccountId,
    idxTransactionsCategoryId,
    idxTransactionsDebtId,
    idxTransactionsReceivableId,
  ];
}

typedef $$AccountsTableTableCreateCompanionBuilder =
    AccountsTableCompanion Function({
      Value<int> id,
      required String name,
      required String type,
      required int initialBalance,
      Value<bool> archived,
    });
typedef $$AccountsTableTableUpdateCompanionBuilder =
    AccountsTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> type,
      Value<int> initialBalance,
      Value<bool> archived,
    });

final class $$AccountsTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $AccountsTableTable, AccountsTableData> {
  $$AccountsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $TransactionsTableTable,
    List<TransactionsTableData>
  >
  _outgoingTransactionsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactionsTable,
    aliasName: 'accounts__id__transactions__account_id',
  );

  $$TransactionsTableTableProcessedTableManager get outgoingTransactions {
    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _outgoingTransactionsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TransactionsTableTable,
    List<TransactionsTableData>
  >
  _incomingTransactionsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactionsTable,
    aliasName: 'accounts__id__transactions__to_account_id',
  );

  $$TransactionsTableTableProcessedTableManager get incomingTransactions {
    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.toAccountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _incomingTransactionsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get initialBalance => $composableBuilder(
    column: $table.initialBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> outgoingTransactions(
    Expression<bool> Function($$TransactionsTableTableFilterComposer f) f,
  ) {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> incomingTransactions(
    Expression<bool> Function($$TransactionsTableTableFilterComposer f) f,
  ) {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.toAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get initialBalance => $composableBuilder(
    column: $table.initialBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get initialBalance => $composableBuilder(
    column: $table.initialBalance,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  Expression<T> outgoingTransactions<T extends Object>(
    Expression<T> Function($$TransactionsTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> incomingTransactions<T extends Object>(
    Expression<T> Function($$TransactionsTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.toAccountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AccountsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTableTable,
          AccountsTableData,
          $$AccountsTableTableFilterComposer,
          $$AccountsTableTableOrderingComposer,
          $$AccountsTableTableAnnotationComposer,
          $$AccountsTableTableCreateCompanionBuilder,
          $$AccountsTableTableUpdateCompanionBuilder,
          (AccountsTableData, $$AccountsTableTableReferences),
          AccountsTableData,
          PrefetchHooks Function({
            bool outgoingTransactions,
            bool incomingTransactions,
          })
        > {
  $$AccountsTableTableTableManager(_$AppDatabase db, $AccountsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> initialBalance = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => AccountsTableCompanion(
                id: id,
                name: name,
                type: type,
                initialBalance: initialBalance,
                archived: archived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String type,
                required int initialBalance,
                Value<bool> archived = const Value.absent(),
              }) => AccountsTableCompanion.insert(
                id: id,
                name: name,
                type: type,
                initialBalance: initialBalance,
                archived: archived,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AccountsTableTable, AccountsTableData>(table),
                  $$AccountsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({outgoingTransactions = false, incomingTransactions = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (outgoingTransactions) db.transactionsTable,
                    if (incomingTransactions) db.transactionsTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (outgoingTransactions)
                        await $_getPrefetchedData<
                          AccountsTableData,
                          $AccountsTableTable,
                          TransactionsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableTableReferences
                              ._outgoingTransactionsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).outgoingTransactions,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (incomingTransactions)
                        await $_getPrefetchedData<
                          AccountsTableData,
                          $AccountsTableTable,
                          TransactionsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableTableReferences
                              ._incomingTransactionsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).incomingTransactions,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.toAccountId == item.id,
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

typedef $$AccountsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTableTable,
      AccountsTableData,
      $$AccountsTableTableFilterComposer,
      $$AccountsTableTableOrderingComposer,
      $$AccountsTableTableAnnotationComposer,
      $$AccountsTableTableCreateCompanionBuilder,
      $$AccountsTableTableUpdateCompanionBuilder,
      (AccountsTableData, $$AccountsTableTableReferences),
      AccountsTableData,
      PrefetchHooks Function({
        bool outgoingTransactions,
        bool incomingTransactions,
      })
    >;
typedef $$CategoriesTableTableCreateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<int> id,
      Value<String?> key,
      Value<String?> name,
      required String kind,
      required String icon,
      required int color,
      Value<bool> isDefault,
      Value<bool> isActive,
      Value<int> sortOrder,
    });
typedef $$CategoriesTableTableUpdateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<int> id,
      Value<String?> key,
      Value<String?> name,
      Value<String> kind,
      Value<String> icon,
      Value<int> color,
      Value<bool> isDefault,
      Value<bool> isActive,
      Value<int> sortOrder,
    });

final class $$CategoriesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoriesTableData
        > {
  $$CategoriesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $TransactionsTableTable,
    List<TransactionsTableData>
  >
  _transactionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionsTable,
        aliasName: 'categories__id__transactions__category_id',
      );

  $$TransactionsTableTableProcessedTableManager get transactionsTableRefs {
    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
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

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsTableRefs(
    Expression<bool> Function($$TransactionsTableTableFilterComposer f) f,
  ) {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
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

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> transactionsTableRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoriesTableData,
          $$CategoriesTableTableFilterComposer,
          $$CategoriesTableTableOrderingComposer,
          $$CategoriesTableTableAnnotationComposer,
          $$CategoriesTableTableCreateCompanionBuilder,
          $$CategoriesTableTableUpdateCompanionBuilder,
          (CategoriesTableData, $$CategoriesTableTableReferences),
          CategoriesTableData,
          PrefetchHooks Function({bool transactionsTableRefs})
        > {
  $$CategoriesTableTableTableManager(
    _$AppDatabase db,
    $CategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> key = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => CategoriesTableCompanion(
                id: id,
                key: key,
                name: name,
                kind: kind,
                icon: icon,
                color: color,
                isDefault: isDefault,
                isActive: isActive,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> key = const Value.absent(),
                Value<String?> name = const Value.absent(),
                required String kind,
                required String icon,
                required int color,
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => CategoriesTableCompanion.insert(
                id: id,
                key: key,
                name: name,
                kind: kind,
                icon: icon,
                color: color,
                isDefault: isDefault,
                isActive: isActive,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTableTable, CategoriesTableData>(
                    table,
                  ),
                  $$CategoriesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionsTableRefs) db.transactionsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsTableRefs)
                    await $_getPrefetchedData<
                      CategoriesTableData,
                      $CategoriesTableTable,
                      TransactionsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableTableReferences
                          ._transactionsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableTableReferences(
                            db,
                            table,
                            p0,
                          ).transactionsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTableTable,
      CategoriesTableData,
      $$CategoriesTableTableFilterComposer,
      $$CategoriesTableTableOrderingComposer,
      $$CategoriesTableTableAnnotationComposer,
      $$CategoriesTableTableCreateCompanionBuilder,
      $$CategoriesTableTableUpdateCompanionBuilder,
      (CategoriesTableData, $$CategoriesTableTableReferences),
      CategoriesTableData,
      PrefetchHooks Function({bool transactionsTableRefs})
    >;
typedef $$DebtsTableTableCreateCompanionBuilder = DebtsTableCompanion Function({
  Value<int> id,
  required String name,
  required String creditor,
  required int initialAmount,
  required int interestRateBp,
  required int minPayment,
  required int dueDay,
  required int priority,
  Value<bool> archived,
});
typedef $$DebtsTableTableUpdateCompanionBuilder = DebtsTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> creditor,
  Value<int> initialAmount,
  Value<int> interestRateBp,
  Value<int> minPayment,
  Value<int> dueDay,
  Value<int> priority,
  Value<bool> archived,
});

final class $$DebtsTableTableReferences
    extends BaseReferences<_$AppDatabase, $DebtsTableTable, DebtsTableData> {
  $$DebtsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $TransactionsTableTable,
    List<TransactionsTableData>
  >
  _transactionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionsTable,
        aliasName: 'debts__id__transactions__debt_id',
      );

  $$TransactionsTableTableProcessedTableManager get transactionsTableRefs {
    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.debtId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DebtsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DebtsTableTable> {
  $$DebtsTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creditor => $composableBuilder(
    column: $table.creditor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get initialAmount => $composableBuilder(
    column: $table.initialAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interestRateBp => $composableBuilder(
    column: $table.interestRateBp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minPayment => $composableBuilder(
    column: $table.minPayment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsTableRefs(
    Expression<bool> Function($$TransactionsTableTableFilterComposer f) f,
  ) {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.debtId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DebtsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtsTableTable> {
  $$DebtsTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creditor => $composableBuilder(
    column: $table.creditor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get initialAmount => $composableBuilder(
    column: $table.initialAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interestRateBp => $composableBuilder(
    column: $table.interestRateBp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minPayment => $composableBuilder(
    column: $table.minPayment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DebtsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtsTableTable> {
  $$DebtsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get creditor =>
      $composableBuilder(column: $table.creditor, builder: (column) => column);

  GeneratedColumn<int> get initialAmount => $composableBuilder(
    column: $table.initialAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get interestRateBp => $composableBuilder(
    column: $table.interestRateBp,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minPayment => $composableBuilder(
    column: $table.minPayment,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dueDay =>
      $composableBuilder(column: $table.dueDay, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  Expression<T> transactionsTableRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.debtId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DebtsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DebtsTableTable,
          DebtsTableData,
          $$DebtsTableTableFilterComposer,
          $$DebtsTableTableOrderingComposer,
          $$DebtsTableTableAnnotationComposer,
          $$DebtsTableTableCreateCompanionBuilder,
          $$DebtsTableTableUpdateCompanionBuilder,
          (DebtsTableData, $$DebtsTableTableReferences),
          DebtsTableData,
          PrefetchHooks Function({bool transactionsTableRefs})
        > {
  $$DebtsTableTableTableManager(_$AppDatabase db, $DebtsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> creditor = const Value.absent(),
                Value<int> initialAmount = const Value.absent(),
                Value<int> interestRateBp = const Value.absent(),
                Value<int> minPayment = const Value.absent(),
                Value<int> dueDay = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => DebtsTableCompanion(
                id: id,
                name: name,
                creditor: creditor,
                initialAmount: initialAmount,
                interestRateBp: interestRateBp,
                minPayment: minPayment,
                dueDay: dueDay,
                priority: priority,
                archived: archived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String creditor,
                required int initialAmount,
                required int interestRateBp,
                required int minPayment,
                required int dueDay,
                required int priority,
                Value<bool> archived = const Value.absent(),
              }) => DebtsTableCompanion.insert(
                id: id,
                name: name,
                creditor: creditor,
                initialAmount: initialAmount,
                interestRateBp: interestRateBp,
                minPayment: minPayment,
                dueDay: dueDay,
                priority: priority,
                archived: archived,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DebtsTableTable, DebtsTableData>(table),
                  $$DebtsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionsTableRefs) db.transactionsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsTableRefs)
                    await $_getPrefetchedData<
                      DebtsTableData,
                      $DebtsTableTable,
                      TransactionsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$DebtsTableTableReferences
                          ._transactionsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DebtsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).transactionsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.debtId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DebtsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DebtsTableTable,
      DebtsTableData,
      $$DebtsTableTableFilterComposer,
      $$DebtsTableTableOrderingComposer,
      $$DebtsTableTableAnnotationComposer,
      $$DebtsTableTableCreateCompanionBuilder,
      $$DebtsTableTableUpdateCompanionBuilder,
      (DebtsTableData, $$DebtsTableTableReferences),
      DebtsTableData,
      PrefetchHooks Function({bool transactionsTableRefs})
    >;
typedef $$ReceivablesTableTableCreateCompanionBuilder =
    ReceivablesTableCompanion Function({
      Value<int> id,
      required String person,
      required int initialAmount,
      required DateTime createdAt,
      Value<String> note,
      Value<bool> archived,
    });
typedef $$ReceivablesTableTableUpdateCompanionBuilder =
    ReceivablesTableCompanion Function({
      Value<int> id,
      Value<String> person,
      Value<int> initialAmount,
      Value<DateTime> createdAt,
      Value<String> note,
      Value<bool> archived,
    });

final class $$ReceivablesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReceivablesTableTable,
          ReceivablesTableData
        > {
  $$ReceivablesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $TransactionsTableTable,
    List<TransactionsTableData>
  >
  _transactionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionsTable,
        aliasName: 'receivables__id__transactions__receivable_id',
      );

  $$TransactionsTableTableProcessedTableManager get transactionsTableRefs {
    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.receivableId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ReceivablesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ReceivablesTableTable> {
  $$ReceivablesTableTableFilterComposer({
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

  ColumnFilters<String> get person => $composableBuilder(
    column: $table.person,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get initialAmount => $composableBuilder(
    column: $table.initialAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsTableRefs(
    Expression<bool> Function($$TransactionsTableTableFilterComposer f) f,
  ) {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.receivableId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReceivablesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ReceivablesTableTable> {
  $$ReceivablesTableTableOrderingComposer({
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

  ColumnOrderings<String> get person => $composableBuilder(
    column: $table.person,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get initialAmount => $composableBuilder(
    column: $table.initialAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReceivablesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReceivablesTableTable> {
  $$ReceivablesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get person =>
      $composableBuilder(column: $table.person, builder: (column) => column);

  GeneratedColumn<int> get initialAmount => $composableBuilder(
    column: $table.initialAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  Expression<T> transactionsTableRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.receivableId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ReceivablesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReceivablesTableTable,
          ReceivablesTableData,
          $$ReceivablesTableTableFilterComposer,
          $$ReceivablesTableTableOrderingComposer,
          $$ReceivablesTableTableAnnotationComposer,
          $$ReceivablesTableTableCreateCompanionBuilder,
          $$ReceivablesTableTableUpdateCompanionBuilder,
          (ReceivablesTableData, $$ReceivablesTableTableReferences),
          ReceivablesTableData,
          PrefetchHooks Function({bool transactionsTableRefs})
        > {
  $$ReceivablesTableTableTableManager(
    _$AppDatabase db,
    $ReceivablesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReceivablesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReceivablesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReceivablesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> person = const Value.absent(),
                Value<int> initialAmount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => ReceivablesTableCompanion(
                id: id,
                person: person,
                initialAmount: initialAmount,
                createdAt: createdAt,
                note: note,
                archived: archived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String person,
                required int initialAmount,
                required DateTime createdAt,
                Value<String> note = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => ReceivablesTableCompanion.insert(
                id: id,
                person: person,
                initialAmount: initialAmount,
                createdAt: createdAt,
                note: note,
                archived: archived,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReceivablesTableTable, ReceivablesTableData>(
                    table,
                  ),
                  $$ReceivablesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionsTableRefs) db.transactionsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsTableRefs)
                    await $_getPrefetchedData<
                      ReceivablesTableData,
                      $ReceivablesTableTable,
                      TransactionsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$ReceivablesTableTableReferences
                          ._transactionsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ReceivablesTableTableReferences(
                            db,
                            table,
                            p0,
                          ).transactionsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.receivableId == item.id,
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

typedef $$ReceivablesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReceivablesTableTable,
      ReceivablesTableData,
      $$ReceivablesTableTableFilterComposer,
      $$ReceivablesTableTableOrderingComposer,
      $$ReceivablesTableTableAnnotationComposer,
      $$ReceivablesTableTableCreateCompanionBuilder,
      $$ReceivablesTableTableUpdateCompanionBuilder,
      (ReceivablesTableData, $$ReceivablesTableTableReferences),
      ReceivablesTableData,
      PrefetchHooks Function({bool transactionsTableRefs})
    >;
typedef $$SavingsGoalsTableTableCreateCompanionBuilder =
    SavingsGoalsTableCompanion Function({
      Value<int> id,
      required String name,
      required int targetAmount,
      Value<DateTime?> targetDate,
      Value<bool> archived,
    });
typedef $$SavingsGoalsTableTableUpdateCompanionBuilder =
    SavingsGoalsTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> targetAmount,
      Value<DateTime?> targetDate,
      Value<bool> archived,
    });

final class $$SavingsGoalsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SavingsGoalsTableTable,
          SavingsGoalsTableData
        > {
  $$SavingsGoalsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $TransactionsTableTable,
    List<TransactionsTableData>
  >
  _transactionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionsTable,
        aliasName: 'savings_goals__id__transactions__goal_id',
      );

  $$TransactionsTableTableProcessedTableManager get transactionsTableRefs {
    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SavingsGoalsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTableTable> {
  $$SavingsGoalsTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsTableRefs(
    Expression<bool> Function($$TransactionsTableTableFilterComposer f) f,
  ) {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SavingsGoalsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTableTable> {
  $$SavingsGoalsTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsGoalsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTableTable> {
  $$SavingsGoalsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  Expression<T> transactionsTableRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.goalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SavingsGoalsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsGoalsTableTable,
          SavingsGoalsTableData,
          $$SavingsGoalsTableTableFilterComposer,
          $$SavingsGoalsTableTableOrderingComposer,
          $$SavingsGoalsTableTableAnnotationComposer,
          $$SavingsGoalsTableTableCreateCompanionBuilder,
          $$SavingsGoalsTableTableUpdateCompanionBuilder,
          (SavingsGoalsTableData, $$SavingsGoalsTableTableReferences),
          SavingsGoalsTableData,
          PrefetchHooks Function({bool transactionsTableRefs})
        > {
  $$SavingsGoalsTableTableTableManager(
    _$AppDatabase db,
    $SavingsGoalsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsGoalsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsGoalsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsGoalsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> targetAmount = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => SavingsGoalsTableCompanion(
                id: id,
                name: name,
                targetAmount: targetAmount,
                targetDate: targetDate,
                archived: archived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int targetAmount,
                Value<DateTime?> targetDate = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => SavingsGoalsTableCompanion.insert(
                id: id,
                name: name,
                targetAmount: targetAmount,
                targetDate: targetDate,
                archived: archived,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SavingsGoalsTableTable, SavingsGoalsTableData>(
                    table,
                  ),
                  $$SavingsGoalsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionsTableRefs) db.transactionsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsTableRefs)
                    await $_getPrefetchedData<
                      SavingsGoalsTableData,
                      $SavingsGoalsTableTable,
                      TransactionsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$SavingsGoalsTableTableReferences
                          ._transactionsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SavingsGoalsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).transactionsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.goalId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SavingsGoalsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsGoalsTableTable,
      SavingsGoalsTableData,
      $$SavingsGoalsTableTableFilterComposer,
      $$SavingsGoalsTableTableOrderingComposer,
      $$SavingsGoalsTableTableAnnotationComposer,
      $$SavingsGoalsTableTableCreateCompanionBuilder,
      $$SavingsGoalsTableTableUpdateCompanionBuilder,
      (SavingsGoalsTableData, $$SavingsGoalsTableTableReferences),
      SavingsGoalsTableData,
      PrefetchHooks Function({bool transactionsTableRefs})
    >;
typedef $$AllocationRulesTableTableCreateCompanionBuilder =
    AllocationRulesTableCompanion Function({
      Value<int> id,
      required String target,
      required int percent,
    });
typedef $$AllocationRulesTableTableUpdateCompanionBuilder =
    AllocationRulesTableCompanion Function({
      Value<int> id,
      Value<String> target,
      Value<int> percent,
    });

class $$AllocationRulesTableTableFilterComposer
    extends Composer<_$AppDatabase, $AllocationRulesTableTable> {
  $$AllocationRulesTableTableFilterComposer({
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

  ColumnFilters<String> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get percent => $composableBuilder(
    column: $table.percent,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AllocationRulesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AllocationRulesTableTable> {
  $$AllocationRulesTableTableOrderingComposer({
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

  ColumnOrderings<String> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get percent => $composableBuilder(
    column: $table.percent,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AllocationRulesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AllocationRulesTableTable> {
  $$AllocationRulesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<int> get percent =>
      $composableBuilder(column: $table.percent, builder: (column) => column);
}

class $$AllocationRulesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AllocationRulesTableTable,
          AllocationRulesTableData,
          $$AllocationRulesTableTableFilterComposer,
          $$AllocationRulesTableTableOrderingComposer,
          $$AllocationRulesTableTableAnnotationComposer,
          $$AllocationRulesTableTableCreateCompanionBuilder,
          $$AllocationRulesTableTableUpdateCompanionBuilder,
          (
            AllocationRulesTableData,
            BaseReferences<
              _$AppDatabase,
              $AllocationRulesTableTable,
              AllocationRulesTableData
            >,
          ),
          AllocationRulesTableData,
          PrefetchHooks Function()
        > {
  $$AllocationRulesTableTableTableManager(
    _$AppDatabase db,
    $AllocationRulesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AllocationRulesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AllocationRulesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AllocationRulesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> target = const Value.absent(),
                Value<int> percent = const Value.absent(),
              }) => AllocationRulesTableCompanion(
                id: id,
                target: target,
                percent: percent,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String target,
                required int percent,
              }) => AllocationRulesTableCompanion.insert(
                id: id,
                target: target,
                percent: percent,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $AllocationRulesTableTable,
                    AllocationRulesTableData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AllocationRulesTableTable,
                    AllocationRulesTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AllocationRulesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AllocationRulesTableTable,
      AllocationRulesTableData,
      $$AllocationRulesTableTableFilterComposer,
      $$AllocationRulesTableTableOrderingComposer,
      $$AllocationRulesTableTableAnnotationComposer,
      $$AllocationRulesTableTableCreateCompanionBuilder,
      $$AllocationRulesTableTableUpdateCompanionBuilder,
      (
        AllocationRulesTableData,
        BaseReferences<
          _$AppDatabase,
          $AllocationRulesTableTable,
          AllocationRulesTableData
        >,
      ),
      AllocationRulesTableData,
      PrefetchHooks Function()
    >;
typedef $$TransactionsTableTableCreateCompanionBuilder =
    TransactionsTableCompanion Function({
      Value<int> id,
      required String kind,
      required int amount,
      required int accountId,
      Value<int?> toAccountId,
      Value<int?> categoryId,
      Value<int?> debtId,
      Value<int?> receivableId,
      Value<int?> goalId,
      required DateTime occurredAt,
      Value<String> note,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
    });
typedef $$TransactionsTableTableUpdateCompanionBuilder =
    TransactionsTableCompanion Function({
      Value<int> id,
      Value<String> kind,
      Value<int> amount,
      Value<int> accountId,
      Value<int?> toAccountId,
      Value<int?> categoryId,
      Value<int?> debtId,
      Value<int?> receivableId,
      Value<int?> goalId,
      Value<DateTime> occurredAt,
      Value<String> note,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
    });

final class $$TransactionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TransactionsTableTable,
          TransactionsTableData
        > {
  $$TransactionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTableTable _accountIdTable(_$AppDatabase db) =>
      db.accountsTable.createAlias('transactions__account_id__accounts__id');

  $$AccountsTableTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableTableManager(
      $_db,
      $_db.accountsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTableTable _toAccountIdTable(_$AppDatabase db) =>
      db.accountsTable.createAlias('transactions__to_account_id__accounts__id');

  $$AccountsTableTableProcessedTableManager? get toAccountId {
    final $_column = $_itemColumn<int>('to_account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableTableManager(
      $_db,
      $_db.accountsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTableTable _categoryIdTable(_$AppDatabase db) => db
      .categoriesTable
      .createAlias('transactions__category_id__categories__id');

  $$CategoriesTableTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableTableManager(
      $_db,
      $_db.categoriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DebtsTableTable _debtIdTable(_$AppDatabase db) =>
      db.debtsTable.createAlias('transactions__debt_id__debts__id');

  $$DebtsTableTableProcessedTableManager? get debtId {
    final $_column = $_itemColumn<int>('debt_id');
    if ($_column == null) return null;
    final manager = $$DebtsTableTableTableManager(
      $_db,
      $_db.debtsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_debtIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ReceivablesTableTable _receivableIdTable(_$AppDatabase db) => db
      .receivablesTable
      .createAlias('transactions__receivable_id__receivables__id');

  $$ReceivablesTableTableProcessedTableManager? get receivableId {
    final $_column = $_itemColumn<int>('receivable_id');
    if ($_column == null) return null;
    final manager = $$ReceivablesTableTableTableManager(
      $_db,
      $_db.receivablesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_receivableIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SavingsGoalsTableTable _goalIdTable(_$AppDatabase db) => db
      .savingsGoalsTable
      .createAlias('transactions__goal_id__savings_goals__id');

  $$SavingsGoalsTableTableProcessedTableManager? get goalId {
    final $_column = $_itemColumn<int>('goal_id');
    if ($_column == null) return null;
    final manager = $$SavingsGoalsTableTableTableManager(
      $_db,
      $_db.savingsGoalsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableFilterComposer({
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

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableTableFilterComposer get accountId {
    final $$AccountsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableFilterComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableFilterComposer get toAccountId {
    final $$AccountsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableFilterComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableFilterComposer get categoryId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableFilterComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DebtsTableTableFilterComposer get debtId {
    final $$DebtsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.debtId,
      referencedTable: $db.debtsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DebtsTableTableFilterComposer(
            $db: $db,
            $table: $db.debtsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReceivablesTableTableFilterComposer get receivableId {
    final $$ReceivablesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receivableId,
      referencedTable: $db.receivablesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceivablesTableTableFilterComposer(
            $db: $db,
            $table: $db.receivablesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SavingsGoalsTableTableFilterComposer get goalId {
    final $$SavingsGoalsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.savingsGoalsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingsGoalsTableTableFilterComposer(
            $db: $db,
            $table: $db.savingsGoalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableTableOrderingComposer get accountId {
    final $$AccountsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableOrderingComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableOrderingComposer get toAccountId {
    final $$AccountsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableOrderingComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableOrderingComposer get categoryId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DebtsTableTableOrderingComposer get debtId {
    final $$DebtsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.debtId,
      referencedTable: $db.debtsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DebtsTableTableOrderingComposer(
            $db: $db,
            $table: $db.debtsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReceivablesTableTableOrderingComposer get receivableId {
    final $$ReceivablesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receivableId,
      referencedTable: $db.receivablesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceivablesTableTableOrderingComposer(
            $db: $db,
            $table: $db.receivablesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SavingsGoalsTableTableOrderingComposer get goalId {
    final $$SavingsGoalsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.savingsGoalsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingsGoalsTableTableOrderingComposer(
            $db: $db,
            $table: $db.savingsGoalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$AccountsTableTableAnnotationComposer get accountId {
    final $$AccountsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableAnnotationComposer get toAccountId {
    final $$AccountsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableAnnotationComposer get categoryId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DebtsTableTableAnnotationComposer get debtId {
    final $$DebtsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.debtId,
      referencedTable: $db.debtsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DebtsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.debtsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReceivablesTableTableAnnotationComposer get receivableId {
    final $$ReceivablesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receivableId,
      referencedTable: $db.receivablesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceivablesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.receivablesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SavingsGoalsTableTableAnnotationComposer get goalId {
    final $$SavingsGoalsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.goalId,
          referencedTable: $db.savingsGoalsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SavingsGoalsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.savingsGoalsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$TransactionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTableTable,
          TransactionsTableData,
          $$TransactionsTableTableFilterComposer,
          $$TransactionsTableTableOrderingComposer,
          $$TransactionsTableTableAnnotationComposer,
          $$TransactionsTableTableCreateCompanionBuilder,
          $$TransactionsTableTableUpdateCompanionBuilder,
          (TransactionsTableData, $$TransactionsTableTableReferences),
          TransactionsTableData,
          PrefetchHooks Function({
            bool accountId,
            bool toAccountId,
            bool categoryId,
            bool debtId,
            bool receivableId,
            bool goalId,
          })
        > {
  $$TransactionsTableTableTableManager(
    _$AppDatabase db,
    $TransactionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int?> toAccountId = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<int?> debtId = const Value.absent(),
                Value<int?> receivableId = const Value.absent(),
                Value<int?> goalId = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => TransactionsTableCompanion(
                id: id,
                kind: kind,
                amount: amount,
                accountId: accountId,
                toAccountId: toAccountId,
                categoryId: categoryId,
                debtId: debtId,
                receivableId: receivableId,
                goalId: goalId,
                occurredAt: occurredAt,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String kind,
                required int amount,
                required int accountId,
                Value<int?> toAccountId = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<int?> debtId = const Value.absent(),
                Value<int?> receivableId = const Value.absent(),
                Value<int?> goalId = const Value.absent(),
                required DateTime occurredAt,
                Value<String> note = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
              }) => TransactionsTableCompanion.insert(
                id: id,
                kind: kind,
                amount: amount,
                accountId: accountId,
                toAccountId: toAccountId,
                categoryId: categoryId,
                debtId: debtId,
                receivableId: receivableId,
                goalId: goalId,
                occurredAt: occurredAt,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTableTable, TransactionsTableData>(
                    table,
                  ),
                  $$TransactionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                accountId = false,
                toAccountId = false,
                categoryId = false,
                debtId = false,
                receivableId = false,
                goalId = false,
              }) {
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
                        if (accountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $$TransactionsTableTableReferences
                                ._accountIdTable(db),
                            referencedColumn: $$TransactionsTableTableReferences
                                ._accountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (toAccountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.toAccountId,
                            referencedTable: $$TransactionsTableTableReferences
                                ._toAccountIdTable(db),
                            referencedColumn: $$TransactionsTableTableReferences
                                ._toAccountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$TransactionsTableTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$TransactionsTableTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (debtId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.debtId,
                            referencedTable: $$TransactionsTableTableReferences
                                ._debtIdTable(db),
                            referencedColumn: $$TransactionsTableTableReferences
                                ._debtIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (receivableId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.receivableId,
                            referencedTable: $$TransactionsTableTableReferences
                                ._receivableIdTable(db),
                            referencedColumn: $$TransactionsTableTableReferences
                                ._receivableIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (goalId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.goalId,
                            referencedTable: $$TransactionsTableTableReferences
                                ._goalIdTable(db),
                            referencedColumn: $$TransactionsTableTableReferences
                                ._goalIdTable(db)
                                .id,
                          ) as T;
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

typedef $$TransactionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTableTable,
      TransactionsTableData,
      $$TransactionsTableTableFilterComposer,
      $$TransactionsTableTableOrderingComposer,
      $$TransactionsTableTableAnnotationComposer,
      $$TransactionsTableTableCreateCompanionBuilder,
      $$TransactionsTableTableUpdateCompanionBuilder,
      (TransactionsTableData, $$TransactionsTableTableReferences),
      TransactionsTableData,
      PrefetchHooks Function({
        bool accountId,
        bool toAccountId,
        bool categoryId,
        bool debtId,
        bool receivableId,
        bool goalId,
      })
    >;
typedef $$AppSettingsTableTableCreateCompanionBuilder =
    AppSettingsTableCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableTableUpdateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsTableData,
          $$AppSettingsTableTableFilterComposer,
          $$AppSettingsTableTableOrderingComposer,
          $$AppSettingsTableTableAnnotationComposer,
          $$AppSettingsTableTableCreateCompanionBuilder,
          $$AppSettingsTableTableUpdateCompanionBuilder,
          (
            AppSettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsTableTable,
              AppSettingsTableData
            >,
          ),
          AppSettingsTableData,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableTableManager(
    _$AppDatabase db,
    $AppSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppSettingsTableCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsTableCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTableTable, AppSettingsTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $AppSettingsTableTable,
                    AppSettingsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTableTable,
      AppSettingsTableData,
      $$AppSettingsTableTableFilterComposer,
      $$AppSettingsTableTableOrderingComposer,
      $$AppSettingsTableTableAnnotationComposer,
      $$AppSettingsTableTableCreateCompanionBuilder,
      $$AppSettingsTableTableUpdateCompanionBuilder,
      (
        AppSettingsTableData,
        BaseReferences<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsTableData
        >,
      ),
      AppSettingsTableData,
      PrefetchHooks Function()
    >;
typedef $$RemindersTableTableCreateCompanionBuilder =
    RemindersTableCompanion Function({
      Value<int> id,
      required String title,
      required DateTime dueAt,
      Value<String?> repeatRule,
      Value<bool> done,
    });
typedef $$RemindersTableTableUpdateCompanionBuilder =
    RemindersTableCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<DateTime> dueAt,
      Value<String?> repeatRule,
      Value<bool> done,
    });

class $$RemindersTableTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTableTable> {
  $$RemindersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<String> get repeatRule => $composableBuilder(
    column: $table.repeatRule,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);
}

class $$RemindersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTableTable,
          RemindersTableData,
          $$RemindersTableTableFilterComposer,
          $$RemindersTableTableOrderingComposer,
          $$RemindersTableTableAnnotationComposer,
          $$RemindersTableTableCreateCompanionBuilder,
          $$RemindersTableTableUpdateCompanionBuilder,
          (
            RemindersTableData,
            BaseReferences<
              _$AppDatabase,
              $RemindersTableTable,
              RemindersTableData
            >,
          ),
          RemindersTableData,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableTableManager(
    _$AppDatabase db,
    $RemindersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> dueAt = const Value.absent(),
                Value<String?> repeatRule = const Value.absent(),
                Value<bool> done = const Value.absent(),
              }) => RemindersTableCompanion(
                id: id,
                title: title,
                dueAt: dueAt,
                repeatRule: repeatRule,
                done: done,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required DateTime dueAt,
                Value<String?> repeatRule = const Value.absent(),
                Value<bool> done = const Value.absent(),
              }) => RemindersTableCompanion.insert(
                id: id,
                title: title,
                dueAt: dueAt,
                repeatRule: repeatRule,
                done: done,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RemindersTableTable, RemindersTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RemindersTableTable,
                    RemindersTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemindersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTableTable,
      RemindersTableData,
      $$RemindersTableTableFilterComposer,
      $$RemindersTableTableOrderingComposer,
      $$RemindersTableTableAnnotationComposer,
      $$RemindersTableTableCreateCompanionBuilder,
      $$RemindersTableTableUpdateCompanionBuilder,
      (
        RemindersTableData,
        BaseReferences<_$AppDatabase, $RemindersTableTable, RemindersTableData>,
      ),
      RemindersTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableTableManager get accountsTable =>
      $$AccountsTableTableTableManager(_db, _db.accountsTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$DebtsTableTableTableManager get debtsTable =>
      $$DebtsTableTableTableManager(_db, _db.debtsTable);
  $$ReceivablesTableTableTableManager get receivablesTable =>
      $$ReceivablesTableTableTableManager(_db, _db.receivablesTable);
  $$SavingsGoalsTableTableTableManager get savingsGoalsTable =>
      $$SavingsGoalsTableTableTableManager(_db, _db.savingsGoalsTable);
  $$AllocationRulesTableTableTableManager get allocationRulesTable =>
      $$AllocationRulesTableTableTableManager(_db, _db.allocationRulesTable);
  $$TransactionsTableTableTableManager get transactionsTable =>
      $$TransactionsTableTableTableManager(_db, _db.transactionsTable);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
  $$RemindersTableTableTableManager get remindersTable =>
      $$RemindersTableTableTableManager(_db, _db.remindersTable);
}
