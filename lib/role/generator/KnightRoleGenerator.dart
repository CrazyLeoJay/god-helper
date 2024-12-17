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

part 'KnightRoleGenerator.g.dart';

// 骑士
var _role = Role.knight;

class KnightRoleGenerator extends RoleGenerator<EmptyAction, KnightDayAction, EmptyRoleTempConfig> {
  KnightRoleGenerator({required super.factory}) : super(role: _role);

  @override
  RoleDayRoundGenerator<KnightDayAction>? getDayRoundGenerator(DayFactory dayFactory) {
    return _KnightRoleDayRoundGenerator(dayFactory);
  }
}

@ToJsonEntity()
@JsonSerializable()
class KnightDayAction extends RoleAction {
  int? targetPlayer;
  bool? targetPlayerIdentity;

  KnightDayAction() : super(_role);

  factory KnightDayAction.fromJson(Map<String, dynamic> json) => _$KnightDayActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$KnightDayActionToJson(this);

  void setTargetPlayer(int targetPlayer, bool identity) {
    this.targetPlayer = targetPlayer;
    targetPlayerIdentity = identity;
    isYes = true;
  }

  @override
  void setToPlayerDetail(PlayerDetail detail, PlayerStateMap states) {
    super.setToPlayerDetail(detail, states);

    /// 白天的技能，无需判断是否完成，没有完成即表示不使用技能
    if (!isYes) return;
    if (targetPlayer == null || targetPlayerIdentity == null) {
      throw AppError.roleNoSelectPlayer.toExc(args: [role.name]);
    }
    var player = detail.getForRole(role);

    if (player.identity) {
      /// 决斗玩家为好人，决斗失败，玩家阵亡
      states.set(player.number, PlayerStateType.knightDuelFailure);
      states.set(targetPlayer!, PlayerStateType.liveForKnightDuel);
    } else {
      /// 决斗玩家为坏人，决斗成功，被决斗玩家阵亡
      states.set(player.number, PlayerStateType.knightDuelSuccess);
      states.set(targetPlayer!, PlayerStateType.killForKnightDuel);
    }
  }
}

class _KnightRoleDayRoundGenerator extends RoleDayRoundGenerator<KnightDayAction> {
  final DayFactory dayFactory;

  _KnightRoleDayRoundGenerator(this.dayFactory) : super(roundFactory: dayFactory, role: _role);

  @override
  JsonEntityData<KnightDayAction> actionJsonConvertor() {
    return KnightDayActionJsonData();
  }

  @override
  Widget? activeSkillWidget(Function() updateCallback) {
    return _KnightActiveSkillComponent(
      dayFactory,
      action,
      resultListener: (targetPlayer, finishUpdateCallback) {
        var player = dayFactory.details.getForRole(role);
        action.setTargetPlayer(targetPlayer, player.identity);
        finishUpdateCallback();
      },
    );
  }
}

/// 骑士白天主动技能
class _KnightActiveSkillComponent extends StatefulWidget {
  final DayFactory dayFactory;
  final KnightDayAction action;
  final Function(int targetPlayer, Function() finishUpdateCallback) resultListener;

  const _KnightActiveSkillComponent(
    this.dayFactory,
    this.action, {
    required this.resultListener,
  });

  @override
  State<_KnightActiveSkillComponent> createState() => _KnightActiveSkillComponentState();
}

class _KnightActiveSkillComponentState extends State<_KnightActiveSkillComponent> {
  DayFactory get _dayFactory => widget.dayFactory;

  KnightDayAction get _action => widget.action;

  bool isAction = false;
  int targetPlayer = 0;

  @override
  void initState() {
    super.initState();
    targetPlayer = _action.targetPlayer ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    if (isAction) {
      return _skillActonWidget();
    } else {
      return _prepareWidget();
    }
  }

  /// 准备界面
  Widget _prepareWidget() {
    return SizedBox(
      height: 45,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Center(child: Text("骑士发动技能：")),
          TextButton(
            onPressed: () {
              setState(() {
                isAction = true;
              });
            },
            child: const Text("发动技能"),
          )
        ],
      ),
    );
  }

  final _isShow = IsShowState();

  /// 处理技能界面
  Widget _skillActonWidget() {
    return Column(
      children: [
        const Row(children: [Text("骑士发动技能：")]),
        RichText(
          text: TextSpan(
            style: app.baseFont,
            children: [
              const TextSpan(text: "骑士选择了\t\t"),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: PlayerSingleSelectButton(
                  selectConfig: SelectConfig(
                    selectableList: _dayFactory.getNowLivePlayer().map((e) => e.number).toList(growable: false),
                    selectable: !_action.isYes,
                    defaultSelect: targetPlayer,
                    callback: (t) => setState(() => targetPlayer = t),
                  ),
                ),
              ),
              const TextSpan(text: "\t\t作为目标，发动技能。"),
            ],
          ),
        ),
        _action.isYes ? _skillFinishView() : _buttonWidget(),
      ],
    );
  }

  Widget _buttonWidget() {
    return Row(
      children: [
        Expanded(
            child: TextButton(
                onPressed: () {
                  setState(() {
                    isAction = false;
                  });
                },
                child: const Text("取消发动"))),
        Expanded(
            child: TextButton(
                onPressed: () {
                  if (targetPlayer <= 0) {
                    showSnackBarMessage("骑士：还没有选择决斗对象", isShow: _isShow);
                    return;
                  }

                  widget.resultListener(targetPlayer, () => setState(() {}));
                },
                child: const Text("发动技能"))),
      ],
    );
  }

  Widget _skillFinishView() {
    return Text("骑士决斗了 ${_action.targetPlayer} 号玩家，他的身份是 ${(_action.targetPlayerIdentity ?? true) ? "好人" : "狼人"}");
  }
}
