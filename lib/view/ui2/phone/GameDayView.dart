import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/entity/RoleActions.dart';
import 'package:god_helper/entity/RuleConfig.dart';
import 'package:god_helper/exceptions.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/AppFactory.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/framework.dart';
import 'package:god_helper/framework/impl/DayFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';

/// 天亮界面
class GameDayView extends StatefulWidget {
  final GameFactory factory;
  final int round;

  const GameDayView(this.factory, this.round, {super.key});

  @override
  State<GameDayView> createState() => _GameDayViewState();
}

class _GameDayViewState extends State<GameDayView> {
  late WhiteDayEntity _whiteDayEntity;

  int get _round => widget.round;

  /// 游戏中角色行为记录
  DayFactory get _dayFactory => widget.factory.getDay(_round);

  final _isShow = IsShowState();

  @override
  void initState() {
    super.initState();
    _whiteDayEntity = WhiteDayEntity(this);
    // restoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第 ${_dayFactory.roundHelper.dayStr}"),
        actions: _topActionBarActions(),
      ),
      bottomNavigationBar: BottomAppBar(child: _bottomAppBarChild()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8 * 2),
        child: ListView(
          children: [
            /// 竞选警长 组件
            _sheriffRaceWidget(this, () => setState(() => saveAction())),
            const SizedBox(height: 8),
            title("昨晚情况"),
            const SizedBox(height: 8),
            _KillPlayerWidget(this),
            _lastNightWidget(this),
            const SizedBox(height: 8),

            /// 处理昨晚如果选举的警长阵亡的处理方式。
            if (isNeedLastRoundSheriffKill())
              _sheriffKillWidget(
                _dayFactory,
                "昨晚倒牌",
                sheriffAction: _dayFactory.sheriff.defaultSheriffAction,
                // 确认结果后
                () => saveAction(),
              ),

            title("昨晚是否死亡玩家可发动技能"),
            const SizedBox(height: 8),
            _outPlayerMotorSkill(
              _dayFactory,
              _dayFactory.getBeforeVoteOutPlayers(),
              () => setState(() => saveAction()),
              () => setState(() => saveAction()),
            ),

            const SizedBox(height: 8),
            _PlayerActiveSkillWidget(
              _dayFactory,
              finishCallback: () => setState(() {}),
            ),

            const SizedBox(height: 8),
            title("投票出局"),
            const SizedBox(height: 8),
            _voteOutWidget(this, () => saveActionAndUpdate()),

            const SizedBox(height: 8),
            title("本回合出局玩家是否发动技能"),
            const SizedBox(height: 8),
            _outPlayerMotorSkill(
              _dayFactory,
              _dayFactory.getAfterVoteOutPlayers(),
              () => setState(() => saveAction()),
              () => setState(() => saveAction()),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// 标题的Actions
  List<Widget> _topActionBarActions() => [
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: TextButton(onPressed: () => _debugPrint(), child: const Text("print")),
            ),
            PopupMenuItem(
              value: "刷新",
              child: IconButton(
                onPressed: () => setState(() {}),
                icon: const Icon(Icons.refresh),
              ),
            ),
            if (kDebugMode)
              PopupMenuItem(
                value: "清除状态",
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _dayFactory.clearNoSqlData();
                      Navigator.popUntil(context, ModalRoute.withName("/"));
                    });
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
          ],
        ),
        IconButton(
          onPressed: () => AppFactory().getRoute(context).toGameSummaryView(_dayFactory.factory).push(),
          icon: const Icon(Icons.menu),
        ),
      ];

  Widget _bottomAppBarChild() {
    var msg = (_dayFactory.isYesWolfBomb) ? "狼人 ${_dayFactory.dayAction.wolfBombPlayer} 自爆，进入黑夜!" : "结束一天，天黑进入下一回合";
    return TextButton(onPressed: () => saveAndFinishThisRoundToNext(), child: Text(msg));
  }

  /// 是否需要处理昨晚警徽相关情况
  /// 如果是第一天，选择完警长后，会判断昨晚这个玩家是否死亡，如果玩家阵亡，返回true
  /// 如果是后面几天，则会延续上一局的警长，如果警长存咋，就判断玩家活没活，如果警长不存在，则表示警徽已经被撕掉
  bool isNeedLastRoundSheriffKill() {
    // 判断当前的警长在昨晚是否阵亡
    var nightFactory = _dayFactory.lastNight();
    var sheriffAction = _dayFactory.sheriff.nowSheriffPlayer;
    if (null == sheriffAction) return false;
    var state = nightFactory.process.playerStateMap.get(sheriffAction);

    // /// 判断昨晚这个万家是否存活
    // /// 由于是白天，一定有上一回合
    // var process = _processes.get(_round - 1);
    // var map = process.playerStateMap;
    // var state = map.get(playerId);
    return state.isDead;
  }

  void _debugPrint() {
    if (kDebugMode) {
      // print("_round: $_round");
      // print("_dayRecord: ${jsonEncode(_dayRecord)}");
      // for (var p in playerDetail.players) print("player: ${jsonEncode(p)}");
      // print("entity: ${jsonEncode(_entity)}");
      // print("是否可以竞选: ${_entity.isCanSheriffRace()}");
      // print(                      "lastNight: ${jsonEncode(_processes.lastRoundProcess().outPlayerNumbers)}");
      print("action ${jsonEncode(_dayFactory.dayAction)}");
      // print("action ${jsonEncode(playerDetail.get(3))}");
    }
  }

  void saveAction() {
    _dayFactory.dayAction.save();
  }

  void saveActionAndUpdate() {
    saveAction();
    setState(() {});
  }

  Future<void> saveAndFinishThisRoundToNext() async {
    try {
      await _dayFactory.recordThisRoundAndToNext(context);
    } on AppException catch (e, stackTrace) {
      // showSnackBarMessage(e.toString(), isShow: _isShow);
      if (e.obj is Role) {
        var role = (e.obj as Role);
        showSnackBarMessage("角色 ${role.roleName} : ${e.message ?? "还有行为未完成"}", isShow: _isShow);
      } else {
        showSnackBarMessage(e.error.err, isShow: _isShow);
      }
      e.printMessage(stackTrace: stackTrace);
    }
  }
}

