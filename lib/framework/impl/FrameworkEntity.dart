import 'package:annotation/annotation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/entity/RoleActions.dart';
import 'package:god_helper/entity/RuleConfig.dart';
import 'package:god_helper/exceptions.dart';
import 'package:god_helper/framework/DefaultFactoryConfig.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/DayFactory.dart';
import 'package:god_helper/framework/impl/NightFactory.dart';
import 'package:json_annotation/json_annotation.dart';

part 'FrameworkEntity.g.dart';

@JsonSerializable()
class RoundActions extends NoSqlDataEntity<RoundActions> {
  int round;

  /// 角色行为记录
  Map<Role, Map<String, dynamic>> roleActionMap = {};

  bool isYes = false;

  RoundActions(super.gameId, this.round);

  factory RoundActions.fromJson(Map<String, dynamic> json) {
    return _$RoundActionsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RoundActionsToJson(this);

  /// 获取角色行为
  T getRoleAction<T extends RoleAction>(
    Role role,
    JsonEntityData<T> jed,
  ) {
    var action = roleActionMap[role];
    if (null == action) {
      T entity = jed.emptyReturn();
      roleActionMap[role] = entity.toJson();
      return entity;
    } else {
      // if (kDebugMode) print("get action ($role) : ${jsonEncode(action)}");
      return jed.createForMap(action);
    }
  }

  T? getRoleActionNullable<T extends RoleAction>(
    Role role,
    JsonEntityData<T> jed,
  ) {
    var action = roleActionMap[role];
    if (null == action) {
      return null;
    } else {
      return jed.createForMap(action);
    }
  }

  @override
  RoundActions createForMap(Map<String, dynamic> map) {
    return RoundActions.fromJson(map);
  }

  @override
  RoundActions emptyReturn() => this;

  @override
  String getSaveKey() {
    return "game_factory_${gameId}_action_${round}";
  }
}

@JsonSerializable()
class RoundProcess extends NoSqlDataEntity<RoundProcess> {
  int round;

  /// 各个玩家在本回合的状态
  PlayerStateMap playerStateMap = PlayerStateMap();

  /// 当前回合被淘汰出局的玩家
  List<int> outPlayerNumbers = [];

  /// 该回合是否已经结束
  bool isFinish = false;

  RoundProcess(super.gameId, this.round);

  factory RoundProcess.fromJson(Map<String, dynamic> json) => _$RoundProcessFromJson(json);

  Map<String, dynamic> toJson() => _$RoundProcessToJson(this);

  @override
  RoundProcess createForMap(Map<String, dynamic> map) {
    return RoundProcess.fromJson(map);
  }

  @override
  RoundProcess emptyReturn() => this;

  @override
  String getSaveKey() {
    return "game_factory_${gameId}_round_process_$round";
  }

  Map<int, PlayerStates> getHasStatePlayers() {
    Map<int, PlayerStates> map = {};
    playerStateMap.states.forEach(
      (key, value) {
        if (value.stateShowStr().isNotEmpty) {
          map[key] = value;
        }
      },
    );
    return map;
  }

  /// 获取需要在一天开始时展示的状态
  Map<int, PlayerStates> getNeedShowForBeginDayStatePlayers() {
    Map<int, PlayerStates> map = {};
    playerStateMap.states.forEach(
      (key, value) {
        if (value.showInDayBeginStates().isNotEmpty) {
          map[key] = value;
        }
      },
    );
    return map;
  }

  PlayerStates getState(int number) => playerStateMap.getNoSet(number);
}

@JsonSerializable()
class DayAction extends NoSqlDataEntity<DayAction> {
  int round;

  /// 是否确认狼人自爆
  // bool isYesWolfBomb = false;

  /// 是否确认投票出局
  bool _isYesVotePlayer = false;

  /// 是否确认投票出局
  bool get isYesVotePlayer => _isYesVotePlayer && ((votePlayer ?? 0) > 0);

