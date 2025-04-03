import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/AppFactory.dart';

/// 游戏列表界面
class GameListView extends StatefulWidget {
  final VoidCallback? onPressed;

  const GameListView({super.key, this.onPressed});

  @override
  State<GameListView> createState() => _GameListViewState();
}

class _GameListViewState extends State<GameListView> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("游戏列表(${_listData.length})"),
        leading: IconButton(
          onPressed: widget.onPressed,
          icon: const Icon(Icons.keyboard_arrow_left),
        ),
        actions: [IconButton(onPressed: loadData, icon: const Icon(Icons.refresh))],
      ),
      body: _GameListWidget(_listData),
    );
  }
}

class _GameListWidget extends StatelessWidget {
  final List<GameDetailEntity> _listData;

  const _GameListWidget(this._listData);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        var data = _listData[index];
        return LeftSlideRowWidget(
          child: GestureDetector(
            onTap: () {
              // UiPadRouteFactory(context).beginGameToView(data).push();
            },
            child: _GameDetailItemView(detail: data),
            // child: Text("data"),
          ),
          onLeftSlideListener: () async {
            // showDeleteDialog(data);
          },
          sideWidget: (isSidleListener) {
            var style = context.app.baseFont.copyWith(color: Colors.white);
            return isSidleListener
                ? Text("释放\n删除该游戏", style: style, textAlign: TextAlign.right)
                : Text("继续左滑\n删除游戏", style: style, textAlign: TextAlign.right);
          },
        );
        // return Text("data");
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 8);
      },
      itemCount: _listData.length,
    );
  }

// Future<void> showDeleteDialog(GameDetailEntity data) async {
//   await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//             title: const Text("确认删除操作"),
//             content: Expanded(
//               child: Text(
//                 "确认删除该游戏？\n(id:${data.id})${data.name}",
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text("取消"),
//               ),
//               TextButton(
//                 onPressed: () async {
//                   Navigator.of(context).pop();
//                   await AppFactory().service.deleteGame(data.id);
//                   loadData();
//                 },
//                 child: const Text("确认"),
//               )
//             ],
//           ));
// }
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
