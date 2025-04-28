import 'package:flutter/material.dart';
import 'package:god_helper/framework/AppFactory.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/view/ui2/phone/GameConfigDetailView.dart';

class GameConfigPreview extends StatelessWidget {
  final GameFactory factory;

  const GameConfigPreview(this.factory, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("配置预览"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: GameConfigDetailView(factory),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          onPressed: () => _yesToBeginGame(context),
          child: const Text("确认无误，开始游戏"),
        ),
      ),
    );
  }

  Future<void> _yesToBeginGame(BuildContext context) async {
    // print("factory :${jsonEncode(factory.entity)}");
    // 创建新游戏
    GameFactory f = await AppFactory().service.createNewGame(factory);
    // 导航到游戏配置界面，并且移除之前的所有历史导航
    AppFactory().getRoute(context).toPlay(f).pushAndRemoveUntil("/");
  }
}
