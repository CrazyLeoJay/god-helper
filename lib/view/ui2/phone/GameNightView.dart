import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/exceptions.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/AppFactory.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/NightFactory.dart';

/// 游戏晚上的进程
class GameNightView extends StatefulWidget {
  final GameFactory _factory;
  final int round;

  const GameNightView(this._factory, this.round, {super.key});

  @override
  State<GameNightView> createState() => _GameNightViewState();
}

class _GameNightViewState extends State<GameNightView> {
  int get _round => widget.round;

  NightFactory get nightFactory => widget._factory.getNight(_round);

  var state = _GameRoleProcessListWidgetState();

  var isShow = IsShowState();

  @override
  void initState() {
    super.initState();
    restoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第 ${RoundHelper(_round).dayStr}"),
        actions: [
          if (kDebugMode) actionPopupMenu(),

          /// 跳转到总进程界面
          IconButton(
            onPressed: () => AppFactory().getRoute(context).toGameSummaryView(nightFactory.factory).push(),
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: _GameRoleProcessListWidget(state, nightFactory),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(onPressed: () async => saveAndToNextRound(), child: const Text("天亮了，所有玩家睁眼")),
      ),
    );
  }

  PopupMenuButton actionPopupMenu() => PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            child: IconButton(
              onPressed: () => setState(() {}),
              icon: const Icon(Icons.refresh),
            ),
          ),
          PopupMenuItem(
            child: TextButton(
                onPressed: () {
                  if (kDebugMode) {
                    // print(
                    //     "playerStateNote: ${jsonEncode(_dayRecord.playerStateNote)}");
                    // print("action: ${jsonEncode(_dayRecord.actionRecord)}");
                  }
                },
                child: const Text("print")),
          ),
        ],
      );

  @override
  void deactivate() {
    saveData();
    super.deactivate();
  }

  @override
  void dispose() {
    saveData();
    super.dispose();
  }

  /// 保存数据
  Future<void> saveData() async {
    nightFactory.actions.save();
  }

  /// 恢复数据
  void restoreData() {}

  Future<void> saveAndToNextRound() async {
    /// 先保存下数据
    saveData();
    try {
      // 检查记录当天结果
      await nightFactory.recordThisRoundAndToNext(context);
    } on AppException catch (e, stackTrace) {
      if (e.obj is Role) {
        var role = (e.obj as Role);
        state.showExpandForRole(role);
        showSnackBarMessage(
          "角色 ${role.roleName} : ${e.message ?? "还有行为未完成"}",
          isShow: isShow,
        );
      }
      if (kDebugMode) {
        // print("玩家 ： ${e.obj}");
        e.printMessage(stackTrace: stackTrace);
      }
    }
  }
}

class NightEntity {
  _GameNightViewState state;

  NightEntity(this.state);

  int get round => state.widget.round;

  GameDetailEntity get entity => state.widget._factory.entity;

  PlayerDetail get playerDetail => state.widget._factory.players.details;

  NightFactory get factory => state.nightFactory;

  GeneratorFactory get generator => factory.factory.generator;

}

/// 游戏角色当晚进程操作列表
class _GameRoleProcessListWidget extends StatefulWidget {
  final State<_GameRoleProcessListWidget> state;
  final NightFactory _factory;

  const _GameRoleProcessListWidget(
    this.state,
    this._factory,
  );

  @override
  State<_GameRoleProcessListWidget> createState() => state;
}

class _GameRoleProcessListWidgetState extends State<_GameRoleProcessListWidget> {
  final ScrollController _scrollController = ScrollController();

  NightFactory get _nightFactory => widget._factory;

  int get _round => widget._factory.round;

  GameDetailEntity get _entity => widget._factory.entity;

  /// 当前展开的索引
  /// 当索引小于0，则不所有都不展开
  int _expandIndex = -1;

  Map<Role, bool> isEmptyMap = {};

  /// 游戏配置的角色列表
  List<Role> get _roleList => _entity.tempConfig.roleConfig.allForActions;

