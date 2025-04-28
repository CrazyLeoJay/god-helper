import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/exceptions.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/impl/NightFactory.dart';
import 'package:god_helper/view/ui_pad/playview/Theme.dart';

/// 游戏夜间操作界面
class PlayNightView extends StatefulWidget {
  final CTheme theme;
  final NightFactory _factory;

  // 转到下一回合回调
  final Function(int nextRound) finishToNextRoundCallback;

  // 游戏结束回调
  final Function() finishToSummaryGameCallback;

  const PlayNightView(
    this._factory, {
    super.key,
    required this.finishToNextRoundCallback,
    required this.finishToSummaryGameCallback,
    required this.theme,
  });

  @override
  State<PlayNightView> createState() => _PlayNightViewState();
}

class _PlayNightViewState extends State<PlayNightView> {
  CTheme get theme => widget.theme;

  NightFactory get _factory => widget._factory;

  List<Role> get _roles => widget._factory.entity.tempConfig.roleConfig.allForActions;

  final ValueNotifier roleNotifier = ValueNotifier(Role.EMPTY);

  @override
  void initState() {
    super.initState();
    // roleNotifier.value = _roles[0];
    _checkIndex();
  }

  void _checkIndex() {
    for (int i = 0; i < _roles.length; i++) {
      var role = _roles[i];
      if (_factory.roleCanNext(role)) continue;
      roleNotifier.value = role;
      break;
    }

    if (kDebugMode) {
      print("night index : ${roleNotifier.value}(${_roles.indexOf(roleNotifier.value)})");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("第 ${widget._factory.roundHelper.dayStr}", style: theme.titleStyle),
        const Divider(height: 1),
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 220,
                // 角色菜单组件
                child: _buildRoleMenuWidget(),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: ValueListenableBuilder(
                    valueListenable: roleNotifier,
                    builder: (context, role, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 角色行为操作界面
                          _buildRoleOptionWidget(role),
                          // 角色操作界面底部按钮
                          _buildRoleBottomWidget(role),
                        ],
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        const Divider(height: 1),
        _buildBottomFinishToNextButtonWidget(),
      ],
    );
  }

  /// 创建角色操作菜单列表
  Widget _buildRoleMenuWidget() {
    return ListView.separated(
      itemBuilder: (context, index) => InkWell(
        onTap: () => roleNotifier.value = _roles[index],
        child: ValueListenableBuilder(
          valueListenable: roleNotifier,
          builder: (context, selectRole, child) {
            var role = _roles[index];
            var isSelect = selectRole == role;

            var isFinish = _factory.roleCanNext(role);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: (isSelect) ? theme.selectColor : null,
              child: Center(
                child: Row(
                  children: [
                    _roles[index].icon(size: 35, color: isSelect ? Colors.white : Colors.black),
                    Expanded(
                      child: Center(
                        child: Text(
                          "${role.roleName}",
                          style: theme.contentStyle.copyWith(color: isSelect ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                    Text(
                      "(${isFinish ? "已完成" : "还未完成"})",
                      style: theme.contentStyle.copyWith(
                        color: isFinish ? Colors.green : Colors.red,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: _roles.length,
    );
  }

  /// 构建角色菜单选项单项的组件
  Widget _buildRoleOptionWidget(Role role) {
    if (role == Role.EMPTY) {
      return Center(
        child: Text(
          "请选择角色",
          style: theme.contentStyle.copyWith(fontSize: 50),
        ),
      );
    }

    if (_factory.roleCanSkip(role)) {
      return const Text("无行为，可以跳过");
    }
    var widgetHelper = _factory.getWidgetHelper(role);
    bool live = true;
    // 由于第一天还未确定身份，所以直接按活的算
    if (_factory.round > 1) {
      if (role == Role.wolf) {
        // 如果是狼人，则需要所有狼人都阵亡才算结束
        var players = _factory.playerDetails.getWolfTypeLivePlayers();
        live = players.isNotEmpty;
      } else {
        var player = _factory.playerDetails.getForRoleNullable(role);
        live = player?.live ?? true;
      }
    }

    var action = widgetHelper.getNightAction(isLive: live) ?? const SizedBox();

    if (_factory.round == 1 && role.isSingleYesPlayerIdentity) {
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

  /// 角色底部组件
  Widget _buildRoleBottomWidget(Role role) {
    if (_factory.isShowNext(role)) {
      if (_roles.indexOf(role) == _roles.length - 1) {
        return const Text("已经是最后一个角色");
      } else {
        return TextButton(
            onPressed: () {
              var nextIndex = _roles.indexOf(role) + 1;
              if (nextIndex < _roles.length) {
                roleNotifier.value = _roles[nextIndex];
              }
            },
            child: const Text("当前玩家闭眼，进行下一个角色"));
      }
    } else {
      return const SizedBox();
    }
  }

  /// 回合结束组件，结束进行下一步
  Widget _buildBottomFinishToNextButtonWidget() {
    if (_factory.factory.summary.isGameOver()) {
      return InkWell(
        onTap: () => widget.finishToNextRoundCallback(_factory.round + 1),
        child: const SizedBox(
          height: 75,
          child: Center(child: Text("下一回合")),
        ),
      );
    } else {
      return InkWell(
        onTap: () => _saveAndToNextRound(),
        child: const SizedBox(
          height: 75,
          child: Center(child: Text("已完成")),
        ),
      );
    }
  }

  /// 保存数据
  Future<void> saveData() async {
    _factory.actions.save();
  }

  final _isShow = IsShowState();

  /// 保存并进行下一个回合
  ///
  /// 如果还有未完成的item，这里会进行标注
  Future<void> _saveAndToNextRound() async {
    /// 先保存下数据
    saveData();
    try {
      // 检查记录当天结果
      await _factory.recordThisRoundAndToNext(
        context,
        finishToNextRoundCallback: widget.finishToNextRoundCallback,
        finishToSummaryGameCallback: widget.finishToSummaryGameCallback,
      );
    } on AppException catch (e, stackTrace) {
      if (e.obj is Role) {
        var role = (e.obj as Role);
        roleNotifier.value = role;
        showSnackBarMessage(
          "角色 ${role.roleName} : ${e.message ?? "还有行为未完成"}",
          isShow: _isShow,
        );
      }
      if (kDebugMode) {
        // print("玩家 ： ${e.obj}");
        e.printMessage(stackTrace: stackTrace);
      }
    }
  }
}
