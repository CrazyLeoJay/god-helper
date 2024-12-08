// 游戏配置界面

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/entity/RuleConfig.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/AppFactory.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/res/app.dart';

/// 游戏配置界面
/// 这里可以选择板子，配置游戏规则、配置
class GameConfigView extends StatefulWidget {
  final GameFactory factory;

  const GameConfigView({required this.factory, super.key});

  @override
  State<GameConfigView> createState() => _GameConfigViewState();
}

class _GameConfigViewState extends State<GameConfigView> {
  GameFactory get _factory => widget.factory;

  GameDetailEntity get _entity => _factory.entity;

  GameTemplateConfigEntity get temp => _factory.entity.tempConfig;

  TempExtraRule get extraRule => _factory.extraRule;

  final ValueNotifier<bool> _isEditNotifier = ValueNotifier(false);

  final gameConfigEditController = TextEditingController(text: "");

  TextStyle get ts => defaultFont;

  // final _isShow = IsShowState();

  @override
  void initState() {
    super.initState();
    gameConfigEditController.text = _entity.name;
    // selectConfig.value = gameEntity.tempConfig;
    if (kDebugMode) print("初始化");

    gameConfigEditController.addListener(() {
      _entity.name = gameConfigEditController.text;
    });

    // _updateGameDetailNotifier.addListener(() {
    //   if (kDebugMode) print("GameDetailEntity更新了");
    //   // 更新屠城屠边规则信息
    //   wolfWinRuleWidgetState.update();
    //   // 补充规则 （widget）
    //   // 保护规则，需要重新设置？因为在多人数改为少人数时，会有可能设置的玩家消失了
    //   var count = _entity.tempConfig?.playerCount ?? 0;
    //   if (kDebugMode) print("角色数量为 $count");
    //
    //   if (count > 0) {
    //     gameSaveRuleWidgetState.update(count);
    //     if (kDebugMode) print(jsonEncode(_entity.saveRule.toJson()));
    //   }
    // });
  }

  void changeEditState() {
    _isEditNotifier.value = !_isEditNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loadAppBar(),
      body: Container(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8 * 2),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.max,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("当前配置:(点击返回从新选择)", style: ts.copyWith(fontSize: 18)),
              const SizedBox(height: 8),
              _GameConfigCard(temp),
              const SizedBox(height: 8),
              const Text("请选择板子后自动生成补充规则"),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Text("胜利条件：", style: ts.copyWith(fontSize: 18)),
              const SizedBox(height: 8),
              WinRule.createSelectView(
                defaultValue: extraRule.winRule,
                callback: (value) {
                  setState(() => extraRule.winRule = value);
                },
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Text("警长配置：", style: ts.copyWith(fontSize: 18)),
              SheriffRace.createSelectView(
                defaultValue: extraRule.getSheriffConfig().sheriffRace,
                callback: (value) {
                  setState(() => extraRule.getSheriffConfig().sheriffRace = value);
                },
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Text("补充规则：", style: ts.copyWith(fontSize: 18)),
              const SizedBox(height: 8),
              _GameExtraConfigCard(_factory),
              const SizedBox(height: 16),
              Text(
                "保护配置(${temp.playerCount} 人)：",
                style: ts.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              _GameSaveConfigView(
                this,
                temp.playerCount,
                _factory.saveRule,
                selectable: true,
                (saveRule) {
                  _factory.entity.saveRule = saveRule;
                  // _factory.saveRule.save();
                  // print("SaveB ${jsonEncode(_factory.saveRule)}");
                },
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8),
        child: TextButton(
          onPressed: () => goToPlay(context),
          child: const Text("保存并开始第一晚"),
        ),
      ),
    );
  }

  void goToPlay(BuildContext context) {
    // print(jsonEncode(_factory.extraRule));
    // print(jsonEncode(_factory.saveRule));
    // print(jsonEncode(_factory.entity));
    AppFactory().getRoute(context).createNewGameToPreView(_factory).push();
  }

  /// Appbar 标题栏
  AppBar loadAppBar() {
    return AppBar(
      title: ValueListenableBuilder(
        valueListenable: _isEditNotifier,
        builder: (context, value, child) {
          return value ? _appBarEditView() : Text("对局配置: ${_entity.name}");
        },
      ),
      actions: [
        ValueListenableBuilder(
          valueListenable: _isEditNotifier,
          builder: (context, value, child) {
            if (value) {
              return IconButton(onPressed: changeEditState, icon: const Icon(Icons.close));
            } else {
              return IconButton(onPressed: changeEditState, icon: const Icon(Icons.edit));
            }
          },
        )
      ],
    );
  }

  Widget _appBarEditView() => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Row(
          children: [
            const Text("配置名称："),
            Flexible(
              child: TextField(
                style: const TextStyle(
                  // color: Colors.deepOrange,
                  fontSize: 20.0,
                ),
                controller: gameConfigEditController,
                decoration: const InputDecoration(
                  hintText: "配置名称",
                  // 移除下划线，因为它是默认的
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
      );
}

/// 游戏配置卡片
class _GameConfigCard extends StatelessWidget {
  final GameTemplateConfigEntity tempConfig;

  const _GameConfigCard(this.tempConfig);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.2), width: 1),
        borderRadius: BorderRadius.circular(9),
      ),
      child: CardButton(
        borderRadius: 8,
        onTap: () => Navigator.pop(context),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: Container(
            width: double.infinity,
            color: Colors.transparent,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: GameConfigSelectedCard(tempConfig),
          ),
        ),
      ),
    );
  }
}

