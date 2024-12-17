import 'package:annotation/annotation.dart';
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
import 'package:json_annotation/json_annotation.dart';

part 'WolfBeautyRoleGenerator.g.dart';

var _role = Role.wolfBeauty;

class WolfBeautyRoleGenerator extends RoleGenerator<WolfBeautyNightAction, WolfBeautyDayAction, EmptyRoleTempConfig> {
  WolfBeautyRoleGenerator({required super.factory}) : super(role: _role);

  @override
  RoleNightGenerator<WolfBeautyNightAction>? getNightRoundGenerator(NightFactory nightFactory) {
    return _WolfBeautyRoleRoundGenerator(nightFactory);
  }

  @override
  RoleDayRoundGenerator<WolfBeautyDayAction>? getDayRoundGenerator(DayFactory dayFactory) {
    return _WolfBeautyDayRoleRoundGenerator(dayFactory);
  }

  @override
  SecondSkillCheck? summarySecondSkillCheck(RoundFactory factory) {
    return _WolfBeautySummarySecondSkillCheck(factory);
  }
}

@ToJsonEntity()
@JsonSerializable()
class WolfBeautyNightAction extends RoleAction {
  int? charmPlayer;

  /// 是否放弃
  bool isAbandon = false;

  WolfBeautyNightAction() : super(_role);

  factory WolfBeautyNightAction.fromJson(Map<String, dynamic> json) => _$WolfBeautyNightActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WolfBeautyNightActionToJson(this);

  @override
  void setToPlayerDetail(PlayerDetail detail, PlayerStateMap states) {
    super.setToPlayerDetail(detail, states);
    if (!isYes) throw AppError.roleActionNotYes.toExc(args: [role.name]);
    if (isAbandon) return;
    if (charmPlayer == null) throw AppError.wolfBeautyNoSelectPlayer.toExc();

    /// 设置玩家被魅惑
    states.set(charmPlayer!, PlayerStateType.isCharmFormWolfBeauty);
  }

  void abandon() {
    charmPlayer = null;
    isAbandon = true;
    isYes = true;
  }

  void setCharmPlayer(int selectPlayer) {
    charmPlayer = selectPlayer;
    isAbandon = false;
    isYes = false;
  }
}

class _WolfBeautyRoleRoundGenerator extends RoleNightGenerator<WolfBeautyNightAction> with _WolfBeautyNightHelper {
  final NightFactory _nightFactory;

  _WolfBeautyRoleRoundGenerator(this._nightFactory) : super(roundFactory: _nightFactory, role: _role);

  @override
  JsonEntityData<WolfBeautyNightAction> actionJsonConvertor() => WolfBeautyNightActionJsonData();

  @override
  Widget actionWidget(Function() updateCallback) {
    return _WolfBeautyNightActionWidget(
      _nightFactory,
      this,
      action,
      cancelListener: (finishCallback) {
        action.abandon();
        saveAction();
        finishCallback();
      },
      updateCallback: (selectPlayer, finishCallback) {
        action.setCharmPlayer(selectPlayer);
        saveAction();
        finishCallback();
      },
    );
  }
}

class _WolfBeautySummarySecondSkillCheck extends SecondSkillCheck {
  final RoundFactory factory;

  _WolfBeautySummarySecondSkillCheck(this.factory);

  @override
  void check(PlayerDetail details, PlayerStateMap states) {
    var player = details.getForRole(_role);
    if (player.live) return;
    WolfBeautyNightAction action;
    // 获取狼美晚上的行动
    if (factory.isNight) {
      // 如果是晚上，就直接获取Action
      action = factory.getRoleAction(_role) as WolfBeautyNightAction;
    } else {
      // 如果是白天，就获取昨天的行动
      action = (factory as DayFactory).lastNight().getRoleAction(_role) as WolfBeautyNightAction;
    }

    if (!action.isYes) throw AppError.roleActionNotYes.toExc(args: [_role.name]);
    if (action.isAbandon) return;
    if ((action.charmPlayer ?? 0) <= 0) throw AppError.wolfBeautyNoSelectPlayer.toExc();

    states.set(action.charmPlayer!, PlayerStateType.isDieBecauseWolfBeautyDie);
  }
}

mixin _WolfBeautyNightHelper on RoleNightGenerator<WolfBeautyNightAction> {
  NightFactory get _nightFactory => roundFactory as NightFactory;

  List<int> get livePlayers => _nightFactory.getLivePlayer().map((e) => e.number).toList(growable: false);
}

