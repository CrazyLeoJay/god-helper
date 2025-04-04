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

// 定义一个名为 GameTemplateConfigEntity 的类，用于表示游戏模板配置实体
  GameTemplateConfigEntity({
    // 使用 required 关键字标记以下属性为必需字段，构造实例时必须提供这些值
    required this.id, // 游戏模板的唯一标识符
    required this.name, // 游戏模板的名称
    required this.playerCount, // 游戏模板所需玩家数量
    required this.roleConfig, // 游戏模板的角色配置信息
    required this.extraRule, // 游戏模板的额外规则信息
    // 以下属性为可选字段，提供默认值，构造实例时可以不提供这些值
    this.weight = 1, // 游戏模板的权重，默认值为1
    this.createTime, // 游戏模板的创建时间，默认为 null
    this.isDefaultConfig = false, // 是否为默认配置，默认值为 false
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