class WhiteDayEntity {
  final _GameDayViewState _state;

  WhiteDayEntity(this._state);

  GameDetailEntity get entity => _state.widget.factory.entity;

  int get round => _state.widget.round;

  PlayerDetail get playerDetail => _state._dayFactory.details;

  int get sheriffPlayer => _state._dayFactory.sheriff.nowSheriffPlayer ?? 0;

  bool get isDestroySheriff => _state._dayFactory.sheriff.isDestroySheriff;

  List<Player> getLivePlayer() {
    var players = playerDetail.getLivePlayer();
    // 实际存活的玩家还要减去在本回合被kill的玩家
    var outPlayerIds = _state._dayFactory.dayAction.outPlayerIds();
    players.removeWhere((element) => outPlayerIds.contains(element.number));
    return players;
  }

  List<int> getLivePlayerIds() => getLivePlayer().map((e) => e.number).toList();

  /// 本局出局玩家
  /// 特指投票后出局
  List<Player> thisRoundAfterVoteOutPlayers() => _state._dayFactory.getAfterVoteOutPlayers();
}

/// 警长竞选选择
class _sheriffRaceWidget extends StatefulWidget {
  final _GameDayViewState state;

  /// 确认警长选择结果
  final Function() affirmSelectCallback;

  const _sheriffRaceWidget(this.state, this.affirmSelectCallback);

  @override
  State<_sheriffRaceWidget> createState() => _sheriffRaceWidgetState();
}

class _sheriffRaceWidgetState extends State<_sheriffRaceWidget> {
  DayFactory get _dayFactory => widget.state._dayFactory;

  /// 警徽流处理
  SheriffHelper get _sheriff => _dayFactory.sheriff;

  PlayerDetail get _playerDetail => widget.state._whiteDayEntity.playerDetail;

  IsShowState get _isShow => widget.state._isShow;

  int get sheriffPlayer => widget.state._whiteDayEntity.sheriffPlayer;

  bool get isDestroySheriff => widget.state._whiteDayEntity.isDestroySheriff;

  bool get isCanContinue => _dayFactory.isCanContinueAction();

  @override
  Widget build(BuildContext context) {
    if (!_dayFactory.isCanSheriffRace()) {
      if (isDestroySheriff) {
        return _destroySheriff();
      } else if ((sheriffPlayer) > 0) {
        return Text("玩家 $sheriffPlayer 为当前的警长");
      } else {
        return const Text("没有玩家成为警长");
      }
    }
    if (!isCanContinue && !_sheriff.isYesSheriffPlayer) {
      /// 如果不能继续游戏，且还没有确认警长是谁，本局将无法选择警长
      return _wolfBombNoteContinue();
    }

    /// 正常选举
    return _selectSheriffWidget();
  }

