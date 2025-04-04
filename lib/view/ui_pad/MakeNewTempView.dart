import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/component/CustomTextField.dart';
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
class MakeNewTempView extends StatefulWidget {
  final GameTemplateConfigEntity? temp;

  const MakeNewTempView({this.temp});

  @override
  State<MakeNewTempView> createState() => _MakeNewTempViewState();
}

class _MakeNewTempViewState extends State<MakeNewTempView> {
  TextStyle get titleStyle => app.baseFont.copyWith(fontSize: 28);

  // 二级标题
  TextStyle get _secondTitleStyle => app.baseFont.copyWith(fontSize: 22);

  // 正文
  TextStyle get _contentTitleStyle => app.baseFont.copyWith(fontSize: 20);

  final double _lineSize = 22;

  /// 模板工厂，用来显示界面和存数据
  final GameFactory _temp = AppFactory().temp();

  final helperData = _MakeTempHelperData();

  @override
  void initState() {
    super.initState();
    if (null != widget.temp) {
      if (kDebugMode) print("设置模板名称：${widget.temp!.name}");
      helperData._tempNameNotifier.value = widget.temp!.name;
      var dv = widget.temp!;
      helperData.init(dv);
      _temp.entity.extraRule = dv.extraRule;
    } else {
      _temp.entity.extraRule.initSheriff();
    }

    if (kDebugMode) print("new temp init");
  }

