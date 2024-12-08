import 'package:flutter/material.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum Role implements Comparable<Role> {
  EMPTY(0, "默认空", RoleType.CITIZEN),
  SHERIFF(-1, "警长", RoleType.CITIZEN),

  /// 村民
  CITIZEN(1, "村民", RoleType.CITIZEN, isSkill: false),

  /// 狼人
  WOLF(
    2,
    "狼人",
    RoleType.WOLF,
    isSkill: false,
    sortWeight: 10,
    icon: Icon(PhosphorIconsRegular.horse),
  ),

  /// 预言家
  SEER(
    3,
    "预言家",
    RoleType.GOD,
    sortWeight: 10,
    afterWithRole: [Role.WOLF],
    icon: Icon(PhosphorIconsRegular.detective),
    ruleDesc: "每晚可以查验一名玩家，可以知道他是好人还是狼人",
  ),

  /// 女巫
  WITCH(
    4,
    "女巫",
    RoleType.GOD,
    sortWeight: 9,
    afterWithRole: [Role.WOLF],
    icon: Icon(PhosphorIconsRegular.stethoscope),
    ruleDesc: "女巫有两瓶药，一瓶解药一瓶毒药，每晚只能用一瓶药。\n"
        "当女巫有解药时，可以知道谁被狼人刀，可以选择救治，但没有药时，不知道。\n"
        "如果女巫也可以选择使用毒药毒一名玩家使其出局。\n"
        "自救行为：不同的板子可以设置女巫的自救规则",
  ),

  /// 猎人
  HUNTER(
    5,
    "猎人",
    RoleType.GOD,
    afterWithRole: [Role.WITCH],
    icon: Icon(PhosphorIconsRegular.crosshair),
  ),

  /// 守卫
  GUARD(
    6,
    "守卫",
    RoleType.GOD,
    icon: Icon(PhosphorIconsRegular.shieldWarning),
  ),

  /// 白痴
  FOOL(
    7,
    "白痴",
    RoleType.GOD,
    ruleDesc: "白痴被投票出局后翻牌，可以免除一次放逐，但后续不能被选择为投票目标。",
  ),

  /// 狼王/狼枪
  WOLF_KING(
    8,
    "狼王/狼枪",
    RoleType.WOLF,
    icon: Icon(PhosphorIconsRegular.horse),
  ),

  /// 白狼王
  WHITE_WOLF_KING(
    9,
    "白狼王",
    RoleType.WOLF,
    icon: Icon(PhosphorIconsRegular.horse),
  ),

  /// 狼美人
  WOLF_AMOR(
    10,
    "狼美人",
    RoleType.THIRD,
    icon: Icon(PhosphorIconsRegular.horse),
  ),

  /// 炸弹人
  BOMB(
    11,
    "炸弹人",
    RoleType.THIRD,
    icon: Icon(PhosphorIconsRegular.bomb),
  ),
  ;

  // 一级信息

  /// 角色id
  final int id;

  /// 角色名称
  final String roleName;

  /// 角色类型
  /// 由于有些角色虽然有技能也可以归为村民
  /// 在实际游戏中，可以根据游戏情况去动态设置角色类型
  final RoleType type;

  /// 角色阵营 也可以根据角色类型获取
  Camp get camp => type.camp;

  /// 默认身份好坏，可以根据角色类型或者阵营来判断
  /// 可能由于技能发生变化，需要在对局中配置
  bool get defaultIdentity => type.defaultIdentity;

  // 二级信息，用于排序，或者基础的Icon设置

  /// 角色图标
  final Icon icon;

  /// 排序权重
  final int _sortWeight;

  /// 是否拥有技能
  /// 在配置模板时，可以根据这个参数来选择是否可以选择该角色到模板中
  final bool isSkill;

  /// 这个值表示当前的角色需要在以下角色的动作结束后，才能进行行动
  /// 如果当局游戏中，不存在这个角色，可以忽略
  /// 如果对局中存在这个角色，需要判断
  final List<Role>? afterWithRole;

  /// 角色胜利目标
  final String winTarget;

  /// 角色的规则描述
  final String ruleDesc;

  const Role(
    this.id,
    this.roleName,
    this.type, {
    int sortWeight = 0,
    this.icon = const Icon(Icons.emoji_people),
    this.isSkill = true,
    this.afterWithRole,
    this.winTarget = "",
    this.ruleDesc = "",
  }) : _sortWeight = sortWeight;

  /// 获取有角色行为的所有角色
  /// 除去 村民、狼人、警长等一些特殊角色
  static List<Role> getRoles() => [...Role.values]..removeWhere((element) => element.id < 3);

  /// 获取实际权重
  /// 这里将好人和狼人的权重做一个较大的分别
  int get _weight {
    // 狼人最先行动
    if (camp == Camp.WOLF) return _sortWeight + 100000;
    // 好人其次
    if (camp == Camp.GOOD) return _sortWeight + 1000;
    // 三方最后
    // if (!desc.identity) return _sortWeight + 10000;
    return _sortWeight;
  }

  /// 由于之前使用了这个实体去封装数据，
  /// 用的地方太多了，懒得改，这里做个冗余，后期没有引用可以删除
  @Deprecated("已弃用")
  RoleDescription get desc => RoleDescription(id, roleName, camp, defaultIdentity);

  @override
  int compareTo(Role other) {
    // 先比较权重
    // 这里自己设置的权重，如果数字越大，就越靠前
    var w = this._weight.compareTo(other._weight) * -1;
    // 如果权重未设置，就按照索引排序
    // 如果是索引排序，则数值越小就越靠前
    if (w == 0) w = index.compareTo(other.index) * 1;
    // 权重越大，越是靠前
    return w;
  }

  get s => PhosphorIcons.stethoscope();

  String get name => roleName;
}

/// 角色类型
/// 主要用于区分有技能我得玩家是否定义为村民，可能由于每局板子不一样会有变化
/// 角色具体的类型在游戏模板中具体确定
enum RoleType {
  CITIZEN("村民", true, Camp.GOOD),
  GOD("神职", true, Camp.GOOD),
  WOLF("狼人", false, Camp.WOLF),
  THIRD("三方", true, Camp.THIRD),
  ;

  final String desc;

  /// 默认是否为好人
  final bool defaultIdentity;

  final Camp camp;

  const RoleType(this.desc, this.defaultIdentity, this.camp);

  static Map<RoleType, List<Role>> getRolesForType() {
    Map<RoleType, List<Role>> map = {};
    for (var role in Role.getRoles()) {
      if (role.id < 3) continue;
      (map[role.type] ??= []).add(role);
    }
    return map;
  }
}

/// 阵营
/// 弱化村民和神职的区别，归类出可以单独胜利的组
/// 三方阵营可以随好人或者狼人胜利，也可以单独胜利，需要独立判断
enum Camp {
  /// 好人
  GOOD,

  /// 狼人
  WOLF,

  /// 三方
  THIRD,
  ;
}
