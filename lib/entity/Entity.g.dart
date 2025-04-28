// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Entity.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

/// PlayersSaveRule 数据库转换器
class PlayersSaveRuleDriftConverter
    extends drift.TypeConverter<PlayersSaveRule?, String?>
    with drift.JsonTypeConverter<PlayersSaveRule?, String?> {
  const PlayersSaveRuleDriftConverter();

  @override
  PlayersSaveRule? fromSql(String? fromDb) {
    if (null == fromDb) return null;
    return _$PlayersSaveRuleFromJson(jsonDecode(fromDb));
  }

  @override
  String? toSql(PlayersSaveRule? value) {
    if (null == value) return null;
    return jsonEncode(_$PlayersSaveRuleToJson(value));
  }
}

/// PlayerDetail 数据库转换器
class PlayerDetailDriftConverter
    extends drift.TypeConverter<PlayerDetail?, String?>
    with drift.JsonTypeConverter<PlayerDetail?, String?> {
  const PlayerDetailDriftConverter();

  @override
  PlayerDetail? fromSql(String? fromDb) {
    if (null == fromDb) return null;
    return _$PlayerDetailFromJson(jsonDecode(fromDb));
  }

  @override
  String? toSql(PlayerDetail? value) {
    if (null == value) return null;
    return jsonEncode(_$PlayerDetailToJson(value));
  }
}

/// TemplateRoleConfig 数据库转换器
class TemplateRoleConfigDriftConverter
    extends drift.TypeConverter<TemplateRoleConfig?, String?>
    with drift.JsonTypeConverter<TemplateRoleConfig?, String?> {
  const TemplateRoleConfigDriftConverter();

  @override
  TemplateRoleConfig? fromSql(String? fromDb) {
    if (null == fromDb) return null;
    return _$TemplateRoleConfigFromJson(jsonDecode(fromDb));
  }

  @override
  String? toSql(TemplateRoleConfig? value) {
    if (null == value) return null;
    return jsonEncode(_$TemplateRoleConfigToJson(value));
  }
}

