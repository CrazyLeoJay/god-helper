import 'dart:convert';

import 'package:annotation/annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/exceptions.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/DayFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/role/generator/DefaultEmptyGenerator.dart';
import 'package:god_helper/role/generator/WitchRoleGenerator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'WolfKingRoleGenerator.g.dart';

/// 狼王玩家生成器
///
/// 狼王完善如果被毒掉，需要第二天需要上帝去判定它是否可以使用
/// 普通玩家也可以有技能发动流程，上帝判定不生效
/// 可以让玩家发动技能，上帝判断是否生效
class WolfKingRoleGenerator extends RoleGenerator<EmptyAction, WolfKingDayAction, EmptyRoleTempConfig> {
  WolfKingRoleGenerator({required super.factory}) : super(role: Role.WOLF_KING);

  /// 获取狼王白天的Actions
  static WolfKingDayAction getDayAction(RoundActions actions) {
    return actions.getRoleAction(Role.WOLF_KING, WolfKingDayActionJsonData());
  }

  /// 狼王如果白天被带走，需要释放技能，可以带走一个玩家
  @override
  RoleDayRoundGenerator<WolfKingDayAction>? getDayRoundGenerator(DayFactory dayFactory) {
    return _WolfKingDayRoleRoundGenerator(dayFactory);
  }
}

class _WolfKingDayRoleRoundGenerator extends RoleDayRoundGenerator<WolfKingDayAction> {
  final DayFactory dayFactory;

  _WolfKingDayRoleRoundGenerator(this.dayFactory) : super(roundFactory: dayFactory, role: Role.WOLF_KING);

  @override
  Future<void> preAction() async {
    // 调用界面的同时去计算下开枪状态，并保存
    if (!action.isCanShut(dayFactory)) {
      action.isYes = true;
      saveAction();
    }
    return await super.preAction();
  }

  @override
  Widget? outWidget(Function() updateCallback) {
    return _WolfKingDayActionWidget(
      super.factory,
      dayFactory,
      action,
      player,
      dayFactory.getPlayerStates(player),
      (killPlayer, callYesFinish) {
        action.shutPlayerId = killPlayer;
        action.isAbandon = false;
        action.canShut = true;
        action.isYes = true;
        saveAction();

        if (kDebugMode) print("WolfKing day action = ${jsonEncode(action)}");
        callYesFinish();
      },
      (callYesFinish) {
        action.shutPlayerId = null;
        action.isAbandon = true;
        action.canShut = true;
        action.isYes = true;
        saveAction();

        if (kDebugMode) print("WolfKing day action = ${jsonEncode(action)}");
        callYesFinish();
      },
    );
  }

  @override
  JsonEntityData<WolfKingDayAction> actionJsonConvertor() {
    return WolfKingDayActionJsonData();
  }
}

@ToJsonEntity()
@JsonSerializable()
class WolfKingDayAction extends RoleAction {
  /// 如果使用技能，带走的玩家
  int? shutPlayerId;

  /// 是否放弃使用技能
  var isAbandon = false;

  @JsonKey(includeToJson: false, includeFromJson: false)
  String noShutMsg = "";

  bool canShut = true;

  WolfKingDayAction({
    this.isAbandon = false,
    this.canShut = true,
  }) : super(Role.WOLF_KING);

  factory WolfKingDayAction.fromJson(Map<String, dynamic> json) => _$WolfKingDayActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WolfKingDayActionToJson(this);

  bool isCanShut(DayFactory factory) => _checkCanBiubiubiu(factory);

  /// 是否可以开枪
  bool _checkCanBiubiubiu(DayFactory dayFactory) {
    var wolfPlayer = dayFactory.details.getForRoleNullable(Role.WOLF_KING);
    if (wolfPlayer == null) throw AppError.wolfKingNoSelectPlayer.toExc();
    if (dayFactory.isYesWolfBomb) {
      // 自爆无法开枪
      if (dayFactory.dayAction.wolfBombPlayer == wolfPlayer.number) {
        noShutMsg = "狼王自爆无法开枪";
        canShut = false;
        return canShut;
      }
    }
    // 获取昨晚情况
    var nightFactory = dayFactory.lastNight();
    var action = WitchRoleGenerator.getRoleNightActionNullable(nightFactory.actions);
    if (null != action && !action.isKillNotUseSkill) {
      var player = action.getKillForPoison();
      var result = player == wolfPlayer.number;
      if (result) {
        noShutMsg = "狼王被毒了，无法开枪";
      }
      canShut = !result;
      return canShut;
    }
    return true;
  }

