import 'package:flutter/material.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/framework/AppFactory.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/DayFactory.dart';
import 'package:god_helper/framework/impl/NightFactory.dart';

class RowDetailsView extends StatefulWidget {
  const RowDetailsView({super.key});

  @override
  State<RowDetailsView> createState() => _RowDetailsViewState();
}

class _RowDetailsViewState extends State<RowDetailsView> {
  List<RoleType> get roleTypes => RoleType.values;

  Map<RoleType, List<Role>> get roleTypeMap => RoleType.getRolesForType(isAll: true);

  @override
  Widget build(BuildContext context) {
    return _RoleTabView<RoleType>(
      roleTypes,
      title: const Text("角色列表"),
      tabBuilder: (t) => Tab(text: t.name),
      childBuilder: (t) => _RoleTabView<Role>(
        roleTypeMap[t] ?? [],
        isScrollable: true,
        tabBuilder: (t) => Tab(text: "${t.nickname}(${t.inNightSingleAction ? "N" : "D"})"),
        childBuilder: (t) => _RoleDetailItemView(t),
      ),
    );
  }
}

class _RoleTabView<T> extends StatefulWidget {
  final Widget? title;
  final List<T> list;
  final Tab Function(T t) tabBuilder;
  final Widget Function(T t) childBuilder;
  final bool isScrollable;

  const _RoleTabView(
    this.list, {
    this.title,
    required this.tabBuilder,
    required this.childBuilder,
    this.isScrollable = false,
  });

  @override
  State<_RoleTabView<T>> createState() => _RoleTabViewState<T>();
}

class _RoleTabViewState<T> extends State<_RoleTabView<T>> with SingleTickerProviderStateMixin {
  List<T> get _list => widget.list;

  late TabController _tabController;
  late List<Tab> _tabs;
  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _list.length, vsync: this);
    _tabs = _list.map((e) => widget.tabBuilder(e)).toList(growable: false);
    _children = _list.map((e) => widget.childBuilder(e)).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return widget.title == null ? _noTitleBuild(context) : _titleBuild(context);
  }

  Widget _titleBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title,
        leading: null,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: widget.isScrollable ? null : const NeverScrollableScrollPhysics(),
        children: _children,
      ),
    );
  }

  Widget _noTitleBuild(BuildContext context) {
    return Column(
      children: [
        if (_list.isNotEmpty)
          Expanded(
            flex: 0,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: _tabs,
            ),
          ),
        Expanded(
          child: TabBarView(
            physics: widget.isScrollable ? null : const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: _children,
          ),
        ),
      ],
    );
  }
}

class _RoleDetailItemView extends StatelessWidget {
  final Role role;

  const _RoleDetailItemView(this.role);

  GameFactory get _factory => AppFactory().temp();

  Widget get _identityGen => _factory.generator.getPlayerIdentityWidget(role);

  NightFactory get _nightFactory => _factory.getNight(1);

  DayFactory get _dayFactory => _factory.getDay(2);

  TempExtraGenerator<RoleTempConfig>? get _extraGenerator => AppFactory().temp().generator.getExtraRuleGenerator(role);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            _title("规则："),
            Text(role.ruleDesc),
            _line(),
            _identityView(),
            _extraView(),
            _nightView(),
            _dayView(),
          ],
        ),
      ),
    );
  }

  Widget _line() {
    return const Column(
      children: [
        SizedBox(height: 8),
        Divider(height: 1),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _title(String title) => Row(children: [Text(title, style: const TextStyle(fontSize: 20))]);

  Widget _extraView() {
    if (null == _extraGenerator) return const SizedBox();
    return Column(
      children: [
        _title("额外规则(样式界面)："),
        _extraGenerator!.tempView(isPreview: true),
        _line(),
      ],
    );
  }

  Widget _nightView() {
    var roleGenerator = _nightFactory.getRoleGenerator(role);
    if (roleGenerator == null) return const SizedBox();
    return Column(
      children: [
        _title("晚上行动(样式界面)："),
        roleGenerator.actionWidget(() {}),
        _line(),
      ],
    );
  }

  Widget _dayView() {
    var helper = _dayFactory.getWidgetHelper(role);
    var outWidget = helper.getOutViewForDay();
    var activeSkill = helper.activeSkillWidget();
    if (outWidget == null && activeSkill == null) return const SizedBox();
    return Column(
      children: [
        _title("白天行动(样式界面)："),
        if (null != outWidget) _title("白天行动(样式界面-出局)："),
        if (null != outWidget) outWidget,
        if (null != activeSkill) _title("白天行动(样式界面-主动技能)："),
        if (null != activeSkill) activeSkill,
        _line(),
      ],
    );
  }

  Widget _identityView() {
    if (!role.isSingleYesPlayerIdentity) return const SizedBox();
    // if (role == Role.CITIZEN) return const SizedBox();
    return Column(
      children: [
        _title("身份确认选择(样式界面)："),
        _identityGen,
        _line(),
      ],
    );
  }
}
