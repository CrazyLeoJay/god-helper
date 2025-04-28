// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DB.dart';

// ignore_for_file: type=lint
class $GameDataTable extends GameData
    with TableInfo<$GameDataTable, GameEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameDataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _configTemplateIdMeta =
      const VerificationMeta('configTemplateId');
  @override
  late final GeneratedColumn<int> configTemplateId = GeneratedColumn<int>(
      'config_template_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isDefaultConfigMeta =
      const VerificationMeta('isDefaultConfig');
  @override
  late final GeneratedColumn<bool> isDefaultConfig = GeneratedColumn<bool>(
      'is_default_config', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_default_config" IN (0, 1))'));
  static const VerificationMeta _extraRuleMeta =
      const VerificationMeta('extraRule');
  @override
  late final GeneratedColumn<String> extraRule = GeneratedColumn<String>(
      'extra_rule', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _saveRuleMeta =
      const VerificationMeta('saveRule');
  @override
  late final GeneratedColumn<String> saveRule = GeneratedColumn<String>(
      'save_rule', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isBeginGameMeta =
      const VerificationMeta('isBeginGame');
  @override
  late final GeneratedColumn<bool> isBeginGame = GeneratedColumn<bool>(
      'is_begin_game', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_begin_game" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isFinishMeta =
      const VerificationMeta('isFinish');
  @override
  late final GeneratedColumn<bool> isFinish = GeneratedColumn<bool>(
      'is_finish', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_finish" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createTimeMeta =
      const VerificationMeta('createTime');
  @override
  late final GeneratedColumn<DateTime> createTime = GeneratedColumn<DateTime>(
      'create_time', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        configTemplateId,
        isDefaultConfig,
        extraRule,
        saveRule,
        isBeginGame,
        isFinish,
        createTime
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_data';
  @override
  VerificationContext validateIntegrity(Insertable<GameEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('config_template_id')) {
      context.handle(
          _configTemplateIdMeta,
          configTemplateId.isAcceptableOrUnknown(
              data['config_template_id']!, _configTemplateIdMeta));
    } else if (isInserting) {
      context.missing(_configTemplateIdMeta);
    }
    if (data.containsKey('is_default_config')) {
      context.handle(
          _isDefaultConfigMeta,
          isDefaultConfig.isAcceptableOrUnknown(
              data['is_default_config']!, _isDefaultConfigMeta));
    } else if (isInserting) {
      context.missing(_isDefaultConfigMeta);
    }
    if (data.containsKey('extra_rule')) {
      context.handle(_extraRuleMeta,
          extraRule.isAcceptableOrUnknown(data['extra_rule']!, _extraRuleMeta));
    } else if (isInserting) {
      context.missing(_extraRuleMeta);
    }
    if (data.containsKey('save_rule')) {
      context.handle(_saveRuleMeta,
          saveRule.isAcceptableOrUnknown(data['save_rule']!, _saveRuleMeta));
    } else if (isInserting) {
      context.missing(_saveRuleMeta);
    }
    if (data.containsKey('is_begin_game')) {
      context.handle(
          _isBeginGameMeta,
          isBeginGame.isAcceptableOrUnknown(
              data['is_begin_game']!, _isBeginGameMeta));
    }
    if (data.containsKey('is_finish')) {
      context.handle(_isFinishMeta,
          isFinish.isAcceptableOrUnknown(data['is_finish']!, _isFinishMeta));
    }
    if (data.containsKey('create_time')) {
      context.handle(
          _createTimeMeta,
          createTime.isAcceptableOrUnknown(
              data['create_time']!, _createTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameEntity.forDB(
      attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}config_template_id'])!,
      attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_default_config'])!,
      attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}save_rule'])!,
      attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extra_rule'])!,
      attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_begin_game'])!,
      attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_finish'])!,
      attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}create_time'])!,
    );
  }

  @override
  $GameDataTable createAlias(String alias) {
    return $GameDataTable(attachedDatabase, alias);
  }
}

class GameDataCompanion extends UpdateCompanion<GameEntity> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> configTemplateId;
  final Value<bool> isDefaultConfig;
  final Value<String> extraRule;
  final Value<String> saveRule;
  final Value<bool> isBeginGame;
  final Value<bool> isFinish;
  final Value<DateTime> createTime;
  const GameDataCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.configTemplateId = const Value.absent(),
    this.isDefaultConfig = const Value.absent(),
    this.extraRule = const Value.absent(),
    this.saveRule = const Value.absent(),
    this.isBeginGame = const Value.absent(),
    this.isFinish = const Value.absent(),
    this.createTime = const Value.absent(),
  });
  GameDataCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int configTemplateId,
    required bool isDefaultConfig,
    required String extraRule,
    required String saveRule,
    this.isBeginGame = const Value.absent(),
    this.isFinish = const Value.absent(),
    this.createTime = const Value.absent(),
  })  : name = Value(name),
        configTemplateId = Value(configTemplateId),
        isDefaultConfig = Value(isDefaultConfig),
        extraRule = Value(extraRule),
        saveRule = Value(saveRule);
  static Insertable<GameEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? configTemplateId,
    Expression<bool>? isDefaultConfig,
    Expression<String>? extraRule,
    Expression<String>? saveRule,
    Expression<bool>? isBeginGame,
    Expression<bool>? isFinish,
    Expression<DateTime>? createTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (configTemplateId != null) 'config_template_id': configTemplateId,
      if (isDefaultConfig != null) 'is_default_config': isDefaultConfig,
      if (extraRule != null) 'extra_rule': extraRule,
      if (saveRule != null) 'save_rule': saveRule,
      if (isBeginGame != null) 'is_begin_game': isBeginGame,
      if (isFinish != null) 'is_finish': isFinish,
      if (createTime != null) 'create_time': createTime,
    });
  }

  GameDataCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? configTemplateId,
      Value<bool>? isDefaultConfig,
      Value<String>? extraRule,
      Value<String>? saveRule,
      Value<bool>? isBeginGame,
      Value<bool>? isFinish,
      Value<DateTime>? createTime}) {
    return GameDataCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      configTemplateId: configTemplateId ?? this.configTemplateId,
      isDefaultConfig: isDefaultConfig ?? this.isDefaultConfig,
      extraRule: extraRule ?? this.extraRule,
      saveRule: saveRule ?? this.saveRule,
      isBeginGame: isBeginGame ?? this.isBeginGame,
      isFinish: isFinish ?? this.isFinish,
      createTime: createTime ?? this.createTime,
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
    if (configTemplateId.present) {
      map['config_template_id'] = Variable<int>(configTemplateId.value);
    }
    if (isDefaultConfig.present) {
      map['is_default_config'] = Variable<bool>(isDefaultConfig.value);
    }
    if (extraRule.present) {
      map['extra_rule'] = Variable<String>(extraRule.value);
    }
    if (saveRule.present) {
      map['save_rule'] = Variable<String>(saveRule.value);
    }
    if (isBeginGame.present) {
      map['is_begin_game'] = Variable<bool>(isBeginGame.value);
    }
    if (isFinish.present) {
      map['is_finish'] = Variable<bool>(isFinish.value);
    }
    if (createTime.present) {
      map['create_time'] = Variable<DateTime>(createTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameDataCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('configTemplateId: $configTemplateId, ')
          ..write('isDefaultConfig: $isDefaultConfig, ')
          ..write('extraRule: $extraRule, ')
          ..write('saveRule: $saveRule, ')
          ..write('isBeginGame: $isBeginGame, ')
          ..write('isFinish: $isFinish, ')
          ..write('createTime: $createTime')
          ..write(')'))
        .toString();
  }
}

