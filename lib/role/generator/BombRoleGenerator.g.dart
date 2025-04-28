// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BombRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class BombDayActionJsonData extends JsonEntityData<BombDayAction> {
  @override
  BombDayAction createForMap(Map<String, dynamic> map) {
    return BombDayAction.fromJson(map);
  }

  @override
  BombDayAction emptyReturn() {
    return BombDayAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BombDayAction _$BombDayActionFromJson(Map<String, dynamic> json) => BombDayAction()
  ..role = $enumDecode(_$RoleEnumMap, json['role'])
  ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
  ..isYes = json['isYes'] as bool
  ..sealing = json['sealing'] as bool
  ..votePlayer = (json['votePlayer'] as List<dynamic>).map((e) => (e as num).toInt()).toList();

Map<String, dynamic> _$BombDayActionToJson(BombDayAction instance) => <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'isYes': instance.isYes,
      'sealing': instance.sealing,
      'votePlayer': instance.votePlayer,
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
