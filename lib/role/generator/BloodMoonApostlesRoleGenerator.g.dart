// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BloodMoonApostlesRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class BloodMoonApostlesDayActionJsonData extends JsonEntityData<BloodMoonApostlesDayAction> {
  @override
  BloodMoonApostlesDayAction createForMap(Map<String, dynamic> map) {
    return BloodMoonApostlesDayAction.fromJson(map);
  }

  @override
  BloodMoonApostlesDayAction emptyReturn() {
    return BloodMoonApostlesDayAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BloodMoonApostlesDayAction _$BloodMoonApostlesDayActionFromJson(Map<String, dynamic> json) =>
    BloodMoonApostlesDayAction()
      ..role = $enumDecode(_$RoleEnumMap, json['role'])
      ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
      ..isYes = json['isYes'] as bool
      ..sealing = json['sealing'] as bool
      ..isBomb = json['isBomb'] as bool;

Map<String, dynamic> _$BloodMoonApostlesDayActionToJson(BloodMoonApostlesDayAction instance) => <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
      'isBomb': instance.isBomb,
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