  /// 是否确认投票出局
  set isYesVotePlayer(bool value) => _isYesVotePlayer = value;

  PlayerStateMap playerStateMap = PlayerStateMap();

  DayAction(super.gameId, this.round);

  factory DayAction.fromJson(Map<String, dynamic> json) => _$DayActionFromJson(json);

  Map<String, dynamic> toJson() => _$DayActionToJson(this);

  @override
  DayAction createForMap(Map<String, dynamic> map) {
    return DayAction.fromJson(map);
  }

  @override
  DayAction emptyReturn() => this;

  @override
  String getSaveKey() {
    return "game_factory_${gameId}_day_actions_$round";
  }

  int? _getPlayerWithType(List<PlayerStateType> types) {
    return playerStateMap.getPlayerForTypeSingle(types);
  }

  /// 狼人自爆玩家
  int? get wolfBombPlayer => _getPlayerWithType([PlayerStateType.isWolfBomb]);

  /// 投票出局玩家
  int? get votePlayer => _getPlayerWithType([PlayerStateType.isYesVotePlayer]);

  /// 被狼王白天击杀玩家
  int? get killWithWolfKing => _getPlayerWithType([PlayerStateType.isKillWithWolfKing]);

  /// 被猎人白天击杀玩家
  int? get killWithHunter => _getPlayerWithType([PlayerStateType.isKillWithHunter]);

  List<int> outPlayerIds() => playerStateMap.outPlayerIds();

  bool isHasStateType(int playerId, PlayerStateType type) {
    var beforeIsType = playerStateMap.getNullable(playerId)?.get(type) ?? false;
    return beforeIsType;
  }

  PlayerStates? getState(int outId) => playerStateMap.getNullable(outId);

  bool isDieForId(int number) => playerStateMap.get(number).isDead;
}

@JsonSerializable()
class PlayerIdentityCache extends NoSqlDataEntity<PlayerIdentityCache> {
  /// 记录狼人的玩家编码
  List<int> wolfNumbers = [];

  /// 记录角色对应的玩家编码
  Map<Role, int> rolePlayerNumberMap = {};

  /// 角色对应的玩家编码是否已经记录完毕
  Map<Role, bool> isRoleRecordFinish = {};

  PlayerIdentityCache(super.gameId);

  factory PlayerIdentityCache.fromJson(Map<String, dynamic> json) => _$PlayerIdentityCacheFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerIdentityCacheToJson(this);

  @override
  PlayerIdentityCache createForMap(Map<String, dynamic> map) {
    return PlayerIdentityCache.fromJson(map);
  }

  @override
  PlayerIdentityCache emptyReturn() => this;

  @override
  String getSaveKey() {
    return "game_${gameId}_player_identity_cache";
  }

  /// 设置有身份的玩家编码
  /// 有身份的狼人、神职、三方都适用
  void setRoleIdentity(Role role, int number) {
    // if (null == rolePlayerNumberMap[role]) {
    rolePlayerNumberMap[role] = number;
    // } else {
    //   throw AppError.roleAlreadySetting.toExc();
    // }
  }

  /// 获取角色的玩家编码
  int getRoleNumber(Role role) => rolePlayerNumberMap[role] ?? 0;

  /// 设置角色对应的玩家编码已经记录完毕
  void setRolePlayerRecordFinish(Role role) {
    isRoleRecordFinish[role] = true;
  }

  bool isRecordFinish(Role wolf) => isRoleRecordFinish[wolf] ?? false;

  /// 设置狼人
  void setWolfsNumber(List<int> numbers) {
    wolfNumbers = numbers;
  }

  /// 设置该角色的玩家身份信息已经记录结束
  void setRecordFinish(Role role) => isRoleRecordFinish[role] = true;

