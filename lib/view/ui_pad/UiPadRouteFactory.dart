import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/framework/AppFactory.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/view/ui2/phone/GaemTempPreview.dart';
import 'package:god_helper/view/ui2/phone/GameConfigPreview.dart';
import 'package:god_helper/view/ui2/phone/GameConfigView.dart';
import 'package:god_helper/view/ui2/phone/GameDayView.dart';
import 'package:god_helper/view/ui2/phone/GameNightView.dart';
import 'package:god_helper/view/ui2/phone/GameProcessesView.dart';
import 'package:god_helper/view/ui2/phone/GameTemplateListView.dart';
import 'package:god_helper/view/ui2/phone/ResourceView.dart';
import 'package:god_helper/view/ui2/phone/RoleDetailsView.dart';
import 'package:god_helper/view/ui_pad/GameListView.dart';
import 'package:god_helper/view/ui_pad/MakeNewGameBeginView.dart';
import 'package:god_helper/view/ui_pad/MakeNewGameSelectTempView.dart';
import 'package:god_helper/view/ui_pad/MakeNewTempView.dart';

class UiPadRouteFactory extends AppRoute {
  UiPadRouteFactory(super.context);

  @override
  RouteHelper beginGameToView(GameDetailEntity entity) {
    var factory = GameFactory.create(entity);
    return beginGameToViewFromFactory(factory);
  }

  @override
  RouteHelper beginGameToViewFromFactory(GameFactory factory) {
    var entity = factory.entity;
    if (!entity.isBeginGame) {
      return toHelper(GameConfigView(factory: factory));
    }
    if (factory.summary.isGameOver()) {
      if (!factory.entity.isFinish) {
        AppFactory.single().service.gameFinish(entity);
      }
      return toGameSummaryView(factory);
    }
    var round = factory.getRound();
    return toGameRoundView(factory, round);
  }

  @override
  RouteHelper toGameSummaryView(GameFactory factory) {
    return toHelper(GameProcessesView(factory));
  }

  @override
  RouteHelper toGameRoundView(GameFactory factory, int round) {
    var rh = RoundHelper(round);
    // 如果游戏已经开始，则判断当前回合是白天还是黑夜，直接进入游戏对应界面
    if (rh.isNight) {
      return toHelper(GameNightView(factory, rh.round));
    } else {
      return toHelper(GameDayView(factory, rh.round));
    }
  }

  @override
  RouteHelper createNewGameToPreView(GameFactory factory) {
    return toHelper(GameConfigPreview(factory));
  }

  @override
  RouteHelper selectTempToCreateNewGameConfigView(GameTemplateConfigEntity temp, bool isSystemConfig) {
    var factory = AppFactory().makeNewGamePreFactory(temp, isSystemConfig);
    return toHelper(GameConfigView(factory: factory));
  }

  @override
  RouteHelper toCreateNewTemp({GameTemplateConfigEntity? temp}) {
    return toHelper(MakeNewTempView(
      temp: temp,
    ));
  }

  @override
  RouteHelper toTemplateSelectView() {
    return toHelper(const MakeNewGameSelectTempView(type: ConfigViewType.create));
  }

  @override
  RouteHelper toTempPreview(GameTemplateConfigEntity data) {
    return toHelper(GameTempPreview.newTempPreview(data));
  }

  @override
  RouteHelper toTempDetail(GameTemplateConfigEntity temp, bool isSystemConfig) {
    return toHelper(GameTempPreview.toLookAndToNewGame(temp, isSystemConfig));
  }

  @override
  RouteHelper toRoleDetailsView() {
    return toHelper(const RowDetailsView());
  }

  @override
  RouteHelper toAssetsResourceView() {
    return toHelper(const ResourceView());
  }

  RouteHelper toGameListView() {
    return toHelper(const GameListView());
  }

  /// 新游戏-选择板子界面
  RouteHelper toNewGameSelectTempView(ConfigViewType type, GameTemplateConfigEntity entity) {
    return toHelper(MakeNewGameSelectTempView(type: type, data: entity));
  }

  /// 新游戏-配置界面
  RouteHelper toNewGameToConfig(GameTemplateConfigEntity entity) {
    return toHelper(MakeNewGameBeginView.make(entity));
  }

//
// @override
// RouteHelper routeToGameView() {
//   if (!entity.isBeginGame) {
//     return toHelper(GameConfigView(factory: super.factory));
//   }
//
//   if (super.factory.summary.isGameOver()) {
//     return toProcessesView();
//   }
//
//   var round = super.factory.getRound();
//   return pushToRoundView(round);
// }
//
// @override
// RouteHelper toTempSelectPage() {
//   return toHelper(const GameTemplateListView(type: ConfigViewType.replace));
// }
//
// @override
// RouteHelper beginGameToView() {
//   if (kDebugMode) {
//     print("开始游戏");
//   }
//   return routeToGameView();
// }
//
// @override
// RouteHelper pushToRoundView(int round) {
//   var rh = RoundHelper(round);
//
//   /// 如果游戏已经开始，则判断当前回合是白天还是黑夜，直接进入游戏对应界面
//   if (rh.isNight) {
//     return toHelper(GameNightView(super.factory, rh.round));
//   } else {
//     return toHelper(GameDayView(super.factory, rh.round));
//   }
// }
//
// @override
// RouteHelper toProcessesView() {
//   return toHelper(GameProcessesView(super.factory));
// }
//
// @override
// RouteHelper gameFinish() {
//   return toHelper(GameProcessesView(super.factory));
// }
}
