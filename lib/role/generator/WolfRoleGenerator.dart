import 'dart:convert';

import 'package:annotation/annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/exceptions.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/framework/impl/NightFactory.dart';
import 'package:json_annotation/json_annotation.dart';

part 'WolfRoleGenerator.g.dart';

/// 狼人相生成器
class WolfRoleGenerator extends RoleGenerator<WolfAction, WolfAction, EmptyRoleTempConfig> {
  WolfRoleGenerator({required super.factory}) : super(role: Role.WOLF);

  @override
  PlayerIdentityGenerator playerIdentityGenerator() {
    return _WolfPlayerIdentityGenerator(super.factory, super.role);
  }

  @override
  RoleRoundGenerator<WolfAction>? getNightRoundGenerator(NightFactory nightFactory) {
    return _WolfRoleNightRoundGenerator(nightFactory);
  }

  static WolfAction getRoleNightAction(RoundActions actions) {
    return actions.getRoleAction(Role.WOLF, WolfActionJsonData());
  }
}

class _WolfPlayerIdentityGenerator extends PlayerIdentityGenerator {
  _WolfPlayerIdentityGenerator(super.factory, super.role);

  @override
  Widget widget() {
    return _WolfPlayerNumberRecordWidget(
      super.factory,
      (wolfList, identityWolfMap, callbackFinish) {
        var cache = super.factory.players.cache;
        cache.setWolfsNumber(wolfList);
        for (var item in identityWolfMap.entries) {
          cache.setRoleIdentity(item.key, item.value);
        }
        cache.setRolePlayerRecordFinish(Role.WOLF);
        cache.save();

        /// 数据保存结束，通知界面修改
        callbackFinish();
      },
    );
  }
}

/// 狼人玩家号码牌记录组件
class _WolfPlayerNumberRecordWidget extends StatefulWidget {
  final GameFactory factory;

  final Function(
    List<int> wolfList,
    Map<Role, int> identityWolfMap,
    Function() callbackFinish,
  ) finishCallback;

  const _WolfPlayerNumberRecordWidget(this.factory, this.finishCallback, {super.key});

  @override
  State<_WolfPlayerNumberRecordWidget> createState() => _WolfPlayerNumberRecordWidgetState();
}

class _WolfPlayerNumberRecordWidgetState extends State<_WolfPlayerNumberRecordWidget> {
  GameFactory get _factory => widget.factory;

  GameTemplateConfigEntity get _tempConfig => widget.factory.entity.tempConfig!;

  TemplateRoleConfig get _roleConfig => _tempConfig.roleConfig;

  /// 用于判断snackBar是否显示
  final _snackBarShow = IsShowState();

  /// 选择为狼人的id
  List<int> _selectableList = [];

  /// 特殊角色对应的狼人设置
  final Map<Role, int> _rolePlayerMap = {};

  /// 是否已经确定了玩家身份
  bool _isYesPlayersIdentity = false;

