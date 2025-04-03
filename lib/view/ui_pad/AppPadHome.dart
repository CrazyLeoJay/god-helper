import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/view/ui_pad/GameListView.dart';
import 'package:god_helper/view/ui_pad/UiPadRouteFactory.dart';

/// Pad UI 界面
class AppPadHome extends StatefulWidget {
  @override
  State<AppPadHome> createState() => _AppPadHomeState();
}

class _AppPadHomeState extends State<AppPadHome> {
  List<MenuItem> get _items => [
        MenuItem(name: "新游戏", invoke: (route) => route.toTemplateSelectView().push()),
        MenuItem(name: "继续游戏", invoke: (route) {}),
        MenuItem(name: "游戏列表", invoke: (route) => toGameList()),
        if (kDebugMode)
          MenuItem(
            name: "(debug) 查看角色",
            invoke: (route) => route.toRoleDetailsView().push(),
          ),
        if (kDebugMode)
          MenuItem(
            name: "(debug) 查看资源",
            invoke: (route) => route.toAssetsResourceView().push(),
          ),
      ];

  bool isToGameList = false;

  void toGameList() {
    setState(() {
      isToGameList = !isToGameList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('AppPadHome'),
      // ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Role.wolf.icon(size: 250, color: Colors.white),
                    const Text(
                      '狼人杀-GM笔记',
                      style: TextStyle(color: Colors.white, fontSize: 50),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: isToGameList ? GameListView(onPressed: toGameList) : menu(),
          ),
        ],
      ),
    );
  }

  /// 主菜单
  Widget menu() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 40),
      color: Colors.white,
      height: double.maxFinite,
      alignment: AlignmentDirectional.center,
      // color: Colors.green,
      // height: constraints.maxHeight,
      // width: constraints.maxWidth,
      child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return rowItem(context, _items[index].name, invoke: _items[index].invoke);
          },
          separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
          itemCount: _items.length),
    );
  }

  /// 菜单项
  Widget rowItem(BuildContext context, String name, {void Function(UiPadRouteFactory route)? invoke}) {
    return Material(
      color: Colors.green,
      child: InkWell(
        onTap: () => invoke?.call(UiPadRouteFactory(context)),
        child: Container(
          alignment: AlignmentDirectional.center,
          height: 50,
          child: Text(
            " $name ",
            style: const TextStyle(fontSize: 35, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  final String name;
  final void Function(UiPadRouteFactory route)? invoke;

  MenuItem({required this.name, this.invoke});
}
