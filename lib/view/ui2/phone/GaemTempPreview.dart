import 'package:flutter/material.dart';
import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/AppFactory.dart';
import 'package:god_helper/framework/GameFactory.dart';

class GameTempPreview extends StatelessWidget {
  final GameTemplateConfigEntity _entity;

  const GameTempPreview._private(this._entity);

  static GameTempLookAndToNewGameView toLookAndToNewGame(GameTemplateConfigEntity entity, bool isSystem) {
    return GameTempLookAndToNewGameView(entity, isSystem);
  }

  static NewTempToPreview newTempPreview(GameTemplateConfigEntity entity) {
    return NewTempToPreview(entity);
  }

  TemplateRoleConfig get _roleConfig => _entity.roleConfig;

  GameFactory get _factory => AppFactory().tempForTemp(_entity);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("模板名称：${_entity.name}"),
          Text("人数设定（总 ${_roleConfig.count()} 人）"),
          Text("普通村民：${_roleConfig.citizenCount}"),
          Text("普通狼人：${_roleConfig.wolfCampCount}"),
          Text("神职：${_roleConfig.gods.map((e) => e.name).toList(growable: false)}"),
          if (_roleConfig.citizenCount > 0)
            Text("村民：${_roleConfig.citizen.map((e) => e.name).toList(growable: false)}"),
          Text("狼职：${_roleConfig.wolfs.map((e) => e.name).toList(growable: false)}"),
          Text("三方：${_roleConfig.thirds.map((e) => e.name).toList(growable: false)}"),
          Text("警长规则：${_entity.extraRule.getSheriffConfig().sheriffRace.desc}"),
          Text("胜利条件：${_entity.extraRule.winRule.desc}"),
          const Text("其他角色规则"),
          _extraView(_entity.extraRule.keys),
        ],
      ),
    );
  }

  Widget _extraView(List<Role> roles) {
    var views = _extraGenerator(roles);
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => views[index],
      separatorBuilder: (context, index) => const SizedBox(),
      itemCount: views.length,
    );
  }

  /// 特殊规则界面生
  List<Widget> _extraGenerator(List<Role> roles) {
    List<Widget> list = [];
    var generator = _factory.generator;
    for (var role in roles) {
      var gen = generator.get(role)?.extraRuleGenerator();
      if (null != gen) {
        list.add(gen.tempView(isPreview: true));
      }
    }
    return list;
  }

// Widget
}

/// 查看模板并开始游戏
class GameTempLookAndToNewGameView extends StatefulWidget {
  final GameTemplateConfigEntity _entity;
  final bool _isSystemTemp;

  const GameTempLookAndToNewGameView(this._entity, this._isSystemTemp, {super.key});

  @override
  State<GameTempLookAndToNewGameView> createState() => _GameTempLookAndToNewGameViewState();
}

class _GameTempLookAndToNewGameViewState extends State<GameTempLookAndToNewGameView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("查看配置")),
      body: GameTempPreview._private(widget._entity),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
            onPressed: () {
              route.selectTempToCreateNewGameConfigView(widget._entity, widget._isSystemTemp).push();
            },
            child: const Text("使用模板创建一个新游戏对局")),
      ),
    );
  }
}

/// 创建新模板并预览
class NewTempToPreview extends StatefulWidget {
  final GameTemplateConfigEntity _entity;

  const NewTempToPreview(this._entity, {super.key});

  @override
  State<NewTempToPreview> createState() => _NewTempToPreviewState();
}

class _NewTempToPreviewState extends State<NewTempToPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("核验配置")),
      body: SingleChildScrollView(child: GameTempPreview._private(widget._entity)),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _createNewTempToCallback,
                child: const Text("创建，并返回模板列表"),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: _createNewTempToNewGame,
                child: const Text("创建并使用模板创建一个新游戏对局"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 创建新模板
  Future<int> _createNewTemp() async {
    // if (kDebugMode) print("result :${jsonEncode(data)}");
    return await AppFactory().service.createTemp(widget._entity);
    // if (kDebugMode) {
    //   print("result (dbid:${id}) :${jsonEncode(data)}");
    // }
  }

  /// 创建模板并开始新游戏
  Future<void> _createNewTempToNewGame() async {
    var id = await _createNewTemp();
    var entity = await AppFactory().service.getTempForId(id);
    route.selectTempToCreateNewGameConfigView(entity, false).push();
  }

  /// 创建模板并开始新游戏
  Future<void> _createNewTempToCallback() async {
    await _createNewTemp();
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