  /// 警长正常选举
  /// 选举结束狗，
  Widget _selectSheriffWidget() {
    return Column(
      children: [
        context.title("警长竞选"),
        Center(
          child: RichText(
            text: TextSpan(
              style: context.defaultFont,
              children: [
                const TextSpan(text: "玩家们选举警长"),
                const WidgetSpan(child: SizedBox(width: 8)),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: PlayerSingleSelectButton.initConfig(
                    config: SelectConfig.forCount(
                      count: _playerDetail.count,
                      selectable: !_sheriff.isYesSheriffPlayer,
                      defaultSelect: _sheriff.firstSheriffPlayer ?? 0,
                      callback: (t) => setState(() {
                        _sheriff.firstSheriffPlayer = t;
                      }),
                    ),
                  ),
                ),
                const WidgetSpan(child: SizedBox(width: 8)),
                const TextSpan(text: "为警长"),
              ],
            ),
          ),
        ),
        if ((_sheriff.firstSheriffPlayer ?? 0) > 0)
          !_sheriff.isYesSheriffPlayer
              ? Center(
                  child: TextButton(
                    onPressed: () {
                      if ((_sheriff.firstSheriffPlayer ?? 0) <= 0) {
                        showSnackBarMessage("还未选择玩家", isShow: _isShow);
                        return;
                      }
                      // 这里需要判断选择的警长在昨天晚上是否已经阵亡
                      var process = _dayFactory.getLastRound();
                      var playerState = process.playerStateMap.get(_sheriff.firstSheriffPlayer!);
                      // 设置玩家存活状态
                      _sheriff.first.isLive = !playerState.isDead;
                      // _sheriff.first.
                      // 已经设置结束标志
                      // _sheriff.isYesSheriffPlayer = true;
                      _sheriff.setYesSheriffPlayer(_dayFactory.round);
                      // 保存这个结果
                      _sheriff.save();
                      // 跟新这个组件并通知
                      setState(() {
                        widget.affirmSelectCallback();
                      });
                    },
                    child: const Text("确认选择该玩家"),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text("选择玩家 P${_sheriff.firstSheriffPlayer} 为警长"),
                ),
      ],
    );
  }

  Widget _destroySheriff() {
    return Column(
      children: [
        context.title("警长情况"),
        Row(
          children: [isDestroySheriff ? const Text("警徽已被销毁") : Text("玩家 $sheriffPlayer 为当前的警长")],
        )
      ],
    );
  }

  /// 狼人自爆导致无法继续竞选警长
  Widget _wolfBombNoteContinue() {
    var sr = _dayFactory.entity.extraRule.getSheriffConfig().sheriffRace;
    switch (sr) {
      case SheriffRace.none:
        break;
      case SheriffRace.onlyFirstDay:
        return const Text("由于狼人自爆时，警长还未选出，所以警徽也被销毁");
      case SheriffRace.notForSecond:
        if (_dayFactory.round == 1) {
          return const Text("由于狼人自爆时，警长还未选出，请在第二晚时获取");
        } else if (_dayFactory.round == 2) {
          return const Text("由于狼人自爆时，警长还未选出，且已经是第二天，根据规则警徽被销毁");
        }
    }
    return const SizedBox.shrink();
  }
}

/// 昨晚倒牌玩家组件
/// 仅展示昨晚情况
class _KillPlayerWidget extends StatelessWidget {
  final _GameDayViewState state;

  const _KillPlayerWidget(this.state);

