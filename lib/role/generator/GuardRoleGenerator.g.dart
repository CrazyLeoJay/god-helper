// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GuardRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class GuardNightActionJsonData extends JsonEntityData<GuardNightAction> {
  @override
  GuardNightAction createForMap(Map<String, dynamic> map) {
    return GuardNightAction.fromJson(map);
  }

  @override
  GuardNightAction emptyReturn() {
    return GuardNightAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuardNightAction _$GuardNightActionFromJson(Map<String, dynamic> json) => GuardNightAction(
      protectedPlayer: (json['protectedPlayer'] as num?)?.toInt(),
      isAbandonUseSkill: json['isAbandonUseSkill'] as bool? ?? false,
      isKillNotUseSkill: json['isKillNotUseSkill'] as bool? ?? false,
    )
      ..role = $enumDecode(_$RoleEnumMap, json['role'])
      ..isYes = json['isYes'] as bool
      ..sealing = json['sealing'] as bool;

Map<String, dynamic> _$GuardNightActionToJson(GuardNightAction instance) => <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
      'protectedPlayer': instance.protectedPlayer,
      'isAbandonUseSkill': instance.isAbandonUseSkill,
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
