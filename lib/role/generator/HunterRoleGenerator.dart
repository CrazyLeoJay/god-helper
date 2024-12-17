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
import 'package:god_helper/framework/impl/NightFactory.dart';
import 'package:god_helper/role/generator/WitchRoleGenerator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'HunterRoleGenerator.g.dart';

/// 女巫玩家生成器
class HunterRoleGenerator extends RoleGenerator<HunterAction, HunterDayAction, EmptyRoleTempConfig> {
  HunterRoleGenerator({required super.factory}) : super(role: Role.HUNTER);

  static HunterAction getRoleNightAction(RoundActions actions) {
    return actions.getRoleAction(Role.HUNTER, HunterActionJsonData());
  }

  /// 猎人晚上判断是否可以开枪
  @override
  RoleNightGenerator<HunterAction>? getNightRoundGenerator(NightFactory nightFactory) {
    return _HunterNightRoleRoundGenerator(nightFactory);
  }

  /// 猎人如果白天被带走，需要释放技能，可以带走一个玩家
  @override
  RoleDayRoundGenerator<HunterDayAction> getDayRoundGenerator(DayFactory dayFactory) {
    return _HunterDayRoleRoundGenerator(dayFactory);
  }
}

class _HunterNightRoleRoundGenerator extends RoleNightGenerator<HunterAction> {
  final NightFactory roundFactory;

  _HunterNightRoleRoundGenerator(this.roundFactory) : super(roundFactory: roundFactory, role: Role.HUNTER);

  @override
  Widget actionWidget(Function() updateCallback) {
    return _HunterNineActionComponent(super.factory, action, roundFactory, () {
      saveAction();
    });
  }

  @override
  JsonEntityData<HunterAction> actionJsonConvertor() {
    return HunterActionJsonData();
  }
}

class _HunterDayRoleRoundGenerator extends RoleDayRoundGenerator<HunterDayAction> {
  final DayFactory dayFactory;

  _HunterDayRoleRoundGenerator(this.dayFactory) : super(roundFactory: dayFactory, role: Role.HUNTER);

  @override
  Future<void> preAction() {
    // 调用界面的同时去计算下开枪状态，并保存
    if (!action.isCanShut(dayFactory)) {
      action.canShut = false;
      action.isYes = true;
      saveAction();
    }
    return super.preAction();
  }

  @override
  Widget actionWidget(Function() updateCallback) {
    return _HunterDayActionWidget(
      super.factory,
      dayFactory,
      action,
      player,
      dayFactory.getPlayerStates(player),
      (killPlayer, callYesFinish) {
        action.shutPlayerId = killPlayer;
        action.isAbandon = false;
        action.isYes = true;
        saveAction();
        if (kDebugMode) print("hunter day action = ${jsonEncode(action)}");
        callYesFinish();
      },
      (callYesFinish) {
        action.shutPlayerId = null;
        action.isAbandon = true;
        action.isYes = true;
        saveAction();

        if (kDebugMode) print("hunter day action = ${jsonEncode(action)}");
        callYesFinish();
      },
    );
  }

  @override
  JsonEntityData<HunterDayAction> actionJsonConvertor() {
    return HunterDayActionJsonData();
  }
}

@ToJsonEntity()
@JsonSerializable()
class HunterAction extends RoleAction {
  bool isCanBiubiubiu = true;

  HunterAction() : super(Role.HUNTER);

  factory HunterAction.fromJson(Map<String, dynamic> json) => _$HunterActionFromJson(json);

  Map<String, dynamic> toJson() => _$HunterActionToJson(this);

  /// 是否可以开枪
  bool checkCanBiubiubiu(NightFactory nightFactory) {
    int hunterId = nightFactory.getRoleNumber(Role.HUNTER);
    if (nightFactory.round == 1 && hunterId <= 0) {
      throw AppError.hunterNoSelectPlayer.toExc();
    }
    // 如果玩家已经是阵亡状态，则无需其他判断
    if (!nightFactory.isRolePlayerLive(Role.WITCH)) return true;
    var action = WitchRoleGenerator.getRoleNightAction(nightFactory.actions);
    var player = action.getKillForPoison();
    isCanBiubiubiu = player != hunterId;
    return isCanBiubiubiu;
  }
}

@ToJsonEntity()
@JsonSerializable()
class HunterDayAction extends RoleAction {
  /// 如果使用技能，带走的玩家
  int? shutPlayerId;

  /// 是否放弃使用技能
  var isAbandon = false;

  bool canShut = true;

  HunterDayAction({
    this.isAbandon = false,
    this.canShut = true,
  }) : super(Role.HUNTER);

  factory HunterDayAction.fromJson(Map<String, dynamic> json) => _$HunterDayActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HunterDayActionToJson(this);

