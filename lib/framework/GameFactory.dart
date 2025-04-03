import 'dart:convert';
import 'dart:math';

import 'package:annotation/annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/entity/RoleActions.dart';
import 'package:god_helper/exceptions.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/AppFactory.dart';
import 'package:god_helper/framework/DefaultFactoryConfig.dart';
import 'package:god_helper/framework/impl/DayFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/framework/impl/NightFactory.dart';
import 'package:god_helper/role/generator/BarbarianChildRoleGenerator.dart';
import 'package:god_helper/role/generator/BearRoleGenerator.dart';
import 'package:god_helper/role/generator/BloodMoonApostlesRoleGenerator.dart';
import 'package:god_helper/role/generator/BombRoleGenerator.dart';
import 'package:god_helper/role/generator/FoolRoleGenerator.dart';
import 'package:god_helper/role/generator/ForbiddenElderRoleGenerator.dart';
import 'package:god_helper/role/generator/FoxRoleGenerator.dart';
import 'package:god_helper/role/generator/GuardRoleGenerator.dart';
import 'package:god_helper/role/generator/HunterRoleGenerator.dart';
import 'package:god_helper/role/generator/KnightRoleGenerator.dart';
import 'package:god_helper/role/generator/MachineWolfRoleGenerator.dart';
import 'package:god_helper/role/generator/RobbersRoleGenerator.dart';
import 'package:god_helper/role/generator/SeerRoleGenerator.dart';
import 'package:god_helper/role/generator/WhiteWolfRoleGenerator.dart';
import 'package:god_helper/role/generator/WitchRoleGenerator.dart';
import 'package:god_helper/role/generator/WitcherRoleGenerator.dart';
import 'package:god_helper/role/generator/WolfBeautyRoleGenerator.dart';
import 'package:god_helper/role/generator/WolfKingRoleGenerator.dart';
import 'package:god_helper/role/generator/WolfRoleGenerator.dart';
import 'package:god_helper/tools/AppData.dart';
import 'package:god_helper/view/ui2/phone/GameRoundSummaryDialogContentWidget.dart';
import 'package:json_annotation/json_annotation.dart';

part 'GameFactory.g.dart';

/// 游戏管理工厂
///
/// 晚上的数据可以在天亮时进行汇总保存，晚上的行动几乎互不干扰
/// 白天的数据需要实时更新，因为发生后会产生的数据，会立马作用于下一个角色
///
/// @auther leojay.fu
/// 可以通过这个工厂类创建并获取白天和晚上的管理器
@RegisterRoleGenerator([
  WolfRoleGenerator,
  SeerRoleGenerator,
  WitchRoleGenerator,
  HunterRoleGenerator,
  WolfKingRoleGenerator,
  GuardRoleGenerator,
  BombRoleGenerator,
  WhiteWolfKingRoleGenerator,
  FoolRoleGenerator,
  WolfBeautyRoleGenerator,
  FoxRoleGenerator,
  BearRoleGenerator,
  BloodMoonApostlesRoleGenerator,
  MachineWolfRoleGenerator,
  RobbersRoleGenerator,
  ForbiddenElderRoleGenerator,
  BarbarianChildRoleGenerator,
  KnightRoleGenerator,
  WitcherRoleGenerator,
])
class GameFactory {
  /// 游戏详情
  /// 这个数据应该来自于Sql数据库
  GameDetailEntity entity;

  // 下面这两个数据动态去数据库获取
  /// 晚上的数据
  Map<int, NightFactory> nightMap = {};

  /// 白天的数据
  Map<int, DayFactory> dayMap = {};

  Map<Role, JsonEntityData<RoleAction>> nightActionJsonTransition = {};
  Map<Role, JsonEntityData<RoleAction>> dayActionJsonTransition = {};

  /// 玩家管理
  late PlayerFactory players;

  /// 角色生成器管理
  late GeneratorFactory generator;

  /// 其他配置管理
  late OtherFactory other;

  late SummaryHelper summary;

  /// 额外配置管理
  TempExtraRule get extraRule => entity.extraRule;

