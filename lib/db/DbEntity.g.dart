// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DbEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameEntity _$GameEntityFromJson(Map<String, dynamic> json) => GameEntity(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      configTemplateId: (json['configTemplateId'] as num).toInt(),
      isDefaultConfig: json['isDefaultConfig'] as bool,
      extraRule:
          TempExtraRule.fromJson(json['extraRule'] as Map<String, dynamic>),
      createTime: DateTime.parse(json['createTime'] as String),
      isBeginGame: json['isBeginGame'] as bool? ?? false,
      isFinish: json['isFinish'] as bool? ?? false,
    )..saveRule =
        PlayersSaveRule.fromJson(json['saveRule'] as Map<String, dynamic>);

Map<String, dynamic> _$GameEntityToJson(GameEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'configTemplateId': instance.configTemplateId,
      'isDefaultConfig': instance.isDefaultConfig,
      'extraRule': instance.extraRule,
      'saveRule': instance.saveRule,
      'isBeginGame': instance.isBeginGame,
      'isFinish': instance.isFinish,
      'createTime': instance.createTime.toIso8601String(),
    };

GameTemplateConfigEntity _$GameTemplateConfigEntityFromJson(
        Map<String, dynamic> json) =>
    GameTemplateConfigEntity(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      playerCount: (json['playerCount'] as num).toInt(),
      roleConfig: TemplateRoleConfig.fromJson(
          json['roleConfig'] as Map<String, dynamic>),
      extraRule:
          TempExtraRule.fromJson(json['extraRule'] as Map<String, dynamic>),
      weight: (json['weight'] as num?)?.toInt() ?? 1,
      createTime: json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String),
    );

Map<String, dynamic> _$GameTemplateConfigEntityToJson(
        GameTemplateConfigEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'playerCount': instance.playerCount,
      'roleConfig': instance.roleConfig,
      'extraRule': instance.extraRule,
      'weight': instance.weight,
      'createTime': instance.createTime?.toIso8601String(),
    };
