// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RuleConfig.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WitchRule _$WitchRuleFromJson(Map<String, dynamic> json) => WitchRule(
      selfSave: $enumDecodeNullable(_$WitchSelfSaveRuleTypeEnumMap, json['selfSave']) ??
          WitchSelfSaveRuleType.ONLY_FIRST_DAY_SELF_SAVE,
    );

Map<String, dynamic> _$WitchRuleToJson(WitchRule instance) => <String, dynamic>{
      'selfSave': _$WitchSelfSaveRuleTypeEnumMap[instance.selfSave]!,
    };

const _$WitchSelfSaveRuleTypeEnumMap = {
  WitchSelfSaveRuleType.ALL_NOT_SAVE: 'ALL_NOT_SAVE',
  WitchSelfSaveRuleType.ALL_SELF_SAVE: 'ALL_SELF_SAVE',
  WitchSelfSaveRuleType.ONLY_FIRST_DAY_SELF_SAVE: 'ONLY_FIRST_DAY_SELF_SAVE',
  WitchSelfSaveRuleType.ONLY_FIRST_DAY_NOT_SELF_SAVE: 'ONLY_FIRST_DAY_NOT_SELF_SAVE',
};

SheriffExtraConfig _$SheriffExtraConfigFromJson(Map<String, dynamic> json) => SheriffExtraConfig(
      sheriffRace: $enumDecodeNullable(_$SheriffRaceEnumMap, json['sheriffRace']) ?? SheriffRace.onlyFirstDay,
    );

Map<String, dynamic> _$SheriffExtraConfigToJson(SheriffExtraConfig instance) => <String, dynamic>{
      'sheriffRace': _$SheriffRaceEnumMap[instance.sheriffRace]!,
    };

const _$SheriffRaceEnumMap = {
  SheriffRace.none: 'none',
  SheriffRace.onlyFirstDay: 'onlyFirstDay',
  SheriffRace.notForSecond: 'notForSecond',
};