class $GameTemplateConfigTable extends GameTemplateConfig
    with TableInfo<$GameTemplateConfigTable, GameTemplateConfigEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameTemplateConfigTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _playerCountMeta =
      const VerificationMeta('playerCount');
  @override
  late final GeneratedColumn<int> playerCount = GeneratedColumn<int>(
      'player_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _roleConfigMeta =
      const VerificationMeta('roleConfig');
  @override
  late final GeneratedColumn<String> roleConfig = GeneratedColumn<String>(
      'role_config', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _extraRuleMeta =
      const VerificationMeta('extraRule');
  @override
  late final GeneratedColumn<String> extraRule = GeneratedColumn<String>(
      'extra_rule', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<int> weight = GeneratedColumn<int>(
      'weight', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createTimeMeta =
      const VerificationMeta('createTime');
  @override
  late final GeneratedColumn<DateTime> createTime = GeneratedColumn<DateTime>(
      'create_time', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  static const VerificationMeta _deleteMeta = const VerificationMeta('delete');
  @override
  late final GeneratedColumn<bool> delete = GeneratedColumn<bool>(
      'delete', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("delete" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        playerCount,
        roleConfig,
        extraRule,
        weight,
        createTime,
        delete
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_template_config';
  @override
  VerificationContext validateIntegrity(
      Insertable<GameTemplateConfigEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('player_count')) {
      context.handle(
          _playerCountMeta,
          playerCount.isAcceptableOrUnknown(
              data['player_count']!, _playerCountMeta));
    } else if (isInserting) {
      context.missing(_playerCountMeta);
    }
    if (data.containsKey('role_config')) {
      context.handle(
          _roleConfigMeta,
          roleConfig.isAcceptableOrUnknown(
              data['role_config']!, _roleConfigMeta));
    } else if (isInserting) {
      context.missing(_roleConfigMeta);
    }
    if (data.containsKey('extra_rule')) {
      context.handle(_extraRuleMeta,
          extraRule.isAcceptableOrUnknown(data['extra_rule']!, _extraRuleMeta));
    } else if (isInserting) {
      context.missing(_extraRuleMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('create_time')) {
      context.handle(
          _createTimeMeta,
          createTime.isAcceptableOrUnknown(
              data['create_time']!, _createTimeMeta));
    }
    if (data.containsKey('delete')) {
      context.handle(_deleteMeta,
          delete.isAcceptableOrUnknown(data['delete']!, _deleteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameTemplateConfigEntity map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameTemplateConfigEntity.forDB(
      attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}player_count'])!,
      attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role_config'])!,
      attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extra_rule'])!,
      attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weight'])!,
      attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}create_time'])!,
    );
  }

  @override
  $GameTemplateConfigTable createAlias(String alias) {
    return $GameTemplateConfigTable(attachedDatabase, alias);
  }
}

class GameTemplateConfigCompanion
    extends UpdateCompanion<GameTemplateConfigEntity> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> playerCount;
  final Value<String> roleConfig;
  final Value<String> extraRule;
  final Value<int> weight;
  final Value<DateTime> createTime;
  final Value<bool> delete;
  const GameTemplateConfigCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.playerCount = const Value.absent(),
    this.roleConfig = const Value.absent(),
    this.extraRule = const Value.absent(),
    this.weight = const Value.absent(),
    this.createTime = const Value.absent(),
    this.delete = const Value.absent(),
  });
  GameTemplateConfigCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int playerCount,
    required String roleConfig,
    required String extraRule,
    required int weight,
    this.createTime = const Value.absent(),
    this.delete = const Value.absent(),
  })  : name = Value(name),
        playerCount = Value(playerCount),
        roleConfig = Value(roleConfig),
        extraRule = Value(extraRule),
        weight = Value(weight);
  static Insertable<GameTemplateConfigEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? playerCount,
    Expression<String>? roleConfig,
    Expression<String>? extraRule,
    Expression<int>? weight,
    Expression<DateTime>? createTime,
    Expression<bool>? delete,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (playerCount != null) 'player_count': playerCount,
      if (roleConfig != null) 'role_config': roleConfig,
      if (extraRule != null) 'extra_rule': extraRule,
      if (weight != null) 'weight': weight,
      if (createTime != null) 'create_time': createTime,
      if (delete != null) 'delete': delete,
    });
  }

  GameTemplateConfigCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? playerCount,
      Value<String>? roleConfig,
      Value<String>? extraRule,
      Value<int>? weight,
      Value<DateTime>? createTime,
      Value<bool>? delete}) {
    return GameTemplateConfigCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      playerCount: playerCount ?? this.playerCount,
      roleConfig: roleConfig ?? this.roleConfig,
      extraRule: extraRule ?? this.extraRule,
      weight: weight ?? this.weight,
      createTime: createTime ?? this.createTime,
      delete: delete ?? this.delete,
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
    if (playerCount.present) {
      map['player_count'] = Variable<int>(playerCount.value);
    }
    if (roleConfig.present) {
      map['role_config'] = Variable<String>(roleConfig.value);
    }
    if (extraRule.present) {
      map['extra_rule'] = Variable<String>(extraRule.value);
    }
    if (weight.present) {
      map['weight'] = Variable<int>(weight.value);
    }
    if (createTime.present) {
      map['create_time'] = Variable<DateTime>(createTime.value);
    }
    if (delete.present) {
      map['delete'] = Variable<bool>(delete.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameTemplateConfigCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('playerCount: $playerCount, ')
          ..write('roleConfig: $roleConfig, ')
          ..write('extraRule: $extraRule, ')
          ..write('weight: $weight, ')
          ..write('createTime: $createTime, ')
          ..write('delete: $delete')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GameDataTable gameData = $GameDataTable(this);
  late final $GameTemplateConfigTable gameTemplateConfig =
      $GameTemplateConfigTable(this);
  late final GameDao gameDao = GameDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [gameData, gameTemplateConfig];
}

typedef $$GameDataTableCreateCompanionBuilder = GameDataCompanion Function({
  Value<int> id,
  required String name,
  required int configTemplateId,
  required bool isDefaultConfig,
  required String extraRule,
  required String saveRule,
  Value<bool> isBeginGame,
  Value<bool> isFinish,
  Value<DateTime> createTime,
});
typedef $$GameDataTableUpdateCompanionBuilder = GameDataCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> configTemplateId,
  Value<bool> isDefaultConfig,
  Value<String> extraRule,
  Value<String> saveRule,
  Value<bool> isBeginGame,
  Value<bool> isFinish,
  Value<DateTime> createTime,
});