  List<int> getNoIdentityPlayerIds(GameDetailEntity entity) {
    var playerCount = entity.tempConfig.playerCount;
    if (playerCount <= 0) throw AppError.playerCountTooSmall.toExc();
    Set<int> settingPlayerNumbers = Set.identity()
      ..addAll(rolePlayerNumberMap.values)
      ..addAll(wolfNumbers);
    return List.generate(playerCount, (index) => index + 1)
      ..removeWhere(
        (element) => settingPlayerNumbers.contains(element),
      )
      ..sort();
  }

  Role? checkPlayerIsConfig(int selectIndex) {
    if (wolfNumbers.contains(selectIndex)) return Role.WOLF;
    for (var e in rolePlayerNumberMap.entries) {
      if (e.value == (selectIndex)) return e.key;
    }
    return null;
  }
}

class Sheriff {
  DayFactory factory;
  int number;

  /// 如果狼人连续自爆，会将警徽冲毁
  bool isAutoDestroy = false;

  Sheriff(this.factory, this.number);

  /// 警徽变化记录
  SheriffTools get sheriffTools => factory.factory.other.sheriffTools;

  /// 默认警徽配置
  SheriffAction get defaultSheriffAction => sheriffTools.defaultSheriffAction;

  /// 第一个警徽
  /// 即玩家投票选举的警长
  int? get firstSheriffPlayer => defaultSheriffAction.sheriffPlayer;

  /// 设置第一个警徽
  set firstSheriffPlayer(value) => defaultSheriffAction.sheriffPlayer = value;

  int? get nowSheriffPlayer => sheriffTools.nowSheriffPlayer;

  bool get isDestroySheriff => sheriffTools.getNowSheriff().isDestroySheriff;

  SheriffAction get first => sheriffTools.defaultSheriffAction;

  bool get isYesSheriffPlayer => sheriffTools.isYesSheriffPlayer;

  SheriffAction get last => sheriffTools.last;

  set isYesSheriffPlayer(value) => sheriffTools.isYesSheriffPlayer = value;

  /// 检查所有的警徽处理
  /// 奖结果写入 process.playerStateMap
  void checkSheriff(PlayerStateMap map) {
    var lastProcess = factory.getLastRound();

    /// 处理所有的警徽流
    for (int i = 0; i < sheriffTools.length; i++) {
      var value = sheriffTools.list[i];

      /// 放在最后，因为需要根据玩家是否出局来判断是否移交警徽
      if ((value.sheriffPlayer ?? 0) > 0) {
        bool isDead = false;
        if (i == 0) {
          /// 第一个数据是需要增加前一晚的情况来判断警徽是否没了
          isDead = lastProcess.playerStateMap.get(value.sheriffPlayer!).isDead;
        }

        /// 然后判断本局是否让局长玩家出局了
        isDead = isDead || map.get(value.sheriffPlayer!).isDead;
        if (isDead) {
          /// 如果警长已经阵亡，需要重新移交警徽或者撕毁
          if (!value.isTransferSheriff) {
            /// 如果没有转移或者撕毁 则需要抛出异常
            throw AppError.youNeedTransferSheriff.toExc();
          }
          if (value.isDestroySheriff) {
            /// 警徽撕毁
            map.set(value.sheriffPlayer!, PlayerStateType.destroySheriff);
          } else if ((value.transferSheriffPlayer ?? 0) > 0) {
            /// 警徽转移
            map.set(value.transferSheriffPlayer!, PlayerStateType.transferSheriff);
          } else {
            /// 如果警徽转移，但没有指定玩家，则需要抛出异常
            throw AppError.youNeedSelectTransferSheriffPlayer.toExc();
          }
        }
      }
    }
  }

  List<int> getOutIds() => sheriffTools.getOutIds();

  /// 设置第一个被选出的警长
  void setFirstSheriff(int playerId) {
    defaultSheriffAction.sheriffPlayer = playerId;
  }

  void save() {
    // 保存other数据，即可保存警徽数据
    factory.factory.other.save();
  }

