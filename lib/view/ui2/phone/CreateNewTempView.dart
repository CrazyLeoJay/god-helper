import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/entity/RuleConfig.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/AppFactory.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// 创建新模板界面
class CreateNewTempView extends StatefulWidget {
  /// 参考填充值
  final GameTemplateConfigEntity? defaultValue;

  const CreateNewTempView({super.key, this.defaultValue});

  @override
  State<CreateNewTempView> createState() => _CreateNewTempViewState();
}

class _CreateNewTempViewState extends State<CreateNewTempView> {
  String tempName = "";

  int get playerCount => _roleConfigSummary.count();

  /// 普通村民数量
  int ordinaryCitizenCount = 0;

  /// 普通狼人数量
  int ordinaryWolfCount = 0;

  /// 不同类型角色数量
  Map<RoleType, List<Role>> roleConfig = {};

  /// 获取一个角色配置的汇总类
  TemplateRoleConfig get _roleConfigSummary => TemplateRoleConfig(
        citizenCount: ordinaryCitizenCount,
        wolfCount: ordinaryWolfCount,
        roles: roleConfig,
      );

  /// 模板工厂，用来显示界面和存数据
  final GameFactory _temp = AppFactory().temp();

  /// 额外规则
  TempExtraRule get extraRule => _temp.extraRule..initSheriff();

  // 二级标题
  TextStyle get _secondTitleStyle => app.baseFont.copyWith(fontSize: 22);

  // 正文
  TextStyle get _contentTitleStyle => app.baseFont.copyWith(fontSize: 16);

  /// 已经选择过的
  List<Role> get _alreadySelectedRole {
    List<Role> list = [];
    for (var item in roleConfig.values) {
      list.addAll(item);
    }
    return list.toSet().toList();
  }

  /// 所有可以选择的角色
  final List<Role> _canSelectRole = Role.getRoles();

  /// 未被选择的角色
  // List<Role> get _noSelectRoles => [..._canSelectRole]..removeWhere((element) => _alreadySelectedRole.contains(element));

  Map<RoleType, List<Role>> get _canSelectForTypeMap => {
        RoleType.CITIZEN: [..._canSelectRole]..removeWhere(
            (role) =>
                ![RoleType.CITIZEN, RoleType.GOD].contains(role.type) ||
                ((roleConfig[RoleType.GOD] ?? []).contains(role)),
          ),
        RoleType.GOD: [..._canSelectRole]..removeWhere(
            (role) =>
                ![RoleType.CITIZEN, RoleType.GOD].contains(role.type) ||
                ((roleConfig[RoleType.CITIZEN] ?? []).contains(role)),
          ),
        RoleType.THIRD: [..._canSelectRole]..removeWhere(
            (element) => element.type != RoleType.THIRD,
          ),
        RoleType.WOLF: [..._canSelectRole]..removeWhere(
            (element) => element.defaultIdentity,
          ),
      };

  // 样式

  double lineSize = 16;

