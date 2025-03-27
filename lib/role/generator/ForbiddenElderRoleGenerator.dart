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

part 'ForbiddenElderRoleGenerator.g.dart';

// 禁言长老
var _role = Role.forbiddenElder;

class ForbiddenElderRoleGenerator extends RoleGenerator<ForbiddenElderNightAction, EmptyAction, EmptyRoleTempConfig> {
  ForbiddenElderRoleGenerator({required super.factory}) : super(role: _role);

  @override
  RoleNightGenerator<ForbiddenElderNightAction>? getNightRoundGenerator(NightFactory nightFactory) {
    return _ForbiddenElderNightRoundGenerator(nightFactory);
  }
}

@ToJsonEntity()
@JsonSerializable()
class ForbiddenElderNightAction extends RoleAction {
  int? selectPlayer;

  bool abandon = false;

  ForbiddenElderNightAction() : super(_role);

  factory ForbiddenElderNightAction.fromJson(Map<String, dynamic> json) => _$ForbiddenElderNightActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ForbiddenElderNightActionToJson(this);

  void bannedPlayer(int selectPlayer) {
    selectPlayer = selectPlayer;
    abandon = false;
    isYes = true;
  }

  void cancel() {
    selectPlayer = null;
    abandon = true;
    isYes = true;
  }

  @override
  void setToPlayerDetail(PlayerDetail detail, PlayerStateMap states) {
    super.setToPlayerDetail(detail, states);
    if (!isYes) throw AppError.roleActionNotYes.toExc(args: [role.nickname]);
    if (abandon) return;

    /// 设置玩家被禁言
    states.set(selectPlayer!, PlayerStateType.bannedOfShutUpForbiddenElder);
  }
}

class _ForbiddenElderNightRoundGenerator extends RoleNightGenerator<ForbiddenElderNightAction> {
  final NightFactory _nightFactory;

  _ForbiddenElderNightRoundGenerator(this._nightFactory) : super(role: _role, roundFactory: _nightFactory);

  @override
  JsonEntityData<ForbiddenElderNightAction> actionJsonConvertor() {
    return ForbiddenElderNightActionJsonData();
  }

  @override
  Widget actionWidget(Function() updateCallback) {
    return _ForbiddenElderNightView(
      _nightFactory,
      action,
      resultListener: (selectPlayer, finishCallback) {
        action.bannedPlayer(selectPlayer);
        saveAction();
        finishCallback();
      },
      cancelListener: (finishCallback) {
        action.cancel();
        saveAction();
        finishCallback();
      },
    );
  }
}

class _ForbiddenElderNightView extends StatefulWidget {
  final NightFactory _nightFactory;
  final ForbiddenElderNightAction _action;
  final Function(int selectPlayer, Function() finishCallback) resultListener;
  final Function(Function() finishCallback) cancelListener;

  const _ForbiddenElderNightView(
    this._nightFactory,
    this._action, {
    required this.resultListener,
    required this.cancelListener,
  });

  @override
  State<_ForbiddenElderNightView> createState() => _ForbiddenElderNightViewState();
}

class _ForbiddenElderNightViewState extends State<_ForbiddenElderNightView> {
  NightFactory get _nightFactory => widget._nightFactory;

  ForbiddenElderNightAction get _action => widget._action;

  List<int> get _livePlayer => _nightFactory.getLivePlayer().map((e) => e.number).toList(growable: false);

  int selectPlayer = 0;

  @override
  void initState() {
    super.initState();
    selectPlayer = _action.selectPlayer ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("禁言长老你可以指定一个玩家禁言，让他在天亮之后，一整个回合不能说话。"),
        RichText(
          text: TextSpan(
            style: app.baseFont,
            children: [
              const TextSpan(text: "选择玩家\t\t"),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: PlayerSingleSelectButton(
                  selectConfig: SelectConfig(
                    selectableList: _livePlayer,
                    defaultSelect: selectPlayer,
                    callback: (t) => setState(() => selectPlayer = t),
                  ),
                ),
              ),
              const TextSpan(text: "\t\t禁言"),
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
      return const Text("已确认禁言");
    } else {
      return Row(
        children: [
          Expanded(
              child: TextButton(
                  onPressed: () {
                    if (!_nightFactory.isAction(context, _role, _isShow)) return;
                    widget.cancelListener(() => setState(() {}));
                  },
                  child: const Text("取消"))),
          Expanded(
              child: TextButton(
                  onPressed: () {
                    if (!_nightFactory.isAction(context, _role, _isShow)) return;

                    if (selectPlayer <= 0) {
                      showSnackBarMessage("还未选择要禁言的玩家", isShow: _isShow);
                      return;
                    }

                    widget.resultListener(selectPlayer, () => setState(() {}));
                  },
                  child: const Text("确认禁言该玩家"))),
        ],
      );
    }
  }
}
