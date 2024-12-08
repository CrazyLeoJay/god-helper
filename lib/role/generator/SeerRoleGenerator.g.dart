// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SeerRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class SeerActionJsonData extends JsonEntityData<SeerAction> {
  @override
  SeerAction createForMap(Map<String, dynamic> map) {
    return SeerAction.fromJson(map);
  }

  @override
  SeerAction emptyReturn() {
    return SeerAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeerAction _$SeerActionFromJson(Map<String, dynamic> json) => SeerAction.createJson(
      checkPlayer: (json['checkPlayer'] as num?)?.toInt() ?? 0,
      identity: json['identity'] as bool? ?? true,
    )
      ..role = $enumDecode(_$RoleEnumMap, json['role'])
      ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
      ..isYes = json['isYes'] as bool;

Map<String, dynamic> _$SeerActionToJson(SeerAction instance) => <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'checkPlayer': instance.checkPlayer,
      'identity': instance.identity,
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
