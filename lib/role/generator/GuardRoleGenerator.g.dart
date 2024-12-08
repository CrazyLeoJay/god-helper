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
      ..isYes = json['isYes'] as bool;

Map<String, dynamic> _$GuardNightActionToJson(GuardNightAction instance) => <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'protectedPlayer': instance.protectedPlayer,
      'isAbandonUseSkill': instance.isAbandonUseSkill,
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
  Role.WOLF_AMOR: 'WOLF_AMOR',
  Role.BOMB: 'BOMB',
};
