// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WolfBeautyRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class WolfBeautyNightActionJsonData
    extends JsonEntityData<WolfBeautyNightAction> {
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

WolfBeautyNightAction _$WolfBeautyNightActionFromJson(
        Map<String, dynamic> json) =>
    WolfBeautyNightAction()
      ..role = $enumDecode(_$RoleEnumMap, json['role'])
      ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
      ..isYes = json['isYes'] as bool
      ..sealing = json['sealing'] as bool
      ..charmPlayer = (json['charmPlayer'] as num?)?.toInt()
      ..isAbandon = json['isAbandon'] as bool;

Map<String, dynamic> _$WolfBeautyNightActionToJson(
        WolfBeautyNightAction instance) =>
    <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
      'charmPlayer': instance.charmPlayer,
      'isAbandon': instance.isAbandon,
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

WolfBeautyDayAction _$WolfBeautyDayActionFromJson(Map<String, dynamic> json) =>
    WolfBeautyDayAction()
      ..role = $enumDecode(_$RoleEnumMap, json['role'])
      ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
      ..isYes = json['isYes'] as bool
      ..sealing = json['sealing'] as bool;

Map<String, dynamic> _$WolfBeautyDayActionToJson(
        WolfBeautyDayAction instance) =>
    <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
    };
