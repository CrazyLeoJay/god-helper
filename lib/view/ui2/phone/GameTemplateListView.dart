import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/AppFactory.dart';
import 'package:god_helper/temp.dart';

/// 角色规则配置选择界面
class GameTemplateListView extends StatefulWidget {
  final ConfigViewType type;

  const GameTemplateListView({super.key, required this.type});

  @override
  State<GameTemplateListView> createState() => _GameTemplateListViewState();
}

enum ConfigViewType {
  create("选择板子创建一个新游戏"),
  replace("替换当前游戏配置"),
  ;

  final String title;

  const ConfigViewType(this.title);
}

class _GameTemplateListViewState extends State<GameTemplateListView> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<GameTemplateConfigEntity> diyTemps = [];

  List<_TabData> get _tabView => [
        _TabData(
          const Tab(text: "默认配置"),
          _systemTempsWidget(),
        ),
        _TabData(
          const Tab(text: "玩家配置"),
          _userDiyTempsWidget(),
        ),
      ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabView.length, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    diyTemps = await AppFactory().service.gameTemps();
    setState(() {
      // if (diyTemps.isNotEmpty && _tabController != null) {
      //   if (_tabController!.index != 1) {
      //     _tabController!.animateTo(1);
      //   }
      // }
    });
  }

  TextStyle get titleStyle => app.baseFont.copyWith(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: titleStyle,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.type.title),
            Text("（左滑根据选择创建新模板）", style: titleStyle.copyWith(fontSize: 10)),
          ],
        ),
        actions: [IconButton(onPressed: _loadData, icon: const Icon(Icons.refresh))],
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabView.map((e) => e.tab).toList(growable: false),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: _tabView.map((e) => e.view).toList(growable: false),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          onPressed: () => AppFactory().getRoute(context).toCreateNewTemp().push(),
          child: const Text("创建一个空模板"),
        ),
      ),
    );
  }

  Widget _systemTempsWidget() {
    var list = defaultGameTemplate.toList();
    list.sort((a, b) => a.weight - b.weight);
    return _DefaultConfig(
      list,
      onLeftSlideListener: _makeNewTemp,
      onItemClickListener: (context, temp) {
        _makeNewGameWithSelectTemp(context, temp, isSystemConfig: true);
      },
    );
  }

  Widget _userDiyTempsWidget() {
    return _DefaultConfig(
      diyTemps,
      onLeftSlideListener: _makeNewTemp,
      onItemClickListener: (context, temp) {
        _makeNewGameWithSelectTemp(context, temp, isSystemConfig: false);
      },
    );
  }

  /// 创建一个新模板
  void _makeNewTemp(BuildContext context, GameTemplateConfigEntity temp) {
    AppFactory().getRoute(context).toCreateNewTemp(temp: temp).push().then((value) {
      if (value != null) _loadData();
    });
  }

  /// 根据选中的模板创建一场新游戏
  void _makeNewGameWithSelectTemp(
    BuildContext context,
    GameTemplateConfigEntity temp, {
    required bool isSystemConfig,
  }) {
    // if(kDebugMode) print("object entit :${jsonEncode(temp)}");
    AppFactory().getRoute(context).toTempDetail(temp, isSystemConfig).push();
    // AppFactory().getRoute(context).selectTempToCreateNewGameConfigView(temp, isSystemConfig).push();
  }
}

class _TabData {
  final Tab tab;
  final Widget view;

  _TabData(this.tab, this.view);
}

/// 游戏配置
class _GameBoardConfig extends StatelessWidget {
  final GameTemplateConfigEntity configEntity;

  const _GameBoardConfig(this.configEntity);

  List<Role> get roles => configEntity.roleConfig.all;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4), // 阴影颜色
          spreadRadius: 0, // 阴影扩散半径
          blurRadius: 4, // 阴影模糊半径
          // offset: const Offset(0, 2), // 阴影偏移量
        )
      ]),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(configEntity.name),
          ),
          SizedBox(
            height: 45,
            width: double.maxFinite,
            child: Row(
              children: [
                const Text("角色："),
                ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: roles.length,
                  itemBuilder: (BuildContext context, int index) => roles[index].icon(),
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(
                    height: 8,
                    width: 8,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 默认界面
class _DefaultConfig extends StatelessWidget {
  final Function(
    BuildContext context,
    GameTemplateConfigEntity temp,
  ) onItemClickListener;
  final Function(
    BuildContext context,
    GameTemplateConfigEntity temp,
  ) onLeftSlideListener;

  final List<GameTemplateConfigEntity> temps;

  const _DefaultConfig(
    this.temps, {
    required this.onItemClickListener,
    required this.onLeftSlideListener,
  });

  @override
  Widget build(BuildContext context) {
    if (temps.isEmpty) {
      return const Center(
        child: Text("还未创建过模板"),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        itemCount: temps.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 8 * 3,
        ),
        itemBuilder: (BuildContext context, int index) {
          return LeftSlideRowWidget(
            onLeftSlideListener: () {
              return onLeftSlideListener(context, temps[index]);
            },
            child: CardButton(
              onTap: () => onItemClickListener(context, temps[index]),
              child: _GameBoardConfig(temps[index]),
            ),
            sideWidget: (isSidleListener) {
              var style = context.app.baseFont.copyWith(color: Colors.white);
              return isSidleListener
                  ? Text("放手\n创建新模板", style: style, textAlign: TextAlign.right)
                  : Text("左滑\n创建新模板", style: style, textAlign: TextAlign.right);
            },
          );
        },
      ),
    );
  }
}
