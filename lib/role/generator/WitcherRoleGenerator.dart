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

part 'WitcherRoleGenerator.g.dart';

/// 猎魔人
var _role = Role.witcher;

class WitcherRoleGenerator extends RoleGenerator<WitcherNightAction, EmptyAction, EmptyRoleTempConfig> {
  WitcherRoleGenerator({required super.factory}) : super(role: _role);

  @override
  RoleNightGenerator<WitcherNightAction>? getNightRoundGenerator(NightFactory nightFactory) {
    return _WitcherRoleNightGenerator(nightFactory);
  }
}

@ToJsonEntity()
@JsonSerializable()
class WitcherNightAction extends RoleAction {
  int? selectPlayer;

  bool isAbandon = false;

  WitcherNightAction() : super(_role);

  factory WitcherNightAction.fromJson(Map<String, dynamic> json) => _$WitcherNightActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WitcherNightActionToJson(this);

  void setAbandon() {
    selectPlayer = null;
    isAbandon = true;
    isYes = true;
  }

  void setSelectPlayer(int selectIndex) {
    this.selectPlayer = selectIndex;
    isAbandon = false;
    isYes = true;
  }

  @override
  void setToPlayerDetail(PlayerDetail detail, PlayerStateMap states) {
    super.setToPlayerDetail(detail, states);
    if (!isYes) throw AppError.roleActionNotYes.toExc(args: [role.name]);
    if (isAbandon) return;
    if (selectPlayer == null) throw AppError.roleNoSelectPlayer.toExc(args: [role.name]);
    var player = detail.get(selectPlayer!);
    if (player.roleType == RoleType.WOLF) {
      states.set(selectPlayer!, PlayerStateType.killInWitcherHunt);
    } else {
      states.set(player.number, PlayerStateType.killInWitcherHuntFailure);
    }
  }
}

class _WitcherRoleNightGenerator extends RoleNightGenerator<WitcherNightAction> {
  NightFactory nightFactory;

  _WitcherRoleNightGenerator(this.nightFactory) : super(roundFactory: nightFactory, role: _role);

  @override
  JsonEntityData<WitcherNightAction> actionJsonConvertor() {
    return WitcherNightActionJsonData();
  }

  @override
  Widget actionWidget(Function() updateCallback) {
    return _WitcherNightActionComponent(
      nightFactory,
      action,
      abandonSkillListener: (finishCallback) {
        action.setAbandon();
        saveAction();
        finishCallback();
      },
      resultListener: (selectIndex, finishCallback) {
        action.setSelectPlayer(selectIndex);
        saveAction();
        finishCallback();
      },
    );
  }
}

class _WitcherNightActionComponent extends StatefulWidget {
  final NightFactory nightFactory;
  final WitcherNightAction action;
  final Function(Function() finishCallback) abandonSkillListener;
  final Function(int selectIndex, Function() finishCallback) resultListener;

  const _WitcherNightActionComponent(
    this.nightFactory,
    this.action, {
    required this.abandonSkillListener,
    required this.resultListener,
  });

  @override
  State<_WitcherNightActionComponent> createState() => _WitcherNightActionComponentState();
}

class _WitcherNightActionComponentState extends State<_WitcherNightActionComponent> {
  NightFactory get _nightFactory => widget.nightFactory;

  WitcherNightAction get _action => widget.action;

  int selectPlayer = 0;

  @override
  void initState() {
    super.initState();
    selectPlayer = _action.selectPlayer ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    // if (_nightFactory.round == 1) {
    //   return const Text("第一晚没有操作");
    // } else {
    //   return _witcherActionView();
    // }
    return _witcherActionView();
  }

  Widget _witcherActionView() {
    return Column(
      children: [
        const Text("猎魔人请选择你要狩猎的对象"),
        RichText(
          text: TextSpan(
            style: app.baseFont,
            children: [
              const TextSpan(text: "猎人选择了\t\t\t"),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: PlayerSingleSelectButton(
                  selectConfig: SelectConfig(
                    selectableList: _nightFactory.getLivePlayerIds(),
                    defaultSelect: selectPlayer,
                    callback: (t) => setState(() => selectPlayer = t),
                  ),
                ),
              ),
              const TextSpan(text: "\t\t\t号玩家进行狩猎"),
            ],
          ),
        ),
        _action.isYes ? _resultView() : _buttonWidget(),
      ],
    );
  }

  final _isShow = IsShowState();

  Widget _buttonWidget() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              if (!_nightFactory.isAction(context, _role, _isShow)) return;
              widget.abandonSkillListener(() => setState(() {}));
            },
            child: const Text("放弃使用技能"),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () {
              if (!_nightFactory.isAction(context, _role, _isShow)) return;

              if (selectPlayer < 0) {
                showSnackBarMessage("猎魔人还未选择目标", isShow: _isShow);
                return;
              }

              widget.resultListener(selectPlayer, () => setState(() {}));
            },
            child: const Text("确定猎魔该玩家"),
          ),
        ),
      ],
    );
  }

  Widget _resultView() {
    if (_action.isAbandon) {
      return const Text("猎魔人放弃使用了技能");
    } else {
      return Text("猎魔人选择了${_action.selectPlayer}号玩家进行狩猎");
    }
  }
}
