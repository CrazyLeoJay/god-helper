// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WolfBeautyRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class WolfBeautyNightActionJsonData extends JsonEntityData<WolfBeautyNightAction> {
  @override
  WolfBeautyNightAction createForMap(Map<String, dynamic> map) {
    return WolfBeautyNightAction.fromJson(map);
  }

  @override
  WolfBeautyNightAction emptyReturn() {
    return WolfBeautyNightAction();
  }
}

class WolfBeautyDayActionJsonData extends JsonEntityData<WolfBeautyDayAction> {
  @override
  WolfBeautyDayAction createForMap(Map<String, dynamic> map) {
    return WolfBeautyDayAction.fromJson(map);
  }

  @override
  WolfBeautyDayAction emptyReturn() {
    return WolfBeautyDayAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WolfBeautyNightAction _$WolfBeautyNightActionFromJson(Map<String, dynamic> json) => WolfBeautyNightAction()
  ..role = $enumDecode(_$RoleEnumMap, json['role'])
  ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
  ..isYes = json['isYes'] as bool
  ..sealing = json['sealing'] as bool
  ..charmPlayer = (json['charmPlayer'] as num?)?.toInt()
  ..isAbandon = json['isAbandon'] as bool;

Map<String, dynamic> _$WolfBeautyNightActionToJson(WolfBeautyNightAction instance) => <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
      'charmPlayer': instance.charmPlayer,
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

WolfBeautyDayAction _$WolfBeautyDayActionFromJson(Map<String, dynamic> json) => WolfBeautyDayAction()
  ..role = $enumDecode(_$RoleEnumMap, json['role'])
  ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
  ..isYes = json['isYes'] as bool
  ..sealing = json['sealing'] as bool;

Map<String, dynamic> _$WolfBeautyDayActionToJson(WolfBeautyDayAction instance) => <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
    };