  final TextEditingController _tempNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tempNameController.addListener(() {
      tempName = _tempNameController.text;
    });
    // if (tempName.isEmpty) {
    // }
    if (widget.defaultValue != null) {
      var dv = widget.defaultValue!;
      _tempNameController.text = tempName = dv.name;
      ordinaryCitizenCount = dv.roleConfig.citizenCount;
      ordinaryWolfCount = dv.roleConfig.wolfCount;
      roleConfig = dv.roleConfig.roles;
      _temp.entity.extraRule = dv.extraRule;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("创建新模板")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(children: [
                Expanded(
                  flex: 0,
                  child: Text("模板名称 :", style: _secondTitleStyle),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    autofocus: false,
                    controller: _tempNameController,
                    decoration: const InputDecoration(hintText: '请设置模板名称'),
                  ),
                ),
              ]),
              Row(
                children: [
                  Expanded(
                    child: Text("建议名字：${_roleConfigSummary.toSimpleName()}"),
                  ),
                  Expanded(
                    flex: 0,
                    child: TextButton(
                      onPressed: () => setState(() {
                        _tempNameController.text = _roleConfigSummary.toSimpleName();
                      }),
                      child: const Text("填入建议名称"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(children: [Text("人数设定", style: _secondTitleStyle)]),
              Row(children: [
                Expanded(
                  flex: 0,
                  child: Text("普通村民: ", style: _contentTitleStyle),
                ),
                Expanded(
                    child: _numberSetting(
                  ordinaryCitizenCount,
                  (count) => ordinaryCitizenCount += count,
                )),
              ]),
              Row(children: [
                Expanded(
                  flex: 0,
                  child: Text("普通狼人: ", style: _contentTitleStyle),
                ),
                Expanded(
                  child: _numberSetting(
                    ordinaryWolfCount,
                    (count) => ordinaryWolfCount += count,
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              SizedBox(width: double.maxFinite, child: _numberSummary()),
              const SizedBox(height: 8),
              Row(children: [Text("配置不同阵营角色", style: _secondTitleStyle)]),
              _roleSetting(),
              const SizedBox(height: 8),
              Row(children: [Text("警长规则配置", style: _secondTitleStyle)]),
              const SizedBox(height: 8),
              RadioGroup(
                config: RadioConfig<SheriffRace>.list(
                  selectItem: SheriffRace.values,
                  defaultValue: extraRule.getSheriffConfig().sheriffRace,
                  callback: (value) => extraRule.setSheriffConfig(value),
                  showText: (value) => value.desc,
                ),
              ),
              const SizedBox(height: 8),
              Row(children: [Text("胜利条件配置", style: _secondTitleStyle)]),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RadioGroup(
                  config: RadioConfig<WinRule>.grid(
                    selectItem: WinRule.values,
                    defaultValue: extraRule.winRule,
                    gridChildAspectRatio: 3 / 1,
                    callback: (value) => setState(() => extraRule.winRule = value),
                    showText: (value) => value.desc,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(children: [Text("角色特殊规则默认配置", style: _secondTitleStyle)]),
              _extraView(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(onPressed: _summaryCreateTempToPreview, child: const Text("创建配置，并去查看预览")),
      ),
    );
  }

  Widget _numberSetting(int count, Function(int count) countSum) {
    return SizedBox(
      height: lineSize * 2,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          IconButton(
            onPressed: () => setState(() {
              if (count > 1) countSum(-1);
            }),
            icon: Icon(PhosphorIcons.minus(), size: lineSize),
          ),
          Center(child: Text("${count.toInt()}")),
          IconButton(
            onPressed: () => setState(() => countSum(1)),
            icon: Icon(PhosphorIcons.plus(), size: lineSize),
          ),
        ],
      ),
    );
  }

  Widget _numberSummary() => Text(
        "总计："
        "神${_roleConfigSummary.gods.length} "
        "+ 狼${(_roleConfigSummary.wolfs.length) + ordinaryWolfCount} "
        "+ 民${(_roleConfigSummary.citizen.length) + ordinaryCitizenCount} "
        "+ 三${_roleConfigSummary.thirds.length} "
        "= ${(_roleConfigSummary.count())} 人",
        style: _contentTitleStyle,
      );

  /// 角色类型排序获取
  final List<RoleType> _roleTypeSort = [
    RoleType.GOD,
    RoleType.CITIZEN,
    RoleType.WOLF,
    RoleType.THIRD,
  ];

  Widget _roleSetting() {
    var children = _roleTypeSort.map((e) {
      List<Role> canSelect = _canSelectForTypeMap[e] ?? [];
      return Column(
        children: [
          Row(children: [Text("角色：${e.desc} (已选：${roleConfig[e]?.length ?? 0} 个)")]),
          MultiSelectWidget.defaultView(
            MultiSelectConfig<Role>(
              selectableList: canSelect,
              defaultSelect: roleConfig[e],
              callback: (t) {
                setState(() {
                  roleConfig[e] = t;
                });
              },
            ),
            // itemBuilder: (t) => Text("R${t.roleName}"),
            itemBuilder: (t, isSelect) {
              // return Icon(t.icon.icon, color: isSelect ? Colors.white : null);
              return t.icon(color: isSelect ? Colors.white : null);
            },
            itemDescBuilder: (t) => t.roleName,
            buttonBuilder: () => const Icon(Icons.add),
          )
        ],
      );
    }).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(children: children),
    );
  }

  /// 特殊规则界面生
  List<Widget> get extraGenerator {
    List<Widget> list = [];
    var generator = _temp.generator;
    for (var role in _alreadySelectedRole) {
      var gen = generator.get(role)?.extraRuleGenerator();
      if (null != gen) {
        list.add(gen.tempView());
      }
    }
    return list;
  }

  Widget _extraView() {
    var views = extraGenerator;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => views[index],
      separatorBuilder: (context, index) => const SizedBox(),
      itemCount: views.length,
    );
  }

  final _isShow = IsShowState();

  Future<void> _summaryCreateTempToPreview() async {
    if (tempName.isEmpty) {
      showSnackBarMessage("请设置一个模板名称", isShow: _isShow);
      return;
    }

    if (playerCount < 8) {
      showSnackBarMessage("玩家数量太少了", isShow: _isShow);
      return;
    }
    var trc = _roleConfigSummary;
    if ((trc.citizenCount + trc.citizen.length) == 0 || (trc.wolfCount + trc.wolfs.length) == 0 || trc.gods.isEmpty) {
      showSnackBarMessage("请平衡人数，神、民、狼人数不能为0", isShow: _isShow);
      return;
    }

    var data = GameTemplateConfigEntity(
      id: 0,
      name: tempName,
      playerCount: playerCount,
      extraRule: TempExtraRule.forFactory(_temp.extraRule),
      roleConfig: trc,
      weight: 10,
    );

    // if (kDebugMode) print("result :${jsonEncode(data)}");

    // var id = await AppFactory().service.createTemp(data);
    // if (kDebugMode) {
    //   print("result (dbid:${id}) :${jsonEncode(data)}");
    // }

    // context.route.selectTempToCreateNewGameConfigView(temp, false).push();
    // Navigator.of(context).pop();

    /// 跳转去预览界面
    route.toTempPreview(data).push();
  }
}