class _WolfBeautyNightActionWidget extends StatefulWidget {
  final NightFactory _nightFactory;
  final _WolfBeautyNightHelper _helper;
  final WolfBeautyNightAction _action;
  final void Function(Function() finishCallback) cancelListener;
  final void Function(int selectPlayer, Function() finishCallback) updateCallback;

  const _WolfBeautyNightActionWidget(
    this._nightFactory,
    this._helper,
    this._action, {
    required this.cancelListener,
    required this.updateCallback,
  });

  @override
  State<_WolfBeautyNightActionWidget> createState() => _WolfBeautyNightActionWidgetState();
}

class _WolfBeautyNightActionWidgetState extends State<_WolfBeautyNightActionWidget> {
  NightFactory get _nightFactory => widget._nightFactory;

  _WolfBeautyNightHelper get _helper => widget._helper;

  WolfBeautyNightAction get _action => widget._action;

  var selectPlayer = 0;

  @override
  void initState() {
    super.initState();
    selectPlayer = _action.charmPlayer ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('狼美人：请选择你要魅惑的玩家'),
        RichText(
          text: TextSpan(
            style: app.baseFont.copyWith(color: Colors.black),
            children: [
              const TextSpan(text: '魅惑\t\t'),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: PlayerSingleSelectButton(
                  selectConfig: SelectConfig(
                    selectableList: _helper.livePlayers,
                    selectable: !_action.isYes,
                    defaultSelect: selectPlayer,
                    callback: (t) => setState(() => selectPlayer = t),
                  ),
                ),
              ),
              const TextSpan(text: '\t\t号玩家'),
            ],
          ),
        ),
        _button(),
      ],
    );
  }

  final _isShow = IsShowState();

  Widget _button() {
    if (_action.isYes) {
      if (_action.isAbandon) {
        return const Text('放弃使用技能');
      } else {
        return const Text('已确认选择');
      }
    } else {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                if (!_nightFactory.isAction(context, _role, _isShow)) return;

                if (selectPlayer <= 0) {
                  showSnackBarMessage("还没有选择要魅惑的玩家", isShow: _isShow);
                  return;
                }

                widget.cancelListener(() => setState(() {}));
              },
              child: const Text("放弃使用技能"),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () {
                if (!_nightFactory.isAction(context, _role, _isShow)) return;

                if (selectPlayer <= 0) {
                  showSnackBarMessage("还没有选择要魅惑的玩家", isShow: _isShow);
                  return;
                }

                widget.updateCallback(selectPlayer, () => setState(() {}));
              },
              child: const Text("确认你的选择"),
            ),
          ),
        ],
      );
    }
  }
}

@ToJsonEntity()
@JsonSerializable()
class WolfBeautyDayAction extends RoleAction {
  WolfBeautyDayAction() : super(_role);

  factory WolfBeautyDayAction.fromJson(Map<String, dynamic> json) => _$WolfBeautyDayActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WolfBeautyDayActionToJson(this);
}

class _WolfBeautyDayRoleRoundGenerator extends RoleDayRoundGenerator<WolfBeautyDayAction> {
  final DayFactory dayFactory;

  WolfBeautyNightAction get _lastNightAction => dayFactory.lastNight().getRoleAction(role) as WolfBeautyNightAction;

  _WolfBeautyDayRoleRoundGenerator(this.dayFactory) : super(role: _role, roundFactory: dayFactory);

  @override
  JsonEntityData<WolfBeautyDayAction> actionJsonConvertor() {
    return WolfBeautyDayActionJsonData();
  }

  @override
  Future<void> preAction() {
    // if(dayFactory.isDieForRole(role)){
    //
    // }
    action.isYes = true;
    saveAction();
    return super.preAction();
  }

  @override
  Widget? outWidget(Function() updateCallback) {
    return Column(
      children: [
        const Row(children: [Text("狼美人阵亡")]),
        _view(),
      ],
    );
  }

  Widget _view() {
    if (_lastNightAction.isAbandon) return const SizedBox();
    var charmPlayer = _lastNightAction.charmPlayer ?? 0;
    if (charmPlayer > 0 && !_lastNightAction.isAbandon) {
      return Text("昨晚被魅惑的$charmPlayer号玩家 一起出局（殉情）");
    } else {
      return const Text("昨晚狼美人并没有魅惑玩家。所以没有其他行为");
    }
  }
}
