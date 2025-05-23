import 'package:annotation/annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/entity/RoleActions.dart';
import 'package:god_helper/entity/RuleConfig.dart';
import 'package:god_helper/exceptions.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/framework/impl/NightFactory.dart';
import 'package:god_helper/role/generator/WolfRoleGenerator.dart';

/// 白天数据
class DayFactory extends RoundFactory {
  late DayAction dayAction;

  late SheriffHelper sheriff;
  late DayFlowHelper flowHelper;

  IsShowState isShow = IsShowState();

  DayFactory(super.round, super.factory) {
    dayAction = DayAction(super.factory.entity.id, round);
    if (round != 0) dayAction = dayAction.loadDb();
    sheriff = SheriffHelper(this, round);

    flowHelper = DayFlowHelper(this);
  }

  @override
  RoleDayRoundGenerator<RoleAction>? getRoleGenerator(Role role) {
    return super.factory.generator.get(role)?.getDayRoundGenerator(this);
  }

  @override
  Map<Role, JsonEntityData<RoleAction>> initActionJsonEntityData() {
    return super.factory.dayActionJsonTransition;
  }

  @override
  void thisRoundPlayerStateTransition(
    PlayerDetail details,
    PlayerStateMap playerStates,
  ) {
    /// 白天行为已经将状态记录好了，所以无需执行
    playerStates.addMap(dayAction.playerStateMap);
    sheriff.checkSheriff(playerStates);
  }

  @override
  void saveAction<Action extends RoleAction>(Role role, Action action) {
    super.saveAction(role, action);

    /// 设置本回合玩家状态，并且保存
    action.setToPlayerDetail(details, dayAction.playerStateMap);
    // 保存角色行为数据
    actions.save();
    dayAction.save();

    /// 实时反应到 玩家信息上
    details.checkLive(dayAction.playerStateMap);
    secondSkillCheckForSummary(details, dayAction.playerStateMap);
    details.checkLive(dayAction.playerStateMap);

    /// 并且去判断下警长是否被杀
    var nowSheriff = sheriff.last;
    if (null != nowSheriff.sheriffPlayer && nowSheriff.isLive) {
      if (dayAction.getState(sheriff.last.sheriffPlayer!)?.isDead ?? false) {
        nowSheriff.isLive = false;
        sheriff.save();
      }
    }
  }

  @override
  void checkFinish() {
    /// 检查白天是否有未完成的行为
    /// 白天需要完成的事：
    /// 1、警长竞选（可以被狼自爆打断）
    /// 2、警长出局后，需要移交警徽
    /// 3、有技能的玩家出局，需要完成技能发动
    /// 4、投票（可以被自爆打断）

    /// 1、先判断警长竞选
    /// 如果没有警长，则无需判断警徽流问题
    /// 2、警长竞选后，判断警长是否出局
    sheriff.dayBeforeSummaryCheck(this);

    /// 3、判断是否完成技能发动
    var outPlayers = dayAction.playerStateMap.outPlayerIds().map((e) => details.get(e)).toList();
    for (var player in outPlayers) {
      var action = getRoleAction(player.role);
      if (action == null) continue;
      if (!action.isYes) {
        throw AppError.outPlayerActionNoExcFinish.toExc(obj: player.role);
      }
    }

    /// 4、判断是否完成投票
    if (!dayAction.isYesVotePlayer && !isYesWolfBomb) {
      throw AppError.withDayNoYesVoteOutPlayer.toExc();
    }
  }

  NightFactory lastNight() => super.factory.getNight(round - 1);

  /// 玩家详情
  PlayerDetail get details => super.factory.players.details;

  bool get isYesWolfBomb {
    var dayAction = actions.getRoleAction(Role.wolf, WolfDayActionJsonData());
    return dayAction.isYes && dayAction.isBomb && (dayAction.wolfBombPlayer ?? 0) > 0;
  }

  /// 是否可以继续活动，对于其他玩家行为
  bool isCanContinueAction() => !isYesWolfBomb;

  /// 获取上一回合被淘汰的玩家
  List<Player> getLastRoundOutPlayers() {
    return getLastRound().outPlayerNumbers.map((e) => details.get(e)).toList(growable: false);
  }

