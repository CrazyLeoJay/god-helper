// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BombRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class BombDayActionJsonData extends JsonEntityData<BombDayAction> {
  @override
  BombDayAction createForMap(Map<String, dynamic> map) {
    return BombDayAction.fromJson(map);
  }

  @override
  BombDayAction emptyReturn() {
    return BombDayAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BombDayAction _$BombDayActionFromJson(Map<String, dynamic> json) =>
    BombDayAction()
      ..role = $enumDecode(_$RoleEnumMap, json['role'])
      ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
      ..isYes = json['isYes'] as bool
      ..sealing = json['sealing'] as bool
      ..votePlayer = (json['votePlayer'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList();

Map<String, dynamic> _$BombDayActionToJson(BombDayAction instance) =>
    <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
      'votePlayer': instance.votePlayer,
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
