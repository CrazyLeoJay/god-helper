// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MachineWolfRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class MachineWolfNightActionJsonData extends JsonEntityData<MachineWolfNightAction> {
  @override
  MachineWolfNightAction createForMap(Map<String, dynamic> map) {
    return MachineWolfNightAction.fromJson(map);
  }

  @override
  MachineWolfNightAction emptyReturn() {
    return MachineWolfNightAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MachineWolfNightAction _$MachineWolfNightActionFromJson(Map<String, dynamic> json) => MachineWolfNightAction()
  ..role = $enumDecode(_$RoleEnumMap, json['role'])
  ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
  ..isYes = json['isYes'] as bool
  ..sealing = json['sealing'] as bool;

Map<String, dynamic> _$MachineWolfNightActionToJson(MachineWolfNightAction instance) => <String, dynamic>{
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
