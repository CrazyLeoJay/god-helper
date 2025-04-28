import 'package:flutter/material.dart';
import 'package:god_helper/db/DB.dart';
import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/db/Service.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/view/ui2/phone/Ui2RouteFactory.dart';
import 'package:god_helper/view/ui_pad/UiPadRouteFactory.dart';

class AppFactory {
  static final AppFactory _instance = AppFactory._private();

  AppFactory._private();

  /// 获取单例
  factory AppFactory() => _instance;

  factory AppFactory.single() => _instance;

  /// 数据库
  final AppDatabase _db = AppDatabase();

  AppRoute getRoute(BuildContext context) => Ui2RouteFactory(context);

  UiPadRouteFactory getPadRoute(BuildContext context) => UiPadRouteFactory(context);

  /// 获取默认模板
  GameFactory temp() => GameFactory.create(GameDetailEntity.generateForTemp(
        _tempData,
        name: "模板数据",
        isSystemConfig: true,
      ))
        ..players.initDetailsForTemp();

  /// 根据给定的模板生成一个模板数据
  GameFactory tempForTemp(GameTemplateConfigEntity temp) => GameFactory.create(GameDetailEntity.generateForTemp(
        id: -3,
        temp,
        name: "模板数据",
        isSystemConfig: true,
      ));

  /// App 的数据服务
  AppService get service => AppService(_db.gameDao);

  /// 创建新游戏的一个预览工厂
  /// 用这个工厂跳转至配置界面，确认所有配置后，点击开始游戏，创建游戏并开始
  GameFactory makeNewGamePreFactory(
    GameTemplateConfigEntity temp,
    bool isSystemConfig,
  ) {
    return GameFactory.create(GameDetailEntity.generateForTemp(
      temp,
      name: "新游戏",
      isSystemConfig: isSystemConfig,
    ));
  }
}

/// 模板，用于保存角色的默认配置
/// 或者其他配置项
var _tempData = GameTemplateConfigEntity.systemTemp(
  id: -1,
  name: "全角色",
  citizenCount: 4,
  wolfCount: 4,
  roles: RoleType.getRolesForType(),
);

abstract class AppRoute {
  final BuildContext context;

  AppRoute(this.context);

  RouteHelper toHelper(Widget target) {
    return RouteHelper(context: context, target: target);
  }

  /// 开始游戏，
  /// 根据游戏状态进入不同的界面
  /// 调用 toPlay，由于dart没有重载，所以这里需要多个不同明明的方法
  RouteHelper toPlayGameForEntity(GameDetailEntity entity);

  /// 开始游戏
  ///
  /// 会根据游戏状态跳转到
  /// - 游戏界面（回合操作）
  /// - 结算界面
  /// - 游戏配置（一般是游戏创建了，还未开始，则需要进行预配置，这个过程新设计的流程可能会没有，游戏创建后会直接开始）
  RouteHelper toPlay(GameFactory factory);

  /// 进入游戏结算界面，
  /// 游戏没有结束也可以进入，显示的界面效果不同
  RouteHelper toGameSummaryView(GameFactory factory);

  /// 进入游戏指定回合的界面
  RouteHelper toPlayForRound(GameFactory factory, int round);

  /// 进入模板选择界面
  RouteHelper toTemplateSelectView();

  /// 选择模板创建游戏，进入新游戏配置界面
  RouteHelper selectTempToCreateNewGameConfigView(GameTemplateConfigEntity temp, bool isSystemConfig);

  /// 创建一个空的新模板
  ///
  /// 或者通过temp初始化
  RouteHelper toCreateNewTemp({GameTemplateConfigEntity? temp});

  /// 游戏配置完成后，会有一个确认界面，这里对界面进行核对
  RouteHelper createNewGameToPreView(GameFactory factory);

  /// 创建新模板时，通过这个界面去预览，并且创建游戏
  RouteHelper toTempPreview(GameTemplateConfigEntity data);

  /// 跳转到模板详情界面，并且可以以此开始新游戏
  RouteHelper toTempDetail(GameTemplateConfigEntity temp, bool isSystemConfig);

  /// 查看系统配置的角色信息
  RouteHelper toRoleDetailsView();

  RouteHelper toAssetsResourceView();
}