/// 配置选项卡
/// 简略显示，已经选择的界面
class GameConfigSelectedCard extends StatelessWidget {
  final GameTemplateConfigEntity entity;

  const GameConfigSelectedCard(this.entity);

  @override
  Widget build(BuildContext context) {
    return Column(
      // verticalDirection: VerticalDirection.down,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: double.maxFinite, child: Text(entity.name)),
        if (entity.roleConfig.gods.isNotEmpty) _roleIconsView(context, "神职：", entity.roleConfig.gods),
        if (entity.roleConfig.wolfs.isNotEmpty) _roleIconsView(context, "狼坑：", entity.roleConfig.wolfs),
        if (entity.roleConfig.thirds.isNotEmpty) _roleIconsView(context, "三方：", entity.roleConfig.thirds),
      ],
    );
  }

  Widget _makeListView(List<Role> roles) => ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) => roles[index].icon,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 8),
        itemCount: roles.length,
      );

  Widget _roleIconsView(BuildContext context, final String tag, final List<Role> roles) => Row(children: [
        Text(tag),
        Expanded(
          child: SizedBox(height: App.of(context).defSize.iconSize, child: _makeListView(roles)),
        ),
      ]);
}

/// 游戏补充规则配置
class _GameExtraConfigCard extends StatelessWidget {
  final GameFactory factory;

  List<TempExtraGenerator> get extraGens => factory.generator.allExtraGen;

  List<Widget> get widgets => extraGens.map((e) => e.tempView()).toList();

  const _GameExtraConfigCard(this.factory);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: widgets,
      ),
    );
  }
}

class _GameSaveConfigView extends StatefulWidget {
  final _GameConfigViewState state;
  final int maxPlayerCount;
  final bool selectable;
  final PlayersSaveRule defaultValue;
  final Function(PlayersSaveRule saveRule) valueCallback;

  const _GameSaveConfigView(
    this.state,
    this.maxPlayerCount,
    this.defaultValue,
    this.valueCallback, {
    this.selectable = true,
  });

  @override
  State<_GameSaveConfigView> createState() => _GameSaveConfigViewState();
}

class _GameSaveConfigViewState extends State<_GameSaveConfigView> {
  PlayersSaveRule get saveRule => widget.defaultValue;

