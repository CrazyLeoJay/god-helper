import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/RoleActions.dart';
import 'package:god_helper/exceptions.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/DayFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/view/ui_pad/playview/Theme.dart';

class PlayDayView extends StatefulWidget {
  final DayFactory _factory;

  // 转到下一回合回调
  final Function(int nextRound) finishToNextRoundCallback;

  // 游戏结束回调
  final Function() finishToSummaryGameCallback;
  final Function()? reloadPlayerMainView;

  const PlayDayView(
    this._factory, {
    super.key,
    required this.finishToNextRoundCallback,
    required this.finishToSummaryGameCallback,
    this.reloadPlayerMainView,
  });

  @override
  State<PlayDayView> createState() => _PlayDayViewState();
}

class _PlayDayViewState extends State<PlayDayView> {
  DayFactory get _factory => widget._factory;

  Map<DayFlow, _PlayerDayFlowKey> get _menus => {
        DayFlow.sheriffSelect: _PlayerDayFlowKey(
          "警长竞选(第一天)",
          child: _PlayerDayPoliceFlow(
            _factory,
            finishToNextFlow: _checkToNextFlow,
          ),
        ),
        DayFlow.lastNightState: _PlayerDayFlowKey(
          "昨晚倒牌玩家技能发动",
          child: _PlayerDayDieSkillFlow(
            _factory,
            players: _factory.getBeforeVoteOutPlayers(),
            title: "昨晚倒牌玩家技能发动",
            loadLastSheriff: true,
            finishToNextFlow: _checkToNextFlow,
          ),
        ),
        DayFlow.freeTalk: _PlayerDayFlowKey("自由发言",
            child: _PlayerDayFreeTalkFlow(
              _factory,
              finishToNextFlow: _checkToNextFlow,
            )),
        DayFlow.vote: _PlayerDayFlowKey("投票环节",
            child: _PlayerDayVoteFlow(
              _factory,
              finishToNextFlow: _checkToNextFlow,
            )),
        DayFlow.outPlayerSkill: _PlayerDayFlowKey(
          "出局玩家技能发动",
          child: _PlayerDayDieSkillFlow(
            _factory,
            players: _factory.getAfterVoteOutPlayers(),
            title: "出局玩家技能发动",
            finishToNextFlow: _checkToNextFlow,
          ),
        ),
        DayFlow.allFinish: _PlayerDayFlowKey(
          "所有流程都已结束",
          child: Center(
            child: Text(
              "所有流程都已结束，点击下方结束白天环节。\n上帝可以宣布：天黑了请闭眼。",
              style: theme.subTitleStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      };

  /// 出局玩家
  List<Player> get _outPlayer => _factory.getLastRoundOutPlayers();

  /// 上局玩家行为
  Map<int, PlayerStates> get _statePlayers => _factory.getLastRound().getHasStatePlayers();

  DayFlowHelper get _flowHelper => _factory.flowHelper;

  /// 用户点击的Flow流程
  final _userSelectFlow = ValueNotifier(DayFlow.none);

  @override
  void initState() {
    super.initState();
    _flowHelper.checkFlowState();
    if (_userSelectFlow.value == DayFlow.none) {
      _userSelectFlow.value = _flowHelper.nowFlow.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    double titleWidth = 300;
    return Column(
      children: [
        // 标题区
        Material(
          elevation: 3,
          child: _buildTitleMenuWidget(titleWidth),
        ),
        const Divider(height: 1),
        // 功能区
        Expanded(
          child: Row(
            children: [
              // 昨晚情况，固定在界面左边中段
              SizedBox(
                width: titleWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("昨晚情况", style: theme.secondTitleStyle),
                    Text("（竞选警长后公布）", style: theme.thirdTitleStyle),
                    Expanded(child: _buildLastNightWidget()),
                  ],
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _userSelectFlow,
                  builder: (context, select, child) {
                    Widget? menuWidget = _menus[select]?.child;
                    return menuWidget ?? const Center(child: Text("请选择流程"));
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        _buildBottomButtonWidget(),
      ],
    );
  }

  /// 昨晚情况
  Widget _buildLastNightWidget() {
    var keys = _statePlayers.keys.toList(growable: false)..sort();
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8 * 2),
        child: Column(
          children: [
            const Divider(height: 8 * 4),
            Row(children: [Text("昨晚倒牌玩家", style: theme.thirdTitleStyle)]),
            Row(
              children: [
                _outPlayer.isNotEmpty
                    ? Expanded(
                        child: AutoGridView(
                        data: _outPlayer,
                        itemBuilder: (t) {
                          return Center(child: Circle(child: Text("P${t.number}")));
                        },
                      ))
                    : const Center(child: Text("无")),
              ],
            ),
            const Divider(height: 8 * 4),
            Row(children: [Text("角色行为", style: theme.thirdTitleStyle)]),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var playerState = _statePlayers[keys[index]]!;
                var player = _factory.details.getNullable(keys[index])!;
                var showStr = playerState.stateShowStr();
                return Column(
                  children: [
                    Row(children: [
                      // Text("${player.number}号玩家 角色 ${player.role.desc.name}"),
                      RichText(
                        text: TextSpan(
                          style: theme.fourthTitleStyle,
                          children: [
                            TextSpan(text: "${player.number}号玩家 角色"),
                            TextSpan(
                              text: player.role.roleName,
                              style: theme.fourthTitleStyle.copyWith(
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
                        itemBuilder: (context, index) => Text("- ${showStr[index]}", style: theme.contentStyle),
                        separatorBuilder: (context, index) => const SizedBox(),
                        itemCount: showStr.length,
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(),
              itemCount: keys.length,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomButtonWidget(
    String text, {
    Function()? onTap,
    Color color = Colors.green,
  }) {
    var lightChanged = ValueNotifier(false);
    return SizedBox(
      height: 45,
      child: InkWell(
        splashColor: color,
        highlightColor: color,
        onTap: () => onTap?.call(),
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: lightChanged,
            builder: (context, value, child) {
              return Text(
                text,
                style: theme.contentStyle.copyWith(
                  color: lightChanged.value ? Colors.white : Colors.black,
                ),
              );
            },
          ),
        ),
        onHighlightChanged: (value) => lightChanged.value = value,
      ),
    );
  }

  /// 生成菜单选项
  Widget _buildTitleMenuWidget(double titleWidth) {
    double h = 60;
    var menuItems = _flowHelper.nowFlowMenuItems();
    Widget line(bool isSelect) => Container(height: 4, color: isSelect ? Colors.green : null);
    return AnimatedBuilder(
      animation: Listenable.merge([_userSelectFlow, _flowHelper.nowFlow]),
      builder: (context, _) {
        var flow = _flowHelper.nowFlow.value;
        var select = _userSelectFlow.value;
        return Row(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: titleWidth,
              padding: const EdgeInsets.symmetric(horizontal: 8 * 4),
              child: Center(
                child: Text("第 ${RoundHelper(_factory.round).dayStr}", style: theme.titleStyle),
              ),
            ),
            Container(width: 1, color: Colors.black),
            // 流程模块
            Expanded(
              child: Ink(
                height: h,
                color: Colors.orangeAccent.withOpacity(0.2),
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var item = menuItems[index];
                    return Ink(
                      width: 240,
                      // color: flow == item ? Colors.green : null,
                      child: InkWell(
                        onTap: () {
                          _userSelectFlow.value = item;
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Container(
                                constraints: const BoxConstraints(minWidth: 280),
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8 * 2),
                                child: Center(
                                  // child: Text(menuItems[index].flowDesc, style: theme.contentStyle),
                                  child: RichText(
                                    text: TextSpan(
                                      style: theme.contentStyle,
                                      children: [
                                        TextSpan(text: menuItems[index].flowDesc),
                                        if (_flowHelper.nowFlow.value == item) const TextSpan(text: "（当前进度）"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            line(select == item),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const VerticalDivider(width: 1),
                  itemCount: menuItems.length,
                ),
              ),
            ),
            const VerticalDivider(width: 1, color: Colors.black, thickness: 8),
            Ink(
              width: 240,
              height: h,
              // padding: const EdgeInsets.all(8),
              color: flow == DayFlow.outPlayerSkill ? Colors.red : null,
              child: InkWell(
                onTap: () {
                  _userSelectFlow.value = DayFlow.outPlayerSkill;
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: RichText(
                          text: TextSpan(style: theme.contentStyle, children: [
                            const TextSpan(text: "出局情况处理"),
                            if (_flowHelper.nowFlow.value == DayFlow.outPlayerSkill) const TextSpan(text: "（当前进度）"),
                          ]),
                        ),
                      ),
                    ),
                    line(select == DayFlow.outPlayerSkill),
                  ],
                ),
              ),
            ),
            Ink(
              // width: 120,
              height: h,
              // padding: const EdgeInsets.all(8),
              color: flow == DayFlow.outPlayerSkill ? Colors.red : null,
              child: InkWell(
                onTap: () {
                  _userSelectFlow.value = _flowHelper.nowFlow.value;
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8 * 2),
                  child: const Center(child: Icon(Icons.refresh)),
                ),
              ),
            ),
            if (kDebugMode)
              // 清除当前回合数据
              Ink(
                height: h,
                child: InkWell(
                  onTap: () {
                    if (_factory.roundHelper.day == 1 && _factory.sheriff.isShowSheriffSelect()) {
                      _factory.sheriff.sheriffTools.clear();
                    }
                    _factory.clearNoSqlData();
                    widget.reloadPlayerMainView?.call();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8 * 2),
                    child: const Center(child: Icon(Icons.delete)),
                  ),
                ),
              )
          ],
        );
      },
    );
  }

  /// 检查并去下一个环节
  _checkToNextFlow() {
    widget._factory.flowHelper.checkFlowState();
    _userSelectFlow.value = _flowHelper.nowFlow.value;
    if (kDebugMode) print("检查后flow=${_userSelectFlow.value}");
  }

  Widget _buildBottomButtonWidget() {
    if (_factory.factory.summary.isGameOver()) {
      return _bottomButtonWidget(
        "下一回合",
        onTap: () => widget.finishToNextRoundCallback(_factory.round + 1),
      );
    } else {
      return Column(
        children: [
          _bottomButtonWidget(
            "狼人自爆",
            color: Colors.red,
            onTap: () {},
          ),
          const Divider(height: 1),
          _bottomButtonWidget(
            "结束白天环节",
            onTap: () async {
              try {
                await _factory.recordThisRoundAndToNext(
                  context,
                  finishToSummaryGameCallback: widget.finishToSummaryGameCallback,
                  finishToNextRoundCallback: widget.finishToNextRoundCallback,
                );
              } on AppException catch (e, s) {
                showSnackBarMessage(e.error.err, isShow: _factory.isShow);
              }
            },
          ),
        ],
      );
    }
  }
}

class _PlayerDayFlowKey {
  final String name;
  final Widget child;

  _PlayerDayFlowKey(this.name, {required this.child});
}

class _ToNextButton extends StatelessWidget {
  final Function() finishToNextFlow;

  const _ToNextButton({required this.finishToNextFlow});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: finishToNextFlow,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.black12.withOpacity(0.05)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8 * 10),
        child: Text("开始下一个环节", style: context.theme.contentStyle.copyToClick()),
      ),
    );
  }
}

/// 游戏白天 警徽流程
class _PlayerDayPoliceFlow extends StatefulWidget {
  final DayFactory _factory;
  final Function() finishToNextFlow;

  const _PlayerDayPoliceFlow(
    this._factory, {
    required this.finishToNextFlow,
  });

  @override
  State<_PlayerDayPoliceFlow> createState() => _PlayerDayPoliceFlowState();
}

class _PlayerDayPoliceFlowState extends State<_PlayerDayPoliceFlow> {
  PlayerDetail get _playerDetail => widget._factory.details;

  SheriffHelper get _sheriff => widget._factory.sheriff;

  final _isShow = IsShowState();

  bool get _isYes => _sheriff.isYesSheriffPlayer;

  int selectPlayer = 0;

  @override
  void initState() {
    super.initState();
    selectPlayer = _sheriff.firstSheriffPlayer ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("警长流程", style: context.theme.titleStyle),
        const SizedBox(height: 8 * 2),
        Center(
          child: RichText(
            text: TextSpan(
              style: theme.secondTitleStyle,
              children: [
                const TextSpan(text: "玩家们选举警长"),
                const WidgetSpan(child: SizedBox(width: 8)),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: PlayerSingleSelectButton.initConfig(
                    config: SelectConfig.forCount(
                      count: _playerDetail.count,
                      selectable: !_isYes,
                      defaultSelect: selectPlayer,
                      callback: (t) => setState(() => selectPlayer = t),
                    ),
                  ),
                ),
                const WidgetSpan(child: SizedBox(width: 8)),
                const TextSpan(text: "为警长"),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8 * 2),
        // 确认按钮
        if ((selectPlayer) > 0) _buildYesPlayerWidget(),

        if (_isYes) _ToNextButton(finishToNextFlow: widget.finishToNextFlow),
      ],
    );
  }

  Widget _buildYesPlayerWidget() {
    return !_isYes
        ? Center(
            child: TextButton(
              onPressed: () {
                if ((selectPlayer) <= 0) {
                  showSnackBarMessage("还未选择玩家", isShow: _isShow);
                  return;
                }
                var round = widget._factory.round;
                // 这里需要判断选择的警长在昨天晚上是否已经阵亡
                var process = widget._factory.getLastRound();
                var playerState = process.playerStateMap.get(selectPlayer);

                /// 警徽设置
                _sheriff.first.init(
                  selectPlayer,
                  round,
                  // 设置玩家存活状态
                  isLive: !playerState.isDead,
                );
                // 已经设置结束标志
                _sheriff.setYesSheriffPlayer(round);
                // 保存这个结果
                _sheriff.save();
                // 跟新这个组件并通知
                setState(() {
                  // widget.affirmSelectCallback();
                });
              },
              child: const Text("确认选择该玩家"),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text("选择玩家 P${_sheriff.firstSheriffPlayer} 为警长", style: theme.contentStyle),
          );
  }
}

/// 游戏白天 昨晚死亡玩家技能行为
class _PlayerDayDieSkillFlow extends StatelessWidget {
  final DayFactory _factory;
  final List<Player> players;
  final String title;

  /// 是否加载上一回合阵亡情况
  final bool loadLastSheriff;
  final Function() finishToNextFlow;

  _PlayerDayDieSkillFlow(
    this._factory, {
    required this.players,
    required this.title,
    this.loadLastSheriff = false,
    required this.finishToNextFlow,
  }) {
    dieHelper = _PlayerDayDieHelper(_factory, players);
    skillViews = dieHelper.getSkillViews();
  }

  late _PlayerDayDieHelper dieHelper;
  late List<Widget> skillViews;

  final ValueNotifier<bool> _valueNextButtonShow = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) {
      // return const Center(child: Text("没有玩家出局"));
      return Column(
        children: [
          const Expanded(child: Center(child: Text("没有玩家出局"))),
          const Divider(height: 0),
          ValueListenableBuilder(
            valueListenable: _valueNextButtonShow,
            builder: (context, value, child) {
              return _buildButtonWidget(context);
            },
          ),
        ],
      );
    } else {
      double split = 8 * 3;
      double retract = 8 * 2;
      Color titleColor = Colors.orange;
      var subTitle = context.theme.secondTitleStyle.copyWith(color: titleColor);
      List<Widget> sv = dieHelper.getSkillViews();
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8 * 2),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: context.theme.titleStyle),
                    Text("（提示：根据实际情况操作面板。先发动技能，后移交警徽）", style: context.theme.secondTitleStyle),
                    const SizedBox(height: 8),
                    _buildOutWidget(context, subTitle),
                    Divider(height: split),
                    Row(children: [Text("出局玩家技能：", style: subTitle)]),
                    Padding(padding: EdgeInsets.symmetric(horizontal: retract), child: _buildSkillView(context, sv)),
                    Divider(height: split),
                    Row(children: [Text("警徽处理：", style: subTitle)]),
                    Padding(padding: EdgeInsets.symmetric(horizontal: retract), child: _sheriffOptionView(context, sv)),
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          ValueListenableBuilder(
            valueListenable: _valueNextButtonShow,
            builder: (context, value, child) {
              return _buildButtonWidget(context);
            },
          ),
        ],
      );
    }
  }

  Widget _buildOutWidget(BuildContext context, TextStyle subTitle) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(children: [
          Text("出局玩家：", style: subTitle),
          const SizedBox(width: 8),
          SizedBox(
            height: 45,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Circle(child: Text("P${players[index].number}")),
              separatorBuilder: (context, index) => const SizedBox(),
              itemCount: players.length,
            ),
          )
        ]),
      ],
    );
  }

  /// 拥有技能的玩家发动技能
  Widget _buildSkillView(BuildContext context, List<Widget> sv) {
    if (sv.isEmpty) {
      return Row(children: [Text("没有需要发动技能的出局玩家", style: context.theme.secondTitleStyle)]);
    } else {
      return ListView.separated(
        itemBuilder: (context, index) => sv[index],
        separatorBuilder: (context, index) => const SizedBox(),
        itemCount: sv.length,
      );
    }
  }

  /// 警徽操作
  Widget _sheriffOptionView(BuildContext context, List<Widget> sv) {
    if (sv.isNotEmpty) {
      if (!dieHelper.isAllHasSkillPlayerActionFinish()) return const Text("先完成出局玩家技能动作");
    }

    // 如果警长存在，且警长被出局了，则需要展示
    if (loadLastSheriff && _factory.sheriff.sheriffIsDieForLastDay()) {
      // 对局开始前，警徽情况。
      var sheriffAction = _factory.getLastDaySheriff();
      return _sheriffKillWidget(
        _factory,
        "出局",
        sheriffAction: sheriffAction,
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildButtonWidget(BuildContext context) {
    if (_factory.dayAction.isYesLastStateFlow) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: _ToNextButton(finishToNextFlow: finishToNextFlow),
      );
    } else {
      return Ink(
        height: 45,
        child: InkWell(
          onTap: () {
            if (players.isNotEmpty) {
              /// 判断出局角色是否都已经操作
              for (var player in players) {
                var roleAction = _factory.getRoleAction(player.role);
                if (roleAction == null) continue;
                if (!(roleAction.isYes)) {
                  context.showSnackBarMessage(
                    "出局角色(${player.role.nickname}/P${player.number}) 还有任务没有完成",
                    isShow: _factory.isShow,
                  );
                  return;
                }
              }

              if (loadLastSheriff && _factory.sheriff.sheriffIsDieForLastDay()) {
                var lastSheriff = _factory.getLastDaySheriff()!;
                if (!lastSheriff.isTransferSheriff) {
                  context.showSnackBarMessage(
                    "警长出局，但警徽还未转移",
                    isShow: _factory.isShow,
                  );
                  return;
                }
              }
            }
            _factory.dayAction.isYesLastStateFlow = true;
            _valueNextButtonShow.value = true;
          },
          child: Center(
            child: Text("结束本回合", style: context.theme.contentStyle),
          ),
        ),
      );
    }
  }
}

class _PlayerDayDieHelper {
  final DayFactory _factory;
  final List<Player> _players;

  Function()? roleUpdateCallback;

  _PlayerDayDieHelper(this._factory, this._players, {this.roleUpdateCallback}) {
    // widgetHelper = _players.map((e) => _factory.getWidgetHelper(e.role)).toList();
    _initSkillPlayer();
  }

  final List<Player> playersForNoSkill = [];
  final List<Player> playersForHasSkill = [];

  final Map<int, Widget> _playerDayViewMap = {};

  /// 将有出局技能和无技能的角色区分
  _initSkillPlayer() {
    for (var player in _players) {
      var wf = _factory.getWidgetHelper(player.role);
      var widget = wf.getOutViewForDay(updateCallback: () => roleUpdateCallback?.call());
      if (widget == null) {
        playersForNoSkill.add(player);
      } else {
        playersForHasSkill.add(player);
        _playerDayViewMap[player.number] = widget;
      }
    }
  }

  Widget? getDayOutWidget(Player p) => _playerDayViewMap[p.number];

  /// 获取存在技能的界面
  List<Widget> getSkillViews() => playersForHasSkill.map((e) => getDayOutWidget(e)!).toList();

  /// 有技能的玩家是否都已经完成动作
  bool isAllHasSkillPlayerActionFinish() {
    for (Player e in playersForHasSkill) {
      var isFinish = _factory.getRoleAction(e.role)?.isYes ?? false;
      if (!isFinish) return false;
    }
    return true;
  }
}

/// 游戏白天 自由发言
class _PlayerDayFreeTalkFlow extends StatefulWidget {
  final DayFactory factory;
  final Function() finishToNextFlow;

  const _PlayerDayFreeTalkFlow(
    this.factory, {
    required this.finishToNextFlow,
  });

  @override
  State<_PlayerDayFreeTalkFlow> createState() => _PlayerDayFreeTalkFlowState();
}

class _PlayerDayFreeTalkFlowState extends State<_PlayerDayFreeTalkFlow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("自由发言", style: context.theme.titleStyle),
        Expanded(
          child: Center(
            child: Text(
              "进入自由发言环节",
              style: context.theme.contentStyle,
            ),
          ),
        ),
        if (!widget.factory.dayAction.isYesFreeTalkFlow)
          Ink(
            height: 45,
            child: InkWell(
              onTap: () {
                widget.factory.dayAction.isYesFreeTalkFlow = true;
                setState(() {});
              },
              child: Center(
                child: Text("结束本流程", style: context.theme.contentStyle),
              ),
            ),
          ),
        if (widget.factory.dayAction.isYesFreeTalkFlow)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _ToNextButton(finishToNextFlow: widget.finishToNextFlow),
          ),
      ],
    );
  }
}