  @override
  Widget build(BuildContext context) {
    var outPlayer = state._dayFactory.getLastRoundOutPlayers();
    return Row(
      children: [
        _showDayBegin(),
        const Text("昨晚倒牌玩家:"),
        const SizedBox(width: 8),
        outPlayer.isNotEmpty
            ? SizedBox(
                height: 60,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Center(child: Circle(child: Text("P${outPlayer[index].number}"))),
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemCount: outPlayer.length,
                ),
              )
            : const Text("无"),
      ],
    );
  }

  /// 展示一些在一天开始时候，个别角色提供的额外信息
  /// todo 还未测试，主要是熊咆哮的行为，检查改代码是否可以正常显示
  Widget _showDayBegin() {
    var statePlayers = state._dayFactory.getLastRound().getNeedShowForBeginDayStatePlayers();
    if (statePlayers.isEmpty) return const SizedBox();
    var keys = statePlayers.keys.toList(growable: false);
    return Column(children: [
      const Row(children: [Text("昨晚额外信息")]),
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var player = state._dayFactory.details.get(keys[index]);
          var states = statePlayers[keys[index]]!.showInDayBeginStates();
          return Column(
            children: [
              Row(children: [Text("玩家(P${player.number}) 角色 ：${player.role.nickname} ")]),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Text("\t\t- ${states[index]}"),
                separatorBuilder: (context, index) => const SizedBox(),
                itemCount: states.length,
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(),
        itemCount: keys.length,
      ),
      const SizedBox(width: 8),
    ]);
  }
}

/// 昨晚玩家行为
/// 记录晚上发生的事情
class _lastNightWidget extends StatelessWidget {
  final _GameDayViewState state;

  const _lastNightWidget(this.state);

