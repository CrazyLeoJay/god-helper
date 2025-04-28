// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ForbiddenElderRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class ForbiddenElderNightActionJsonData
    extends JsonEntityData<ForbiddenElderNightAction> {
  @override
  ForbiddenElderNightAction createForMap(Map<String, dynamic> map) {
    return ForbiddenElderNightAction.fromJson(map);
  }

  @override
  ForbiddenElderNightAction emptyReturn() {
    return ForbiddenElderNightAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForbiddenElderNightAction _$ForbiddenElderNightActionFromJson(
        Map<String, dynamic> json) =>
    ForbiddenElderNightAction()
      ..role = $enumDecode(_$RoleEnumMap, json['role'])
      ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
      ..isYes = json['isYes'] as bool
      ..sealing = json['sealing'] as bool
      ..selectPlayer = (json['selectPlayer'] as num?)?.toInt()
      ..abandon = json['abandon'] as bool;

Map<String, dynamic> _$ForbiddenElderNightActionToJson(
        ForbiddenElderNightAction instance) =>
    <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
      'selectPlayer': instance.selectPlayer,
      'abandon': instance.abandon,
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