  @override
  void initState() {
    super.initState();
    _checkIndex();
  }

  void _checkIndex() {
    for (int i = 0; i < _roleList.length; i++) {
      var role = _roleList[i];
      if (_nightFactory.roleCanNext(role)) continue;
      _expandIndex = i;
      break;
    }
    if (kDebugMode) {
      print("night index : $_expandIndex");
    }
  }

  /// 游戏角色当晚的动作行为记录界面
  List<ExpansionPanel> get _expansionPanels => List.generate(_roleList.length, (index) {
        var role = _roleList[index];
        return ExpansionPanel(
          // canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            var isSkipMsg = _nightFactory.roleCanSkip(role);
            var player = this.widget._factory.playerDetails.getForRoleNullable(role);
            return ListTile(
              title: RichText(
                text: TextSpan(
                  style: app.baseFont,
                  children: [
                    TextSpan(text: 'R ${index + 1} : '),
                    if (player != null) TextSpan(text: "(玩家P${player.number}) "),
                    TextSpan(text: _roleList[index].roleName),
                    if (isSkipMsg) TextSpan(text: "\t\t\t 无行为，可跳过", style: app.baseFont.copyWith(color: Colors.green)),
                    if (!_nightFactory.config.isCanAction(role))
                      TextSpan(text: "\t\t\t (被封印)", style: app.baseFont.copyWith(color: Colors.yellow)),
                  ],
                ),
              ),
              onTap: () => _toggleExpansion(index, !isExpanded),
              // tileColor: Colors.amber,
            );
          },
          body: Container(
            // color: Colors.deepOrange,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: RichText(
                    text: TextSpan(
                      style: app.font.base.copyWith(color: Colors.black, fontSize: 24),
                      children: [
                        TextSpan(
                          text: role.roleName,
                          style: app.font.base.copyWith(color: Colors.red),
                        ),
                        const TextSpan(text: "玩家 请睁眼")
                      ],
                    ),
                  ),
                ),

                /// 角色行动
                _firstNightRecordPlayer(_roleList[index], widget),
                if (_nightFactory.isShowNext(_roleList[index]))
                  TextButton(onPressed: () => setState(() => _expandIndex++), child: const Text("当前玩家闭眼，进行下一个角色"))
              ],
            ),
          ),
          isExpanded: _expandIndex == index,
        );
      });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          _toggleExpansion(index, isExpanded);
        },
        children: _expansionPanels,
        elevation: 3,
        materialGapSize: 8,
        expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        expandIconColor: Colors.red,
      ),
    );
  }

  /// 切换展开状态
  void _toggleExpansion(int index, bool isExpanded) {
    setState(() {
      if (isExpanded) {
        _expandIndex = index;
      } else {
        _expandIndex = -1;
      }
    });
  }

  /// 第一晚需要记录玩家信息
  /// 这里根据天数判断是否添加这个界面
  Widget _firstNightRecordPlayer(Role role, Widget actionWidget) {
    var widgetHelper = _nightFactory.getWidgetHelper(role);
    var player = _nightFactory.playerDetails.getForRoleNullable(role);
    var action = widgetHelper.getNightAction(isLive: player?.live ?? true) ?? const SizedBox();

    if (_round == 1 && role.isSingleYesPlayerIdentity) {
      var identity = widgetHelper.getIdentityWidget();

      /// 第一晚需要记录玩家信息
      return Column(
        children: [
          identity,
          action,
        ],
      );
    } else {
      /// 除了第一回合，其余情况不需要去操作记录角色玩家情况
      return action;
    }
  }

  void showExpandForRole(Role r) {
    for (int i = 0; i < _roleList.length; i++) {
      var role = _roleList[i];
      print("Test 排序： ${role}");
      if (role == r) {
        _expandIndex = i;
        break;
      }
      if (_nightFactory.roleCanNext(role)) continue;
      _expandIndex = i;
      break;
    }
    setState(() {});
  }
}
