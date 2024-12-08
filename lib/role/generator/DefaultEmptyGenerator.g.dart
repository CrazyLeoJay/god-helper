// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DefaultEmptyGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class EmptyActionJsonData extends JsonEntityData<EmptyAction> {
  @override
  EmptyAction createForMap(Map<String, dynamic> map) {
    return EmptyAction.fromJson(map);
  }

  @override
  EmptyAction emptyReturn() {
    return EmptyAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmptyAction _$EmptyActionFromJson(Map<String, dynamic> json) => EmptyAction()
  ..role = $enumDecode(_$RoleEnumMap, json['role'])
  ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
  ..isYes = json['isYes'] as bool;

Map<String, dynamic> _$EmptyActionToJson(EmptyAction instance) => <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
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

EmptyJsonEntity _$EmptyJsonEntityFromJson(Map<String, dynamic> json) => EmptyJsonEntity();

Map<String, dynamic> _$EmptyJsonEntityToJson(EmptyJsonEntity instance) => <String, dynamic>{};
