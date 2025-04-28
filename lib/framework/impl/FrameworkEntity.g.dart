// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FrameworkEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoundActions _$RoundActionsFromJson(Map<String, dynamic> json) => RoundActions(
      (json['gameId'] as num).toInt(),
      (json['round'] as num).toInt(),
    )
      ..roleActionMap = (json['roleActionMap'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$RoleEnumMap, k), e as Map<String, dynamic>),
      )
      ..isYes = json['isYes'] as bool;

Map<String, dynamic> _$RoundActionsToJson(RoundActions instance) => <String, dynamic>{
      'gameId': instance.gameId,
      'round': instance.round,
      'roleActionMap': instance.roleActionMap.map((k, e) => MapEntry(_$RoleEnumMap[k]!, e)),
      'isYes': instance.isYes,
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

RoundProcess _$RoundProcessFromJson(Map<String, dynamic> json) => RoundProcess(
      (json['gameId'] as num).toInt(),
      (json['round'] as num).toInt(),
    )
      ..playerStateMap = PlayerStateMap.fromJson(json['playerStateMap'] as Map<String, dynamic>)
      ..outPlayerNumbers = (json['outPlayerNumbers'] as List<dynamic>).map((e) => (e as num).toInt()).toList()
      ..isFinish = json['isFinish'] as bool
      ..sheriffPlayer = (json['sheriffPlayer'] as num?)?.toInt();

Map<String, dynamic> _$RoundProcessToJson(RoundProcess instance) => <String, dynamic>{
      'gameId': instance.gameId,
      'round': instance.round,
      'playerStateMap': instance.playerStateMap,
      'outPlayerNumbers': instance.outPlayerNumbers,
      'isFinish': instance.isFinish,
      'sheriffPlayer': instance.sheriffPlayer,
    };

DayAction _$DayActionFromJson(Map<String, dynamic> json) => DayAction(
      (json['gameId'] as num).toInt(),
      (json['round'] as num).toInt(),
    )
      ..isYesVotePlayer = json['isYesVotePlayer'] as bool
      ..playerStateMap = PlayerStateMap.fromJson(json['playerStateMap'] as Map<String, dynamic>)
      ..isYesLastStateFlow = json['isYesLastStateFlow'] as bool
      ..isYesFreeTalkFlow = json['isYesFreeTalkFlow'] as bool
      ..isYesVoteFlow = json['isYesVoteFlow'] as bool;

Map<String, dynamic> _$DayActionToJson(DayAction instance) => <String, dynamic>{
      'gameId': instance.gameId,
      'round': instance.round,
      'isYesVotePlayer': instance.isYesVotePlayer,
      'playerStateMap': instance.playerStateMap,
      'isYesLastStateFlow': instance.isYesLastStateFlow,
      'isYesFreeTalkFlow': instance.isYesFreeTalkFlow,
      'isYesVoteFlow': instance.isYesVoteFlow,
    };

PlayerIdentityCache _$PlayerIdentityCacheFromJson(Map<String, dynamic> json) => PlayerIdentityCache(
      (json['gameId'] as num).toInt(),
    )
      ..wolfNumbers = (json['wolfNumbers'] as List<dynamic>).map((e) => (e as num).toInt()).toList()
      ..rolePlayerNumberMap = (json['rolePlayerNumberMap'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$RoleEnumMap, k), (e as num).toInt()),
      )
      ..isRoleRecordFinish = (json['isRoleRecordFinish'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$RoleEnumMap, k), e as bool),
      );

Map<String, dynamic> _$PlayerIdentityCacheToJson(PlayerIdentityCache instance) => <String, dynamic>{
      'gameId': instance.gameId,
      'wolfNumbers': instance.wolfNumbers,
      'rolePlayerNumberMap': instance.rolePlayerNumberMap.map((k, e) => MapEntry(_$RoleEnumMap[k]!, e)),
      'isRoleRecordFinish': instance.isRoleRecordFinish.map((k, e) => MapEntry(_$RoleEnumMap[k]!, e)),
    };

EmptyRoleTempConfig _$EmptyRoleTempConfigFromJson(Map<String, dynamic> json) => EmptyRoleTempConfig();

Map<String, dynamic> _$EmptyRoleTempConfigToJson(EmptyRoleTempConfig instance) => <String, dynamic>{};
