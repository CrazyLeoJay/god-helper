import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/component/AutoShrinkSideMenu.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/view/ui_pad/playview/PlayDayView.dart';
import 'package:god_helper/view/ui_pad/playview/PlayNightView.dart';
import 'package:god_helper/view/ui_pad/playview/Theme.dart';

class PlayerView extends StatefulWidget {
  final GameFactory _gameFactory;
  final int _initRound;

  const PlayerView(this._gameFactory, this._initRound, {super.key});

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  final _selectIndexNotifier = ValueNotifier(0);

  int get _gameRound {
    if (widget._gameFactory.maxRound > 0) return widget._gameFactory.maxRound;
    return 1;
  }

  final ValueNotifier<List<ShrinkMenuItemData>> _roundMenusNotify = ValueNotifier<List<ShrinkMenuItemData>>([]);

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  @override
  Widget build(BuildContext context) {
    _loadMenu();
    return Scaffold(
      appBar: AppBar(
        title: const Text("游戏开始"),
        // backgroundColor: Colors.white,
        // elevation: 8,
        // backgroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: _roundMenusNotify,
        builder: (context, menus, child) => Row(
          children: [
            // 侧边栏，可伸缩的菜单
            AutoShrinkSideMenu(
              menuItems: menus,
              selectedIndexNotifier: _selectIndexNotifier,
              selectItemColor: context.theme.selectColor,
            ),
            // 主内容界面
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _selectIndexNotifier,
                builder: (context, value, child) {
                  return menus[value].child ??
                      const Center(
                        child: Text("还未配置界面", style: TextStyle(fontSize: 24)),
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 加载菜单
  void _loadMenu() {
    _roundMenusNotify.value = [
      ShrinkMenuItemData(
        name: "游戏流程",
        icon: const Icon(Icons.book_outlined),
        child: _PlayFlowView(widget._gameFactory),
      ),
      ...List.generate(
        _gameRound,
        (index) {
          var round = index + 1;
          var rf = RoundHelper(round);
          return ShrinkMenuItemData(
            name: rf.dayMenuStr,
            icon: rf.isNight ? const Icon(Icons.shield_moon) : const Icon(Icons.sunny),
            child: rf.isNight
                ? PlayNightView(
                    theme: theme,
                    widget._gameFactory.getNight(round),
                    finishToNextRoundCallback: _invokeNextToRound,
                    finishToSummaryGameCallback: _invokeFinishGame,
                  )
                : PlayDayView(
                    widget._gameFactory.getDay(round),
                    finishToNextRoundCallback: _invokeNextToRound,
                    finishToSummaryGameCallback: _invokeFinishGame,
                    reloadPlayerMainView: () {
                      _selectIndexNotifier.value = _gameRound;
                      if (kDebugMode) print("刷新界面");
                    },
                  ),
          );
        },
      ),
    ];
  }

  /// 去下一个回合
  void _invokeNextToRound(int nextRound) {
    if (widget._gameFactory.summary.isGameOver() && widget._gameFactory.maxRound <= nextRound) {
      _selectIndexNotifier.value = 0;
      return;
    }
    // 创建下一回合
    widget._gameFactory.getRoundFactory(nextRound);
    _loadMenu();
    _selectIndexNotifier.value++;
  }

  void _invokeFinishGame() {
    _selectIndexNotifier.value = 0;
  }
}

/// 游戏流程界面
class _PlayFlowView extends StatelessWidget {
  final GameFactory _gameFactory;

  const _PlayFlowView(this._gameFactory);

  List<Player> get _data => _gameFactory.players.details.players;

  List<RoundProcess> get _processes => _gameFactory.getProcesses();

  PlayerDetail get _playerDetail => _gameFactory.players.details;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          Text(
            "游戏进程",
            style: context.theme.titleStyle,
          ),
          Row(children: [Text("玩家角色状态", style: context.theme.secondTitleStyle)]),
          _buildPlayerMessageWidget(context),
          const Divider(height: 0),
          _buildGameFinishWidget(context),
          Expanded(child: _buildGameRoundFlowWidget(context)),
        ],
      ),
    );
  }

  /// 玩家信息展示
  Widget _buildPlayerMessageWidget(BuildContext context) {
    double size = 45.0;
    return AutoGridView(
      circleSize: size + 20,
      data: _data,
      childAspectRatio: 8 / 10,
      itemBuilder: (t) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: Circle(
                  circleSize: size,
                  color: t.live ? null : Colors.red,
                  child: Text(
                    "P${t.number}",
                    style: context.theme.contentStyle.copyWith(
                      color: t.live ? null : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Text(t.role.roleName, style: context.theme.contentStyle),
          ],
        );
      },
    );
  }

  /// 游戏结束组件
  Widget _buildGameFinishWidget(BuildContext context) {
    if (_gameFactory.summary.isGameOver()) {
      return Container(
        child: Text(
          "游戏结束：${_gameFactory.summary.result()}",
          style: context.theme.titleStyle.copyWith(color: Colors.green),
        ),
      );
    }

    return Container();
  }

  Widget _buildGameRoundFlowWidget(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var process = _processes[index];
          var statePlayers = process.getHasStatePlayers();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(height: 8 * 2, thickness: 4),
              Row(children: [Text("第 ${RoundHelper(process.round).dayStr}", style: context.theme.secondTitleStyle)]),
              const SizedBox(height: 8 * 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8 * 4),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    List<int> keys = statePlayers.keys.toList()..sort();
                    PlayerStates playerState = statePlayers[keys[index]]!;
                    var number = keys[index];
                    var stateList = playerState.stateShowStr();
                    // if (kDebugMode) {
                    //   print("Item ${jsonEncode(stateList)}");
                    // }
                    return Column(
                      children: [
                        Row(children: [
                          Text(
                            "玩家 P$number (角色：${_playerDetail.get(number).role.nickname})",
                            style: context.theme.thirdTitleStyle,
                          )
                        ]),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8 * 4),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Text("- ${stateList[index]}", style: context.theme.contentStyle);
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return const SizedBox(height: 8);
                            },
                            itemCount: stateList.length,
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemCount: statePlayers.length,
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(),
        itemCount: _processes.length,
      ),
    );
  }
}