  @override
  Widget build(BuildContext context) {
    Row row_title(String title, Widget child) => Row(children: [
          Text("${title}：", style: titleStyle),
          Expanded(child: child),
        ]);

    return Scaffold(
      appBar: AppBar(title: const Text("创建新模板")),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: row_title(
                      "设置名称",
                      ValueListenableBuilder(
                        valueListenable: helperData._tempNameNotifier,
                        builder: (context, value, child) {
                          return CustomTextField(
                            textNotifier: helperData._tempNameNotifier,
                            hintText: "设置模板名称",
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            fontSize: 20,
                            hintTextColor: Colors.black.withOpacity(0.3),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("建议名字：${helperData._roleConfigSummary.toSimpleName()}", style: titleStyle),
                          TextButton(
                            onPressed: () {
                              helperData._tempNameNotifier.value = helperData._roleConfigSummary.toSimpleName();
                            },
                            child: const Center(child: Text("填入建议名称", style: TextStyle(fontSize: 18))),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildPreview()),
                  const SizedBox(width: 8 * 2),
                  Expanded(child: _buildTempConfig()),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: TextButton(onPressed: _summaryCreateTempToPreview, child: const Text("创建模板")),
      ),
    );
  }

  /// 板子预览界面
  Widget _buildPreview() {
    double spex = 2;
    Widget roleIconWidget(List<Role> roles, {bool isListview = true}) {
      if (roles.isEmpty) return const SizedBox();
      double size = 70;
      if (isListview) {
        return Row(children: [
          SizedBox(
            height: size,
            width: 600,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Column(
                children: [roles[index].icon(size: size - 30), Text(roles[index].roleName)],
              ),
              separatorBuilder: (context, index) => const SizedBox(width: 8 * 2),
              itemCount: roles.length,
            ),
          )
        ]);
      } else {
        return AutoGridView(
          data: roles,
          childAspectRatio: 9 / 16,
          padding: 8,
          itemBuilder: (t) => Column(
            children: [t.icon(size: size - 30), Text(t.roleName)],
          ),
        );
      }
    }

    List<Padding> list = _temp.extraRule.keys
        .where((e) => _temp.generator.get(e)?.extraRuleGenerator()?.configResultMessage() != null)
        .map((e) {
      List<String> mes = _temp.generator.get(e)!.extraRuleGenerator()!.configResultMessage();
      return Padding(
        padding: EdgeInsets.only(left: 8 * spex),
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) => Text(mes[index], style: _contentTitleStyle),
          separatorBuilder: (context, index) => const SizedBox(),
          itemCount: mes.length,
        ),
      );
    }).toList();

    return Material(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          children: [
            Row(children: [Text("模板预览", style: titleStyle)]),
            Row(children: [Text("角色配置", style: _secondTitleStyle)]),
            Padding(
              padding: EdgeInsets.only(left: 8 * spex),
              child: Column(children: [
                Row(children: [Text("村民(${helperData.allCitizen().length} 人)：")]),
                Padding(
                  padding: EdgeInsets.only(left: 8 * spex),
                  child: roleIconWidget(helperData.allCitizen(), isListview: false),
                ),
                Row(children: [Text("狼人(${helperData.allWolf().length} 人)：")]),
                Padding(
                  padding: EdgeInsets.only(left: 8 * spex),
                  child: roleIconWidget(helperData.allWolf(), isListview: false),
                ),
              ]),
            ),
            Row(children: [Text("规则", style: _secondTitleStyle)]),
            Padding(
              padding: EdgeInsets.only(left: 8 * spex),
              child: Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("警徽规则：", style: _contentTitleStyle),
                    Expanded(child: Text(_temp.extraRule.sheriffRace.desc, style: _contentTitleStyle))
                  ],
                ),
                Row(children: [Text("胜利规则：${_temp.extraRule.winRule.desc}", style: _contentTitleStyle)]),
              ]),
            ),
            Row(children: [Text("其他角色规则", style: _secondTitleStyle)]),
            Padding(
              padding: EdgeInsets.only(left: 8 * spex),
              child: Column(children: list),
            ),
          ],
        ),
      ),
    );
  }

  /// 模板配置
  Widget _buildTempConfig() {
    return Column(
      children: [
        Row(children: [Text("人数设定", style: titleStyle)]),
        Row(children: [
          Expanded(flex: 0, child: Text("普通村民: ", style: _contentTitleStyle)),
          Expanded(child: _buildNumberSetting(helperData._ordinaryCitizenCount)),
        ]),
        Row(
          children: [
            Expanded(flex: 0, child: Text("普通狼人: ", style: _contentTitleStyle)),
            Expanded(child: _buildNumberSetting(helperData._ordinaryWolfCount)),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(width: double.maxFinite, child: helperData.buildNumberSummary(_contentTitleStyle)),
        const SizedBox(height: 8),
        Row(children: [Text("配置不同阵营角色", style: _secondTitleStyle)]),
        _roleSetting(),
        const SizedBox(height: 8),
        Row(children: [Text("警长规则配置", style: _secondTitleStyle)]),
        const SizedBox(height: 8),
        RadioGroup(
          config: RadioConfig<SheriffRace>.list(
            selectItem: SheriffRace.values,
            defaultValue: _temp.entity.extraRule.getSheriffConfig().sheriffRace,
            callback: (value) => setState(() => _temp.entity.extraRule.setSheriffConfig(value)),
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
              defaultValue: _temp.extraRule.winRule,
              gridChildAspectRatio: 6 / 1,
              callback: (value) => setState(() => _temp.extraRule.winRule = value),
              showText: (value) => value.desc,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(children: [Text("角色特殊规则默认配置", style: _secondTitleStyle)]),
        _buildExtraView(),
      ],
    );
  }

  /// 数字增减设置组件
  Widget _buildNumberSetting(ValueNotifier<int> numberNotifier) {
    return SizedBox(
      height: _lineSize * 2,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          IconButton(
            onPressed: () => setState(() => numberNotifier.value -= 1),
            icon: Icon(PhosphorIcons.minus(), size: _lineSize),
          ),
          Center(
            child: ValueListenableBuilder(
              valueListenable: numberNotifier,
              builder: (context, value, child) => Text("$value", style: _secondTitleStyle),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => numberNotifier.value += 1),
            icon: Icon(PhosphorIcons.plus(), size: _lineSize),
          ),
        ],
      ),
    );
  }

  Widget _roleSetting() {
    var children = helperData.roleTypeSort.map((e) {
      List<Role> canSelect = helperData.canSelectForTypeMap[e] ?? [];
      return Column(
        children: [
          Row(children: [
            Text(
              "角色：${e.desc} (已选：${helperData.roleConfig[e]?.length ?? 0} 个)",
              style: _secondTitleStyle,
            )
          ]),
          MultiSelectWidget.defaultView(
            MultiSelectConfig<Role>(
              selectableList: canSelect,
              defaultSelect: helperData.roleConfig[e],
              callback: (t) {
                setState(() => helperData.roleConfig[e] = t);
              },
            ),
            itemBuilder: (t, isSelect) {
              return t.icon(color: isSelect ? Colors.white : Colors.black);
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

  /// 构建角色补充规则的配置界面
  Widget _buildExtraView() {
    List<Widget> list = helperData.extraGenerator(_temp, updateCallback: () {
      setState(() {});
      print("object");
    });
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => list[index],
      separatorBuilder: (context, index) => const SizedBox(),
      itemCount: list.length,
    );
  }

  final _isShow = IsShowState();

  Future<void> _summaryCreateTempToPreview() async {
    if (helperData._tempNameNotifier.value.isEmpty) {
      showSnackBarMessage("请设置一个模板名称", isShow: _isShow);
      return;
    }

    if (helperData._roleConfigSummary.count() < 8) {
      showSnackBarMessage("玩家数量太少了", isShow: _isShow);
      return;
    }
    var trc = helperData._roleConfigSummary;
    if ((trc.citizenCount + trc.citizen.length) == 0 || (trc.wolfCount + trc.wolfs.length) == 0 || trc.gods.isEmpty) {
      showSnackBarMessage("请平衡人数，神、民、狼人数不能为0", isShow: _isShow);
      return;
    }

    var data = GameTemplateConfigEntity(
      id: 0,
      name: helperData._tempNameNotifier.value,
      playerCount: helperData._roleConfigSummary.count(),
      extraRule: TempExtraRule.forFactory(_temp.extraRule),
      roleConfig: trc,
      weight: 10,
    );

    // if (kDebugMode) print("result :${jsonEncode(data)}");

    var id = await AppFactory().service.createTemp(data);
    if (kDebugMode) {
      print("result (dbid:${id}) :${jsonEncode(data)}");
    }
    GameTemplateConfigEntity entity = await AppFactory().service.getTempForId(id);

    // padRoute.selectTempToCreateNewGameConfigView(entity, false).pushReplace();
    Navigator.pop(context, entity);
  }
}

class _MakeTempHelperData {
  /// 普通村民数量
  final _ordinaryCitizenCount = ValueNotifier(0);

  /// 普通狼人数量
  final _ordinaryWolfCount = ValueNotifier(0);

  /// 不同类型角色数量
  Map<RoleType, List<Role>> roleConfig = {};

  /// 获取一个角色配置的汇总类
  TemplateRoleConfig get _roleConfigSummary => TemplateRoleConfig(
        citizenCount: _ordinaryCitizenCount.value,
        wolfCount: _ordinaryWolfCount.value,
        roles: roleConfig,
      );

  final _tempNameNotifier = ValueNotifier("");

  /// 角色类型排序获取
  final List<RoleType> roleTypeSort = [
    RoleType.GOD,
    RoleType.CITIZEN,
    RoleType.WOLF,
    RoleType.THIRD,
  ];

  /// 所有可以选择的角色
  final List<Role> canSelectRole = Role.getRoles();

  Map<RoleType, List<Role>> get canSelectForTypeMap => {
        RoleType.CITIZEN: [...canSelectRole]..removeWhere(
            (role) =>
                ![RoleType.CITIZEN, RoleType.GOD].contains(role.type) ||
                ((roleConfig[RoleType.GOD] ?? []).contains(role)),
          ),
        RoleType.GOD: [...canSelectRole]..removeWhere(
            (role) =>
                ![RoleType.CITIZEN, RoleType.GOD].contains(role.type) ||
                ((roleConfig[RoleType.CITIZEN] ?? []).contains(role)),
          ),
        RoleType.THIRD: [...canSelectRole]..removeWhere(
            (element) => element.type != RoleType.THIRD,
          ),
        RoleType.WOLF: [...canSelectRole]..removeWhere(
            (element) => element.defaultIdentity,
          ),
      };

  Widget buildNumberSummary(TextStyle contentTitleStyle) => Text(
        "总计："
        "神${_roleConfigSummary.gods.length} "
        "+ 狼${(_roleConfigSummary.wolfs.length) + _ordinaryWolfCount.value} "
        "+ 民${(_roleConfigSummary.citizen.length) + _ordinaryCitizenCount.value} "
        "+ 三${_roleConfigSummary.thirds.length} "
        "= ${(_roleConfigSummary.count())} 人",
        style: contentTitleStyle,
      );

  /// 已经选择过的
  List<Role> get _alreadySelectedRole {
    List<Role> list = [];
    for (var item in roleConfig.values) {
      list.addAll(item);
    }
    return list.toSet().toList();
  }

  /// 特殊规则界面生
  List<Widget> extraGenerator(GameFactory temp, {Function()? updateCallback}) {
    List<Widget> list = [];
    var generator = temp.generator;
    for (var role in _alreadySelectedRole) {
      var gen = generator.get(role)?.extraRuleGenerator();
      if (null != gen) {
        list.add(gen.tempView(updateCallback: updateCallback));
      }
    }
    return list;
  }

  void init(GameTemplateConfigEntity dv) {
    _ordinaryCitizenCount.value = dv.roleConfig.citizenCount;
    _ordinaryWolfCount.value = dv.roleConfig.wolfCount;
    roleConfig = dv.roleConfig.roles;
  }

  List<Role> allCitizen() {
    List<Role> list = [];
    list.addAll(List.generate(_ordinaryCitizenCount.value, (index) => Role.citizen));
    list.addAll(roleConfig[RoleType.GOD] ?? List.empty());
    list.addAll(roleConfig[RoleType.CITIZEN] ?? List.empty());
    return list;
  }

  List<Role> allWolf() {
    List<Role> list = [];
    list.addAll(List.generate(_ordinaryWolfCount.value, (index) => Role.wolf));
    list.addAll(roleConfig[RoleType.WOLF] ?? List.empty());
    return list;
  }
}
