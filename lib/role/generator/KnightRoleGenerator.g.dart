// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'KnightRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class KnightDayActionJsonData extends JsonEntityData<KnightDayAction> {
  @override
  KnightDayAction createForMap(Map<String, dynamic> map) {
    return KnightDayAction.fromJson(map);
  }

  @override
  KnightDayAction emptyReturn() {
    return KnightDayAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KnightDayAction _$KnightDayActionFromJson(Map<String, dynamic> json) => KnightDayAction()
  ..role = $enumDecode(_$RoleEnumMap, json['role'])
  ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
  ..isYes = json['isYes'] as bool
  ..sealing = json['sealing'] as bool
  ..targetPlayer = (json['targetPlayer'] as num?)?.toInt()
  ..targetPlayerIdentity = json['targetPlayerIdentity'] as bool?;

Map<String, dynamic> _$KnightDayActionToJson(KnightDayAction instance) => <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
      'targetPlayer': instance.targetPlayer,
      'targetPlayerIdentity': instance.targetPlayerIdentity,
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