class $$GameDataTableFilterComposer
    extends Composer<_$AppDatabase, $GameDataTable> {
  $$GameDataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get configTemplateId => $composableBuilder(
      column: $table.configTemplateId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefaultConfig => $composableBuilder(
      column: $table.isDefaultConfig,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get extraRule => $composableBuilder(
      column: $table.extraRule, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get saveRule => $composableBuilder(
      column: $table.saveRule, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBeginGame => $composableBuilder(
      column: $table.isBeginGame, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFinish => $composableBuilder(
      column: $table.isFinish, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createTime => $composableBuilder(
      column: $table.createTime, builder: (column) => ColumnFilters(column));
}

class $$GameDataTableOrderingComposer
    extends Composer<_$AppDatabase, $GameDataTable> {
  $$GameDataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get configTemplateId => $composableBuilder(
      column: $table.configTemplateId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefaultConfig => $composableBuilder(
      column: $table.isDefaultConfig,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extraRule => $composableBuilder(
      column: $table.extraRule, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get saveRule => $composableBuilder(
      column: $table.saveRule, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBeginGame => $composableBuilder(
      column: $table.isBeginGame, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFinish => $composableBuilder(
      column: $table.isFinish, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createTime => $composableBuilder(
      column: $table.createTime, builder: (column) => ColumnOrderings(column));
}

class $$GameDataTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameDataTable> {
  $$GameDataTableAnnotationComposer({
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

  GeneratedColumn<int> get configTemplateId => $composableBuilder(
      column: $table.configTemplateId, builder: (column) => column);

  GeneratedColumn<bool> get isDefaultConfig => $composableBuilder(
      column: $table.isDefaultConfig, builder: (column) => column);

  GeneratedColumn<String> get extraRule =>
      $composableBuilder(column: $table.extraRule, builder: (column) => column);

  GeneratedColumn<String> get saveRule =>
      $composableBuilder(column: $table.saveRule, builder: (column) => column);

  GeneratedColumn<bool> get isBeginGame => $composableBuilder(
      column: $table.isBeginGame, builder: (column) => column);

  GeneratedColumn<bool> get isFinish =>
      $composableBuilder(column: $table.isFinish, builder: (column) => column);

  GeneratedColumn<DateTime> get createTime => $composableBuilder(
      column: $table.createTime, builder: (column) => column);
}

class $$GameDataTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GameDataTable,
    GameEntity,
    $$GameDataTableFilterComposer,
    $$GameDataTableOrderingComposer,
    $$GameDataTableAnnotationComposer,
    $$GameDataTableCreateCompanionBuilder,
    $$GameDataTableUpdateCompanionBuilder,
    (GameEntity, BaseReferences<_$AppDatabase, $GameDataTable, GameEntity>),
    GameEntity,
    PrefetchHooks Function()> {
  $$GameDataTableTableManager(_$AppDatabase db, $GameDataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameDataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameDataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameDataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> configTemplateId = const Value.absent(),
            Value<bool> isDefaultConfig = const Value.absent(),
            Value<String> extraRule = const Value.absent(),
            Value<String> saveRule = const Value.absent(),
            Value<bool> isBeginGame = const Value.absent(),
            Value<bool> isFinish = const Value.absent(),
            Value<DateTime> createTime = const Value.absent(),
          }) =>
              GameDataCompanion(
            id: id,
            name: name,
            configTemplateId: configTemplateId,
            isDefaultConfig: isDefaultConfig,
            extraRule: extraRule,
            saveRule: saveRule,
            isBeginGame: isBeginGame,
            isFinish: isFinish,
            createTime: createTime,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int configTemplateId,
            required bool isDefaultConfig,
            required String extraRule,
            required String saveRule,
            Value<bool> isBeginGame = const Value.absent(),
            Value<bool> isFinish = const Value.absent(),
            Value<DateTime> createTime = const Value.absent(),
          }) =>
              GameDataCompanion.insert(
            id: id,
            name: name,
            configTemplateId: configTemplateId,
            isDefaultConfig: isDefaultConfig,
            extraRule: extraRule,
            saveRule: saveRule,
            isBeginGame: isBeginGame,
            isFinish: isFinish,
            createTime: createTime,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GameDataTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GameDataTable,
    GameEntity,
    $$GameDataTableFilterComposer,
    $$GameDataTableOrderingComposer,
    $$GameDataTableAnnotationComposer,
    $$GameDataTableCreateCompanionBuilder,
    $$GameDataTableUpdateCompanionBuilder,
    (GameEntity, BaseReferences<_$AppDatabase, $GameDataTable, GameEntity>),
    GameEntity,
    PrefetchHooks Function()>;
typedef $$GameTemplateConfigTableCreateCompanionBuilder
    = GameTemplateConfigCompanion Function({
  Value<int> id,
  required String name,
  required int playerCount,
  required String roleConfig,
  required String extraRule,
  required int weight,
  Value<DateTime> createTime,
  Value<bool> delete,
});
typedef $$GameTemplateConfigTableUpdateCompanionBuilder
    = GameTemplateConfigCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> playerCount,
  Value<String> roleConfig,
  Value<String> extraRule,
  Value<int> weight,
  Value<DateTime> createTime,
  Value<bool> delete,
});

class $$GameTemplateConfigTableFilterComposer
    extends Composer<_$AppDatabase, $GameTemplateConfigTable> {
  $$GameTemplateConfigTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get playerCount => $composableBuilder(
      column: $table.playerCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get roleConfig => $composableBuilder(
      column: $table.roleConfig, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get extraRule => $composableBuilder(
      column: $table.extraRule, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createTime => $composableBuilder(
      column: $table.createTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get delete => $composableBuilder(
      column: $table.delete, builder: (column) => ColumnFilters(column));
}

class $$GameTemplateConfigTableOrderingComposer
    extends Composer<_$AppDatabase, $GameTemplateConfigTable> {
  $$GameTemplateConfigTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get playerCount => $composableBuilder(
      column: $table.playerCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get roleConfig => $composableBuilder(
      column: $table.roleConfig, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extraRule => $composableBuilder(
      column: $table.extraRule, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createTime => $composableBuilder(
      column: $table.createTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get delete => $composableBuilder(
      column: $table.delete, builder: (column) => ColumnOrderings(column));
}

class $$GameTemplateConfigTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameTemplateConfigTable> {
  $$GameTemplateConfigTableAnnotationComposer({
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

  GeneratedColumn<int> get playerCount => $composableBuilder(
      column: $table.playerCount, builder: (column) => column);

  GeneratedColumn<String> get roleConfig => $composableBuilder(
      column: $table.roleConfig, builder: (column) => column);

  GeneratedColumn<String> get extraRule =>
      $composableBuilder(column: $table.extraRule, builder: (column) => column);

  GeneratedColumn<int> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<DateTime> get createTime => $composableBuilder(
      column: $table.createTime, builder: (column) => column);

  GeneratedColumn<bool> get delete =>
      $composableBuilder(column: $table.delete, builder: (column) => column);
}

class $$GameTemplateConfigTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GameTemplateConfigTable,
    GameTemplateConfigEntity,
    $$GameTemplateConfigTableFilterComposer,
    $$GameTemplateConfigTableOrderingComposer,
    $$GameTemplateConfigTableAnnotationComposer,
    $$GameTemplateConfigTableCreateCompanionBuilder,
    $$GameTemplateConfigTableUpdateCompanionBuilder,
    (
      GameTemplateConfigEntity,
      BaseReferences<_$AppDatabase, $GameTemplateConfigTable,
          GameTemplateConfigEntity>
    ),
    GameTemplateConfigEntity,
    PrefetchHooks Function()> {
  $$GameTemplateConfigTableTableManager(
      _$AppDatabase db, $GameTemplateConfigTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameTemplateConfigTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameTemplateConfigTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameTemplateConfigTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> playerCount = const Value.absent(),
            Value<String> roleConfig = const Value.absent(),
            Value<String> extraRule = const Value.absent(),
            Value<int> weight = const Value.absent(),
            Value<DateTime> createTime = const Value.absent(),
            Value<bool> delete = const Value.absent(),
          }) =>
              GameTemplateConfigCompanion(
            id: id,
            name: name,
            playerCount: playerCount,
            roleConfig: roleConfig,
            extraRule: extraRule,
            weight: weight,
            createTime: createTime,
            delete: delete,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int playerCount,
            required String roleConfig,
            required String extraRule,
            required int weight,
            Value<DateTime> createTime = const Value.absent(),
            Value<bool> delete = const Value.absent(),
          }) =>
              GameTemplateConfigCompanion.insert(
            id: id,
            name: name,
            playerCount: playerCount,
            roleConfig: roleConfig,
            extraRule: extraRule,
            weight: weight,
            createTime: createTime,
            delete: delete,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GameTemplateConfigTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GameTemplateConfigTable,
    GameTemplateConfigEntity,
    $$GameTemplateConfigTableFilterComposer,
    $$GameTemplateConfigTableOrderingComposer,
    $$GameTemplateConfigTableAnnotationComposer,
    $$GameTemplateConfigTableCreateCompanionBuilder,
    $$GameTemplateConfigTableUpdateCompanionBuilder,
    (
      GameTemplateConfigEntity,
      BaseReferences<_$AppDatabase, $GameTemplateConfigTable,
          GameTemplateConfigEntity>
    ),
    GameTemplateConfigEntity,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GameDataTableTableManager get gameData =>
      $$GameDataTableTableManager(_db, _db.gameData);
  $$GameTemplateConfigTableTableManager get gameTemplateConfig =>
      $$GameTemplateConfigTableTableManager(_db, _db.gameTemplateConfig);
}