  SheriffAction? getForKillPlayerIds(List<int> killPlayers) => sheriffTools.getForKillPlayerIds(killPlayers);

  void add(SheriffAction sheriffAction) => sheriffTools.add(sheriffAction);

  /// 白天结算前的警徽流检测
  void dayBeforeSummaryCheck(DayFactory dayFactory) {
    // 警徽规则
    var sheriffRule = dayFactory.factory.entity.extraRule.sheriffRace;
    // 无需警徽流，则直接跳过
    if (sheriffRule == SheriffRace.none) return;
    var round = dayFactory.round;
    if (sheriffRule == SheriffRace.onlyFirstDay && round > 1) {
      return;
    } else if (sheriffRule == SheriffRace.notForSecond && round > 2) {
      return;
    }

    // 是否自爆
    var isBomb = dayFactory.isYesWolfBomb;

    /// 1、先判断警长竞选
    /// 如果没有警长，则无需判断警徽流问题

    // 剩余两种规则，无论那种，都要先判断警长是否竞选过
    if (isYesSheriffPlayer && firstSheriffPlayer != null) {
      // 警长已经选择过了，仅仅需要判断当前的警长是否阵亡即可
      if (!last.isLive && !last.isTransferSheriff) {
        throw AppError.haveDieSheriffNoTransfer.toExc(args: [last.sheriffPlayer!], obj: Role.SHERIFF);
      }
    } else {
      // 如果警长没有选择，那么就要抛出异常，必须竞选警长
      if (!isBomb) {
        throw AppError.dayNeedVoteSelectSheriff.toExc(obj: Role.SHERIFF);
      }

      // 如果没竞选过，且狼人自爆了，则需要根据规则销毁警徽
      if (round == 1 && sheriffRule == SheriffRace.onlyFirstDay) {
        // 如果第一天自爆，且第二天继续自爆，警徽会被直接冲掉
        isAutoDestroy = true;
        save();
      } else if (round == 2 && sheriffRule == SheriffRace.notForSecond) {
        // 如果第一天自爆，且第二天继续自爆，警徽会被直接冲掉
        isAutoDestroy = true;
        save();
      }
    }
  }
}

@JsonSerializable()
class EmptyRoleTempConfig extends RoleTempConfig<EmptyRoleTempConfig> {
  EmptyRoleTempConfig();

  factory EmptyRoleTempConfig.fromJson(Map<String, dynamic> e) => _$EmptyRoleTempConfigFromJson(e);

  @override
  Map<String, dynamic> toJson() => _$EmptyRoleTempConfigToJson(this);

  @override
  EmptyRoleTempConfig createForMap(Map<String, dynamic> map) {
    return EmptyRoleTempConfig.fromJson(map);
  }

  @override
  EmptyRoleTempConfig emptyReturn() {
    return this;
  }
}

/// 组件管理
/// 根据配置加载不同地方的组件
class WidgetFactory {
  final RoundFactory _factory;
  final Role _role;

  GeneratorFactory get _generator => _factory.factory.generator;

  /// 获取回合配置
  RoundExtraConfig get roundExtraConfig => _factory.config;

  WidgetFactory(this._factory, this._role);

  /// 身份选择器，每个角色必须有
  PlayerIdentityGenerator _getIdentityGenerator() {
    return _generator.get(_role)?.playerIdentityGenerator() ?? DefaultPlayerIdentityGenerator(_factory.factory, _role);
  }

  Widget getIdentityWidget() {
    return _getIdentityGenerator().widget();
  }

  /// 获取角色行为活动界面
  Widget? getNightAction({Function()? updateCallback, bool isLive = true}) {
    if (_factory is! NightFactory) return const SizedBox();
    var generator = _factory.factory.generator.get(_role)?.getNightRoundGenerator(_factory);
    if (generator == null) return null;

    if (!roundExtraConfig.isCanAction(_role)) {
      /// 设置技能被封印。
      generator.sealingSkill();
      return const Text("技能被封印，无法发动技能。");
    }

    // 需要去执行一些预操作
    generator.preAction();
    if (isLive) {
      return generator.actionWidget(() {
        if (null != updateCallback) updateCallback();
      });
    } else {
      return generator.playerLastKillNoActionWidget() ?? const Text("由于玩家已经出局，无法使用技能");
    }
  }