  @override
  void initState() {
    super.initState();
    _isYesPlayersIdentity = _factory.players.cache.isRecordFinish(Role.WOLF);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          const SizedBox(
            width: double.maxFinite,
            child: Text("以下的玩家是狼人"),
          ),
          const SizedBox(height: 8),

          // 设置，将玩家中狼人身份的玩家标出
          _wolfSelectWidget(),
          const SizedBox(height: 8),

          // 记录有身份的狼的玩家id
          _identityWolfRecordWidget(),
          const SizedBox(height: 8),

          _yesWolfIdentityWidget(),
          const SizedBox(height: 8),
          // if (kDebugMode) _testButton(),
        ],
      ),
    );
  }

  Widget _testButton() => TextButton(
        child: const Text("打印狼人信息"),
        onPressed: () {
          if (kDebugMode) {
            print(jsonEncode(_factory.players.cache));
          }
        },
      );

  /// 确认狼人身份按钮
  Widget _yesWolfIdentityWidget() {
    return _isYesPlayersIdentity
        ? const Text("已确认身份，请进行今晚动作")
        : TextButton(
            onPressed: () {
              if (!_checkWolfIdentity()) return;

              widget.finishCallback(_selectableList, _rolePlayerMap, () {
                /// 数据保存结束，设置状态并修改action
                _isYesPlayersIdentity = true;
                setState(() {});
              });
            },
            child: const Text("确认狼人身份？"),
          );
  }

  /// 狼人身份检查
  bool _checkWolfIdentity() {
    try {
      if (!checkWolfCount(_selectableList)) {
        if (kDebugMode) print("_snackBarShow $_snackBarShow");

        showSnackBar(
            SnackBar(
              content: const Text("狼人数量还不够"),
              action: SnackBarAction(
                label: "好的",
                onPressed: () {},
              ),
            ),
            isShow: _snackBarShow);
        return false;
      }

      if (!checkWolfRoleHasPlayerNumber(_roleConfig.wolfs, _selectableList, _rolePlayerMap)) {
        showSnackBarMessage("还存在拥有身份的狼未设置玩家", isShow: _snackBarShow);
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      if (e is AppException) {
        showSnackBarMessage(e.error.err, isShow: _snackBarShow);
      }
      return false;
    }

    return true;
  }

  /// 检查狼人数量是否合理，用于判断数据合理性
  bool checkWolfCount(List<int> wolfSelects) {
    var entity = _factory.entity;
    var wolfCampCount = entity.tempConfig?.roleConfig.wolfCampCount ?? AppError.tempNotSetting.toExc();
    return wolfSelects.length == wolfCampCount;
  }

  /// 检查有身份的狼人是否都拥有玩家编号
  bool checkWolfRoleHasPlayerNumber(
    List<Role> wolfs,
    List<int> selectableList,
    Map<Role, int> rolePlayerMap,
  ) {
    for (var wolf in wolfs) {
      if (null == rolePlayerMap[wolf]) return false;
      // 检查玩家编号是否在设置的狼人列表中
      if (!selectableList.contains(rolePlayerMap[wolf]!)) {
        throw AppError.identityWolfPlayerNumberIsNotInWolfNumberList.toExc();
      }
    }
    return true;
  }

  /// 狼人选择组件
  Widget _wolfSelectWidget() => PlayerMultiSelectButton.forConfig(
        config: SelectConfig.forCount(
          count: _roleConfig.count(),
          defaultSelect: _factory.players.cache.wolfNumbers,
          callback: (List<int> t) => _updateSelectableList(t),
          maxSelect: _roleConfig.wolfCampCount,
          circleSize: 36,
          selectable: !_isYesPlayersIdentity,
        ),
      );

  /// 狼人身份记录组件
  Widget _identityWolfRecordWidget() {
    if (_roleConfig.wolfs.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: double.maxFinite,
            child: Text("身份狼"),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.maxFinite,
            // height: 160,
            child: ListView.separated(
              // 收缩list，否则会导致ui错误
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _wolfPlayerSelectItem(_roleConfig.wolfs[index]);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemCount: _roleConfig.wolfs.length,
            ),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  /// 狼人身份选择组件
  Widget _wolfPlayerSelectItem(Role role) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(role.desc.name),
        const SizedBox(width: 16),
        PlayerSingleSelectButton.initConfig(
          config: SelectConfig(
              circleSize: 36,
              selectableList: _selectableList,
              defaultSelect: _factory.players.cache.getRoleNumber(role),
              callback: (element) => _rolePlayerMap[role] = element,
              selectableListEmptyTip: "请确认狼人编号后，选择带有身份的狼。",
              selectable: !_isYesPlayersIdentity),
        ),
      ],
    );
  }

  void _updateSelectableList(List<int> selectableList) {
    _selectableList = selectableList;
    setState(() {});
  }
}

/// 狼人晚上回合的生成器
class _WolfRoleNightRoundGenerator extends RoleRoundGenerator<WolfAction> {
  final NightFactory nightFactory;

  _WolfRoleNightRoundGenerator(this.nightFactory) : super(roundFactory: nightFactory, role: Role.WOLF);

  @override
  Widget actionWidget(Function() updateCallback) {
    return _WolfActionComponent(super.factory, nightFactory, action, () {
      if (kDebugMode) print("wolf action: ${jsonEncode(action)}");
      saveAction();
    });
  }

  @override
  JsonEntityData<WolfAction> actionJsonConvertor() {
    return WolfActionJsonData();
  }
}

@ToJsonEntity()
@JsonSerializable()
class WolfAction extends RoleAction {
  /// 选择击杀玩家
  int killPlayer = 0;

