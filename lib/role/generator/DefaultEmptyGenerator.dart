import 'package:annotation/annotation.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'DefaultEmptyGenerator.g.dart';

/// 默认空的配置
class DefaultEmptyGenerator extends RoleGenerator<EmptyAction, EmptyAction, EmptyRoleTempConfig> {
  DefaultEmptyGenerator({required super.factory, required super.role});
}

@ToJsonEntity()
@JsonSerializable()
class EmptyAction extends RoleAction {
  EmptyAction() : super(Role.EMPTY);

  factory EmptyAction.fromJson(Map<String, dynamic> json) => _$EmptyActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EmptyActionToJson(this);
}
