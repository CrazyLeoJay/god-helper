

// part 'RobbersRoleGenerator.g.dart';

/// 盗贼
/// todo 由于盗贼角色需要额外增加两张身份牌给他选，模板配置和适配上会存在问题，这里先不加入盗贼角色
// var _role = Role.robbers;
//
// class RobbersRoleGenerator extends RoleGenerator<RobbersNightAction, EmptyAction, RobbersTempExtraConfig> {
//   RobbersRoleGenerator({required super.factory}) : super(role: _role);
//
//   @override
//   TempExtraGenerator<RobbersTempExtraConfig>? extraRuleGenerator() {
//     return RobbersTempExtraGenerator(super.factory, role);
//   }
//
//   @override
//   RoleNightGenerator<RobbersNightAction>? getNightRoundGenerator(NightFactory nightFactory) {
//     return _RobbersRoleNightGenerator(nightFactory);
//   }
// }
//
// @ToJsonEntity()
// @JsonSerializable()
// class RobbersTempExtraConfig extends RoleTempConfig<RobbersTempExtraConfig> {
//   RobbersIdentitySelectWay identitySelectWay;
//
//   RobbersTempExtraConfig({this.identitySelectWay = RobbersIdentitySelectWay.tempRole});
//
//   factory RobbersTempExtraConfig.fromJson(Map<String, dynamic> json) => _$RobbersTempExtraConfigFromJson(json);
//
//   @override
//   Map<String, dynamic> toJson() => _$RobbersTempExtraConfigToJson(this);
//
//   @override
//   RobbersTempExtraConfig createForMap(Map<String, dynamic> map) {
//     return RobbersTempExtraConfig.fromJson(map);
//   }
//
//   @override
//   RobbersTempExtraConfig emptyReturn() {
//     return this;
//   }
// }
//
// enum RobbersIdentitySelectWay {
//   tempRole("在游戏模板内选择"),
//   extraRole("需要配置额外的角色"),
//   ;
//
//   final String desc;
//
//   const RobbersIdentitySelectWay(this.desc);
// }
//
// class RobbersTempExtraGenerator extends TempExtraGenerator<RobbersTempExtraConfig> {
//   RobbersTempExtraGenerator(super.factory, super.role);
//
//   @override
//   List<String> configResultMessage() {
//     // TODO: implement configResultMessage
//     throw UnimplementedError();
//   }
//
//   @override
//   RobbersTempExtraConfig initExtraConfigEntity() {
//     // TODO: implement initExtraConfigEntity
//     throw UnimplementedError();
//   }
//
//   @override
//   Widget tempView({bool isPreview = false}) {
//     // TODO: implement tempView
//     throw UnimplementedError();
//   }
// }
//
// @ToJsonEntity()
// @JsonSerializable()
// class RobbersNightAction extends RoleAction {
//   RobbersNightAction() : super(_role);
//
//   factory RobbersNightAction.fromJson(Map<String, dynamic> json) => _$RobbersNightActionFromJson(json);
//
//   @override
//   Map<String, dynamic> toJson() => _$RobbersNightActionToJson(this);
// }
//
// class _RobbersRoleNightGenerator extends RoleNightGenerator<RobbersNightAction> {
//   final NightFactory nightFactory;
//
//   _RobbersRoleNightGenerator(this.nightFactory) : super(role: _role, roundFactory: nightFactory);
//
//   @override
//   JsonEntityData<RobbersNightAction> actionJsonConvertor() {
//     return RobbersNightActionJsonData();
//   }
//
//   @override
//   Widget actionWidget(Function() updateCallback) {
//     return _RobbersNightActionComponent(nightFactory, action);
//   }
// }
//
// class _RobbersNightActionComponent extends StatefulWidget {
//   final NightFactory nightFactory;
//   final RobbersNightAction action;
//
//   const _RobbersNightActionComponent(this.nightFactory, this.action);
//
//   @override
//   State<_RobbersNightActionComponent> createState() => _RobbersNightActionComponentState();
// }
//
// class _RobbersNightActionComponentState extends State<_RobbersNightActionComponent> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text('盗贼'),
//       ],
//     );
//   }
// }
