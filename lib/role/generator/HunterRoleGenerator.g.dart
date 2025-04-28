// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HunterRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class HunterActionJsonData extends JsonEntityData<HunterAction> {
  @override
  HunterAction createForMap(Map<String, dynamic> map) {
    return HunterAction.fromJson(map);
  }

  @override
  HunterAction emptyReturn() {
    return HunterAction();
  }
}

class HunterDayActionJsonData extends JsonEntityData<HunterDayAction> {
  @override
  HunterDayAction createForMap(Map<String, dynamic> map) {
    return HunterDayAction.fromJson(map);
  }

  @override
  HunterDayAction emptyReturn() {
    return HunterDayAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HunterAction _$HunterActionFromJson(Map<String, dynamic> json) => HunterAction()
  ..role = $enumDecode(_$RoleEnumMap, json['role'])
  ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
  ..isYes = json['isYes'] as bool
  ..sealing = json['sealing'] as bool
  ..isCanBiubiubiu = json['isCanBiubiubiu'] as bool;

Map<String, dynamic> _$HunterActionToJson(HunterAction instance) => <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
      'isCanBiubiubiu': instance.isCanBiubiubiu,
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

HunterDayAction _$HunterDayActionFromJson(Map<String, dynamic> json) => HunterDayAction(
      isAbandon: json['isAbandon'] as bool? ?? false,
      canShut: json['canShut'] as bool? ?? true,
    )
      ..role = $enumDecode(_$RoleEnumMap, json['role'])
      ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
      ..isYes = json['isYes'] as bool
      ..sealing = json['sealing'] as bool
      ..shutPlayerId = (json['shutPlayerId'] as num?)?.toInt();

Map<String, dynamic> _$HunterDayActionToJson(HunterDayAction instance) => <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
      'shutPlayerId': instance.shutPlayerId,
      'isAbandon': instance.isAbandon,
      'canShut': instance.canShut,
    };
