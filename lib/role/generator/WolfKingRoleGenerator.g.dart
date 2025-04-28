// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WolfKingRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class WolfKingDayActionJsonData extends JsonEntityData<WolfKingDayAction> {
  @override
  WolfKingDayAction createForMap(Map<String, dynamic> map) {
    return WolfKingDayAction.fromJson(map);
  }

  @override
  WolfKingDayAction emptyReturn() {
    return WolfKingDayAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WolfKingDayAction _$WolfKingDayActionFromJson(Map<String, dynamic> json) =>
    WolfKingDayAction(
      isAbandon: json['isAbandon'] as bool? ?? false,
      canShut: json['canShut'] as bool? ?? true,
    )
      ..role = $enumDecode(_$RoleEnumMap, json['role'])
      ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
      ..isYes = json['isYes'] as bool
      ..sealing = json['sealing'] as bool
      ..shutPlayerId = (json['shutPlayerId'] as num?)?.toInt();

Map<String, dynamic> _$WolfKingDayActionToJson(WolfKingDayAction instance) =>
    <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
      'shutPlayerId': instance.shutPlayerId,
      'isAbandon': instance.isAbandon,
      'canShut': instance.canShut,
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
