import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum Role implements Comparable<Role> {
  EMPTY(0, "默认空", RoleType.CITIZEN, isSkill: false),
  sheriff(-1, "警长", RoleType.CITIZEN, isSkill: false),

  /// 村民
  citizen(
    1,
    "村民",
    RoleType.CITIZEN,
    isSkill: false,
    iconAsset: "citizen",
    // icon: Icon(AppIcons.imgAvatarWolfKingLg),
  ),

  /// 狼人
  wolf(
    2,
    "狼人",
    RoleType.WOLF,
    inNightSingleAction: true,
    isSkill: false,
    sortWeight: 10,
    // icon: Icon(PhosphorIconsRegular.horse),
    iconAsset: "wolf",
    icon: Icon(PhosphorIconsRegular.horse),
    ruleDesc: "所有的狼人阵营玩家，除非规则显示，在狼人回合时，一起睁眼，共同商量刀一个玩家出局。",
  ),

  /// 预言家
  seer(
    3,
    "预言家",
    RoleType.GOD,
    sortWeight: 10,
    afterWithRole: [Role.wolf],
    icon: Icon(PhosphorIconsRegular.detective),
    iconAsset: "seer",
    ruleDesc: "每晚可以查验一名玩家，可以知道他是好人还是狼人",
  ),

  /// 女巫
  witch(
    4,
    "女巫",
    RoleType.GOD,
    sortWeight: 9,
    afterWithRole: [Role.wolf],
    icon: Icon(PhosphorIconsRegular.stethoscope),
    iconAsset: "witch",
    ruleDesc: "女巫有两瓶药，一瓶解药一瓶毒药，每晚只能用一瓶药。\n"
        "当女巫有解药时，可以知道谁被狼人刀，可以选择救治，但没有药时，不知道。\n"
        "如果女巫也可以选择使用毒药毒一名玩家使其出局。\n"
        "自救行为：不同的板子可以设置女巫的自救规则",
  ),

  /// 猎人
  hunter(
    5,
    "猎人",
    RoleType.GOD,
    afterWithRole: [Role.witch],
    icon: Icon(PhosphorIconsRegular.crosshair),
    iconAsset: "hunter",
    ruleDesc: "当且仅当猎人被狼人出局或被投票放逐时，猎人可以亮出自己的身份牌并指定猎捕一名玩家。",
  ),

  /// 守卫
  guard(
    6,
    "守卫",
    RoleType.GOD,
    icon: Icon(PhosphorIconsRegular.shieldWarning),
    iconAsset: "guard",
    ruleDesc: "每晚可以守护一名玩家，但不能连续两晚守护同一名玩家。被守卫守护的玩家当晚不会被狼人淘汰。",
  ),

  /// 白痴
  fool(7, "白痴", RoleType.GOD, ruleDesc: "白痴被投票出局后翻牌，可以免除一次放逐，但后续不能被选择为投票目标。", iconAsset: "fool"),

  /// 狼王/狼枪
  wolfKing(
    8,
    "狼王/狼枪",
    RoleType.WOLF,
    icon: Icon(PhosphorIconsRegular.horse),
    ruleDesc: "属于狼人阵营，具有出局后猎捕技能，带走一名玩家。（跟随出局和被毒不能猎捕）",
  ),

  /// 白狼王
  whiteWolfKing(
    9,
    "白狼王",
    RoleType.WOLF,
    icon: Icon(PhosphorIconsRegular.horse),
    ruleDesc: "属于狼人阵营，白狼王可以在白天自曝身份的时候，选择带走一名玩家，非自曝身份出局不得发动技能。",
  ),

  /// 狼美人
  wolfBeauty(
    10,
    "狼美人",
    RoleType.WOLF,
    icon: Icon(PhosphorIconsRegular.horse),
    ruleDesc: "狼美人每天晚上参与杀人后，可单独魅惑一名好人阵营的玩家。狼美人死亡时，当晚被魅惑的玩家随之殉情。狼美人不能自爆或自刀。",
    afterWithRole: [Role.wolf],
    inNightSingleAction: true,
    canSelfBomb: false,
    canKillTargetForWolf: false,
  ),

  /// 炸弹人
  bomb(
    11,
    "炸弹人",
    RoleType.THIRD,
    icon: Icon(PhosphorIconsRegular.bomb),
    ruleDesc: "炸弹人属于第三方阵营，他的目标通常是阻止任何一方阵营获胜。\n"
        "白天被投票放逐后，所有给他上票的玩家全部死亡，其他方式死亡无法发动技能如果炸弹人被放逐时炸死了场上所有人，则炸弹人单独获得胜利。",
  ),

  /// 狐狸
  fox(
    12,
    "狐狸",
    RoleType.GOD,
    ruleDesc: "每天晚上，你可以选择一组三个相邻的玩家，指出中央的玩家示意上帝。\n"
        "如果三个人中有独人出现，上帝会给你肯定的手势，下个晚上你可以继续使用技能。\n"
        "如果三个人中没有狼人，你就失去技能。",
  ),

  /// 熊
  bear(
    13,
    "熊",
    RoleType.GOD,
    ruleDesc: "天亮后，如果熊存活且熊两边存活的玩家之中存在狼人，则法官会向场上所有玩家宣布“熊咆哮了”。"
        "如果熊出局或熊相邻存活的玩家之中没有狼人，则法官会向场上所有玩家宣布“熊没有咆哮”。 "
        "\n(eg: 如果相邻玩家死亡，则左右两边存活玩家顺延)",
  ),

  /// 血月使徒
  bloodMoonApostles(
    14,
    "血月使徒",
    RoleType.WOLF,
    ruleDesc: "在自爆后将合直接进入黑夜，当晚所有神牌的技能都将会被血月使捷所封印；"
        "若是最后一个被放逐出局的狼人，则他可以翻牌并依靠他强大的血脉之力存活到下一个白天天亮之后才死亡；"
        "若血月是最后一个狼人，自爆则游戏结束，不发动技能。",
  ),

  /// 机械狼
  machineWolf(
    15,
    "机械狼",
    RoleType.WOLF,
    online: false,
    inNightSingleAction: true,
  ),

  /// 盗贼
  /// todo 由于盗贼角色需要额外增加两张身份牌给他选，模板配置和适配上会存在问题，这里先不加入盗贼角色
  robbers(
    16,
    "盗贼",
    RoleType.THIRD,
    online: false,
    ruleDesc: "上带将剩下的两张没有分配的身份牌出示，你可以在这两张牌中，选择一张成为你的身份牌。有狼人必须选择狼人。",
  ),

  /// 禁言长老
  forbiddenElder(
    17,
    "禁言长老",
    RoleType.GOD,
    ruleDesc: "每天晚上你可以向上带示意一名玩家接下来的那个白天，这个玩家全程不能说话，（可以用动作表示）",
  ),

  /// 野孩子
  barbarianChild(
    18,
    "野孩子",
    RoleType.CITIZEN,
    ruleDesc: "第一天晚上，上带会让你选择一个玩家作为\"榜样\"游戏中，如果榜样出局，你就变身为狼人。",
    // 只有野孩子转变为狼人时，可以参与狼人投票
    isActionForWolf: true,
  ),

  /// 骑士
  knight(
    19,
    "骑士",
    RoleType.GOD,
    ruleDesc: "骑士可以在白天投黑前的任何时候翻出底牌并指定一名玩家，由上帝宣布该玩家是否是狼人。\n"
        "若是狼人，则此玩家立刻死亡，白天结束，马上进入晚上。\n"
        "如果不是，则骑士以死谢罪。该技能只能发动一次。\n",
  ),

  /// 猎魔人
  witcher(
    20,
    "猎魔人",
    RoleType.GOD,
    ruleDesc: "从第二晚开始，每晚都可以选择一名玩家进行狩猎。\n"
        "如果对方是狼人，则次日对方出局；\n"
        "如果对方是好人，则次日猎魔人出局。\n"
        "女巫的毒药对猎魔人无效。",
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
  final Icon _defaultIcon;

  final String? iconAsset;

  static const _RES_PATH = "assets/theme/die-notes/role/icons";

  Widget icon({
    Color? color,
    double? size,
  }) {
    var defaultResName = name.toLowerCase();
    return MultiIcon(
      defaultIcon: _defaultIcon,
      resList: [
        // "$_RES_PATH/s/img_avatar_${iconAsset}_s.svg",
        "$_RES_PATH/sm/img_avatar_${iconAsset}_s.svg",
        // "$_RES_PATH/lg/img_avatar_${iconAsset}_lg.svg",

        // "$_RES_PATH/s/img_avatar_${defaultResName}_s.svg",
        "$_RES_PATH/sm/img_avatar_${defaultResName}_s.svg",
        // "$_RES_PATH/lg/img_avatar_${defaultResName}_lg.svg",
      ],
      color: color,
      size: size,
    );
  }

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

  /// 是否在夜晚有单独行动
  final bool inNightSingleAction;

  /// 是否可以自爆
  final bool canSelfBomb;

  /// 是否可以成为被狼人刀的目标

  final bool canKillTargetForWolf;

  /// 是否跟随狼人行动一起行动。即参与狼人刀人。
  /// 有些角色虽然设置为true，但也必须是在状态转变为狼人时生效
  /// 即参与狼人刀人有两个条件，一个是玩家的角色类型为狼人，另外这个值为true
  /// 如果狼人阵营，且不随狼人刀人行动，需要单独确定玩家ID
  final bool isActionForWolf;

  /// 是否上线角色，主要处理角色显示问题
  /// 如果还未开发完成，可以设置成false。防止被使用
  final bool _online;

  const Role(
    this.id,
    this.roleName,
    this.type, {
    int sortWeight = 0,
    Icon icon = const Icon(Icons.emoji_people),
    this.iconAsset = null,
    this.isSkill = true,
    this.afterWithRole,
    this.winTarget = "",
    this.ruleDesc = "",
    bool? inNightSingleAction,
    bool? canSelfBomb,
    this.canKillTargetForWolf = true,
    bool? isActionForWolf,
    bool online = true,
  })  : _sortWeight = sortWeight,
        // 默认 非狼、村民角色，晚上都有行动
        inNightSingleAction = inNightSingleAction ?? (type != RoleType.WOLF && id > 1),
        canSelfBomb = canSelfBomb ?? (type == RoleType.WOLF),
        isActionForWolf = isActionForWolf ?? (type == RoleType.WOLF),
        _online = online,
        _defaultIcon = icon;

  /// 获取有角色行为的所有角色
  /// 除去 村民、狼人、警长等一些特殊角色
  static List<Role> getRoles() => [...Role.values]..removeWhere((e) => e.id < 3 || !e._online);

  static List<Role> get all => values.toList()..removeWhere((e) => !e._online);

  // static List<Role> get all => getRoles();

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

  /// 是否为普通身份
  /// 普通村民或者普通狼人等
  bool get isOrdinaryIdentity => id < 3;

  /// 是否为游戏角色
  /// 除了0 空占位和 -1警长这种没有玩家映射的角色
  bool get isGameRole => id > 0;

  String get nickname => roleName;

  /// 是否单独确认身份信息
  /// 根据这个判断角色是否需要展示身份确认界面
  bool get isSingleYesPlayerIdentity =>
      (id > 1) &&
      ((this == Role.wolf) ||
          // 狼人，且不予狼人单独行动的角色
          (type == RoleType.WOLF && !isActionForWolf) ||
          // 神职
          (type == RoleType.GOD) ||
          // 三方村民
          (type == RoleType.THIRD) ||
          // 村民类型，但不是普通村民
          (type == RoleType.CITIZEN && this != Role.citizen));
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

  /// 获取角色类型对应的角色列表
  ///
  /// @param isAll 是否包含所有角色，包括普通村民和狼人这样的角色
  static Map<RoleType, List<Role>> getRolesForType({bool isAll = false}) {
    Map<RoleType, List<Role>> map = {};
    for (var role in (isAll ? Role.all : Role.getRoles())) {
      if (isAll) {
        if (role.id <= 0) continue;
      } else {
        if (role.id < 3) continue;
      }
      (map[role.type] ??= []).add(role);
    }
    return map;
  }

  String get name => desc;
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
