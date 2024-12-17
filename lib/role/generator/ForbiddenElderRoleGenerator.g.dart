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
