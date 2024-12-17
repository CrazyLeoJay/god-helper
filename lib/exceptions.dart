import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:sprintf/sprintf.dart';

abstract class ErrorMessage {
  int get code;

  String get err;
}

enum AppError implements ErrorMessage, Exception {
  none(0, ""),
  gameNoSelectTemp(1, "游戏未选择模板"),
  roleAlreadySetting(2, "角色早已设置身份。"),
  tempNotSetting(3, "游戏模板还未设置！"),
  playerCountTooSmall(4, "玩家数量太少了！"),
  identityWolfPlayerNumberIsNotInWolfNumberList(5, "当前角色对应的玩家，不在狼人玩家列表中"),
  roleNotConfigAction(6, "当前角色没有配置 Action 实体"),
  noSearchPlayer(7, "没有找到该玩家 %s", defaultArgs: [""]),
  witchTargetIsNull(8, "女巫没有设置用药目标"),
  roleNoteSetPlayer(9, "角色 %s 还未设置玩家"),
  notGetLastProcessInFirstRound(10, "无法在第一回合获取上一回合的process"),
  withDayWolfBombNotSelectWolf(11, "白天选择狼自爆，但没有选择狼人"),
  withDayNoSelectVoteOutPlayer(12, "白天没有选择投票出局的玩家"),
  withDayNoYesVoteOutPlayer(13, "白天没有确认投票出局的玩家"),
  withDayNoSelectSheriffPlayer(14, "白天没有选择警长玩家"),
  putZeroPlayerToStateMap(15, "给玩家状态列表设置0号玩家"),
  wolfNotSelectKillPlayer(16, "狼人玩家尚未决定击杀谁"),
  youNeedTransferSheriff(17, "你需要处理移交警徽行为"),
  youNeedSelectTransferSheriffPlayer(18, "你需要选择被转移警徽的玩家"),
  witchNoActionYes(19, "女巫还没有行动"),
  hunterNoSelectPlayer(20, "猎人还没有选择玩家"),
  wolfKingNoSelectPlayer(21, "狼王还没有选择玩家"),
  hunterNoSelectShutPlayer(22, "猎人还没有选择击杀玩家"),
  wolfKingNoSelectShutPlayer(23, "狼王还没有选择玩家"),
  selectWolfCountTooSmall(24, "选择的狼人数量太少"),
  roleNoFinishAction(24, "未完成其角色行为"),
  dayNeedVoteSelectSheriff(25, "白天需要先选举警长"),
  haveDieSheriffNoTransfer(26, "警长 %d 阵亡，还未转移警徽"),
  outPlayerActionNoExcFinish(27, "出局玩家的技能还未发动完成"),
  withNightKillNoSelectPlayer(28, "女巫晚上使用毒药没有选择玩家"),
  withNightSaveNoSelectPlayer(28, "女巫晚上使用解药没有选择玩家"),
  gameNotFinish(29, "游戏还未结束"),
  citizenCountToMany(30, "村民太多，应该还有角色未设置"),
  withNoSaveSelf(31, "女巫不能自救"),
  roleActionNotYes(32, "角色 %s 还未行动"),
  roleActionNotKillPlayer(33, "角色 %s 没有击杀玩家"),
  wolfBeautyNoSelectPlayer(34, "狼美人没有选择魅惑目标或者放弃技能。"),
  barbarianChildSelectPlayerOnlyFirstNight(35, "野孩子必须在第一晚选择一位榜样。"),
  roleNoSelectPlayer(36, "%s 没有选择玩家。"),
  foxNotVerify(37, "狐狸还未进行验证"),
  ;

  @override
  final int code;

  @override
  final String err;

  final List<dynamic>? defaultArgs;

  const AppError(this.code, this.err, {this.defaultArgs});

  @override
  String toString() {
    return "Exc:$code: $err";
  }

  AppException toExc({List<dynamic>? args, dynamic obj}) {
    return AppException(this, args: args, obj: obj);
  }
}

class AppException implements Exception {
  AppError error;
  final List<dynamic>? args;
  dynamic obj;
  String? message;

  AppException(this.error, {this.args, this.obj});

  @override
  String toString() {
    var msg = (args?.isEmpty ?? true) ? error.err : sprintf(error.err, args ?? error.defaultArgs ?? []);
    return "Exc:${error.code}-${message ?? ""}: $msg";
  }

  void printMessage({StackTrace? stackTrace}) {
    if (kDebugMode) {
      print(toString());
      var current = StackTrace.current;
      print(current);
      if (null != stackTrace) {
        print(toString());
        print("ERROR: stackTrace");
        print(stackTrace);
      }
    }
  }
}
