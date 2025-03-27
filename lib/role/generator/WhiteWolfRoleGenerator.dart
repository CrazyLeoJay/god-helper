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
import 'package:god_helper/role/generator/DefaultEmptyGenerator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'WhiteWolfRoleGenerator.g.dart';

var _role = Role.whiteWolfKing;

class WhiteWolfKingRoleGenerator extends RoleGenerator<EmptyAction, WhiteWolfKingDayAction, EmptyRoleTempConfig> {
  WhiteWolfKingRoleGenerator({required super.factory}) : super(role: _role);

  @override
  RoleDayRoundGenerator<WhiteWolfKingDayAction>? getDayRoundGenerator(DayFactory dayFactory) {
    return _WhiteWolfKingDayRoleGenerator(dayFactory);
  }
}

@ToJsonEntity()
@JsonSerializable()
class WhiteWolfKingDayAction extends RoleAction {
  /// 被带走的玩家
  int? killPlayer;
  bool isAbandonSkill = false;

  WhiteWolfKingDayAction() : super(_role);

  factory WhiteWolfKingDayAction.fromJson(Map<String, dynamic> json) => _$WhiteWolfKingDayActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WhiteWolfKingDayActionToJson(this);

  @override
  void setToPlayerDetail(PlayerDetail detail, PlayerStateMap states) {
    super.setToPlayerDetail(detail, states);
    if (!isYes) throw AppError.roleActionNotYes.toExc(args: [role.nickname]);
    if (isAbandonSkill) return;
    if (killPlayer == null) throw AppError.roleActionNotKillPlayer.toExc(args: [role.nickname]);

    /// 设置击杀情况
    var player = detail.getForRole(role);
    states.set(killPlayer!, PlayerStateType.isKillWithWhiteWolfKing);
    states.setKillPlayer(player.number, [killPlayer!]);
  }

  /// 放弃使用技能
  void abandonSkill() {
    killPlayer = null;
    isAbandonSkill = true;
    isYes = true;
  }

  void kill(int killPlayer) {
    this.killPlayer = killPlayer;
    isAbandonSkill = false;
    isYes = true;
  }
}

class _WhiteWolfKingDayRoleGenerator extends RoleDayRoundGenerator<WhiteWolfKingDayAction> with _ActionHelper {
  @override
  final DayFactory dayFactory;

  _WhiteWolfKingDayRoleGenerator(this.dayFactory) : super(roundFactory: dayFactory, role: Role.whiteWolfKing);

  @override
  JsonEntityData<WhiteWolfKingDayAction> actionJsonConvertor() {
    return WhiteWolfKingDayActionJsonData();
  }

  @override
  Widget? outWidget(Function() updateCallback) {
    return _WhiteWOlfKingDayActionWidget(
      dayFactory,
      action,
      this,
      cancelCallback: (finishCallback) {
        action.abandonSkill();
        saveAction();
        finishCallback();
      },
      killPlayerCallback: (killPlayer, finishCallback) {
        action.kill(killPlayer);
        saveAction();
        finishCallback();
      },
    );
  }
}

mixin _ActionHelper on RoleDayRoundGenerator<WhiteWolfKingDayAction> {
  DayFactory get dayFactory => roundFactory as DayFactory;

  List<int> getLivePlayer() => dayFactory.getNowLivePlayer().map((e) => e.number).toList();
}

/// 白狼王白天行动
class _WhiteWOlfKingDayActionWidget extends StatefulWidget {
  final DayFactory dayFactory;

  /// 白狼王的行动
  final WhiteWolfKingDayAction action;
  final _ActionHelper helper;

  /// 取消使用技能回调
  final Function(Function() finishCallback) cancelCallback;

  /// 带走玩家回调
  final Function(int killPlayer, Function() finishCallback) killPlayerCallback;

  const _WhiteWOlfKingDayActionWidget(this.dayFactory, this.action, this.helper,
      {required this.cancelCallback, required this.killPlayerCallback});

  @override
  State<_WhiteWOlfKingDayActionWidget> createState() => _WhiteWOlfKingDayActionWidgetState();
}

/// 白狼王自爆时可以带走一个玩家
class _WhiteWOlfKingDayActionWidgetState extends State<_WhiteWOlfKingDayActionWidget> {
  DayFactory get _factory => widget.dayFactory;

  WhiteWolfKingDayAction get _action => widget.action;

  _ActionHelper get _helper => widget.helper;

  TextStyle get _font => context.app.baseFont;

  int killPlayer = 0;

  bool get _isYes => _action.isYes;

  @override
  void initState() {
    super.initState();
    killPlayer = _action.killPlayer ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("(白狼王自爆了)，你可以发动技能选择带走一名玩家"),
        RichText(
          text: TextSpan(
            style: _font,
            children: [
              const TextSpan(text: "你选择带走\t\t"),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: PlayerSingleSelectButton(
                  selectConfig: SelectConfig(
                    selectableList: _helper.getLivePlayer(),
                    selectable: !_isYes,
                    defaultSelect: killPlayer,
                    callback: (t) => setState(() => killPlayer = t),
                  ),
                ),
              ),
              const TextSpan(text: "\t\t号玩家"),
            ],
          ),
        ),
        _buttonWidget(),
      ],
    );
  }

  final _isShow = IsShowState();

  Widget _buttonWidget() {
    if (_isYes) {
      return const Text("已确认行为");
    } else {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => widget.cancelCallback(() => setState(() {})),
              child: const Text("不带走任何人"),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () {
                if (killPlayer <= 0) {
                  showSnackBarMessage("还没有选择要带走的玩家", isShow: _isShow);
                  return;
                }
                widget.killPlayerCallback(killPlayer, () => setState(() {}));
              },
              child: const Text("确认行为"),
            ),
          ),
        ],
      );
    }
  }
}