  @override
  Widget build(BuildContext context) {
    var statePlayers = state._dayFactory.getLastRound().getHasStatePlayers();
    var keys = statePlayers.keys.toList(growable: false)..sort();
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var playerState = statePlayers[keys[index]]!;
        var player = state._dayFactory.details.getNullable(keys[index])!;
        var showStr = playerState.stateShowStr();
        return Column(
          children: [
            Row(children: [
              // Text("${player.number}号玩家 角色 ${player.role.desc.name}"),
              RichText(
                text: TextSpan(
                  style: state.app.baseFont,
                  children: [
                    TextSpan(text: "${player.number}号玩家 角色"),
                    TextSpan(
                      text: player.role.roleName,
                      style: state.app.baseFont.copyWith(
                        color: player.identity ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              )
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Text("- ${showStr[index]}"),
                separatorBuilder: (context, index) => const SizedBox(),
                itemCount: showStr.length,
              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(),
      itemCount: keys.length,
    );
  }
}

/// 处理出局玩家的一些被动技能发动
class _outPlayerMotorSkill extends StatefulWidget {
  final DayFactory _dayFactory;
  final List<Player> players;

  /// 技能结束回调
  final Function() finishCallback;

  /// 如果存在警长操作，结束后进行回调
  final Function() sheriffFinishCallback;

  const _outPlayerMotorSkill(
    this._dayFactory,
    this.players,
    this.finishCallback,
    this.sheriffFinishCallback,
  );

  @override
  State<_outPlayerMotorSkill> createState() => _outPlayerMotorSkillState();
}

class _outPlayerMotorSkillState extends State<_outPlayerMotorSkill> {
  List<Player> get _players => widget.players;

  DayFactory get _dayFactory => widget._dayFactory;

  // PlayerStateMap get playerStateMap => widget.playerStateMap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var player = _players[index];

        // 获取该角色击杀的玩家
        List<int> killPlayers = _dayFactory.dayAction.getState(player.number)?.killPlayer ?? [];

        SheriffAction? lastSheriff = _dayFactory.sheriff.getForKillPlayerIds(killPlayers);

        // if (kDebugMode) print("playerStateMap : ${jsonEncode(playerStateMap)}");
        // if (kDebugMode) print("killPlayers: ${jsonEncode(killPlayers)}");
        if (kDebugMode) {
          print("sheriff(${player.number} kill $killPlayers) : ${jsonEncode(lastSheriff)}");
        }

        // 获取该玩家本回合的技能界面
        var outWidget = _dayFactory
            .getWidgetHelper(player.role)
            .getOutViewForDay(updateCallback: () => widget.finishCallback.call());

        return Column(
          children: [
            outWidget ??
                Row(children: [Text("P${player.number}号玩家 ${player.role.roleName} 出局(无技能)", style: app.font.subtitle)]),

            /// 警徽判断
            if (null != lastSheriff)
              _sheriffKillWidget(
                _dayFactory,
                "被 ${_players[index].role.roleName} 带走",
                sheriffAction: lastSheriff,
                // 确认结果后
                widget.sheriffFinishCallback,
              ),
          ],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(),
      itemCount: widget.players.length,
    );
  }
}

/// 警长被杀处理
class _sheriffKillWidget extends StatefulWidget {
  final DayFactory _dayFactory;

  /// 死亡描述
  final String killDesc;

  /// 如果没有指定特定的警长活动，则表示需要去寻找最新的阵亡数据去处理
  final SheriffAction? sheriffAction;
  final Function() finishCallback;

  const _sheriffKillWidget(this._dayFactory, this.killDesc, this.finishCallback, {this.sheriffAction});

  @override
  State<_sheriffKillWidget> createState() => _sheriffKillWidgetState();
}

class _sheriffKillWidgetState extends State<_sheriffKillWidget> {
  SheriffHelper get _sheriff => widget._dayFactory.sheriff;

  SheriffAction get _sheriffPlayer => widget.sheriffAction ?? _sheriff.last;

  Player get _player => widget._dayFactory.details.getNullable(_sheriffPlayer.sheriffPlayer!)!;

  final _isShow = IsShowState();

  @override
  Widget build(BuildContext context) {
    var livePlayers = widget._dayFactory.details.getLivePlayer().map((e) => e.number).toList();
    livePlayers.removeWhere((element) => element == _player.number);
    return Column(
      children: [
        Row(children: [Text("警长 ${widget.killDesc}", style: app.baseFont.copyWith(fontSize: 18))]),
        Row(children: [Text("P${_player.number}号玩家 警长 ${widget.killDesc}", style: app.baseFont)]),
        (_sheriffPlayer.isDestroySheriff && _sheriffPlayer.isTransferSheriff)
            ? const Row(children: [Text("警徽已被该玩家撕毁撕毁")])
            : RichText(
                text: TextSpan(
                  style: app.baseFont,
                  children: [
                    const TextSpan(text: "转移警徽给"),
                    const WidgetSpan(child: SizedBox(width: 8)),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: PlayerSingleSelectButton.initConfig(
                        config: SelectConfig(
                          selectableList: livePlayers,
                          selectable: !_sheriffPlayer.isTransferSheriff,
                          defaultSelect: _sheriffPlayer.transferSheriffPlayer ?? 0,
                          callback: (t) => _sheriffPlayer.transferSheriffPlayer = t,
                        ),
                      ),
                    ),
                    const WidgetSpan(child: SizedBox(width: 8)),
                    const TextSpan(text: "号玩家"),
                  ],
                ),
              ),
        if (!_sheriffPlayer.isTransferSheriff)
          Row(children: [
            Expanded(
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        _sheriffPlayer.isLive = false;
                        _sheriffPlayer.transferSheriffPlayer = null;
                        _sheriffPlayer.isDestroySheriff = true;
                        _sheriffPlayer.isTransferSheriff = true;
                        _sheriff.save();
                      });
                    },
                    child: const Text("撕毁警徽"))),
            Expanded(
                child: TextButton(
                    onPressed: () => setState(() {
                          if ((_sheriffPlayer.transferSheriffPlayer ?? 0) <= 0) {
                            showSnackBarMessage("需要先设置转移警徽给哪个玩家，或者撕毁。", isShow: _isShow);
                            return;
                          }

                          _sheriffPlayer.isLive = false;
                          _sheriffPlayer.isDestroySheriff = false;
                          _sheriffPlayer.isTransferSheriff = true;

                          /// 添加一个新的警长
                          /// 新警长必须是活的
                          _sheriff.add(SheriffAction(
                            sheriffPlayer: _sheriffPlayer.transferSheriffPlayer!,
                          ));
                          _sheriff.save();
                          // widget.state.saveAction();
                          widget.finishCallback();
                        }),
                    child: const Text("确认转交警徽"))),
          ]),
      ],
    );
  }
}

/// 玩家主动技能发动界面
class _PlayerActiveSkillWidget extends StatefulWidget {
  final DayFactory _dayFactory;

  /// 技能结束回调
  final Function() finishCallback;

  const _PlayerActiveSkillWidget(this._dayFactory, {required this.finishCallback});

  @override
  State<_PlayerActiveSkillWidget> createState() => _PlayerActiveSkillWidgetState();
}

class _PlayerActiveSkillWidgetState extends State<_PlayerActiveSkillWidget> {
  DayFactory get _dayFactory => widget._dayFactory;

