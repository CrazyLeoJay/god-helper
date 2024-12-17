import 'package:annotation/annotation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/exceptions.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/framework/impl/NightFactory.dart';
import 'package:god_helper/role/generator/DefaultEmptyGenerator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'BarbarianChildRoleGenerator.g.dart';

///野孩子
var _role = Role.barbarianChild;

class BarbarianChildRoleGenerator extends RoleGenerator<BarbarianChildNightAction, EmptyAction, EmptyRoleTempConfig> {
  BarbarianChildRoleGenerator({required super.factory}) : super(role: _role);

  @override
  RoleNightGenerator<BarbarianChildNightAction>? getNightRoundGenerator(NightFactory nightFactory) {
    return _BarbarianChildNightRoleRoundGenerator(nightFactory);
  }

  @override
  SecondSkillCheck? summarySecondSkillCheck(RoundFactory factory) {
    return _BarbarianChildSecondSkillCheck(factory);
  }
}

@ToJsonEntity()
@JsonSerializable()
class BarbarianChildNightAction extends RoleAction {
  int? selectPlayer;

  BarbarianChildNightAction() : super(_role);

  factory BarbarianChildNightAction.fromJson(Map<String, dynamic> json) => _$BarbarianChildNightActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BarbarianChildNightActionToJson(this);

  @override
  void setToPlayerDetail(PlayerDetail detail, PlayerStateMap states) {
    super.setToPlayerDetail(detail, states);
    if (!isYes) throw AppError.roleActionNotYes.toExc(args: [role.name]);

    if (selectPlayer != null) {
      states.set(selectPlayer!, PlayerStateType.barbarianChildExample);
    }
  }
}

class _BarbarianChildNightRoleRoundGenerator extends RoleNightGenerator<BarbarianChildNightAction> {
  final NightFactory _nightFactory;

  _BarbarianChildNightRoleRoundGenerator(this._nightFactory) : super(roundFactory: _nightFactory, role: _role);

  @override
  Future<void> preAction() {
    if (_nightFactory.round > 1 && !action.isYes) {
      /// 如果不是第一天，直接设置为true
      action.isYes = true;
      saveAction();
    }
    return super.preAction();
  }

  @override
  JsonEntityData<BarbarianChildNightAction> actionJsonConvertor() {
    return BarbarianChildNightActionJsonData();
  }

  @override
  Widget actionWidget(Function() updateCallback) {
    return _BarbarianChildNightView(_nightFactory, action, selectListener: (selectPlayer, finishCallback) {
      if (_nightFactory.round == 1) {
        action.selectPlayer = selectPlayer;
        action.isYes = true;
        saveAction();
        finishCallback();
      } else {
        throw AppError.barbarianChildSelectPlayerOnlyFirstNight.toExc();
      }
    });
  }
}

class _BarbarianChildNightView extends StatefulWidget {
  final NightFactory nightFactory;
  final BarbarianChildNightAction action;
  final Function(int selectPlayer, void Function() finishCallback) selectListener;

  const _BarbarianChildNightView(this.nightFactory, this.action, {required this.selectListener});

  @override
  State<_BarbarianChildNightView> createState() => _BarbarianChildNightViewState();
}

class _BarbarianChildNightViewState extends State<_BarbarianChildNightView> {
  NightFactory get _nightFactory => widget.nightFactory;

  BarbarianChildNightAction get _action => widget.action;

  int get _round => _nightFactory.round;

  int selectPlayer = 0;

  @override
  void initState() {
    super.initState();
    selectPlayer = _action.selectPlayer ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    if (_round == 1) {
      return Column(
        children: [
          const Text("你需要选择你的榜样，且必须选择"),
          RichText(
            text: TextSpan(
              style: app.baseFont.copyWith(),
              children: [
                const TextSpan(text: "选择\t\t\t"),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: PlayerSingleSelectButton(
                    selectConfig: SelectConfig.forCount(
                      count: _nightFactory.entity.tempConfig.playerCount,
                      defaultSelect: selectPlayer,
                      selectable: !_action.isYes,
                      callback: (t) => setState(() => selectPlayer = t),
                    ),
                  ),
                ),
                const TextSpan(text: "\t\t\t号玩家成为你的榜样"),
              ],
            ),
          ),
          _button(),
        ],
      );
    } else {
      return Text("野孩子的榜样是 $selectPlayer 号玩家");
    }
  }

  final _isShow = IsShowState();

  Widget _button() {
    if (_action.isYes) {
      return Text("你选择了 $selectPlayer 号玩家作为榜样");
    } else {
      return TextButton(
          onPressed: () {
            if (!_nightFactory.isAction(context, _role, _isShow)) return;

            if (selectPlayer <= 0) {
              showSnackBarMessage("还未选择野孩子的榜样", isShow: _isShow);
              return;
            }

            widget.selectListener(selectPlayer, () => setState(() {}));
          },
          child: const Text("确认你的榜样"));
    }
  }
}

/// 野孩子二次技能判断
class _BarbarianChildSecondSkillCheck extends SecondSkillCheck {
  final RoundFactory _factory;

  _BarbarianChildSecondSkillCheck(this._factory);

  /// 获取第一晚的情况
  NightFactory get _firstNight => (_factory.round == 1 ? (_factory as NightFactory) : _factory.factory.getNight(1));

  /// 根据野孩子的规则
  /// 如果榜样阵亡，则身份要发生变化，无论白天黑夜
  @override
  void check(PlayerDetail details, PlayerStateMap states) {
    // 二次检查时，角色早已设置过
    var player = details.getForRole(_role);
    var action = _firstNight.getRoleAction(_role) as BarbarianChildNightAction;
    var examplePlayer = action.selectPlayer!;
    if (_factory.isNight) {
      if (!details.get(examplePlayer).live) {
        // 成为狼人
        player.roleType = RoleType.WOLF;
        states.set(player.number, PlayerStateType.barbarianChildChangeWolfForExampleDie);
      }
    } else {
      // 白天需要多重判断
      // 白天时，states 传入为当前回合，白天的玩家实时状态
      // 如果之前回合榜样出局或者当前回合榜样出局，则野孩子转变为狼人
      if (!details.get(examplePlayer).live || (states.getNullable(examplePlayer)?.isDead ?? false)) {
        // 成为狼人
        player.roleType = RoleType.WOLF;
        states.set(player.number, PlayerStateType.barbarianChildChangeWolfForExampleDie);
      }
    }
  }
}