  /// 获取角色出局操作界面，在白天回合上
  Widget? getOutViewForDay({Function()? updateCallback, bool isLive = true}) {
    if (_factory is! DayFactory) return null;
    var generator = _factory.factory.generator.get(_role)?.getDayRoundGenerator(_factory);
    if (generator == null) return null;

    generator.preAction();

    /// 阵亡操作没有封印一说，直接去获取界面
    return generator.outWidget(() {
      if (null != updateCallback) updateCallback();
    });
  }

  /// 主动技能界面
  Widget? activeSkillWidget({Function()? updateCallback}) {
    if (_factory is! DayFactory) return null;
    var generator = _factory.factory.generator.get(_role)?.getDayRoundGenerator(_factory);
    if (generator == null) return null;

    return generator.activeSkillWidget(() {
      if (null != updateCallback) updateCallback();
    });
  }

  List<int> dieForDayActiveSkill() {
    if (_factory is! DayFactory) return [];
    var generator = _factory.factory.generator.get(_role)?.getDayRoundGenerator(_factory);
    if (generator == null) return [];
    return generator.dieForDayActiveSkill();
  }
}

/// 结算辅助工具
class SummaryHelper {
  final GameFactory _factory;

  SummaryHelper(this._factory);

  PlayerDetail get _details => _factory.players.details;

  OtherFactory get _other => _factory.other;

  GameTemplateConfigEntity get _temp => _factory.entity.tempConfig;

  bool get _isInit => _other.maxRound > 0 && _details.count == _temp.playerCount && _details.isAllInit;

  bool _isBeginGame() {
    // 游戏至少得过了第一晚才算开始
    if (_factory.other.maxRound < 2) return false;
    // 如果第一回合还没有结束，则游戏不可能结束
    if (!_factory.getRoundFactory(1).process.isFinish) return false;
    return true;
  }

  ResultSummary get _summary {
    var winRule = _factory.extraRule.winRule;
    Set<int> liveCitizen = {};
    Set<int> liveGod = {};
    Set<int> liveWolf = {};
    Set<int> liveThird = {};

    for (var player in _factory.players.details.players) {
      if (!player.live) continue;
      if (player.identity && player.role != Role.WOLF) {
        if (player.role == Role.CITIZEN) {
          liveCitizen.add(player.number);
        } else if (player.role.camp == Camp.THIRD) {
          // 三方阵营算民
          liveCitizen.add(player.number);
          // 普通
          liveThird.add(player.number);
        } else {
          liveGod.add(player.number);
        }
      } else {
        liveWolf.add(player.number);
        // if (player.role.desc.camp == Camp.THIRD){
        //   // 即使在狼队，也可能存在三方阵营由于技能被转换过来的，一般按狼人算
        // }
      }
    }

    return ResultSummary(
      _factory.entity.tempConfig.roleConfig,
      _factory.players.details,
      wolfWinRule: winRule,
      liveCitizen: liveCitizen.length,
      liveGod: liveGod.length,
      liveWolf: liveWolf.length,
      liveThird: liveThird.length,
    );
  }

  /// 获取单独角色胜利实体
  /// 如果返回为null，则表示没有三方角色胜利
  RoleWinEntity? get _thirdRoleWin {
    /// 上面的内容主要是整理数据
    /// 下面的是用来判断角色是否有单独胜利的
    var winRules = _factory.generator.roleWinRules;
    for (var value in winRules) {
      if (value.isWin()) {
        return value.winEntity();
      }
    }
    return null;
  }

