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
import 'package:god_helper/view/ui2/phone/GameTemplateListView.dart';

/// 游戏开始界面-游戏界面
/// 已经选择好模板，开始游戏
class MakeNewGameBeginView extends StatefulWidget {
  final GameFactory _factory;

  const MakeNewGameBeginView(this._factory, {super.key});

  factory MakeNewGameBeginView.make(GameTemplateConfigEntity temp, {bool? isSystemConfig}) {
    return MakeNewGameBeginView(AppFactory().makeNewGamePreFactory(temp, isSystemConfig ?? temp.isDefaultConfig));
  }

  @override
  State<MakeNewGameBeginView> createState() => _MakeNewGameBeginViewState();
}

class _MakeNewGameBeginViewState extends State<MakeNewGameBeginView> {
  GameTemplateConfigEntity get _entity => widget._factory.entity.tempConfig;

  bool get _isSystemConfig => widget._factory.entity.isSystemConfig;

  TempExtraRule get _extraRule => _entity.extraRule;

  List<TempExtraGenerator> get _extraGens => widget._factory.generator.allExtraGen;

  List<Widget> get _widgets => _extraGens.map((e) => e.tempView()).toList();

  @override
  void initState() {
    super.initState();
    for (var value in _extraGens) {
      value.initExtraConfigEntity();
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = context.defaultFont.copyWith(fontSize: 18);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (kDebugMode) {
          print("test : $didPop");
        }
        context.padRoute.toNewGameSelectTempView(ConfigViewType.create, _entity).pushReplace();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('创建新游戏-begin game'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("当前配置:(点击返回从新选择)", style: titleStyle),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          constraints: const BoxConstraints(
                            minWidth: 400,
                            maxWidth: 600,
                          ),
                          child: _GameConfigCard(_entity),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text("请选择板子后自动生成补充规则"),
                        const SizedBox(height: 8),
                        const Divider(height: 1),
                        const SizedBox(height: 8),
                        Row(children: [Text("胜利条件：", style: titleStyle)]),
                        const SizedBox(height: 8),
                        Center(
                          child: Container(
                            child: WinRule.createSelectView(
                              defaultValue: _extraRule.winRule,
                              gridChildAspectRatio: 12 / 2,
                              callback: (value) {
                                setState(() => _extraRule.winRule = value);
                              },
                            ),
                          ),
                        ),
                        Row(children: [Text("警长配置：", style: titleStyle)]),
                        SheriffRace.createSelectView(
                          defaultValue: _extraRule.getSheriffConfig().sheriffRace,
                          callback: (value) {
                            setState(() => _extraRule.getSheriffConfig().sheriffRace = value);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),

              Row(children: [Text("补充规则：", style: titleStyle)]),
              const SizedBox(height: 8),
              // AutoGridView(data: List.of(elements), itemBuilder: itemBuilder)
              Center(
                child: AutoGridView.gen(
                  circleSize: 450,
                  absSize: true,
                  autoCenter: true,
                  childAspectRatio: 16 / 12,
                  padding: 16,
                  children: _widgets.map((e) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      child: e,
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),

              Row(children: [Text("保护配置(${_entity.playerCount} 人)：", style: titleStyle)]),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _GameSaveConfigView(
                  _entity.playerCount,
                  widget._factory.saveRule,
                  selectable: true,
                  (saveRule) {
                    widget._factory.entity.saveRule = saveRule;
                    // _factory.saveRule.save();
                    // print("SaveB ${jsonEncode(_factory.saveRule)}");
                  },
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: TextButton(
              onPressed: () {
                // GameFactory.create(_entity)
                _NewGamePreviewDialog.showPreviewDialog(
                  context: context,
                  factory: widget._factory,
                  gotoBeginGame: () async {
                    // print("factory :${jsonEncode(factory.entity)}");

                    // 创建新游戏
                    GameFactory f = await AppFactory().service.createNewGame(widget._factory);
                    // 导航到游戏配置界面，并且移除之前的所有历史导航
                    // padRoute.beginGameToViewFromFactory(f).pushAndRemoveUntil("/");
                    padRoute.beginGameToViewFromFactory(f).pushReplace();
                  },
                );
              },
              child: const Text("开始游戏")),
        ),
      ),
    );
  }
}

/// 游戏配置卡片
class _GameConfigCard extends StatelessWidget {
  final GameTemplateConfigEntity _temp;

  const _GameConfigCard(this._temp);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.2), width: 1),
        borderRadius: BorderRadius.circular(9),
      ),
      child: CardButton(
        borderRadius: 8,
        onTap: () {
          // Navigator.pop(context);
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: Container(
            width: double.infinity,
            color: Colors.transparent,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: Column(
              // verticalDirection: VerticalDirection.down,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: double.maxFinite, child: Text(_temp.name)),
                if (_temp.roleConfig.gods.isNotEmpty) _roleIconsView(context, "神职：", _temp.roleConfig.gods),
                if (_temp.roleConfig.wolfs.isNotEmpty) _roleIconsView(context, "狼坑：", _temp.roleConfig.wolfs),
                if (_temp.roleConfig.thirds.isNotEmpty) _roleIconsView(context, "三方：", _temp.roleConfig.thirds),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _makeListView(List<Role> roles) => ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) => roles[index].icon(),
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

class _GameSaveConfigView extends StatefulWidget {
  final int maxPlayerCount;
  final bool selectable;
  final PlayersSaveRule defaultValue;
  final Function(PlayersSaveRule saveRule) valueCallback;

  const _GameSaveConfigView(
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
  final String title;
  final bool selectable;
  final int playerCount;
  final List<int> selectList;
  final Function(List<int> selectList) selectCallback;

  const _SelectSavePlayer({
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

/// 新建游戏前的预览提示框
class _NewGamePreviewDialog extends StatelessWidget {
  final GameFactory _factory;

  /// 去开始游戏
  final Function() gotoBeginGame;

  const _NewGamePreviewDialog(this._factory, {required this.gotoBeginGame});

  static void showPreviewDialog({
    required BuildContext context,
    required GameFactory factory,
    required Function() gotoBeginGame,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            constraints: const BoxConstraints(minWidth: 600),
            child: _NewGamePreviewDialog(factory, gotoBeginGame: gotoBeginGame),
          ),
        );
      },
    );
  }

  /// 模板配置
  GameTemplateConfigEntity get _entity => _factory.entity.tempConfig;

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = context.defaultFont.copyWith(fontSize: 20);

    Widget row(String key, Widget value) {
      return Row(children: [
        Text(
          "$key :",
          style: titleStyle.copyWith(color: Colors.deepOrangeAccent),
        ),
        value,
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("规则配置预览"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("当前配置:(点击返回从新选择)", style: titleStyle),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              constraints: const BoxConstraints(
                minWidth: 400,
                maxWidth: 600,
              ),
              child: _GameConfigCard(_entity),
            ),
            row("胜利条件", Text(_factory.entity.extraRule.winRule.desc)),
            row("警长配置", Text(_factory.entity.extraRule.sheriffRace.desc)),
            Row(children: [Text("其他规则", style: titleStyle)]),
            for (var v in _factory.entity.extraRule.useConfigRoles) _buildRoleExtraConfigWidget(context, v),
            const SizedBox(height: 16),
            Row(children: [Text("保护配置(${_factory.entity.tempConfig.playerCount})", style: titleStyle)]),
            row("首刀保护", _buildSafeNumberRow(_factory.entity.saveRule.firstKillSavePlayers)),
            row("首验保护", _buildSafeNumberRow(_factory.entity.saveRule.firstVerifySavePlayers)),
            row("首毒保护", _buildSafeNumberRow(_factory.entity.saveRule.firstPoisonSavePlayers)),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            Expanded(
                child: TextButton(onPressed: () => Navigator.pop(context), child: const Center(child: Text("取消")))),
            Expanded(
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      gotoBeginGame();
                    },
                    child: const Center(child: Text("开始游戏")))),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleExtraConfigWidget(BuildContext context, Role role) {
    List<String> list = _factory.generator.get(role)?.extraRuleGenerator()?.configResultMessage() ?? List.empty();
    if (list.isEmpty) {
      return const SizedBox();
    } else {
      return Column(
        children: [
          Row(children: [
            Text(
              "角色：${role.roleName}",
              style: context.defaultFont.copyWith(fontSize: 18, color: Colors.cyanAccent),
            ),
          ]),
          for (var value in list) Row(children: [Text(value)])
        ],
      );
    }
  }

  Widget _buildSafeNumberRow(List<int> ids) {
    return Row(
      children: ids
          .map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Circle(child: Text("P$e")),
            ),
          )
          .toList(),
    );
  }
}