  /// 玩家保护规则
  PlayersSaveRule get saveRule => entity.saveRule;

  GameFactory._private(this.entity) {
    // extraRule = ExtraRule(entity.id).loadDb();
    other = OtherFactory(entity.id).loadDb();

    /// 初始化实体，防止生成太多的实例
    players = PlayerFactory(this);
    summary = SummaryHelper(this);

    // 获取角色json转换器的实体，用于界面实体数据转换
    nightActionJsonTransition = _$nightActionJsonTransition(this);
    dayActionJsonTransition = _$dayActionJsonTransition(this);

    // 先初始化数据后再加载生成器
    generator = GeneratorFactory(this);
    // 加载已经产生的数据到内存中
    _loadFactory();
  }

  int get maxRound => other.maxRound;

  factory GameFactory.create(GameDetailEntity entity) => GameFactory._private(entity);

  NightFactory getNight(int round) {
    other.saveWithMax(round);
    return nightMap[round] ??= NightFactory(round, this);
  }

  DayFactory getDay(int round) {
    other.saveWithMax(round);
    return dayMap[round] ??= DayFactory(round, this);
  }

  int getRound() {
    List<int> rounds = [...nightMap.keys, ...dayMap.keys];
    var round = other.getRound();
    if (rounds.isEmpty) return round;
    for (var value in rounds) {
      round = max(round, value);
    }
    return round;
  }

  RoundHelper getRoundHelper() => RoundHelper(getRound());

  List<RoundProcess> getProcesses() {
    List<RoundProcess> list = [];
    for (var item in nightMap.entries) {
      var process = item.value.process;
      list.add(process);
    }
    for (var item in dayMap.entries) {
      var process = item.value.process;
      list.add(process);
    }
    list.removeWhere((element) => element.round <= 0);
    list.sort((a, b) => a.round.compareTo(b.round));
    return list;
  }

  Future<void> _loadFactory() async {
    for (int i = 1; i <= other.maxRound; i++) {
      if (RoundHelper(i).isNight) {
        getNight(i);
      } else {
        getDay(i);
      }
    }
  }

  RoundFactory getRoundFactory(int round) {
    if (RoundHelper(round).isNight) {
      return getNight(round);
    } else {
      return getDay(round);
    }
  }

  /// 结束游戏检查和汇总
  void finishSummary() {
    if (summary.isContinue()) {
      throw AppError.gameNotFinish.toExc();
    } else {
      other.gameOver = true;
      other.save();
    }
  }

  /// 清除当前对局的所有数据，从新开始
  void clearNoSqlData() {
    for (var night in nightMap.values) {
      night.clearNoSqlData();
    }
    for (var day in dayMap.values) {
      day.clearNoSqlData();
    }
    other.clear();
    players.cache.clear();
    players.details.clear();
  }

  /// 最后一个白天的回合
  DayFactory getLastDayRoundFactory() {
    DayFactory lastDayRound;
    var lastRound = getRoundFactory(other.maxRound);
    if (lastRound.isNight) {
      lastDayRound = getDay(other.maxRound - 1);
    } else {
      lastDayRound = lastRound as DayFactory;
    }
    return lastDayRound;
  }

  /// 最后一晚
  NightFactory getLastNightRoundFactory() {
    NightFactory lastDayRound;
    var lastRound = getRoundFactory(other.maxRound);
    if (lastRound.isNight) {
      lastDayRound = lastRound as NightFactory;
    } else {
      lastDayRound = getNight(other.maxRound - 1);
    }
    return lastDayRound;
  }

  RoundFactory getLastRoundFactory() => getRoundFactory(other.maxRound);
}

/// 其他游戏数据
@JsonSerializable()
class OtherFactory extends NoSqlDataEntity<OtherFactory> {
  /// 最大回合数
  /// 用于加载数据时。
  int maxRound = 0;

  SheriffTools sheriffTools = SheriffTools();

  /// 是否游戏结束
  bool gameOver = false;

  OtherFactory(super.gameId, {this.gameOver = false});

