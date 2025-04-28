// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WhiteWolfRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class WhiteWolfKingDayActionJsonData
    extends JsonEntityData<WhiteWolfKingDayAction> {
  @override
  WhiteWolfKingDayAction createForMap(Map<String, dynamic> map) {
    return WhiteWolfKingDayAction.fromJson(map);
  }

  @override
  WhiteWolfKingDayAction emptyReturn() {
    return WhiteWolfKingDayAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhiteWolfKingDayAction _$WhiteWolfKingDayActionFromJson(
        Map<String, dynamic> json) =>
    WhiteWolfKingDayAction()
      ..role = $enumDecode(_$RoleEnumMap, json['role'])
      ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
      ..isYes = json['isYes'] as bool
      ..sealing = json['sealing'] as bool
      ..killPlayer = (json['killPlayer'] as num?)?.toInt()
      ..isAbandonSkill = json['isAbandonSkill'] as bool;

Map<String, dynamic> _$WhiteWolfKingDayActionToJson(
        WhiteWolfKingDayAction instance) =>
    <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
      'killPlayer': instance.killPlayer,
      'isAbandonSkill': instance.isAbandonSkill,
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