  bool isContinue() {
    if (!_isInit) return true;
    if (!_isBeginGame()) return true;

    /// 如果三方胜利条件不为空，则表示有角色触发了胜利条件，游戏结束
    if (_thirdRoleWin != null) return false;
    return _summary.isContinue();
  }

  bool isGameOver() => !isContinue();

  String result() {
    if (isContinue()) return "游戏还在继续";
    var roleWin = _thirdRoleWin;
    if (roleWin != null) {
      return "角色 ${roleWin.role.roleName} 胜利：${roleWin.winMsg}";
    }
    return _summary.result().desc;
  }
}

/// 角色如果胜利，这里返回一个实体来记录角色数据
class RoleWinEntity {
  final Role role;
  final String winMsg;

  RoleWinEntity(this.role, this.winMsg);
}

class ResultSummary {
  final TemplateRoleConfig temp;
  final PlayerDetail details;
  WinRule wolfWinRule;
  int liveCitizen;
  int liveGod;
  int liveWolf;
  int liveThird = 0;

  ResultSummary(
    this.temp,
    this.details, {
    required this.wolfWinRule,
    required this.liveCitizen,
    required this.liveGod,
    required this.liveWolf,
    this.liveThird = 0,
  });

  /// 游戏是否继续
  bool isContinue() {
    /// 狼人死完已经无需游戏，好人获胜
    if (liveWolf == 0) return false;
    switch (wolfWinRule) {
      case WinRule.KILL_ALL_CITY:
        // 屠城局，需要好人全部阵亡
        return (liveCitizen + liveGod) != 0;
      case WinRule.KILL_SIDE:
        // 屠边局，仅仅需要村民或者神职为0即为狼人胜利
        var maxLiveCitizen = temp.citizenCampLength - temp.sideKillCount;
        var maxLiveGod = temp.godsLength - temp.sideKillCount;
        // 当民或者神的存活数量小于或者等于最小存活数量时，游戏结束。
        // 否则游戏继续
        var result = !(liveCitizen <= maxLiveCitizen || liveGod <= maxLiveGod);
        return (result);
    }
  }

  GameResult result() {
    if (liveWolf == 0) {
      /// 如果神或者民还有存活，则好人胜利
      /// 否则就是平局
      if ((liveCitizen + liveThird) != 0 || (liveGod) != 0) {
        return GameResult.goodPersonWin;
      } else {
        return GameResult.dogfall;
      }
    } else {
      switch (wolfWinRule) {
        case WinRule.KILL_ALL_CITY:
          if (liveCitizen == 0 && liveGod == 0) {
            /// 屠城局
            /// 狼人还存活、村民和神职全部阵亡，则狼人胜利
            return GameResult.wolfWin;
          }
          break;
        case WinRule.KILL_SIDE:
          if ((liveCitizen <= (temp.citizenCampLength - temp.sideKillCount) ||
              liveGod <= (temp.godsLength - temp.sideKillCount))) {
            /// 屠边局
            /// 狼人还存活、村民或者神职全部阵亡，则狼人胜利
            return GameResult.wolfWin;
          }
          break;
      }
    }

    // 如果所有判定都没有通过，则表示游戏还在继续
    return GameResult.continueGame;
  }

  @override
  String toString() {
    return "游戏: ${result().desc}";
  }
}

enum GameResult {
  continueGame("还未结束"),
  wolfWin("狼人胜利"),
  goodPersonWin("好人胜利"),
  dogfall("平局"),
  thirdRoleWin("三方角色胜利"),
  ;

  final String desc;

  const GameResult(this.desc);
}

class RouteHelper {
  final BuildContext context;
  final Widget target;

  RouteHelper({required this.context, required this.target});

  Future push() {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => target),
    );
  }

  Future pushReplace() {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => target),
    );
  }

  Future pushAndRemoveUntil(String name) {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => target),
      ModalRoute.withName(name),
    );
  }
}