  factory OtherFactory.fromJson(Map<String, dynamic> json) => _$OtherFactoryFromJson(json);

  Map<String, dynamic> toJson() => _$OtherFactoryToJson(this);

  @override
  OtherFactory createForMap(Map<String, dynamic> map) {
    return OtherFactory.fromJson(map);
  }

  @override
  OtherFactory emptyReturn() => this;

  @override
  String getSaveKey() => "game_factory_${gameId}_other";

  void saveWithMax(int round) {
    if (maxRound >= round) return;
    maxRound = max(maxRound, round);
    save();
  }

  int getRound() {
    if (maxRound <= 0) return 1;
    return maxRound;
  }
}

/// 玩家数据管理
class PlayerFactory {
  final GameFactory factory;

  late PlayerDetail details;
  late PlayerIdentityCache cache;

  PlayerFactory(this.factory) {
    cache = PlayerIdentityCache(factory.entity.id).loadDb();
    details = PlayerDetail(factory.entity.id).loadDb();
    details.init(factory);
  }

  List<int> getNoIdentityPlayerIds() => cache.getNoIdentityPlayerIds(factory.entity);

  /// 获取存活的玩家，在晚上
  /// 由于晚上信息比较不透明，所以对于玩家来说，在结算前，被选择死亡状态的玩家依旧算活，结算后，修改状态
  List<Player> getLivePlayerInNight() {
    return details.getLivePlayer();
  }

  /// 将缓存内的数据转换到玩家数据中
  void transitionCacheToPlayerIdentity() {
    for (var wolf in cache.wolfNumbers) {
      details.get(wolf).updateRole(Role.wolf, RoleType.WOLF);
    }

    // 通过配置的模板，去设置玩家的阵营类型
    var roleConfig = factory.entity.tempConfig.roleConfig;
    // 设置神职身份
    void setType(RoleType type) {
      var roles = roleConfig.roles[type];
      if (null != roles && roles.isNotEmpty) {
        for (Role role in roles) {
          // 获取该角色设置的玩家Id
          var playerId = cache.rolePlayerNumberMap[role];
          if (null == playerId) {
            throw AppError.roleNoteSetPlayer.toExc(args: [role.roleName]);
          }
          // 更新玩家角色和类型数据
          // 并且表示初始化成功
          details.get(playerId).updateRole(role, type);
        }
      }
    }

    // 每个类型都设置一遍
    for (var type in roleConfig.roles.keys) {
      setType(type);
    }

    var noInitPlayer = details.getNoInitPlayer();
    // 剩下的一般是村民
    if (noInitPlayer.length > roleConfig.citizenCount) {
      throw AppError.citizenCountToMany.toExc();
    }

    for (var player in noInitPlayer) {
      player.isInit = true;
      // if(kDebugMode) print("player update ${player.number} isInit ${player.isInit}");
    }

    // 保存数据
    details.save();
  }

  void detailsUpdate() {
    details = PlayerDetail(factory.entity.id).loadDb();
  }

  /// 为模板初始化
  void initDetailsForTemp() {
    details.init(factory);
    // 还需要把角色分配给玩家
    var roles = factory.entity.tempConfig.roleConfig.all;
    var wolfs = factory.entity.tempConfig.roleConfig.wolfCount;
    for (int i = 0; i < roles.length; i++) {
      details.players[i].role = roles[i];
      details.players[i].roleType = roles[i].type;
      details.players[i].identity = roles[i].defaultIdentity;
      cache.setRoleIdentity(roles[i], details.players[i].number);
      cache.setRolePlayerRecordFinish(roles[i]);
    }
    for (int j = roles.length; j < (roles.length + wolfs); j++) {
      details.players[j].role = Role.wolf;
      details.players[j].roleType = Role.wolf.type;
      details.players[j].identity = Role.wolf.defaultIdentity;
    }

    cache.setRolePlayerRecordFinish(Role.wolf);
    cache.setWolfsNumber(details.getWolfNumbers());
  }
}

