// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FoxRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class FoxNightActionJsonData extends JsonEntityData<FoxNightAction> {
  @override
  FoxNightAction createForMap(Map<String, dynamic> map) {
    return FoxNightAction.fromJson(map);
  }

  @override
  FoxNightAction emptyReturn() {
    return FoxNightAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoxNightAction _$FoxNightActionFromJson(Map<String, dynamic> json) =>
    FoxNightAction()
      ..role = $enumDecode(_$RoleEnumMap, json['role'])
      ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
      ..isYes = json['isYes'] as bool
      ..sealing = json['sealing'] as bool
      ..selectPlayer = (json['selectPlayer'] as num?)?.toInt()
      ..selectPlayers = (json['selectPlayers'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList()
      ..isWolf = json['isWolf'] as bool?
      ..isAbandon = json['isAbandon'] as bool;

Map<String, dynamic> _$FoxNightActionToJson(FoxNightAction instance) =>
    <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
      'selectPlayer': instance.selectPlayer,
      'selectPlayers': instance.selectPlayers,
      'isWolf': instance.isWolf,
      'isAbandon': instance.isAbandon,
    };

const _$RoleEnumMap = {
  Role.EMPTY: 'EMPTY',
  Role.SHERIFF: 'SHERIFF',
  Role.CITIZEN: 'CITIZEN',
  Role.WOLF: 'WOLF',
  Role.SEER: 'SEER',
  Role.WITCH: 'WITCH',
  Role.HUNTER: 'HUNTER',
  Role.GUARD: 'GUARD',
  Role.FOOL: 'FOOL',
  Role.WOLF_KING: 'WOLF_KING',
  Role.WHITE_WOLF_KING: 'WHITE_WOLF_KING',
  Role.wolfBeauty: 'wolfBeauty',
  Role.bomb: 'bomb',
  Role.fox: 'fox',
  Role.bear: 'bear',
  Role.bloodMoonApostles: 'bloodMoonApostles',
  Role.machineWolf: 'machineWolf',
  Role.forbiddenElder: 'forbiddenElder',
  Role.barbarianChild: 'barbarianChild',
  Role.knight: 'knight',
  Role.witcher: 'witcher',
};
