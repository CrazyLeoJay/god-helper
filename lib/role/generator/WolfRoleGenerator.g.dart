// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WolfRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class WolfActionJsonData extends JsonEntityData<WolfAction> {
  @override
  WolfAction createForMap(Map<String, dynamic> map) {
    return WolfAction.fromJson(map);
  }

  @override
  WolfAction emptyReturn() {
    return WolfAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WolfAction _$WolfActionFromJson(Map<String, dynamic> json) => WolfAction()
  ..role = $enumDecode(_$RoleEnumMap, json['role'])
  ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
  ..isYes = json['isYes'] as bool
  ..killPlayer = (json['killPlayer'] as num).toInt()
  ..noKill = json['noKill'] as bool;

Map<String, dynamic> _$WolfActionToJson(WolfAction instance) => <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'killPlayer': instance.killPlayer,
      'noKill': instance.noKill,
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