abstract class RoundFactory {
  int round;
  GameFactory factory;

  late Map<Role, JsonEntityData<RoleAction>> actionJsonEntityData;
  late RoundActions actions;

  /// 获取当前回合配置
  RoundExtraConfig get config => round == 1 ? RoundExtraConfig(factory) : getLastRoundFactory().nextRoundConfig;

  /// 设置下一回合配置
  late RoundExtraConfig nextRoundConfig;

  RoundFactory(this.round, this.factory) {
    actionJsonEntityData = initActionJsonEntityData();
    actions = RoundActions(factory.entity.id, round);
    if (round != 0) actions = actions.loadDb();
    // 配置下一回合的设置
    nextRoundConfig = RoundExtraConfig(factory);
  }

  GameDetailEntity get entity => factory.entity;

  PlayerDetail get playerDetails => factory.players.details;

  /// 每次获取detail，都是去拿最新的数据
  // PlayerDetail get playerDetails => factory.players.details.loadDb();

  RoundHelper get roundHelper => RoundHelper(round);

  RoundProcess get process => RoundProcess(factory.entity.id, round).loadDb();

  bool get isNight => roundHelper.isNight;

  WidgetFactory getWidgetHelper(Role role) => WidgetFactory(this, role);

  /// 获取上一回合数据
  RoundProcess getLastRound() {
    return RoundProcess(entity.id, round - 1).loadDb();
  }

  /// 获取上一回合数据
  RoundFactory getLastRoundFactory() {
    return factory.getRoundFactory(round - 1);
  }

  AbstractRoleRoundGenerator<RoleAction>? getRoleGenerator(Role role);

  SecondSkillCheck? _getSummarySecondSkillCheck(Role role) {
    return factory.generator.get(role)?.summarySecondSkillCheck(this);
  }

  /// 初始化RoleJson的转换器
  Map<Role, JsonEntityData<RoleAction>> initActionJsonEntityData();

  /// 获取角色行为
  RoleAction? getRoleAction(Role role) {
    JsonEntityData<RoleAction>? entityData;

    var generator = getRoleGenerator(role);
    entityData = generator?.actionJsonConvertor();
    // entityData = actionJsonEntityData[role];
    if (entityData == null) return null;
    return actions.getRoleActionNullable(role, entityData);
  }

  /// 本回合玩家状态转换
  /// 这个方法是当每回合结算时，已经检查过所有玩家都已经结算后，调用。
  /// 主要讲本回合玩家行动做一个汇总，得到每一个玩家在回合结束后被赋予的状态
  /// 并设置其是否出局
  ///
  /// 晚上和白天的规则各有差别，需要分开实现。
  /// 晚上：等到晚上回合结束统一结算
  /// 白天：每个玩家行为结束后，立即结算。所以白天仅需要把结算结果添加入playerStates即可
  void thisRoundPlayerStateTransition(PlayerDetail details, PlayerStateMap playerStates);

  /// 玩家出局后技能被动发动情况
  /// 由于有些玩家的技能具有滞后性，比如自己阵亡后才会触发，这里需要做一个二次检查
  /// 比如狼美人，在阵亡时，会带走被她魅惑的玩家
  /// 比如野孩子，在榜样阵亡时，会变成狼人
  /// 所以有被动的，有主动的，这里做一个全检查
  void secondSkillCheckForSummary(PlayerDetail details, PlayerStateMap states) {
    for (var player in details.players) {
      var role = player.role;
      // 如果是普通村民或者狼人，则直接跳过，没有技能操作
      if (role.isOrdinaryIdentity) continue;
      var skillCheck = _getSummarySecondSkillCheck(role);
      if (skillCheck == null) continue;
      skillCheck.check(details, states);
    }
  }

  TempConfig getExtraConfig<TempConfig extends RoleTempConfig<TempConfig>>(
    Role role,
    TempConfig tc,
  ) =>
      factory.extraRule.get(role, tc);

