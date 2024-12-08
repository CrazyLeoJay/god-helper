import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/RoleActions.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';

/// 游戏进度界面
class GameProcessesView extends StatefulWidget {
  final GameFactory factory;

  const GameProcessesView(this.factory, {super.key});

  @override
  State<GameProcessesView> createState() => _GameProcessesViewState();
}

class _GameProcessesViewState extends State<GameProcessesView> {
  GameFactory get _factory => widget.factory;

  PlayerDetail get _playerDetail => _factory.players.details;

  SheriffTools get sheriff => _factory.other.sheriffTools;

  TextStyle get _titleStyle => app.baseFont.copyWith(fontSize: 20);

  List<RoundProcess> get _processes => _factory.getProcesses();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("游戏进程"),
        actions: [
          IconButton(
            onPressed: () {
              if (kDebugMode) {
                print("object ${jsonEncode(_factory.other.maxRound)}");
              }
            },
            icon: const Icon(Icons.print),
          ),
          if (kDebugMode)
            IconButton(
              onPressed: () {
                _factory.clearNoSqlData();
              },
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: ListView(
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("玩家状态：", style: _titleStyle),
            )
          ]),
          _playersStateWidget(),
          const SizedBox(height: 16),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("游戏结算：${_factory.summary.result()}"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("游戏进程：", style: _titleStyle),
            )
          ]),
          _processItemWidget(context),
        ],
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: TextButton(onPressed: () {}, child: const Text("继续游戏")),
      // ),
      // drawer: Drawer(child: Text("test"),),
    );
  }

  /// 玩家状态组件
  Widget _playersStateWidget() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          crossAxisCount: 6,
          // 宽/高
          childAspectRatio: 100 / 145,
          children: _playerGridItems(context),
        ),
      );

  /// 玩家状态列表组件生成
  List<Widget> _playerGridItems(BuildContext context) {
    var circleSize = 8.0 * 6;
    return List.generate(_playerDetail.count, (index) {
      Player player = _playerDetail.players[index];
      var textColor = player.live ? Colors.green : Colors.white;
      var tagColor = player.live ? Colors.green : Colors.red;
      var tagSize = circleSize / 6;
      return Column(
        children: [
          Expanded(
            flex: 0,
            child: Center(
              child: Text(
                sheriff.nowSheriffPlayer == player.number ? "警长" : "",
                style: app.baseFont.copyWith(fontSize: tagSize, color: tagColor),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Circle(
                circleSize: circleSize,
                color: player.live ? null : Colors.red,
                child: Text(
                  "P${player.number}",
                  style: context.defaultFont.copyWith(color: textColor, fontSize: circleSize / 3),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 0,
            child: Text(
              player.role.name,
              style: app.baseFont.copyWith(fontSize: tagSize, color: tagColor),
            ),
          ),
        ],
      );
    });
  }

  // final ScrollController _scrollController = ScrollController();
  List<bool> _isExpanded = [];

  /// 游戏进程组件
  Widget _processItemWidget(BuildContext context) {
    if (_isExpanded.length != _processes.length) {
      _isExpanded = List.generate(_processes.length, (_) => true);
    }
    return SingleChildScrollView(
      // controller: _scrollController,
      // scrollDirection: Axis.vertical,
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) => {
          setState(() {
            _isExpanded[index] = isExpanded;
          })
        },
        children: List.generate(_processes.length, (index) {
          var process = _processes[index];
          var playersState = process.getHasStatePlayers();
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: RichText(
                  text: TextSpan(
                    style: app.baseFont.copyWith(color: Colors.black),
                    children: [
                      TextSpan(text: ("第 ${process.round} 回合，第 ${RoundHelper(process.round).dayStr}   ")),
                      TextSpan(text: process.isFinish ? "已结束" : "进行中", style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                onTap: () => setState(() => _isExpanded[index] = !isExpanded),
              );
            },
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8 * 2),
              child: Column(
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  _gameProcessMessageWidget(playersState),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            isExpanded: _isExpanded[index],
            // isExpanded: true,
          );
        }),
        elevation: 3,
        materialGapSize: 8,
        expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        expandIconColor: Colors.red,
      ),
    );
  }

  /// 游戏单个回合的信息展示组件列表
  Widget _gameProcessMessageWidget(Map<int, PlayerStates> playersState) => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          List<int> keys = playersState.keys.toList()..sort();
          PlayerStates playerState = playersState[keys[index]]!;
          var number = keys[index];
          var stateList = playerState.stateShowStr();
          // if (kDebugMode) {
          //   print("Item ${jsonEncode(stateList)}");
          // }
          return Column(
            children: [
              Row(children: [Text("玩家 P$number")]),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8 * 2),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Text(stateList[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 8);
                  },
                  itemCount: stateList.length,
                ),
              )
            ],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemCount: playersState.length,
      );
}
