import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/entity/RuleConfig.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/AppFactory.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/temp.dart';
import 'package:god_helper/view/ui2/phone/GameTemplateListView.dart';

/// 创建新游戏页面
class MakeNewGameSelectTempView extends StatefulWidget {
  final ConfigViewType type;
  final GameTemplateConfigEntity? data;

  const MakeNewGameSelectTempView({super.key, required this.type, this.data});

  @override
  State<MakeNewGameSelectTempView> createState() => _MakeNewGameSelectTempViewState();
}

class _MakeNewGameSelectTempViewState extends State<MakeNewGameSelectTempView> {
  _TempItemData? data;

  final ValueNotifier<List<_TempItemData>> _tempNotifier = ValueNotifier(List<_TempItemData>.empty());

  final IsShowState _isShow = IsShowState();

  final GlobalKey<_TempListState> _keyTempList = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (null != widget.data) {
      data = _TempItemData(widget.data!);
    }
    _loadTempData();
  }

  Future<void> _loadTempData() async {
    _tempNotifier.value = await AppFactory().service.gameTemps().then((value) {
      return value.map((GameTemplateConfigEntity e) => _TempItemData(e)).toList();
    });

    if (kDebugMode) {
      print("加载${_tempNotifier.value.length} 个数据");
    }
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("创建新游戏-选择游戏板子"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Material(
              elevation: 15,
              child: Container(
                width: constraints.maxWidth / 3,
                // height: constraints.maxHeight,
                constraints: const BoxConstraints(
                  minWidth: 400,
                  maxWidth: 500,
                ),
                child: ValueListenableBuilder(
                  valueListenable: _tempNotifier,
                  builder: (context, value, child) {
                    return _TempList(
                      key: _keyTempList,
                      temps: _tempNotifier.value,
                      defaultData: data,
                      initialIndex: (data?.temp.isDefaultConfig ?? true) ? 0 : 1,
                      selectItem: (data) {
                        setState(() => this.data = data);
                      },
                      loadTempData: _loadTempData,
                      toCreateNewTempInvoke: () => _buildToMakeNewTem(),
                      toRemoveTemp: _toRemoveTemp,
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  _TempPreviewWidget(data: data),
                  Positioned(
                    right: 32,
                    child: Material(
                      elevation: 2,
                      child: TextButton(
                        onPressed: () {
                          if (null == data) {
                            showSnackBarMessage("还未选择模板", isShow: _isShow);
                            return;
                          }
                          _buildToMakeNewTem(temp: data?.entity);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: const Center(child: Text("复制此模板创建")),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          onPressed: () {
            if (null == data) {
              showSnackBarMessage("还未选择模板", isShow: _isShow);
              return;
            }
            padRoute.toNewGameToConfig(data!.entity).pushReplace();
          },
          child: Text("选择模板（${data?.name ?? ""}）开始游戏"),
        ),
      ),
    );
  }

  void _buildToMakeNewTem({GameTemplateConfigEntity? temp}) {
    padRoute.toCreateNewTemp(temp: temp).push().then(
      (value) {
        if (value is GameTemplateConfigEntity) {
          data = _TempItemData(value);
          _loadTempData();
          setState(() {});
          _keyTempList.currentState?.switchTab((data?.temp.isDefaultConfig ?? true) ? 0 : 1);
        }
      },
    );
  }

  _toRemoveTemp(_TempItemData temp) async {
    await AppFactory().service.removeTemp(temp.temp.id);
    _loadTempData();
    if (data?.temp.id == temp.temp.id) {
      setState(() {
        data = null;
      });
    }
  }
}

/// 模板每行的数据
class _TempItemData {
  final GameTemplateConfigEntity entity;

  _TempItemData(this.entity);

  String get name => entity.name;

  List<Role> get roles => entity.roleConfig.all;

  int get playerCount => entity.playerCount;

  List<Role> get gods => entity.roleConfig.gods;

  List<Role> get citizens => entity.roleConfig.citizen;

  List<Role> get wolfs => entity.roleConfig.wolfs;

  List<Role> get thirds => entity.roleConfig.thirds;

  SheriffRace get sheriffRace => entity.extraRule.sheriffRace;

  WinRule get winRule => entity.extraRule.winRule;

  TempExtraRule get roleExtraRule => entity.extraRule;

  GameTemplateConfigEntity get temp => entity;

  int count({Role? role, RoleType? type}) {
    if (null != role) {
      switch (role) {
        case Role.citizen:
          return entity.roleConfig.citizenCount;
        case Role.wolf:
          return entity.roleConfig.wolfCount;
        default:
          return 0;
      }
    } else if (type != null) {
      switch (type) {
        case RoleType.CITIZEN:
          return entity.roleConfig.citizenCampLength;
        case RoleType.WOLF:
          return entity.roleConfig.wolfCampCount;
        case RoleType.GOD:
          return entity.roleConfig.godsLength;
        default:
          return 0;
      }
    }

    return 0;
  }
}

/// 模板每行的展示样式
class _TempItem extends StatelessWidget {
  final _TempItemData data;
  final double circleSize = 30;
  final bool isSelect;

  const _TempItem(this.data, {this.isSelect = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: (isSelect ? Colors.red : Colors.black).withOpacity(0.6), // 阴影颜色
            spreadRadius: 0, // 阴影扩散半径
            blurRadius: 4, // 阴影模糊半径
            offset: const Offset(0, 4), // 阴影偏移量
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(data.name),
          ),
          SizedBox(
            // height: 45,
            width: double.maxFinite,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: circleSize,
                  child: const Center(
                    child: Text("角色："),
                  ),
                ),
                Expanded(
                  child: AutoGridView(
                    data: data.roles,
                    itemBuilder: (t) => t.icon(),
                    circleSize: circleSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 模板列表
class _TempList extends StatefulWidget {
  final int initialIndex;
  final _TempItemData? defaultData;
  final List<_TempItemData> temps;
  final Function(_TempItemData? data)? selectItem;

  final Function()? loadTempData;

  final Function()? toCreateNewTempInvoke;
  final Function(_TempItemData temp) toRemoveTemp;

  const _TempList({
    super.key,
    required this.temps,
    required this.toRemoveTemp,
    this.defaultData,
    this.selectItem,
    this.initialIndex = 0,
    this.loadTempData,
    this.toCreateNewTempInvoke,
  });

  @override
  State<_TempList> createState() => _TempListState();
}

class _TempListState extends State<_TempList> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final _systemTemps = defaultGameTemplate.map((e) => _TempItemData(e)).toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: widget.initialIndex, length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 2,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "游戏板子",
                      style: context.app.baseFont.copyWith(fontSize: 22),
                    ),
                    Row(
                      children: [
                        IconButton(onPressed: () => widget.toCreateNewTempInvoke?.call(), icon: const Icon(Icons.add)),
                        IconButton(onPressed: () => widget.loadTempData?.call(), icon: const Icon(Icons.refresh)),
                      ],
                    ),
                  ],
                ),
              ),
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "默认"),
                  Tab(text: "玩家配置"),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListView(_systemTemps),
                _buildListView(widget.temps),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 渲染列表
  Widget _buildListView(List<_TempItemData> temps) {
    if (temps.isEmpty) {
      return const EmptyWidget(text: "没有模板数据");
    } else {
      int selectIndex = -1;
      if (widget.defaultData != null && selectIndex == -1) {
        for (var value in temps) {
          if (value.temp.id == widget.defaultData!.temp.id) {
            selectIndex = temps.indexOf(value);
            if (kDebugMode) {
              print("set index: $selectIndex");
            }
            break;
          }
        }
      }

      /// 单个item的实现
      /// 还有模板点击事件
      Widget itemView(_TempItemData data, int index) {
        return InkWell(
          child: _TempItem(data, isSelect: selectIndex == index),
          onTap: () {
            setState(() => selectIndex = index);
            widget.selectItem?.call(data);
          },
        );
      }

      return ListView.separated(
        itemBuilder: (context, index) => temps[index].temp.isDefaultConfig
            ? itemView(temps[index], index)
            : LeftSlideRowWidget(
                child: itemView(temps[index], index),
                sideWidget: (isSidleListener) {
                  var style = context.app.baseFont.copyWith(color: Colors.white);
                  return isSidleListener
                      ? Text("放手\n创建新模板", style: style, textAlign: TextAlign.right)
                      : Text("左滑\n创建新模板", style: style, textAlign: TextAlign.right);
                },
                onLeftSlideListener: () {
                  widget.toRemoveTemp(temps[index]);
                },
              ),
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemCount: temps.length,
      );
    }
  }

  void switchTab(int index) {
    if (kDebugMode) print("switch tab to $index");
    _tabController!.animateTo(index);
  }
}

class _TempPreviewWidget extends StatelessWidget {
  final _TempItemData? data;

  const _TempPreviewWidget({this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const EmptyWidget(text: "还未选择模板");
    } else {
      GameFactory factory = AppFactory().tempForTemp(data!.temp);
      var titleStyle = context.app.baseFont.copyWith(fontSize: 24);
      var contentStyle = context.app.baseFont.copyWith(fontSize: 20);
      Text content(String text) => Text(text, style: contentStyle);

      List<Role> roles = _extraGenerator(factory, data!.roleExtraRule.keys);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text("选择模板: ${data?.name}", style: titleStyle),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => SizedBox(
                  height: constraints.maxHeight,
                  // width: constraints.minWidth,
                  child: ListView(
                    primary: true,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    // shrinkWrap: true,
                    // controller: ScrollController(),
                    children: [
                      _buildItemWidget(context, "人数设定", child: content("总 ${data!.playerCount} 人")),
                      _buildItemWidget(context, "普通村民", child: content("${data!.count(role: Role.citizen)}")),
                      _buildItemWidget(context, "普通狼人", child: content("${data!.count(role: Role.wolf)}")),
                      _buildItemWidget(context, "神职", child: content("${data!.gods.map((e) => e.roleName)}")),
                      _buildItemWidget(context, "村职", child: content("${data!.citizens.map((e) => e.roleName)}")),
                      _buildItemWidget(context, "狼职", child: content("${data!.wolfs.map((e) => e.roleName)}")),
                      _buildItemWidget(context, "三方", child: content("${data!.thirds.map((e) => e.roleName)}")),
                      _buildItemWidget(context, "警长规则", child: content(data!.sheriffRace.desc)),
                      _buildItemWidget(context, "胜利条件", child: content(data!.winRule.desc)),
                      const SizedBox(height: 8),
                      Text("角色规则定义", style: titleStyle),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        // scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) =>
                            factory.generator.get(roles[index])?.extraRuleGenerator()?.tempView(isPreview: true) ??
                            Text("角色：${roles[index].roleName}"),
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemCount: roles.length,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Row _buildItemWidget(BuildContext context, String name, {Widget child = const SizedBox()}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Expanded(flex: 1, child: Text("${name}：", style: context.app.baseFont.copyWith(fontSize: 20))),
        Text("${name}：", style: context.app.baseFont.copyWith(fontSize: 20)),
        // Text(name, style: context.app.baseFont.copyWith(fontSize: 20)),
        child,
      ],
    );
  }

  /// 特殊规则界面生
  List<Role> _extraGenerator(GameFactory _factory, List<Role> roles) {
    List<Role> list = [];
    var generator = _factory.generator;
    for (var role in roles) {
      var gen = generator.get(role)?.extraRuleGenerator();
      if (null != gen) {
        list.add(role);
      }
    }
    return list;
  }
}