  /// 保存当前回合数据，并且跳转去下一回合
  ///
  /// @param states 玩家状态，一般在白天传入，因为白天行为在事件发生时就写入状态，不需要最后统一总结状态。
  Future<void> recordThisRoundAndToNext(BuildContext context) async {
    checkFinish();

    var process = RoundProcess(factory.entity.id, round).loadDb();

    if (round == 1) {
      // 仅需要第一天设置玩家信息
      // 将缓存数据中的玩家角色信息设置到 detail中
      factory.players.transitionCacheToPlayerIdentity();
    }

    // 获取玩家详情数据
    // 获取的是上次保存的新数据，这样如果后面设置了数据，如果没有保存，就一直可以反复利用该数据
    var details = factory.players.details.loadDb();
    // var details = playerDetails;
    var playerStates = PlayerStateMap();

    process.playerStateMap = playerStates;

    /// 如果已经传入玩家状态，则无需再去读取一遍
    /// 否则会导致白天的玩家状态和buff不一致的情况
    // 将当前回合的玩家状态设置到玩家数据中
    thisRoundPlayerStateTransition(details, playerStates);

    // 记录本回合淘汰玩家
    process.outPlayerNumbers = playerStates.outPlayerIds();

    // 最后，检查本局玩家成活情况并写入玩家详情
    // 只有记录了玩家状态才能结算游戏，所以一定要先设置参数才能结算
    //
    // 也可以先不结算，将设置参数放入保存数据前，保存本回合数据后，再进行结算计算，如果判断为游戏结束，则直接跳转详情界面
    details.addNewBuff(playerStates.buffs);

    details.checkLive(playerStates);

    if (kDebugMode) print("playerStates: ${jsonEncode(playerStates)}");
    if (kDebugMode) print("summary: ${jsonEncode(process.outPlayerNumbers)}");

    // 保存数据
    process.isFinish = true;
    process.save();
    details.save();

    /// 表示这一回合的操作结束
    actions.isYes = true;
    actions.save();
    factory.players.detailsUpdate();

    var summary = factory.summary;
    // 显示结算界面
    await showDialog(
      context: context,
      builder: (context) => PopScope(
        /// 一旦调用了结算方法，则表示当前回合结束，这里不允许返回，只能进行下一步
        canPop: false,
        child: AlertDialog(
          title: const Text("当前回合结算"),
          content: AppGameRoundSummaryDialogContentWidget(this, process, details),
          actions: [
            summary.isContinue()
                ? TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 关闭 dialog
                      // Navigator.of(context).pop(); // 关闭 dialog
                      AppFactory().getRoute(context).toGameRoundView(factory, round + 1).pushReplace();
                    },
                    child: const Text("好的"),
                  )
                : TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 关闭 dialog

                      /// 检查一下是否真的结束，如果有问题会抛出异常
                      factory.finishSummary();
                      AppFactory().getRoute(context).toGameSummaryView(factory).pushReplace();
                    },
                    child: Text("结束游戏 ${summary.result()}"),
                  ),
          ],
        ),
      ),
    );
  }

  /// 检查所有角色是否已经完成操作
  /// 白天晚上的规则有些区别，晚上是都得完成，但白天需要判断是否存活，如果角色还活着，则无需判定技能是否使用过。
  void checkFinish();

  /// 保存玩家行为数据
  void saveAction<Action extends RoleAction>(Role role, Action action) {
    actions
      ..roleActionMap[role] = action.toJson()
      ..save();
  }

  /// 获取玩家，第一天时，玩家可能没有设置，所以可能为null
  int? getPlayerNumber(Role role) {
    if (round == 1) {
      return factory.players.cache.getRoleNumber(role);
    } else {
      return playerDetails.getForRoleNullable(role)?.number;
    }
  }

  void clearNoSqlData() {
    actions.clear();
    actions = RoundActions(factory.entity.id, round);
    if (kDebugMode) print("清除 roundFactory actions");
  }
}

/// 角色生成器获取工厂类
class GeneratorFactory {
  GameFactory factory;
  late List<RoleGenerator> generators;
  late Map<Role, RoleGenerator> generatorMap;
  late List<AbstractWinRule> roleWinRules;
  List<TempExtraGenerator<RoleTempConfig>> extraGenerator = [];
  Map<Role, TempExtraGenerator<RoleTempConfig>> extraGeneratorMap = {};

