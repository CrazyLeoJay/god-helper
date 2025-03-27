// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WolfRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class WolfActionJsonData extends JsonEntityData<WolfAction> {
  @override
  WolfAction createForMap(Map<String, dynamic> map) {
    return WolfAction.fromJson(map);
  }

  @override
  WolfAction emptyReturn() {
    return WolfAction();
  }
}

class WolfDayActionJsonData extends JsonEntityData<WolfDayAction> {
  @override
  WolfDayAction createForMap(Map<String, dynamic> map) {
    return WolfDayAction.fromJson(map);
  }

  @override
  WolfDayAction emptyReturn() {
    return WolfDayAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WolfAction _$WolfActionFromJson(Map<String, dynamic> json) => WolfAction()
  ..role = $enumDecode(_$RoleEnumMap, json['role'])
  ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
  ..isYes = json['isYes'] as bool
  ..sealing = json['sealing'] as bool
  ..killPlayer = (json['killPlayer'] as num).toInt()
  ..noKill = json['noKill'] as bool;

Map<String, dynamic> _$WolfActionToJson(WolfAction instance) => <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
      'killPlayer': instance.killPlayer,
      'noKill': instance.noKill,
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

WolfDayAction _$WolfDayActionFromJson(Map<String, dynamic> json) => WolfDayAction(
      isBomb: json['isBomb'] as bool? ?? false,
    )
      ..role = $enumDecode(_$RoleEnumMap, json['role'])
      ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
      ..sealing = json['sealing'] as bool
      ..wolfBombPlayer = (json['wolfBombPlayer'] as num?)?.toInt()
      ..isYes = json['isYes'] as bool;

Map<String, dynamic> _$WolfDayActionToJson(WolfDayAction instance) => <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'sealing': instance.sealing,
      'wolfBombPlayer': instance.wolfBombPlayer,
      'isBomb': instance.isBomb,
      'isYes': instance.isYes,
    };