  /// 获取投票前被淘汰的玩家id
  ///
  /// 应该是在自由发言前，阵亡的玩家发动技能
  List<int> getBeforeVoteOutPlayerNumbers() {
    List<int> lastOuts = getLastRound().outPlayerNumbers;
    if (lastOuts.isEmpty) return [];
    List<int> list = [];
    // 将上一回合淘汰的玩家使用技能带走的玩家也带走
    for (var outId in lastOuts) {
      list.add(outId);
      var state = dayAction.getState(outId);
      if (null == state) continue;
      if (state.killPlayer.isEmpty) continue;
      // 将该角色击杀的玩家，也写入当前行为
      list.addAll(state.killPlayer);
    }
    return list;
  }

  /// 获取本回合在投票前就被被淘汰的玩家
  List<Player> getBeforeVoteOutPlayers() {
    var list = getBeforeVoteOutPlayerNumbers();
    return list.map((e) => details.get(e)).toList();
  }

  /// 是否可以警长竞选
  /// 根据板子配置中的警长竞选配置来判断
  /// 必须是白天
  /// 且第一天需要竞选警长
  /// 第一天如果因为突发事件导致警长被冲掉
  /// 则第二天可以继续选举，但没有发言权
  bool isCanSheriffRace() {
    if (round > 2) return false;
    var sheriffRace = entity.tempConfig.extraRule.getSheriffConfig().sheriffRace;
    // if (kDebugMode) {
    //   print(sheriffRace);
    //   // todo 测试代码
    //   sheriffRace = SheriffRace.notForSecond;
    // }

    switch (sheriffRace) {
      case SheriffRace.none:
        return false;
      case SheriffRace.onlyFirstDay:
        // 仅仅第一天白天可以竞选警长
        return !roundHelper.isNight && (roundHelper.day == 1);
      case SheriffRace.notForSecond:
        // 第一天和第二天没有警长产生时都可以竞选警长
        if (round == 2 && (sheriff.nowSheriffPlayer ?? 0) == 0) {
          /// 如果第二天没有设置警长，这里做一个检查，判断第一天是否设置过警长
        }

        /// 这里仅涉及到警长的选举
        /// 所以只判断是否去选择了默认的警徽
        var isFirstRoundSelect = sheriff.defaultSheriffAction.isLive &&
            (sheriff.defaultSheriffAction.sheriffPlayer ?? 0) > 0 &&
            sheriff.isYesSheriffPlayer;

        /// 所以在
        /// 1、白天。
        /// 2、第一天，
        /// 3、或者第二天时，第一天没有选择出警长
        /// 以上的情况下，可以继续竞选警长
        return !roundHelper.isNight && (roundHelper.day == 1 || (roundHelper.day == 2 && !isFirstRoundSelect));
    }
  }

  List<Player> getAfterVoteOutPlayers() => thisRoundAfterVoteOutPlayerNumbers().map((e) => details.get(e)).toList();

  List<int> thisRoundAfterVoteOutPlayerNumbers() {
    int? player = dayAction.votePlayer;
    if (null == player) return [];
    List<int> list = [player];
    var state = dayAction.getState(player);
    if (null == state) return list;
    if (state.killPlayer.isEmpty) return list;
    return list..addAll(state.killPlayer);
  }

  PlayerStates getPlayerStates(Player player) {
    return process.getState(player.number);
  }

  /// 获取当下还存活的玩家，需要根据本回合情况实时变化
  List<Player> getNowLivePlayer() {
    var player = details.getLivePlayer();
    var outIds = dayAction.outPlayerIds();
    if (outIds.isNotEmpty) {
      player.removeWhere((element) => outIds.contains(element.number));
    }
    return player;
  }

  @override
  void clearNoSqlData() {
    super.clearNoSqlData();
    dayAction.clear();
    dayAction = DayAction(super.factory.entity.id, round);
    if (kDebugMode) print("清除 dayFactory dayAction");
  }

  /// 玩家是否已经阵亡，通过角色判断
  bool isDieForRole(Role role) {
    var player = details.getForRole(role);
    if (!player.live) return true;
    return dayAction.playerStateMap.getNoSet(player.number).isDead;
  }

  List<Role> activeSkillRoles() {
    List<Role> result = [];
    List<Role> list = [...super.factory.entity.tempConfig.roleConfig.all, Role.wolf]..sort();
    for (var value in list) {
      var helper = getWidgetHelper(value);
      var skillWidget = helper.activeSkillWidget();
      if (null != skillWidget) {
        result.add(value);
      }
    }
    return result;
  }