  List<Role> get activeSkillRoles => _dayFactory.activeSkillRoles();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        title("玩家主动技能"),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            /// 由于获取时已经判断过，这里做多余的判断
            var helper = _dayFactory.getWidgetHelper(activeSkillRoles[index]);
            // 这里需要在角色发动技能后，进行一个判断，判断该角色是否导致阵亡，并且是否需要发动该角色的特定技能
            List<int> skills = helper.dieForDayActiveSkill();
            var activeWidget = helper.activeSkillWidget(updateCallback: () => widget.finishCallback())!;
            if (skills.isEmpty) {
              return activeWidget;
            } else {
              return Column(
                children: [
                  activeWidget,
                  _outPlayerMotorSkill(
                    _dayFactory,
                    skills.map((e) => _dayFactory.playerDetails.get(e)).toList(),
                    widget.finishCallback,
                    () {},
                  ),
                ],
              );
            }
          },
          separatorBuilder: (context, index) => const SizedBox(),
          itemCount: activeSkillRoles.length,
        ),
      ],
    );
  }
}

/// 白天投票组件
class _voteOutWidget extends StatefulWidget {
  final _GameDayViewState state;
  final Function() finishCallback;

  const _voteOutWidget(this.state, this.finishCallback);

  @override
  State<_voteOutWidget> createState() => _voteOutWidgetState();
}

class _voteOutWidgetState extends State<_voteOutWidget> {
  DayAction get _action => widget.state._dayFactory.dayAction;

  IsShowState get _isShow => widget.state._isShow;

  DayFactory get _dayFactory => widget.state._dayFactory;

  var _defaultSelect = 0;

  /// 当前警长是否被透出
  /// 投票结束后，如果被投票的玩家和当前警长一致，需要移交警徽流
  bool get isSheriffKill =>
      _action.isYesVotePlayer &&
      (_action.votePlayer ?? 0) > 0 &&
      _dayFactory.sheriff.last.sheriffPlayer == _action.votePlayer;

  bool get isCanContinue => _dayFactory.isCanContinueAction();

  @override
  void initState() {
    super.initState();
    _defaultSelect = _action.votePlayer ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    if (!isCanContinue && !_action.isYesVotePlayer) {
      return _isNoVoteOutPlayerAndNotContinueWidget();
    }
    return Column(
      children: [
        RichText(
          text: TextSpan(
            style: app.baseFont,
            children: [
              const TextSpan(text: "根据投票结果，选择玩家"),
              const WidgetSpan(child: SizedBox(width: 8)),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: PlayerSingleSelectButton.initConfig(
                  config: SelectConfig(
                    selectable: !_action.isYesVotePlayer,
                    selectableList: widget.state._whiteDayEntity.getLivePlayerIds(),
                    defaultSelect: _defaultSelect,
                    callback: (t) => _defaultSelect = t,
                  ),
                ),
              ),
              const WidgetSpan(child: SizedBox(width: 8)),
              const TextSpan(text: "投票出局？"),
            ],
          ),
        ),
        if (!_action.isYesVotePlayer)
          Row(
            children: [
              const Expanded(child: SizedBox()),
              Expanded(
                child: TextButton(
                  onPressed: () => _yesResult(),
                  child: const Text("确认玩家出局"),
                ),
              ),
            ],
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text("玩家 P${_action.votePlayer} 被玩家们投票出局"),
          ),
        // 判断是否显示警徽流
        if (isSheriffKill)
          _sheriffKillWidget(
            _dayFactory,
            "被投票出局",
            sheriffAction: _dayFactory.sheriff.last,
            // 确认结果后
            () {},
          ),
      ],
    );
  }

  /// 还未选出投票出局玩家时，狼人自爆导致无法继续投票
  Widget _isNoVoteOutPlayerAndNotContinueWidget() {
    return const Text("由于本回合狼人自爆，而且还未选择投票出局的玩家，所以投票无法继续");
  }

  void _yesResult() {
    // 需要先判断警长行为
    if (!_dayFactory.sheriff.isYesSheriffPlayer && _dayFactory.isCanSheriffRace()) {
      showSnackBarMessage("请先确认警长选举结果", isShow: _isShow);
      return;
    }

    if ((_defaultSelect) <= 0) {
      showSnackBarMessage("还未选择玩家", isShow: _isShow);
      return;
    }

    _action.playerStateMap.set(_defaultSelect, PlayerStateType.isYesVotePlayer);
    _action.isYesVotePlayer = true;

    /// 保存这个修改
    _action.save();
    widget.finishCallback();
    setState(() {});
  }
}