/// TempExtraRule 数据库转换器
class TempExtraRuleDriftConverter
    extends drift.TypeConverter<TempExtraRule?, String?>
    with drift.JsonTypeConverter<TempExtraRule?, String?> {
  const TempExtraRuleDriftConverter();

  @override
  TempExtraRule? fromSql(String? fromDb) {
    if (null == fromDb) return null;
    return _$TempExtraRuleFromJson(jsonDecode(fromDb));
  }

  @override
  String? toSql(TempExtraRule? value) {
    if (null == value) return null;
    return jsonEncode(_$TempExtraRuleToJson(value));
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameDetailEntity _$GameDetailEntityFromJson(Map<String, dynamic> json) =>
    GameDetailEntity(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String,
      tempConfig: GameTemplateConfigEntity.fromJson(
          json['tempConfig'] as Map<String, dynamic>),
      isSystemConfig: json['isSystemConfig'] as bool? ?? false,
      createTime: json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String),
      isBeginGame: json['isBeginGame'] as bool? ?? false,
      isFinish: json['isFinish'] as bool? ?? false,
    )
      ..extraRule =
          TempExtraRule.fromJson(json['extraRule'] as Map<String, dynamic>)
      ..saveRule =
          PlayersSaveRule.fromJson(json['saveRule'] as Map<String, dynamic>);

Map<String, dynamic> _$GameDetailEntityToJson(GameDetailEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isSystemConfig': instance.isSystemConfig,
      'tempConfig': instance.tempConfig,
      'createTime': instance.createTime?.toIso8601String(),
      'extraRule': instance.extraRule,
      'saveRule': instance.saveRule,
      'isBeginGame': instance.isBeginGame,
      'isFinish': instance.isFinish,
    };

PlayersSaveRule _$PlayersSaveRuleFromJson(Map<String, dynamic> json) =>
    PlayersSaveRule.createForJson(
      firstKillSavePlayers: (json['firstKillSavePlayers'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      firstVerifySavePlayers: (json['firstVerifySavePlayers'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      firstPoisonSavePlayers: (json['firstPoisonSavePlayers'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$PlayersSaveRuleToJson(PlayersSaveRule instance) =>
    <String, dynamic>{
      'firstKillSavePlayers': instance.firstKillSavePlayers,
      'firstVerifySavePlayers': instance.firstVerifySavePlayers,
      'firstPoisonSavePlayers': instance.firstPoisonSavePlayers,
    };

PlayerDetail _$PlayerDetailFromJson(Map<String, dynamic> json) => PlayerDetail(
      (json['gameId'] as num).toInt(),
    )..players = (json['players'] as List<dynamic>)
        .map((e) => Player.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$PlayerDetailToJson(PlayerDetail instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'players': instance.players,
    };

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
      number: (json['number'] as num).toInt(),
      identity: json['identity'] as bool? ?? true,
      role: $enumDecodeNullable(_$RoleEnumMap, json['role']) ?? Role.citizen,
      live: json['live'] as bool? ?? true,
      isInit: json['isInit'] as bool? ?? false,
      roleType: $enumDecodeNullable(_$RoleTypeEnumMap, json['roleType']),
      buffs: (json['buffs'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$PlayerBuffTypeEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'number': instance.number,
      'role': _$RoleEnumMap[instance.role]!,
      'identity': instance.identity,
      'live': instance.live,
      'isInit': instance.isInit,
      'roleType': _$RoleTypeEnumMap[instance.roleType]!,
      'buffs': instance.buffs.map((e) => _$PlayerBuffTypeEnumMap[e]!).toList(),
    };

const _$RoleEnumMap = {
  Role.EMPTY: 'EMPTY',
  Role.sheriff: 'sheriff',
  Role.citizen: 'citizen',
  Role.wolf: 'wolf',
  Role.seer: 'seer',
  Role.witch: 'witch',
  Role.hunter: 'hunter',
  Role.guard: 'guard',
  Role.fool: 'fool',
  Role.wolfKing: 'wolfKing',
  Role.whiteWolfKing: 'whiteWolfKing',
  Role.wolfBeauty: 'wolfBeauty',
  Role.bomb: 'bomb',
  Role.fox: 'fox',
  Role.bear: 'bear',
  Role.bloodMoonApostles: 'bloodMoonApostles',
  Role.machineWolf: 'machineWolf',
  Role.robbers: 'robbers',
  Role.forbiddenElder: 'forbiddenElder',
  Role.barbarianChild: 'barbarianChild',
  Role.knight: 'knight',
  Role.witcher: 'witcher',
};

const _$RoleTypeEnumMap = {
  RoleType.CITIZEN: 'CITIZEN',
  RoleType.GOD: 'GOD',
  RoleType.WOLF: 'WOLF',
  RoleType.THIRD: 'THIRD',
};

const _$PlayerBuffTypeEnumMap = {
  PlayerBuffType.foolVoteOutDefense: 'foolVoteOutDefense',
  PlayerBuffType.foxVerifyThreeGoodPlayer: 'foxVerifyThreeGoodPlayer',
  PlayerBuffType.witchUsedAntidote: 'witchUsedAntidote',
  PlayerBuffType.witchUsedPoison: 'witchUsedPoison',
};

PlayerStates _$PlayerStatesFromJson(Map<String, dynamic> json) => PlayerStates(
      states: (json['states'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry($enumDecode(_$PlayerStateTypeEnumMap, k), e as bool),
      ),
      killPlayer: (json['killPlayer'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      murderer: (json['murderer'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PlayerStatesToJson(PlayerStates instance) =>
    <String, dynamic>{
      'states': instance.states
          .map((k, e) => MapEntry(_$PlayerStateTypeEnumMap[k]!, e)),
      'killPlayer': instance.killPlayer,
      'murderer': instance.murderer,
    };

const _$PlayerStateTypeEnumMap = {
  PlayerStateType.isWolfKill: 'isWolfKill',
  PlayerStateType.isProtectedForGuard: 'isProtectedForGuard',
  PlayerStateType.isKillWithPoison: 'isKillWithPoison',
  PlayerStateType.isSaveWithMedicine: 'isSaveWithMedicine',
  PlayerStateType.isCheckedForSeer: 'isCheckedForSeer',
  PlayerStateType.isKillWithHunter: 'isKillWithHunter',
  PlayerStateType.isKillWithWolfKing: 'isKillWithWolfKing',
  PlayerStateType.isHaveAntidote: 'isHaveAntidote',
  PlayerStateType.isUsedAntidote: 'isUsedAntidote',
  PlayerStateType.isHavePoison: 'isHavePoison',
  PlayerStateType.isUsedPoison: 'isUsedPoison',
  PlayerStateType.isWolfBomb: 'isWolfBomb',
  PlayerStateType.isYesVotePlayer: 'isYesVotePlayer',
  PlayerStateType.isSheriff: 'isSheriff',
  PlayerStateType.transferSheriff: 'transferSheriff',
  PlayerStateType.destroySheriff: 'destroySheriff',
  PlayerStateType.abandonUsePower: 'abandonUsePower',
  PlayerStateType.dieForBomb: 'dieForBomb',
  PlayerStateType.foolShowIdentity: 'foolShowIdentity',
  PlayerStateType.isKillWithWhiteWolfKing: 'isKillWithWhiteWolfKing',
  PlayerStateType.isCharmFormWolfBeauty: 'isCharmFormWolfBeauty',
  PlayerStateType.isDieBecauseWolfBeautyDie: 'isDieBecauseWolfBeautyDie',
  PlayerStateType.barbarianChildExample: 'barbarianChildExample',
  PlayerStateType.barbarianChildChangeWolfForExampleDie:
      'barbarianChildChangeWolfForExampleDie',
  PlayerStateType.theBearGrowled: 'theBearGrowled',
  PlayerStateType.bloodMoonApostlesBomb: 'bloodMoonApostlesBomb',
  PlayerStateType.bannedOfShutUpForbiddenElder: 'bannedOfShutUpForbiddenElder',
  PlayerStateType.verifyForFox: 'verifyForFox',
  PlayerStateType.foxVerifyWolf: 'foxVerifyWolf',
  PlayerStateType.foxVerifyNoWolf: 'foxVerifyNoWolf',
  PlayerStateType.knightDuelFailure: 'knightDuelFailure',
  PlayerStateType.knightDuelSuccess: 'knightDuelSuccess',
  PlayerStateType.killForKnightDuel: 'killForKnightDuel',
  PlayerStateType.liveForKnightDuel: 'liveForKnightDuel',
  PlayerStateType.killInWitcherHunt: 'killInWitcherHunt',
  PlayerStateType.killInWitcherHuntFailure: 'killInWitcherHuntFailure',
};

PlayerStateMap _$PlayerStateMapFromJson(Map<String, dynamic> json) =>
    PlayerStateMap(
      states: (json['states'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            int.parse(k), PlayerStates.fromJson(e as Map<String, dynamic>)),
      ),
      buffs: (json['buffs'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            int.parse(k), PlayerBuffs.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$PlayerStateMapToJson(PlayerStateMap instance) =>
    <String, dynamic>{
      'states': instance.states.map((k, e) => MapEntry(k.toString(), e)),
      'buffs': instance.buffs.map((k, e) => MapEntry(k.toString(), e)),
    };

PlayerBuffs _$PlayerBuffsFromJson(Map<String, dynamic> json) => PlayerBuffs(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$PlayerBuffTypeEnumMap, e))
          .toSet(),
    );

Map<String, dynamic> _$PlayerBuffsToJson(PlayerBuffs instance) =>
    <String, dynamic>{
      'list': instance.list.map((e) => _$PlayerBuffTypeEnumMap[e]!).toList(),
    };

TemplateRoleConfig _$TemplateRoleConfigFromJson(Map<String, dynamic> json) =>
    TemplateRoleConfig(
      citizenCount: (json['citizenCount'] as num?)?.toInt() ?? 0,
      wolfCount: (json['wolfCount'] as num?)?.toInt() ?? 0,
      roles: (json['roles'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$RoleTypeEnumMap, k),
            (e as List<dynamic>)
                .map((e) => $enumDecode(_$RoleEnumMap, e))
                .toList()),
      ),
    );

Map<String, dynamic> _$TemplateRoleConfigToJson(TemplateRoleConfig instance) =>
    <String, dynamic>{
      'citizenCount': instance.citizenCount,
      'wolfCount': instance.wolfCount,
      'roles': instance.roles.map((k, e) => MapEntry(
          _$RoleTypeEnumMap[k]!, e.map((e) => _$RoleEnumMap[e]!).toList())),
    };

TempExtraRule _$TempExtraRuleFromJson(Map<String, dynamic> json) =>
    TempExtraRule(
      ruleMaps: (json['ruleMaps'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry($enumDecode(_$RoleEnumMap, k), e as Map<String, dynamic>),
      ),
      winRule: $enumDecodeNullable(_$WinRuleEnumMap, json['winRule']) ??
          WinRule.KILL_SIDE,
    );

Map<String, dynamic> _$TempExtraRuleToJson(TempExtraRule instance) =>
    <String, dynamic>{
      'ruleMaps':
          instance.ruleMaps.map((k, e) => MapEntry(_$RoleEnumMap[k]!, e)),
      'winRule': _$WinRuleEnumMap[instance.winRule]!,
    };

const _$WinRuleEnumMap = {
  WinRule.KILL_SIDE: 'KILL_SIDE',
  WinRule.KILL_ALL_CITY: 'KILL_ALL_CITY',
};