  // 获取上一个白天工厂类
  DayFactory? getLastDayFactory() {
    if (round <= 3) return null;
    return super.factory.getDay(round - 2);
  }

  /// 获取上天结束时，警长玩家标记
  /// 如果当前是第一天，则返回当前警长选择
  SheriffAction? getLastDaySheriff() {
    /// 如果还没有确定警徽流，则返回null
    if (!sheriff.isYesSheriffPlayer) return null;

    int? player;
    // 第一天直接返回
    if (roundHelper.day == 1) {
      player = sheriff.first.sheriffPlayer!;
    } else {
      player = getLastDayFactory()!.process.sheriffPlayer;
      if (null == player && sheriff.isShowSheriffSelect()) {
        /// 如果上个回合没有选出警长，并且当前回合可以展示
        /// 则表示当前回合已经选出，则返回first为当前回合选择
        player = sheriff.first.sheriffPlayer!;
      }
      // 如果没有上一局没有设置警徽，则返回null
      if (null == player) return null;
    }
    return sheriff.sheriffTools.toMapKeyPlayerNumber()[player];
  }
}

/// 白天流程
enum DayFlow {
  /// 未选择
  none("未选择"),

  /// 警徽选择
  sheriffSelect("警徽选择"),

  /// 昨晚情况
  lastNightState("昨晚情况"),

  /// 自由发言环节
  freeTalk("发言环节"),

  /// 投票环节
  vote("投票环节"),

  /// 出局玩家处理
  outPlayerSkill("出局玩家处理"),

  /// 所有流程已经结束，可以进行下一环节
  allFinish("全部完成"),

  /// 狼人自爆环节
  wolfBomb("狼人自爆"),
  ;

  final String flowDesc;

  const DayFlow(this.flowDesc);
}

class DayFlowHelper {
  final DayFactory factory;

  /// 流程结束判断
  final Map<DayFlow, bool Function(DayFactory factory)> flowIsFinish = {
    // 警长选择需要调用方法 isShowSheriffSelect 判断是否有该流程
    // 在生成当前流程时，会根据方法判断是否包含这个流程。所以这里不需要再次判断
    DayFlow.sheriffSelect: (factory) {
      // 判断警长选择是否结束
      var isNowRound = factory.round == factory.sheriff.yesSheriffRound;
      var isYes = factory.sheriff.isYesSheriffPlayer;
      return isNowRound && isYes;
    },
    DayFlow.lastNightState: (factory) => factory.dayAction.isYesLastStateFlow,
    DayFlow.freeTalk: (factory) => factory.dayAction.isYesFreeTalkFlow,
    DayFlow.vote: (factory) => factory.dayAction.isYesVotePlayer && factory.dayAction.isYesVoteFlow,
  };

  /// 当前流程
  final nowFlow = ValueNotifier(DayFlow.none);

  /// 是否狼人自爆
  bool isWolfBombFlow = false;

  int get _round => factory.round;

  DayFlowHelper(this.factory);

  /// 检查纠正当前流程状态，判断当前属于哪个回合
  /// 一般用于初始化或者进度复位检查
  checkFlowState() {
    if (isWolfBombFlow) {
      nowFlow.value = DayFlow.wolfBomb;
      return;
    }
    var items = nowFlowMenuItems();
    DayFlow nf = items[0];
    var finish = true;
    for (var value in items) {
      nf = value;
      // 如果当前流程已经结束，就继续循环
      // 如果流程未结束，就结束循环，直接break
      var isFinish = flowIsFinish[value]?.call(factory) ?? true;
      if (!(isFinish)) {
        finish = false;
        break;
      }
    }
    if (finish) {
      nowFlow.value = DayFlow.allFinish;
    } else {
      nowFlow.value = nf;
    }
    if (kDebugMode) print("当前进度：${nowFlow.value}");
  }

  /// 获取流程菜单的列表
  List<DayFlow> nowFlowMenuItems() {
    return [
      if (factory.sheriff.isShowSheriffSelect()) DayFlow.sheriffSelect,
      DayFlow.lastNightState,
      DayFlow.freeTalk,
      DayFlow.vote,
    ];
  }
}