  /// 本回合放弃出刀
  bool noKill = false;

  WolfAction() : super(Role.WOLF);

  factory WolfAction.fromJson(Map<String, dynamic> json) => _$WolfActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WolfActionToJson(this);

  @override
  void setToPlayerDetail(PlayerDetail detail, PlayerStateMap states) {
    if (noKill) {
      if (kDebugMode) print("放弃刀人");
      return;
    }
    if (killPlayer > 0) {
      states.set(killPlayer, PlayerStateType.isWolfKill);
      if (kDebugMode) print("玩家 $killPlayer 被狼人刀死");
    } else if (!noKill) {
      throw AppError.wolfNotSelectKillPlayer.toExc();
    }
  }
}

class _WolfActionComponent extends StatefulWidget {
  final WolfAction action;
  final GameFactory factory;
  final NightFactory nightFactory;
  final Function() finishCallback;

  const _WolfActionComponent(this.factory, this.nightFactory, this.action, this.finishCallback, {super.key});

  @override
  State<_WolfActionComponent> createState() => _WolfActionComponentState();
}

class _WolfActionComponentState extends State<_WolfActionComponent> {
  WolfAction get action => widget.action;

  List<Player> get livePlayers => widget.factory.players.getLivePlayerInNight();

  final _isShow = IsShowState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          width: double.maxFinite,
          child: Text("狼人请选择今晚要刀的对象"),
        ),
        const SizedBox(height: 8),
        // 是否展示选择刀掉玩家
        if (!(action.isYes && action.noKill)) _selectKillPlayerWidget(),
        const SizedBox(height: 8),
        action.isYes
            ? _yesWidget()
            : Row(
                children: [
                  Expanded(child: _abandonButton()),
                  Expanded(child: _killButton()),
                ],
              ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _killButton() {
    return TextButton(
        onPressed: () {
          if (!widget.nightFactory.isAction(context, Role.WOLF, _isShow)) {
            return;
          }
          if (action.killPlayer <= 0) {
            showSnackBarMessage("还未选择玩家", isShow: _isShow);
            return;
          }

          action.noKill = false;
          action.isYes = true;
          setState(() {});
          widget.finishCallback();
        },
        child: const Text("确认选择刀掉该玩家？"));
  }

  Widget _abandonButton() {
    return TextButton(
        onPressed: () {
          if (!widget.nightFactory.isAction(context, Role.WOLF, _isShow)) {
            return;
          }
          setState(() {
            action.killPlayer = 0;
            action.noKill = true;
            action.isYes = true;
            widget.finishCallback();
          });
        },
        child: const Text("放弃刀人"));
  }

  /// 结果确认后的界面
  Widget _yesWidget() {
    return action.noKill
        ? Text("${Role.WOLF.desc.name} 放弃刀人")
        : RichText(
            text: TextSpan(
              style: app.baseFont.copyWith(color: Colors.black),
              children: [
                const TextSpan(text: "玩家"),
                TextSpan(
                  text: " ${action.killPlayer}号 ",
                  style: app.baseFont.copyWith(color: Colors.black, fontSize: 24),
                ),
                TextSpan(
                  text: "已被刀掉",
                  style: app.baseFont.copyWith(color: Colors.red, fontSize: 24),
                )
              ],
            ),
          );
  }

  Widget _selectKillPlayerWidget() => RichText(
        text: TextSpan(
          style: app.baseFont.copyWith(color: Colors.black),
          children: [
            const TextSpan(text: "今晚要刀"),
            const WidgetSpan(child: SizedBox(width: 8)),
            WidgetSpan(
              child: PlayerSingleSelectButton.initConfig(
                config: SelectConfig(
                  // count: _tempConfig.playerCount,
                  selectableList: livePlayers.map((e) => e.number).toList()..sort(),
                  defaultSelect: action.killPlayer,
                  selectable: !action.isYes,
                  circleSize: app.defSize.defaultCircle,
                  callback: (t) => action.killPlayer = t,
                ),
              ),
              alignment: PlaceholderAlignment.middle,
            ),
            const WidgetSpan(child: SizedBox(width: 8)),
            const TextSpan(text: "号玩家"),
          ],
        ),
      );
}
