// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RoleActions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SheriffTools _$SheriffToolsFromJson(Map<String, dynamic> json) =>
    SheriffTools.forJson(
      (json['list'] as List<dynamic>)
          .map((e) => SheriffAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      isYesSheriffPlayer: json['isYesSheriffPlayer'] as bool? ?? false,
      yesSheriffRound: (json['yesSheriffRound'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SheriffToolsToJson(SheriffTools instance) =>
    <String, dynamic>{
      'list': instance.list,
      'isYesSheriffPlayer': instance.isYesSheriffPlayer,
      'yesSheriffRound': instance.yesSheriffRound,
    };

SheriffAction _$SheriffActionFromJson(Map<String, dynamic> json) =>
    SheriffAction.forJson(
      (json['sheriffPlayer'] as num?)?.toInt(),
      json['isLive'] as bool,
      (json['settingRound'] as num?)?.toInt(),
      json['isTransferSheriff'] as bool,
      json['isDestroySheriff'] as bool,
      (json['transferSheriffPlayer'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SheriffActionToJson(SheriffAction instance) =>
    <String, dynamic>{
      'sheriffPlayer': instance.sheriffPlayer,
      'isLive': instance.isLive,
      'settingRound': instance.settingRound,
      'isTransferSheriff': instance.isTransferSheriff,
      'isDestroySheriff': instance.isDestroySheriff,
      'transferSheriffPlayer': instance.transferSheriffPlayer,
    };
