import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/AppFactory.dart';
import 'package:god_helper/res/app.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AppHome extends StatefulWidget {
  AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  var state = _BeginViewGameListState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("上帝助手"),
        actions: [
          IconButton(
              onPressed: state.loadData,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              icon: Icon(
                // Icons.refresh,
                PhosphorIcons.arrowClockwise(),
              )),
          if (kDebugMode)
            IconButton(
                onPressed: () {
                  context.data.noSql.clear();
                },
                padding: const EdgeInsets.symmetric(horizontal: 16),
                icon: const Icon(Icons.delete)),
        ],
      ),
      body: _BeginViewGameList(state: state),
      bottomNavigationBar: const BottomAppBar(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: _BeginGameButton(),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        width: 150,
        child: MenuDrawerChildren(
          menus: [
            MenuItem("查看角色", (route) => route.toRoleDetailsView().push()),
            MenuItem("查看资源", (route) => route.toAssetsResourceView().push()),
          ],
        ),
      ),
    );
  }
}

class _BeginViewGameList extends StatefulWidget {
  final _BeginViewGameListState state;

  const _BeginViewGameList({required this.state});

  @override
  State<StatefulWidget> createState() => state;
}

class _BeginViewGameListState extends State<_BeginViewGameList> {
  List<GameDetailEntity> _listData = List.empty();
  var _isLoad = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (_isLoad) return;
    _isLoad = true;

    _listData = await AppFactory().service.allGames();
    if (kDebugMode) _listData.insert(0, GameDetailEntity.generateDebugData());
    setState(() {
      // print("生成：${_listData.length} 个数据");
      _isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        var data = _listData[index];
        return LeftSlideRowWidget(
          child: GestureDetector(
            onTap: () {
              AppFactory().getRoute(context).toPlayGameForEntity(data).push();
            },
            child: _GameDetailItemView(detail: data),
          ),
          onLeftSlideListener: () async {
            showDeleteDialog(data);
          },
          sideWidget: (isSidleListener) {
            var style = app.baseFont.copyWith(color: Colors.white);
            return isSidleListener
                ? Text("释放\n删除该游戏", style: style, textAlign: TextAlign.right)
                : Text("继续左滑\n删除游戏", style: style, textAlign: TextAlign.right);
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 8);
      },
      itemCount: _listData.length,
    );
  }

  Future<void> showDeleteDialog(GameDetailEntity data) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("确认删除操作"),
              content: Expanded(
                child: Text(
                  "确认删除该游戏？\n(id:${data.id})${data.name}",
                  textAlign: TextAlign.center,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("取消"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await AppFactory().service.deleteGame(data.id);
                    loadData();
                  },
                  child: const Text("确认"),
                )
              ],
            ));
  }
}

/// 开始游戏按钮
class _BeginGameButton extends StatelessWidget {
  const _BeginGameButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AppFactory().getRoute(context).toTemplateSelectView().push(),
      borderRadius: BorderRadius.circular(16),
      highlightColor: Colors.blue,
      splashColor: Colors.yellow,
      hoverColor: Colors.greenAccent,
      focusColor: Colors.deepOrange,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          // color: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          width: double.infinity,
          height: 64,
          child: Text(
            "开始新游戏",
            style: App.of(context).font.base.copyWith(color: Colors.white),
            // TextStyle(color: Colors.white, fontSize: 18, fontFamily: ""),
          ),
        ),
      ),
    );
  }
}

/// 开始游戏列表的单项
class _GameDetailItemView extends StatelessWidget {
  final GameDetailEntity detail;

  const _GameDetailItemView({required this.detail});

  GameTemplateConfigEntity get _temp => detail.tempConfig!;
  final TextStyle ts = const TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      // width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "${detail.id} (${detail.isFinish ? "已结束" : (detail.isBeginGame ? "已开始" : "未开始")}) ${detail.name}",
                style: ts.copyWith(fontSize: 18),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Text(
                      "总${_temp.playerCount}人，神${_temp.roleConfig.godsLength}人、民${_temp.roleConfig.citizenCampLength}人、三方${_temp.roleConfig.thirds.length}人",
                      style: ts,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: Text(
                "创建时间：yyyy-MM-dd",
                style: ts,
              ),
            )
          ],
        ),
      ),
    );
  }
}