/// 游戏白天 投票环节
class _PlayerDayVoteFlow extends StatefulWidget {
  final DayFactory _factory;
  final Function() finishToNextFlow;

  const _PlayerDayVoteFlow(this._factory, {required this.finishToNextFlow});

  @override
  State<_PlayerDayVoteFlow> createState() => _PlayerDayVoteFlowState();
}

class _PlayerDayVoteFlowState extends State<_PlayerDayVoteFlow> {
  DayAction get _action => widget._factory.dayAction;

  DayFactory get _dayFactory => widget._factory;

  DayFlowHelper get _flowHelper => _dayFactory.flowHelper;

  final IsShowState _isShow = IsShowState();

  var _defaultSelect = 0;

  /// 当前警长是否被透出
  /// 投票结束后，如果被投票的玩家和当前警长一致，需要移交警徽流
  ///
  /// 这里需要获取到本局的当前警长
  /// - 获取上一个白天的警长
  /// - 判断警长是否换过，如果换过，则获取到换之后的警长。即当前警长
  /// - 判断当前警长是否阵亡
  // bool get isSheriffKill =>
  //     _action.isYesVotePlayer &&
  //     (_action.votePlayer ?? 0) > 0 &&
  //     widget._factory.sheriff.last.sheriffPlayer == _action.votePlayer;
  bool get isSheriffKill => !nowSheriffIsKill;