  GeneratorFactory(this.factory) {
    // 这里将map和 list 维护起来，这样再次获取时不用每次都去实例化加遍历
    generators = factory._$Generators;
    generatorMap = factory._$GeneratorMap;
    roleWinRules = _initRoleWinRules();
    extraGenerator = _initAllExtraGen();
    extraGeneratorMap = extraGenerator.toMap(
      key: (element) => element.role,
      value: (element) => element,
    );
  }

  /// 初始化角色胜利规则
  List<AbstractWinRule> _initRoleWinRules() {
    List<AbstractWinRule> map = [];
    for (var value in generators) {
      if (value.checkWinRule() == null) continue;
      map.add(value.checkWinRule()!);
    }
    return map;
  }

  /// 获取生成器
  RoleGenerator? get(Role role) => generatorMap[role];

  List<TempExtraGenerator> get allExtraGen => extraGenerator;

  List<TempExtraGenerator> _initAllExtraGen() {
    List<Role> roles = factory.entity.tempConfig.roleConfig.all ?? [];
    if (roles.isEmpty) return [];
    List<TempExtraGenerator> list = [];
    for (var value in generators) {
      /// 如果模板里不包含该角色，就跳过该角色的获取
      if (!roles.contains(value.role)) continue;

      /// 将有的配置放入
      var generator = value.extraRuleGenerator();
      if (null != generator) {
        list.add(generator);
      }
    }
    if (list.length > 1) {
      /// 根据角色排个序
      list.sort((a, b) => a.role.compareTo(b.role));
    }
    return list;
  }

  Widget getPlayerIdentityWidget(Role role) {
    var gen = get(role)?.playerIdentityGenerator() ?? DefaultPlayerIdentityGenerator(factory, role);

    return gen.widget();
  }

  bool isHasRoleWin() {
    for (var value in roleWinRules) {
      if (value.isWin()) return true;
    }
    return false;
  }

  TempExtraGenerator<RoleTempConfig>? getExtraRuleGenerator(Role role) => extraGeneratorMap[role];
}

/// NoSql数据基础类
///
/// 这里的泛型 T 必须是被继承的类
abstract class NoSqlDataEntity<T> extends JsonEntityData<T> {
  final int gameId;

  /// 是否跳过存储
  bool get _isSkip => gameId < 0;

  NoSqlDataEntity(this.gameId);

  String getSaveKey();

  Future<void> save() async {
    if (_isSkip) return;
    var json = jsonEncode(this);
    AppData().noSql.save(getSaveKey(), json);
  }

  T loadDb() {
    if (_isSkip) emptyReturn();
    var json = AppData().noSql.getData(getSaveKey()) as String?;
    if (json == null) return emptyReturn();
    var decoder = jsonDecode(json);
    return createForMap(decoder);
  }

  void clear() {
    if (_isSkip) return;
    AppData().noSql.delete(getSaveKey());
    if (kDebugMode) print("清除：${getSaveKey()}");
  }
}

/// 根据角色生成组件时
///
/// 需要实现的方法
/// 在创建新角色时，仅仅需要实现这个方法，就可以添加一个新角色
///
/// 大多数角色只在一种类型的回合上有实现，所以没有状态的那部分不实现就好了
abstract class RoleGenerator<Night extends RoleAction, Day extends RoleAction,
    TempConfig extends RoleTempConfig<TempConfig>> {
  final Role role;
  final GameFactory factory;

  /// 构造函数必须有角色传入
  RoleGenerator({required this.factory, required this.role});

  /// 配置界面上，用于生成配置，并保存如模板配置
  /// 极个别角色会有
  /// 会影响到后面的操作流程
  TempExtraGenerator<TempConfig>? extraRuleGenerator() => null;

  /// 玩家身份生成器
  PlayerIdentityGenerator playerIdentityGenerator() {
    return DefaultPlayerIdentityGenerator(factory, role);
  }

  /// 晚上回合生成器
  RoleNightGenerator<Night>? getNightRoundGenerator(NightFactory nightFactory) {
    return null;
  }

  /// 白天回合生成器
  RoleDayRoundGenerator<Day>? getDayRoundGenerator(DayFactory dayFactory) {
    return null;
  }

  /// 角色特殊胜利规则
  /// 默认是null，则没有配置胜利条件
  /// 如果有值，则该角色有单独的胜利规则
  AbstractWinRule? checkWinRule() => null;

  /// 结算时二次技能检查
  SecondSkillCheck? summarySecondSkillCheck(RoundFactory factory) => null;
}

