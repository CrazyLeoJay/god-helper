import 'dart:convert';

import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/framework/AppFactory.dart';
import 'package:json_annotation/json_annotation.dart';

part 'DbEntity.g.dart';

@JsonSerializable()
class GameEntity {
  int id;
  String name;
  int configTemplateId;

  /// 是否为系统默认配置
  bool isDefaultConfig;

  TempExtraRule extraRule = TempExtraRule();
  PlayersSaveRule saveRule = PlayersSaveRule();

  bool isBeginGame = false;
  bool isFinish = false;
  DateTime createTime;

  GameEntity({
    required this.id,
    required this.name,
    required this.configTemplateId,
    required this.isDefaultConfig,
    required this.extraRule,
    required this.createTime,
    this.isBeginGame = false,
    this.isFinish = false,
  });

  GameEntity.forDB(
    this.id,
    this.name,
    this.configTemplateId,
    this.isDefaultConfig,
    String? saveRule,
    String? extraRule,
    this.isBeginGame,
    this.isFinish,
    this.createTime,
  ) {
    if (null != saveRule) {
      this.saveRule = PlayersSaveRule.fromJson(jsonDecode(saveRule));
    }
    if (null != extraRule) {
      this.extraRule = TempExtraRule.fromJson(jsonDecode(extraRule));
    }
  }

  Future<GameTemplateConfigEntity> get tempConfig async {
    return await AppFactory().service.getTempForId(configTemplateId);
  }
}

/// 游戏模板配置
@JsonSerializable()
class GameTemplateConfigEntity {
  int id;
  String name;
  int playerCount;
  late TemplateRoleConfig roleConfig;
  late TempExtraRule extraRule;
  int weight;
  DateTime? createTime;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isDefaultConfig = false;

  GameTemplateConfigEntity({
    required this.id,
    required this.name,
    required this.playerCount,
    required this.roleConfig,
    required this.extraRule,
    this.weight = 1,
    this.createTime,
    this.isDefaultConfig = false,
  });

  GameTemplateConfigEntity.forDB(
    this.id,
    this.name,
    this.playerCount,
    String? roleConfig,
    String? extraRule,
    this.weight,
    this.createTime,
  ) {
    if (null != roleConfig) {
      this.roleConfig = TemplateRoleConfig.fromJson(jsonDecode(roleConfig));
    } else {
      this.roleConfig = TemplateRoleConfig(roles: {});
    }
    if (null != extraRule) {
      this.extraRule = TempExtraRule.fromJson(jsonDecode(extraRule));
    } else {
      this.extraRule = TempExtraRule();
    }
  }

  GameTemplateConfigEntity.systemTemp({
    required int id,
    required String name,
    required int citizenCount,
    required int wolfCount,
    required Map<RoleType, List<Role>> roles,
    TempExtraRule? extraRule,
  }) : this(
          id: id,
          name: name,
          playerCount: TemplateRoleConfig(roles: roles, citizenCount: citizenCount, wolfCount: wolfCount).count(),
          roleConfig: TemplateRoleConfig(roles: roles, citizenCount: citizenCount, wolfCount: wolfCount),
          extraRule: extraRule ?? TempExtraRule(),
          weight: 3,
          createTime: null,
          isDefaultConfig: true,
        );

  factory GameTemplateConfigEntity.fromJson(Map<String, dynamic> json) => _$GameTemplateConfigEntityFromJson(json);

  Map<String, dynamic> toJson() => _$GameTemplateConfigEntityToJson(this);
}
