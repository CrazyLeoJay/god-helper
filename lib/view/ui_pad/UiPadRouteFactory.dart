import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/framework/AppFactory.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/view/ui2/phone/GaemTempPreview.dart';
import 'package:god_helper/view/ui2/phone/GameConfigPreview.dart';
import 'package:god_helper/view/ui2/phone/GameConfigView.dart';
import 'package:god_helper/view/ui2/phone/GameTemplateListView.dart';
import 'package:god_helper/view/ui2/phone/ResourceView.dart';
import 'package:god_helper/view/ui2/phone/RoleDetailsView.dart';
import 'package:god_helper/view/ui_pad/GameListView.dart';
import 'package:god_helper/view/ui_pad/MakeNewGamePreviewView.dart';
import 'package:god_helper/view/ui_pad/MakeNewGameSelectTempView.dart';
import 'package:god_helper/view/ui_pad/MakeNewTempView.dart';
import 'package:god_helper/view/ui_pad/PlayView.dart';

class UiPadRouteFactory extends AppRoute {
  UiPadRouteFactory(super.context);

  @override
  RouteHelper toPlayGameForEntity(GameDetailEntity entity) {
    var factory = GameFactory.create(entity);
    return toPlay(factory);
  }

  @override
  RouteHelper toPlay(GameFactory factory) {
    var entity = factory.entity;
    if (!entity.isBeginGame) {
      /// 如果还未开始游戏，先去配置界面
      return toHelper(GameConfigView(factory: factory));
    }

    /// 如果已经开始游戏
    if (factory.summary.isGameOver()) {
      /// 如果游戏已经结束，检查游戏状态，直接跳转到结算界面
      if (!factory.entity.isFinish) {
        AppFactory.single().service.gameFinish(entity);
      }
      return toGameSummaryView(factory);
    }

    /// 跳转到游戏接界面
    var round = factory.getRound();
    return toPlayForRound(factory, round);
  }

  @override
  RouteHelper toGameSummaryView(GameFactory factory) {
    // return toHelper(GameProcessesView(factory));
    return toHelper(PlayerView(factory, 0));
  }

  @override
  RouteHelper toPlayForRound(GameFactory factory, int round) {
    // var rh = RoundHelper(round);
    // // 如果游戏已经开始，则判断当前回合是白天还是黑夜，直接进入游戏对应界面
    // if (rh.isNight) {
    //   return toHelper(GameNightView(factory, rh.round));
    // } else {
    //   return toHelper(GameDayView(factory, rh.round));
    // }

    return toHelper(PlayerView(factory, round));
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
    return toHelper(MakeNewGamePreviewView.make(entity));
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
