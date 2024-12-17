// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WitcherRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class WitcherNightActionJsonData extends JsonEntityData<WitcherNightAction> {
  @override
  WitcherNightAction createForMap(Map<String, dynamic> map) {
    return WitcherNightAction.fromJson(map);
  }

  @override
  WitcherNightAction emptyReturn() {
    return WitcherNightAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WitcherNightAction _$WitcherNightActionFromJson(Map<String, dynamic> json) =>
    WitcherNightAction()
      ..role = $enumDecode(_$RoleEnumMap, json['role'])
      ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
      ..isYes = json['isYes'] as bool
      ..sealing = json['sealing'] as bool
      ..selectPlayer = (json['selectPlayer'] as num?)?.toInt()
      ..isAbandon = json['isAbandon'] as bool;

Map<String, dynamic> _$WitcherNightActionToJson(WitcherNightAction instance) =>
    <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
      'selectPlayer': instance.selectPlayer,
      'isAbandon': instance.isAbandon,
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