  int get maxPlayerCount => widget.maxPlayerCount;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _saveSelectItem(
          context,
          "首刀保护",
          saveRule.firstKillSavePlayers,
          (selectList) => saveRule.firstKillSavePlayers = selectList,
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 16),
        _saveSelectItem(
          context,
          "首验保护",
          saveRule.firstVerifySavePlayers,
          (selectList) => saveRule.firstVerifySavePlayers = selectList,
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 16),
        _saveSelectItem(
          context,
          "首毒保护",
          saveRule.firstPoisonSavePlayers,
          (selectList) => saveRule.firstPoisonSavePlayers = selectList,
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
      ],
    );
  }

  Widget _saveSelectItem(
    BuildContext context,
    String title,
    List<int> selectPlayers,
    Function(List<int> selectList) callback,
  ) {
    return _SelectSavePlayer(
      widget.state,
      title: title,
      selectable: widget.selectable,
      playerCount: maxPlayerCount,
      selectList: selectPlayers,
      selectCallback: (selectList) {
        // selectPlayers = selectList;
        callback(selectList);
        widget.valueCallback(saveRule);
      },
    );
  }

  void update(int count) {
    saveRule.removeForPlayerCount(count);
    setState(() {});
  }
}

class _SelectSavePlayer extends StatefulWidget {
  final _GameConfigViewState state;
  final String title;
  final bool selectable;
  final int playerCount;
  final List<int> selectList;
  final Function(List<int> selectList) selectCallback;

  const _SelectSavePlayer(
    this.state, {
    required this.title,
    required this.selectable,
    required this.playerCount,
    required this.selectList,
    required this.selectCallback,
  });

  @override
  State<_SelectSavePlayer> createState() => _SelectSavePlayerState();
}

class _SelectSavePlayerState extends State<_SelectSavePlayer> {
  List<int> selectIndexList = [];

  @override
  void initState() {
    super.initState();
    selectIndexList = widget.selectList;
    // log("selectIndexList: ${selectIndexList.toList().toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.maxFinite,
          child: Text(widget.title),
        ),
        PlayerMultiSelectButton.forConfig(
          config: SelectConfig.forCount(
            circleSize: 34,
            selectable: widget.selectable,
            count: widget.playerCount,
            callback: (t) => setState(() {
              selectIndexList = t;
              widget.selectCallback(t);
            }),
            defaultSelect: selectIndexList,
            multiShowResultView: false,
          ),
        )
      ],
    );
  }
}

class _SelectSavePlayerDialogContent extends StatefulWidget {
  final int playerCount;
  final _SelectSavePlayerDialogContentState state;

  const _SelectSavePlayerDialogContent({
    required this.playerCount,
    required this.state,
  });

  @override
  State<_SelectSavePlayerDialogContent> createState() => state;
}

class _SelectSavePlayerDialogContentState extends State<_SelectSavePlayerDialogContent> {
  final List<int> selectIndexList = List<int>.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 120,
        maxWidth: double.maxFinite,
      ),
      // min: 300,
      // width: double.maxFinite,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 5,
        // 主轴间距
        mainAxisSpacing: 8.0,
        // 交叉轴间距
        crossAxisSpacing: 8.0,
        // 子项边界的内边距
        children: List.generate(widget.playerCount, (index) {
          return Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(60),
            color: selectIndexList.contains(index + 1) ? Colors.deepOrange : Colors.white,
            child: CircleButton(
              size: 50,
              onTap: () => _selectItem(index),
              child: Text('P ${index + 1}'),
            ),
          );
        }),
      ),
    );
  }

  void _selectItem(int index) async {
    int playerId = index + 1;
    // 处理按钮点击事件
    // Navigator.of(context).pop(playerId.toString());
    if (selectIndexList.contains(playerId)) {
      selectIndexList.remove(playerId);
    } else {
      selectIndexList.add(playerId);
    }
    setState(() {});
  }

  void clear() {
    selectIndexList.clear();
    setState(() {});
  }
}