abstract class AbstractRoleRoundGenerator<Action extends RoleAction> {
  final Role role;
  final RoundFactory roundFactory;
  late Action action;

  AbstractRoleRoundGenerator({required this.roundFactory, required this.role}) {
    action = _getAction();
  }

  GameFactory get factory => roundFactory.factory;

  int get round => roundFactory.round;

  Player get player => this.factory.players.details.getForRole(role);

  /// action 的 json 实体转换器
  JsonEntityData<Action> actionJsonConvertor();

  /// 返回一个白天的Action，应该也是个泛型才对
  Action _getAction() {
    JsonEntityData<Action> convertor = actionJsonConvertor();
    return roundFactory.actions.getRoleAction(role, convertor);
  }

  /// 保存行为
  ///
  /// 晚上：统一保存状态，等到回合结束统一结算
  /// 白天：每一个行为都要进行实时的计算
  void saveAction() {
    try {
      /// 覆盖设置，并且保存数据
      roundFactory.saveAction(role, action);
    } catch (e) {
      if (e is AppException) {
        e.printMessage();
      }
    }
  }
}

abstract class RoleNightGenerator<Action extends RoleAction> extends AbstractRoleRoundGenerator<Action> {
  RoleNightGenerator({required super.roundFactory, required super.role});

  /// 这里对行为处理后需看需求保存  saveAction()  方法
  Future<void> preAction() async {
    action.checkLive(roundFactory);
  }

  /// 活动行为
  ///
  /// @param updateCallback 通知更新上级视图
  Widget actionWidget(Function() updateCallback);

  /// 当玩家在上一回合阵亡后，无法执行Action的界面
  Widget? playerLastKillNoActionWidget() => null;

  /// 封印技能
  /// 表示这个action被封印，无法执行
  void sealingSkill() {
    action.sealing = true;
    saveAction();
  }
}

abstract class RoleDayRoundGenerator<Action extends RoleAction> extends AbstractRoleRoundGenerator<Action> {
  RoleDayRoundGenerator({required super.roundFactory, required super.role});

  /// 这里对行为处理后需看需求保存  saveAction()  方法
  Future<void> preAction() async {
    action.checkLive(roundFactory);
  }

  // /// 活动行为
  // ///
  // /// @param updateCallback 通知更新上级视图
  // Widget actionWidget(Function() updateCallback);

  /// 出局画面
  Widget? outWidget(Function() updateCallback) => null;

  /// 主动技能界面
  /// 比如狼自爆、骑士决斗
  Widget? activeSkillWidget(Function() updateCallback) => null;

  /// 获取因为这个角色主动技能出局的玩家
  /// 如果白天技能发动后，有玩家阵亡，需要设置这个方法去获取，否则会缺失玩家行为
  List<int> dieForDayActiveSkill() => [];
}

abstract class RoleAction {
  Role role;

  // 是否已经阵亡无法使用既能
  bool isKillNotUseSkill = false;

  /// 是否完成并确认该行为
  bool _isYes;

  /// 是否完成并确认该行为
  bool get isYes => _isYes || isKillNotUseSkill || sealing;

  /// 是否完成并确认该行为
  set isYes(bool value) => _isYes = value;

  /// 是否被封印
  bool sealing;

  final bool canSkip;

