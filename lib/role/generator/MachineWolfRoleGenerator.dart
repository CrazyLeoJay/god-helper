import 'package:annotation/annotation.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/role/generator/DefaultEmptyGenerator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'MachineWolfRoleGenerator.g.dart';

/// 机械狼
var _role = Role.machineWolf;

class MachineWolfRoleGenerator extends RoleGenerator<EmptyAction, EmptyAction, EmptyRoleTempConfig> {
  MachineWolfRoleGenerator({required super.factory}) : super(role: _role);
}

@ToJsonEntity()
@JsonSerializable()
class MachineWolfNightAction extends RoleAction {
  MachineWolfNightAction() : super(_role);

  factory MachineWolfNightAction.fromJson(Map<String, dynamic> json) => _$MachineWolfNightActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MachineWolfNightActionToJson(this);
}
