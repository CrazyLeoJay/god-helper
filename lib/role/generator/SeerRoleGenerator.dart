import 'dart:convert';

import 'package:annotation/annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/framework/impl/NightFactory.dart';
import 'package:json_annotation/json_annotation.dart';

part 'SeerRoleGenerator.g.dart';

class SeerRoleGenerator extends RoleGenerator<SeerAction, SeerAction, EmptyRoleTempConfig> {
  SeerRoleGenerator({required super.factory}) : super(role: Role.seer);

  @override
  RoleNightGenerator<SeerAction>? getNightRoundGenerator(NightFactory nightFactory) {
    return _SeerRoleRoundGenerator(nightFactory);
  }
}

@ToJsonEntity()
@JsonSerializable(constructor: "createJson")
class SeerAction extends RoleAction {
  /// 选择查验玩家
  int checkPlayer = 0;
  bool identity = true;

  SeerAction() : super(Role.seer);

  SeerAction.createJson({this.checkPlayer = 0, this.identity = true}) : super(Role.seer);

  factory SeerAction.fromJson(Map<String, dynamic> json) => _$SeerActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SeerActionToJson(this);

  @override
  void setToPlayerDetail(PlayerDetail detail, PlayerStateMap states) {
    states.set(checkPlayer, PlayerStateType.isCheckedForSeer);
  }
}

class _SeerRoleRoundGenerator extends RoleNightGenerator<SeerAction> {
  final NightFactory nightFactory;

  _SeerRoleRoundGenerator(this.nightFactory) : super(roundFactory: nightFactory, role: Role.seer);

  @override
  Widget actionWidget(Function() updateCallback) {
    return SeerActionComponent(super.factory, nightFactory, action, round, () {
      if (kDebugMode) print("SeerAction：${jsonEncode(action)}");
      saveAction();
    });
  }

  @override
  JsonEntityData<SeerAction> actionJsonConvertor() => SeerActionJsonData();
}

/// 预言家动作组件
class SeerActionComponent extends StatefulWidget {
  final GameFactory factory;
  final NightFactory nightFactory;
  final int round;
  final SeerAction action;
  final Function() finishCallback;

  const SeerActionComponent(this.factory, this.nightFactory, this.action, this.round, this.finishCallback, {super.key});

  @override
  State<SeerActionComponent> createState() => _SeerActionComponentState();
}

/// 预言家动作组件状态
class _SeerActionComponentState extends State<SeerActionComponent> {
  TextStyle get _baseTs => app.font.base;

  GameFactory get _factory => widget.factory;

  GameTemplateConfigEntity get tempConfig => _factory.entity.tempConfig;

  SeerAction get action => widget.action;

  List<Player> get livePlayers => widget.nightFactory.getLivePlayer();

  final IsShowState isShow = IsShowState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _roleActorLinesText(),
        const SizedBox(height: 8),
        const Text("（玩家手势选择）"),
        const SizedBox(height: 8),
        RichText(
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
          text: TextSpan(
            style: _baseTs.copyWith(color: Colors.black, fontSize: 16.0),
            children: [
              const TextSpan(text: "今晚你要查验"),
              const WidgetSpan(child: SizedBox(width: 8)),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: PlayerSingleSelectButton.initConfig(
                  config: SelectConfig(
                    circleSize: 36,
                    selectableList: livePlayers.map((e) => e.number).toList(),
                    defaultSelect: action.checkPlayer,
                    callback: (element) {
                      widget.action.checkPlayer = element;
                      widget.action.identity = widget.nightFactory.checkIdentityIsGoodboy(element);
                      setState(() {});
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
        // TextButton(onPressed: () {}, child: const Text("确认查验？"))
        _CheckButton(),
      ],
    );
  }

  Widget _CheckButton() {
    if (action.isYes) {
      return RichText(
        text: TextSpan(
          style: app.baseFont.copyWith(color: Colors.black),
          children: [
            const TextSpan(text: "玩家"),
            TextSpan(
              text: " ${action.checkPlayer}号 ",
              style: app.baseFont.copyWith(color: Colors.black, fontSize: 24),
            ),
            const TextSpan(text: "他的身份是 "),
            TextSpan(
              text: action.identity ? "好人。" : "狼人!",
              style: app.baseFont.copyWith(color: action.identity ? Colors.green : Colors.red, fontSize: 24),
            )
          ],
        ),
      );
    } else {
      return TextButton(
          onPressed: () {
            if (!widget.nightFactory.isAction(context, Role.seer, isShow)) {
              return;
            }

            if (action.checkPlayer <= 0) {
              showSnackBarMessage("请预言家选择要查验的玩家", isShow: isShow);
              return;
            }

            action.isYes = true;
            setState(() {});
            widget.finishCallback();
          },
          child: const Text("确认查验该玩家？"));
    }
  }

  /// 角色台词
  Widget _roleActorLinesText() => RichText(
        text: TextSpan(
          style: _baseTs.copyWith(color: Colors.black, fontSize: 14.0),
          children: [
            TextSpan(
              text: "预言家",
              style: _baseTs.copyWith(color: Colors.red),
            ),
            const TextSpan(text: "请选择你今晚要查验的对象！"),
          ],
        ),
      );
}
