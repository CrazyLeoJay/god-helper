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
    );

Map<String, dynamic> _$SheriffToolsToJson(SheriffTools instance) =>
    <String, dynamic>{
      'list': instance.list,
      'isYesSheriffPlayer': instance.isYesSheriffPlayer,
    };

SheriffAction _$SheriffActionFromJson(Map<String, dynamic> json) =>
    SheriffAction.forJson(
      (json['sheriffPlayer'] as num?)?.toInt(),
      json['isTransferSheriff'] as bool,
      json['isDestroySheriff'] as bool,
      (json['transferSheriffPlayer'] as num?)?.toInt(),
    )..isLive = json['isLive'] as bool;

Map<String, dynamic> _$SheriffActionToJson(SheriffAction instance) =>
    <String, dynamic>{
      'sheriffPlayer': instance.sheriffPlayer,
      'isLive': instance.isLive,
      'isTransferSheriff': instance.isTransferSheriff,
      'isDestroySheriff': instance.isDestroySheriff,
      'transferSheriffPlayer': instance.transferSheriffPlayer,
    };