  RoleAction(
    this.role, {
    bool isYes = false,
    this.canSkip = false,
    this.isKillNotUseSkill = false,
    this.sealing = false,
  }) : _isYes = isYes;

  Map<String, dynamic> toJson();

  /// 设置玩家详情
  void setToPlayerDetail(PlayerDetail detail, PlayerStateMap states) {}

  void checkLive(RoundFactory factory) {
    if (factory.round <= 1) return;
    isKillNotUseSkill = !factory.playerDetails.getForRole(role).live;
  }
}

/// 模板额外规则相关生成器
abstract class TempExtraGenerator<T extends RoleTempConfig<T>> {
  final GameFactory factory;
  final Role role;

  late T config;

  TempExtraGenerator(this.factory, this.role) {
    config = factory.extraRule.get(role, initExtraConfigEntity());
    saveConfig();
  }

  /// 模板视图
  ///
  /// @param isPreview 是否是预览界面
  Widget tempView({bool isPreview = false});

  /// 配置的结果展示
  /// 用文本描述，当前的配置结果
  List<String> configResultMessage();

  /// 直接new实现即可，会根据类实例去获取数据
  /// 初始化状态
  T initExtraConfigEntity();

  /// 保存配置
  void saveConfig() {
    factory.extraRule.put(role, config);

    /// 由于一般情况下，配置完成之前，游戏还没有创建，所以这里先不保存更新
    // if(factory.entity.id <= 0)return;
    // // 需要给数据库或者使用其他方式保存一下配置
    // AppFactory().service.updateGameExtraRule(factory.entity.id, config);
  }
}

class RoundHelper {
  int round;

  RoundHelper(this.round);

  /// 实际游戏天数
  int get day => (round ~/ 2) + (round % 2 > 0 ? 1 : 0);

  bool get isNight => round == 0 || round % 2 > 0;

  String get dayStr => round == 0 ? "(还未开始)" : "${_dayStrNumber(day)} ${isNight ? "天晚上" : "天天亮"}";
}

/// 将天数转换为中文数字
String _dayStrNumber(int day) {
  switch (day) {
    case 1:
      return "一";
    case 2:
      return "二";
    case 3:
      return "三";
    case 4:
      return "四";
    case 5:
      return "五";
    case 6:
      return "六";
    case 7:
      return "七";
    case 8:
      return "八";
    case 9:
      return "九";
    case 10:
    // return "十";
    case 11:
    // return "十一";
    case 12:
    // return "十二";
    default:
      return "$day";
  }
}

abstract class PlayerIdentityGenerator {
  GameFactory factory;
  Role role;

  PlayerIdentityCache get cache => playerFactory.cache;

  PlayerFactory get playerFactory => factory.players;

  PlayerIdentityGenerator(this.factory, this.role) {}

  Widget widget();
}

class ActionJsonTransition {
  Map<Role, JsonEntityData<RoleAction>> map = {};

  ActionJsonTransition(this.map);

  factory ActionJsonTransition.single(Map<Role, JsonEntityData<RoleAction>> Function() map) {
    return ActionJsonTransition(map());
  }
}

abstract class AbstractWinRule {
  GameFactory factory;
  Role role;

  AbstractWinRule({required this.factory, required this.role});

  bool isWin();

  RoleWinEntity winEntity();
}

abstract class RoleTempConfig<T> extends JsonEntityData<T> with ToJsonInvoke {}

abstract class SecondSkillCheck {
  void check(PlayerDetail details, PlayerStateMap states);
}

/// 回合的额外限制
class RoundExtraConfig {
  GameFactory _factory;

  /// 不能发动技能的角色
  List<Role> notActionRole = [];

  RoundExtraConfig(this._factory);

  /// 封印非狼人玩家的技能发动
  void sealingSkillForNoWolf() {
    var players = _factory.players.details.players;
    for (var player in players) {
      var role = player.role;
      if (player.roleType != RoleType.WOLF) continue;
      if (!role.isSkill) continue;
      notActionRole.add(role);
    }
  }

  bool isCanAction(Role role) => !notActionRole.contains(role);
}
