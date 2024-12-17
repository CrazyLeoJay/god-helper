import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/framework/AppFactory.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/view/ui2/phone/CreateNewTempView.dart';
import 'package:god_helper/view/ui2/phone/GaemTempPreview.dart';
import 'package:god_helper/view/ui2/phone/GameConfigPreview.dart';
import 'package:god_helper/view/ui2/phone/GameConfigView.dart';
import 'package:god_helper/view/ui2/phone/GameDayView.dart';
import 'package:god_helper/view/ui2/phone/GameNightView.dart';
import 'package:god_helper/view/ui2/phone/GameProcessesView.dart';
import 'package:god_helper/view/ui2/phone/GameTemplateListView.dart';
import 'package:god_helper/view/ui2/phone/RoleDetailsView.dart';

class Ui2RouteFactory extends AppRoute {
  Ui2RouteFactory(super.context);

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
  RouteHelper selectTempToCreateNewTemp(GameTemplateConfigEntity temp) {
    return toHelper(CreateNewTempView(defaultValue: temp));
  }

  @override
  RouteHelper toCreateNewTemp() {
    return toHelper(const CreateNewTempView());
  }

  @override
  RouteHelper toTemplateSelectView() {
    return toHelper(const GameTemplateListView(type: ConfigViewType.create));
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
    return toHelper(RowDetailsView());
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