  @override
  void setToPlayerDetail(PlayerDetail detail, PlayerStateMap states) {
    super.setToPlayerDetail(detail, states);
    // 如果是不能开枪，则直接跳过
    if (!canShut) return;
    // 如果还未完成任务，则需要抛出异常
    if (!isYes) throw AppError.wolfKingNoSelectShutPlayer.toExc();
    // if(isCanShut())
    var id = detail.getForRole(role).number;
    if (isAbandon) {
      states.set(id, PlayerStateType.abandonUsePower);
    } else if (shutPlayerId != null) {
      states.set(shutPlayerId!, PlayerStateType.isKillWithWolfKing);
      states.setKillPlayer(id, [shutPlayerId!]);
    } else {
      throw AppError.wolfKingNoSelectShutPlayer.toExc();
    }
  }
}

/// 狼王出局
class _WolfKingDayActionWidget extends StatefulWidget {
  final GameFactory factory;
  final DayFactory dayFactory;
  final WolfKingDayAction action;
  final Player outPlayer;
  final PlayerStates playerState;
  final Function(int killPlayer, Function() callYesFinish) callback;
  final Function(Function() callYesFinish) cancelCallback;

  const _WolfKingDayActionWidget(
    this.factory,
    this.dayFactory,
    this.action,
    this.outPlayer,
    this.playerState,
    this.callback,
    this.cancelCallback,
  );

  @override
  State<_WolfKingDayActionWidget> createState() => _WolfKingDayActionWidgetState();
}

class _WolfKingDayActionWidgetState extends State<_WolfKingDayActionWidget> {
  final _role = Role.WOLF_KING;

  GameFactory get _factory => widget.factory;

  DayFactory get _dayFactory => widget.dayFactory;

  WolfKingDayAction get _action => widget.action;

  TextStyle get _baseStyle => app.baseFont;

  TextStyle get _titleStyle => _baseStyle.copyWith(fontSize: 18);

  Player get _outPlayer => widget.outPlayer;

  PlayerStates get _playerState => widget.playerState;

  List<int> get _livePlayerIds => _dayFactory.getNowLivePlayer().map((e) => e.number).toList()
    ..removeWhere(
      (element) => element == _outPlayer.number,
    );

  int _defaultSelect = 0;

  final _isShow = IsShowState();

  TextStyle get _font => app.baseFont;

  bool get _isYes => _action.isYes;

  bool get isDieForWitchPoison => _playerState.get(PlayerStateType.isKillWithPoison);

  bool get isAbandon => _action.isAbandon;

  bool get isCanShut => _action.isCanShut(_dayFactory);

  @override
  void initState() {
    super.initState();
    _defaultSelect = _action.shutPlayerId ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 1),
        Row(children: [Text("玩家 ${_outPlayer.number}号 ${_role.desc.name}出局", style: _titleStyle)]),
        _mainContainerWidget(),
      ],
    );
  }

  /// 主要内容
  Widget _mainContainerWidget() {
    if (isCanShut) {
      if (_isYes) {
        if (isAbandon) {
          return Text("玩家 ${_outPlayer.number} 放弃了使用技能");
        } else {
          // return Text("玩家 ${_action.killWithWolfKing} 被 ${_role.desc.name} 带走了 ");
          return RichText(
            text: TextSpan(
              style: _baseStyle,
              children: [
                const TextSpan(text: "玩家"),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Circle(child: Text("${_action.shutPlayerId}")),
                ),
                TextSpan(text: "被 ${_role.roleName} 带走了 "),
              ],
            ),
          );
        }
      } else {
        return _killPlayerWidget();
      }
    } else {
      var cause = _action.noShutMsg.isEmpty ? "由于规则限制，无法使用技能" : _action.noShutMsg;
      return Text("玩家 ${_outPlayer.number} $cause");
    }
  }

  Widget _killPlayerWidget() => Column(
        children: [
          Text("${_role.desc.name}可以选择带走一名玩家"),
          RichText(
            text: TextSpan(
              style: _baseStyle,
              children: [
                TextSpan(text: "玩家 ${_outPlayer.number}号 选择带走"),
                const WidgetSpan(child: SizedBox(width: 8)),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: PlayerSingleSelectButton.initConfig(
                    config: SelectConfig(
                      selectableList: _livePlayerIds,
                      selectable: !_isYes,
                      defaultSelect: _defaultSelect,
                      callback: (t) {
                        setState(() => _defaultSelect = t);
                      },
                    ),
                  ),
                ),
                const WidgetSpan(child: SizedBox(width: 8)),
                const TextSpan(text: "号玩家"),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () => cancel(),
                  child: const Text("放弃使用技能"),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () => yesResult(),
                  child: const Text("确认是否带走该玩家"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
        ],
      );

  void yesResult() {
    if (_defaultSelect < 0) {
      showSnackBarMessage("还未选择要带走玩家", isShow: _isShow);
      return;
    }
    // 返回一个结果
    widget.callback(_defaultSelect, () {
      // 表示完成保存，这个组件完成任务，并更新状态
      setState(() {});
    });
  }

  void cancel() {
    /// 返回一个结果
    widget.cancelCallback(() {
      setState(() {});
    });
  }
}
