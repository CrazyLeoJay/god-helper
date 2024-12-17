// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FoolRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class FoolDayActionJsonData extends JsonEntityData<FoolDayAction> {
  @override
  FoolDayAction createForMap(Map<String, dynamic> map) {
    return FoolDayAction.fromJson(map);
  }

  @override
  FoolDayAction emptyReturn() {
    return FoolDayAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoolDayAction _$FoolDayActionFromJson(Map<String, dynamic> json) => FoolDayAction()
  ..role = $enumDecode(_$RoleEnumMap, json['role'])
  ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
  ..isYes = json['isYes'] as bool
  ..sealing = json['sealing'] as bool
  ..isVoteOut = json['isVoteOut'] as bool;

Map<String, dynamic> _$FoolDayActionToJson(FoolDayAction instance) => <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
      'isVoteOut': instance.isVoteOut,
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
