import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';

/// 游戏一个回合的总结弹窗内容
class AppGameRoundSummaryDialogContentWidget extends StatelessWidget {
  final _circleSize = 45.0;
  final RoundFactory roundFactory;
  final RoundProcess process;
  final PlayerDetail playerDetail;

  const AppGameRoundSummaryDialogContentWidget(this.roundFactory, this.process, this.playerDetail, {super.key});

  GameFactory get factory => roundFactory.factory;

  int get round => roundFactory.round;

  List<int> get _wolfNumber => playerDetail.getWolfNumbers();

  List<int> get _citizenNumber => playerDetail.getCitizenNumber();

  Map<Role, int> get _rolePlayerMap => playerDetail.getHasPowerRoleNumber();

  List<Role> get _rpMapKey => _rolePlayerMap.keys.toList()..sort();

  List<int> get _killPlayer => process.outPlayerNumbers;

  Map<int, PlayerStates> get _playerState => process.getHasStatePlayers();

  SummaryHelper get resultSummary => factory.summary;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        // _playerDetailMessageWidget(context),
        _playerSimpleMessageWidget(context),
        const SizedBox(height: 8 * 2),
        Text("当前回合判定：${resultSummary.result()}"),
        const SizedBox(height: 8),
        Container(
          width: double.maxFinite,
          alignment: Alignment.centerLeft,
          child: Text(
            "本回合",
            style: context.app.baseFont.copyWith(fontSize: 18),
          ),
        ),
        const SizedBox(height: 8),
        _roleLineShowWidget("阵亡", _killPlayer),
        const SizedBox(height: 8),
        _playerActionWidget(),
        const SizedBox(height: 8),
        // const SizedBox(height: 8),
      ],
    );
  }

  Widget _playerDetailMessageWidget(BuildContext context) => Column(
        children: [
          _roleLineShowWidget("狼人", _wolfNumber),
          const SizedBox(height: 8),
          _roleLineShowWidget("村民", _citizenNumber),
          const SizedBox(height: 8 * 2),
          Container(
            width: double.maxFinite,
            alignment: Alignment.centerLeft,
            child: Text(
              "身份角色",
              style: context.app.baseFont.copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(height: 8),
          _hasPowerRolePlayerWidget(),
        ],
      );

  Widget _playerSimpleMessageWidget(BuildContext context) {
    var _circleSize = this._circleSize + 5;
    var players = playerDetail.players;
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      children: List.generate(
        players.length,
        (index) {
          var player = players[index];
          // if (kDebugMode) {
          //   print(" ${jsonEncode(player)}");
          // }
          var textColor = player.live ? Colors.black : Colors.white;
          return Center(
            child: Circle(
              circleSize: _circleSize,
              color: player.live ? null : Colors.red,
              child: Column(
                children: [
                  const Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        "P${player.number}",
                        style: context.app.baseFont.copyWith(
                          fontSize: _circleSize / 3.5,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      player.role.desc.name,
                      style: context.app.baseFont.copyWith(
                        fontSize: _circleSize / 6,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _roleLineShowWidget(String name, List<int> values) => SizedBox(
        height: _circleSize,
        child: Row(
          children: [
            Expanded(flex: 0, child: Text("$name : ")),
            Expanded(
              flex: 1,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) => _circleWidget(
                  Text(
                    "P${values[index]}",
                    style: context.app.baseFont.copyWith(
                      color: _killPlayer.contains(values[index]) ? Colors.red : Colors.black,
                      fontSize: _circleSize / 2.75,
                    ),
                  ),
                ),
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemCount: values.length,
              ),
            )
          ],
        ),
      );

  Widget _circleWidget(Widget child) => Center(child: Circle(circleSize: _circleSize, child: child));

  /// 有能力角色和玩家对应关系
  Widget _hasPowerRolePlayerWidget() => LayoutBuilder(
        builder: (context, constraints) => Wrap(
          spacing: 10.0,
          runSpacing: 8.0,
          crossAxisAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.start,
          children: List.generate(
            _rpMapKey.length,
            (index) {
              var playerIndex = _rolePlayerMap[_rpMapKey[index]];
              return SizedBox(
                height: _circleSize + 1,
                width: constraints.maxWidth / 2 - 6,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Center(child: Text("${_rpMapKey[index].desc.name} : ")),
                    // const SizedBox(width: 8),
                    _circleWidget(Text("P$playerIndex",
                        style: context.app.baseFont
                            .copyWith(color: _killPlayer.contains(playerIndex) ? Colors.red : Colors.black))),
                  ],
                ),
              );
            },
          ),
        ),
      );

  Widget _playerActionWidget() {
    var keys = _playerState.keys.toList()..sort();
    print('_playerActionWidget $keys');
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              Container(
                alignment: AlignmentDirectional.centerStart,
                child: Text("玩家 P${keys[index]} ${playerDetail.getNullable(keys[index])!.role.desc.name}: "),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, j) => Text("- ${_playerState[keys[index]]!.stateShowStr()[j]}"),
                  separatorBuilder: (context, j) => const SizedBox(height: 0),
                  itemCount: _playerState[keys[index]]!.stateShowStr().length,
                ),
              )
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemCount: keys.length,
    );
  }
}
