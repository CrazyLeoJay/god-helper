// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WitchRoleGenerator.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

class WitchActionJsonData extends JsonEntityData<WitchAction> {
  @override
  WitchAction createForMap(Map<String, dynamic> map) {
    return WitchAction.fromJson(map);
  }

  @override
  WitchAction emptyReturn() {
    return WitchAction();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WitchExtraConfig _$WitchExtraConfigFromJson(Map<String, dynamic> json) => WitchExtraConfig(
      witchRule: $enumDecodeNullable(_$WitchSelfSaveRuleTypeEnumMap, json['witchRule']) ??
          WitchSelfSaveRuleType.ONLY_FIRST_DAY_NOT_SELF_SAVE,
    );

Map<String, dynamic> _$WitchExtraConfigToJson(WitchExtraConfig instance) => <String, dynamic>{
      'witchRule': _$WitchSelfSaveRuleTypeEnumMap[instance.witchRule]!,
    };

const _$WitchSelfSaveRuleTypeEnumMap = {
  WitchSelfSaveRuleType.ALL_NOT_SAVE: 'ALL_NOT_SAVE',
  WitchSelfSaveRuleType.ALL_SELF_SAVE: 'ALL_SELF_SAVE',
  WitchSelfSaveRuleType.ONLY_FIRST_DAY_SELF_SAVE: 'ONLY_FIRST_DAY_SELF_SAVE',
  WitchSelfSaveRuleType.ONLY_FIRST_DAY_NOT_SELF_SAVE: 'ONLY_FIRST_DAY_NOT_SELF_SAVE',
};

WitchAction _$WitchActionFromJson(Map<String, dynamic> json) => WitchAction()
  ..role = $enumDecode(_$RoleEnumMap, json['role'])
  ..isKillNotUseSkill = json['isKillNotUseSkill'] as bool
  ..sealing = json['sealing'] as bool
  ..used = json['used'] as bool
  ..isSave = json['isSave'] as bool?
  ..target = (json['target'] as num?)?.toInt()
  ..haveSaveMedicine = json['haveSaveMedicine'] as bool
  ..haveKillMedicine = json['haveKillMedicine'] as bool
  ..isYes = json['isYes'] as bool;

Map<String, dynamic> _$WitchActionToJson(WitchAction instance) => <String, dynamic>{
      'role': _$RoleEnumMap[instance.role]!,
      'isKillNotUseSkill': instance.isKillNotUseSkill,
      'sealing': instance.sealing,
      'used': instance.used,
      'isSave': instance.isSave,
      'target': instance.target,
      'haveSaveMedicine': instance.haveSaveMedicine,
      'haveKillMedicine': instance.haveKillMedicine,
      'isYes': instance.isYes,
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
