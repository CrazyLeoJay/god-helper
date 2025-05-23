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
      ..isYes = json['isYes'] as bool
      ..sealing = json['sealing'] as bool;

Map<String, dynamic> _$SeerActionToJson(SeerAction instance) => <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
      'checkPlayer': instance.checkPlayer,
      'identity': instance.identity,
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
