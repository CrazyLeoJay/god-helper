// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RobbersRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class RobbersNightActionJsonData extends JsonEntityData<RobbersNightAction> {
  @override
  RobbersNightAction createForMap(Map<String, dynamic> map) {
    return RobbersNightAction.fromJson(map);
  }

  @override
  RobbersNightAction emptyReturn() {
    return RobbersNightAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RobbersNightAction _$RobbersNightActionFromJson(Map<String, dynamic> json) =>
    RobbersNightAction()
      ..role = $enumDecode(_$RoleEnumMap, json['role'])
      ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
      ..isYes = json['isYes'] as bool
      ..sealing = json['sealing'] as bool;

Map<String, dynamic> _$RobbersNightActionToJson(RobbersNightAction instance) =>
    <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
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