  bool isCanShut(DayFactory factory) {
    var hunter = factory.details.getForRole(Role.HUNTER);
    int hunterId = hunter.number;
    if (factory.round == 1 && hunterId <= 0) {
      throw AppError.hunterNoSelectPlayer.toExc();
    }
    // 获取昨晚情况
    var nightFactory = factory.lastNight();

    var action = WitchRoleGenerator.getRoleNightActionNullable(nightFactory.actions);
    if (null != action && !action.isKillNotUseSkill) {
      var player = action.getKillForPoison();
      var result = player != hunterId;
      return result;
    }
    return true;
  }

  @override
  void setToPlayerDetail(PlayerDetail detail, PlayerStateMap states) {
    super.setToPlayerDetail(detail, states);
    if (!canShut) return;
    if (!isYes) throw AppError.hunterNoSelectShutPlayer.toExc();
    var id = detail.getForRole(role).number;
    if (isAbandon) {
      states.set(id, PlayerStateType.abandonUsePower);
    } else if (shutPlayerId != null) {
      states.set(shutPlayerId!, PlayerStateType.isKillWithHunter);
      states.setKillPlayer(id, [shutPlayerId!]);
    } else {
      throw AppError.hunterNoSelectShutPlayer.toExc();
    }
  }
}

/// 猎人晚上行为
/// 主要是查看是否可以开枪
class _HunterNineActionComponent extends StatefulWidget {
  final GameFactory factory;
  final HunterAction action;
  final NightFactory nightFactory;
  final Function() finishCallback;

  const _HunterNineActionComponent(
    this.factory,
    this.action,
    this.nightFactory,
    this.finishCallback,
  );

  @override
  State<_HunterNineActionComponent> createState() => _HunterNineActionComponentState();
}

class _HunterNineActionComponentState extends State<_HunterNineActionComponent> {
  HunterAction get _action => widget.action;

  NightFactory get _nightFactory => widget.nightFactory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _action.isYes
            ? RichText(
                text: TextSpan(
                  style: app.baseFont.copyWith(color: Colors.black),
                  children: [
                    const TextSpan(text: "猎人的开枪状态为："),
                    TextSpan(
                      text: _action.isCanBiubiubiu ? "可以开枪" : "不可以开枪",
                      style: app.baseFont.copyWith(color: _action.isCanBiubiubiu ? Colors.green : Colors.red),
                    ),
                  ],
                ),
              )
            : TextButton(onPressed: check, child: const Text("检查猎人开枪状态")),
      ],
    );
  }

  final _isShowState = IsShowState();

  void check() {
    if (!_nightFactory.isAction(context, Role.HUNTER, _isShowState)) return;
    _action.checkCanBiubiubiu(_nightFactory);
    setState(() {
      _action.isYes = true;
      widget.finishCallback();
    });
  }
}

/// 猎人出局
class _HunterDayActionWidget extends StatefulWidget {
  final GameFactory factory;
  final DayFactory dayFactory;
  final HunterDayAction action;
  final Player outPlayer;
  final PlayerStates playerState;
  final Function(int killPlayer, Function() callYesFinish) callback;
  final Function(Function() callYesFinish) cancelCallback;

  const _HunterDayActionWidget(
    this.factory,
    this.dayFactory,
    this.action,
    this.outPlayer,
    this.playerState,
    this.callback,
    this.cancelCallback,
  );

  @override
  State<_HunterDayActionWidget> createState() => _HunterDayActionWidgetState();
}

class _HunterDayActionWidgetState extends State<_HunterDayActionWidget> {
  final _role = Role.HUNTER;

  DayFactory get _dayFactory => widget.dayFactory;

  HunterDayAction get _action => widget.action;

  TextStyle get _baseStyle => app.baseFont;

  TextStyle get _titleStyle => _baseStyle.copyWith(fontSize: 18);

  Player get _outPlayer => widget.outPlayer;

  PlayerStates get _playerState => widget.playerState;

  List<int> get _livePlayerIds => _dayFactory.playerDetails.getLivePlayer().map((e) => e.number).toList()
    ..removeWhere(
      (element) => element == _outPlayer.number,
    );

  int _defaultSelect = 0;

  final _isShow = IsShowState();

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
        Row(children: [Text("玩家 ${_outPlayer.number}号 ${_role.roleName}出局", style: _titleStyle)]),
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
          // return Text("玩家 ${_action.killWithHunter} 被 ${_role.roleName} 带走了 ");
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
      return Text("玩家 ${_outPlayer.number} 由于规则限制，无法使用技能");
    }
  }

  Widget _killPlayerWidget() => Column(
        children: [
          Text("${_role.roleName}可以选择带走一名玩家"),
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