  bool get nowSheriffIsKill => _dayFactory.sheriff.getSheriffForAfterVote()?.isLive ?? true;

  bool get isCanContinue => widget._factory.isCanContinueAction();

  List<Player> get livePlayers => widget._factory.getNowLivePlayer();

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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("白天投票环节", style: context.theme.titleStyle),

                // 投票组件
                _buildVoteWidget(),
                const Divider(height: 8 * 2),

                // 出局玩家技能组件
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _buildOutSkillWidget(),
                ),

                // 警长被投出处理
                _buildSherifWidget(),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
        // 结束按钮
        _buildFinishButtonWidget(),
      ],
    );
  }

  /// 还未选出投票出局玩家时，狼人自爆导致无法继续投票
  Widget _isNoVoteOutPlayerAndNotContinueWidget() {
    return const Text("由于本回合狼人自爆，而且还未选择投票出局的玩家，所以投票无法继续");
  }

  void _yesResult() {
    // 需要先判断警长行为
    if (!widget._factory.sheriff.isYesSheriffPlayer && widget._factory.isCanSheriffRace()) {
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
    // widget.finishCallback();
    setState(() {});
  }

  /// 构建投票组件
  Widget _buildVoteWidget() {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            style: context.theme.contentStyle,
            children: [
              const TextSpan(text: "根据投票结果，选择玩家"),
              const WidgetSpan(child: SizedBox(width: 8)),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: PlayerSingleSelectButton.initConfig(
                  config: SelectConfig(
                    selectable: !_action.isYesVotePlayer,
                    // selectableList: widget.state._whiteDayEntity.getLivePlayerIds(),
                    selectableList: livePlayers.map((e) => e.number).toList(),
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
          TextButton(onPressed: () => _yesResult(), child: const Text("确认玩家出局"))
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text("玩家 P${_action.votePlayer} 被玩家们投票出局"),
          ),
      ],
    );
  }

  /// 构建出局玩家技能处理
  Widget _buildOutSkillWidget() {
    if (!_dayFactory.dayAction.isYesVotePlayer) {
      // 若还未投票，则不存在技能界面等
      return Container();
    }

    var outPlayers = _dayFactory.getAfterVoteOutPlayers();
    var dieHelper = _PlayerDayDieHelper(
      _dayFactory,
      outPlayers,
      roleUpdateCallback: () {
        setState(() {});
      },
    );
    var skillViews = dieHelper.getSkillViews();
    if (skillViews.isEmpty) return const SizedBox();

    return Column(
      children: [
        Row(children: [Text("出局玩家技能发动", style: theme.titleStyle)]),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8 * 2),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => skillViews[index],
            separatorBuilder: (context, index) => const SizedBox(),
            itemCount: skillViews.length,
          ),
        ),
      ],
    );
  }

  /// 警长被投票出局选项
  Widget _buildSherifWidget() {
    // 判断是否显示警徽流
    if (isSheriffKill) {
      var sheriffAction = _dayFactory.sheriff.getSheriffForAfterVote();

      return _sheriffKillWidget(
        widget._factory,
        "被投票出局",
        sheriffAction: sheriffAction,
      );
    } else {
      return const SizedBox();
    }
  }

  /// 结束按钮组件
  Widget _buildFinishButtonWidget() {
    return Column(
      children: [
        if (!_dayFactory.dayAction.isYesVoteFlow)
          Ink(
            height: 45,
            child: InkWell(
              onTap: _buttonFinishThisFlow,
              child: Center(
                child: Text("结束本流程", style: context.theme.contentStyle),
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _ToNextButton(finishToNextFlow: widget.finishToNextFlow),
          ),
      ],
    );
  }

  /// 按钮 结束本流程
  ///
  void _buttonFinishThisFlow() {
    if (!_dayFactory.dayAction.isYesVotePlayer) {
      showSnackBarMessage("还未进行投票", isShow: _dayFactory.isShow);
      return;
    }

    int votePlayer = _dayFactory.dayAction.votePlayer!;
    var role = _dayFactory.details.get(votePlayer).role;
    var roleAction = _dayFactory.getRoleAction(role);
    if (null != roleAction && !roleAction.isYes) {
      showSnackBarMessage("角色 ${role.roleName} 被投票出局后，还有技能没有释放", isShow: _dayFactory.isShow);
      return;
    }

    var outPlayers = _dayFactory.getAfterVoteOutPlayers();
    for (var value in outPlayers) {
      if (value.number == votePlayer) continue;
      var roleAction = _dayFactory.getRoleAction(value.role);
      if (null != roleAction && !roleAction.isYes) {
        showSnackBarMessage("角色 ${value.role.roleName} 出局，还有技能没有释放", isShow: _dayFactory.isShow);
        return;
      }
    }

    if (isSheriffKill) {
      if (!_dayFactory.sheriff.getSheriffForAfterVote()!.isTransferSheriff) {
        showSnackBarMessage("警长还未转移警徽", isShow: _dayFactory.isShow);
        return;
      }
    }

    _dayFactory.dayAction.isYesVoteFlow = true;
    setState(() {});
  }
}

/// 警长被杀处理
class _sheriffKillWidget extends StatefulWidget {
  final DayFactory _dayFactory;

  /// 死亡描述
  final String killDesc;

  /// 如果没有指定特定的警长活动，则表示需要去寻找最新的阵亡数据去处理
  final SheriffAction? sheriffAction;
  final Function()? finishCallback;

  const _sheriffKillWidget(this._dayFactory, this.killDesc, {this.sheriffAction, this.finishCallback});

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
        // Row(children: [Text("警长 ${widget.killDesc}", style: theme.secondTitleStyle)]),
        Row(children: [Text("P${_player.number}号玩家 警长 ${widget.killDesc}", style: theme.secondTitleStyle)]),
        (_sheriffPlayer.isDestroySheriff && _sheriffPlayer.isTransferSheriff)
            ? const Row(children: [Text("警徽已被该玩家撕毁撕毁")])
            : RichText(
                text: TextSpan(
                  style: theme.contentStyle,
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
        const SizedBox(height: 8 * 2),
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
                    child: Text("撕毁警徽", style: theme.contentStyle))),
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
                    settingRound: widget._dayFactory.round,
                  ));
                  _sheriff.save();
                  widget.finishCallback?.call();
                }),
                child: Text("确认转交警徽", style: theme.contentStyle),
              ),
            ),
          ]),
        const SizedBox(height: 8 * 2),
      ],
    );
  }
}
