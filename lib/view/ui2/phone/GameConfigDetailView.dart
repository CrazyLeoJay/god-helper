import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/view/ui2/phone/GameConfigView.dart';

/// 游戏配置详情界面
class GameConfigDetailView extends StatelessWidget {
  final GameFactory factory;

  const GameConfigDetailView(this.factory);

  GameDetailEntity get _entity => factory.entity;

  GameTemplateConfigEntity get _temp => factory.entity.tempConfig;

  PlayersSaveRule get _saveRule => factory.saveRule;

  @override
  Widget build(BuildContext context) {
    TextStyle _titleStyle = context.app.baseFont.copyWith(fontSize: 20);
    return ListView(
      children: [
        Row(children: [Text("游戏配置", style: _titleStyle)]),
        const SizedBox(height: 8),
        Row(children: [Text("名称： ${_entity.name}")]),
        const SizedBox(height: 8),
        Row(children: [Text("配置： ${_temp.name}")]),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: GameConfigSelectedCard(_temp),
        ),
        const SizedBox(height: 8),
        Row(children: [Text("胜利规则：${factory.extraRule.winRule.desc}")]),
        const SizedBox(height: 8),
        Row(children: [Text("警徽规则：${factory.extraRule.getSheriffConfig().sheriffRace.desc}")]),
        const SizedBox(height: 8 * 2),
        Row(children: [Text("角色额外配置", style: _titleStyle)]),
        for (var role in factory.extraRule.keys) _getExtra(role),
        const SizedBox(height: 8 * 2),
        Row(children: [Text("保护配置", style: _titleStyle)]),
        _getSaveConfigView("首刀保护：", _saveRule.firstKillSavePlayers),
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 8),
        _getSaveConfigView("首毒保护：", _saveRule.firstPoisonSavePlayers),
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 8),
        _getSaveConfigView("首验保护：", _saveRule.firstVerifySavePlayers),
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _getExtra(Role role) {
    return Column(
      children: [
        Row(children: [
          const Text("角色："),
          Text(
            role.roleName,
            style: const TextStyle(color: Colors.green),
          )
        ]),
        _getExtraString(role)
      ],
    );
  }

  Widget _getExtraString(Role role) {
    var gen = factory.generator.extraGeneratorMap[role];
    if (null == gen) {
      return const SizedBox();
    } else {
      var msgs = gen.configResultMessage();
      if (msgs.isEmpty) return const SizedBox();
      Widget item(int index) => Row(children: [Text("- ${msgs[index]}")]);
      if (msgs.length == 1) return item(0);
      return ListView.separated(
        itemBuilder: (context, index) => item(index),
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemCount: msgs.length,
      );
    }
  }

  Widget _getSaveConfigView(String name, List<int> playerIds) {
    double size = 50;
    Widget playerCircles;
    if (playerIds.isEmpty) {
      playerCircles = const SizedBox();
    } else {
      playerCircles = LayoutBuilder(
        builder: (context, constraints) {
          int row = (constraints.maxWidth / size).toInt();
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: row,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return Center(
                child: Circle(
                  circleSize: size - 1,
                  child: Text("P${playerIds[index]}"),
                ),
              );
            },
            itemCount: playerIds.length,
          );
        },
      );
    }
    bool isToMany = playerIds.length > _temp.roleConfig.count() / 3;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 0,
            child: SizedBox(
              height: size,
              child: Center(
                child: Text(name),
              ),
            )),
        isToMany
            ? Expanded(
                child: Column(
                  children: [
                    playerCircles,
                    const SizedBox(height: 8),
                    const Text(
                      "是不是保护的人太多了？你确定能玩？",
                      style: TextStyle(color: Colors.deepOrangeAccent),
                    )
                  ],
                ),
              )
            : Expanded(child: playerCircles),
      ],
    );
  }
}
