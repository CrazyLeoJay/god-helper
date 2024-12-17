import 'package:annotation/annotation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/framework/impl/NightFactory.dart';
import 'package:god_helper/role/generator/DefaultEmptyGenerator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'RobbersRoleGenerator.g.dart';

/// 盗贼
/// todo 由于盗贼角色需要额外增加两张身份牌给他选，模板配置和适配上会存在问题，这里先不加入盗贼角色
var _role = Role.robbers;

class RobbersRoleGenerator extends RoleGenerator<RobbersNightAction, EmptyAction, EmptyRoleTempConfig> {
  RobbersRoleGenerator({required super.factory}) : super(role: _role);

  @override
  RoleNightGenerator<RobbersNightAction>? getNightRoundGenerator(NightFactory nightFactory) {
    return _RobbersRoleNightGenerator(nightFactory);
  }
}

@ToJsonEntity()
@JsonSerializable()
class RobbersNightAction extends RoleAction {
  RobbersNightAction() : super(_role);

  factory RobbersNightAction.fromJson(Map<String, dynamic> json) => _$RobbersNightActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RobbersNightActionToJson(this);
}

class _RobbersRoleNightGenerator extends RoleNightGenerator<RobbersNightAction> {
  final NightFactory nightFactory;

  _RobbersRoleNightGenerator(this.nightFactory) : super(role: _role, roundFactory: nightFactory);

  @override
  JsonEntityData<RobbersNightAction> actionJsonConvertor() {
    return RobbersNightActionJsonData();
  }

  @override
  Widget actionWidget(Function() updateCallback) {
    return _RobbersNightActionComponent(nightFactory, action);
  }
}

class _RobbersNightActionComponent extends StatefulWidget {
  final NightFactory nightFactory;
  final RobbersNightAction action;

  const _RobbersNightActionComponent(this.nightFactory, this.action);

  @override
  State<_RobbersNightActionComponent> createState() => _RobbersNightActionComponentState();
}

class _RobbersNightActionComponentState extends State<_RobbersNightActionComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('盗贼'),
      ],
    );
  }
}
