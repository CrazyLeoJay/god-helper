import 'package:json_annotation/json_annotation.dart';

part 'RoleActions.g.dart';

/// 警徽流处理工具
@JsonSerializable(constructor: "forJson")
class SheriffTools {
  List<SheriffAction> list = [];

  /// 是否完成了警长选举行为
  /// 就是指是否完成了第一任警长的选举
  /// 是否确认选择警长玩家
  bool isYesSheriffPlayer = false;

  SheriffTools();

  SheriffTools.forJson(this.list, {this.isYesSheriffPlayer = false});

  factory SheriffTools.fromJson(Map<String, dynamic> json) => _$SheriffToolsFromJson(json);

  Map<String, dynamic> toJson() => _$SheriffToolsToJson(this);

  bool get isEmpty => list.isEmpty;

  int get length => list.length;

  SheriffAction get last => list.last;

  SheriffAction get defaultSheriffAction {
    if (list.isEmpty) {
      var action = SheriffAction();
      list.add(action);
      return action;
    }
    return list[0];
  }

  SheriffAction get lastSheriffAction {
    SheriffAction action = list.last;
    // 阵亡并且撕毁警徽，返回当前
    if (!action.isLive && action.isDestroySheriff) return action;
    // 阵亡并且转移警徽，返回转移的玩家
    if (!action.isLive && action.isTransferSheriff && action.transferSheriffPlayer != null) {
      action = SheriffAction(sheriffPlayer: action.transferSheriffPlayer);
      list.add(action);
    }
    return action;
  }

  /// 获取当前持有警徽的玩家
  int? get nowSheriffPlayer {
    if (list.isEmpty) return null;
    if (list.length == 1 && list[0].sheriffPlayer == null) return null;

    /// 倒叙从列表里获取事件
    /// 根据机制设计，最后一个玩家应该是警徽流的持有或者撕毁
    /// 前面的警长仅当阵亡时，才会创建并传递给下一个
    var length = list.length;
    var item = list[length - 1];
    // 如果警徽已被销毁，返回 null
    if (item.isDestroySheriff && item.isTransferSheriff) return null;
    // 如果没有销毁，则返回玩家id，理论上，这个值一定存在
    return item.sheriffPlayer;
  }

  void add(SheriffAction action) => list.add(action);

  void remove(SheriffAction action) => list.remove(action);

  void clear() => list.clear();

  void addAll(List<SheriffAction> actions) => list.addAll(actions);

  List<int> getOutIds() {
    List<int> list = [];
    for (var value in this.list) {
      if (!value.isLive) list.add(value.sheriffPlayer!);
    }
    return list;
  }

  /// 通过击杀列表获取警徽流 action
  ///
  /// @param killPlayers 当前角色的击杀列表
  SheriffAction? getForKillPlayerIds(List<int> killPlayers) {
    for (var value in list) {
      /// 如果还未设置警徽就跳过，一般是第一条
      if (null == value.sheriffPlayer) continue;
      if (killPlayers.contains(value.sheriffPlayer!)) {
        return value;
      }
    }
    return null;
  }

  SheriffAction getNowSheriff() {
    for (var value in list) {
      if (value.isLive) return value;
    }

    /// 如果都死光了，则可能是销毁了警徽，直接返回最后一个
    return list.last;
  }
}

/// 警徽行为
/// 这里记录白天的警徽变化行为
@JsonSerializable(constructor: "forJson")
class SheriffAction {
  /// 警长玩家
  int? sheriffPlayer;

  /// 警长玩家是否存活
  bool isLive = true;
  bool isTransferSheriff = false;
  bool isDestroySheriff = false;
  int? transferSheriffPlayer;

  SheriffAction({this.sheriffPlayer});

  SheriffAction.forJson(
    this.sheriffPlayer,
    this.isTransferSheriff,
    this.isDestroySheriff,
    this.transferSheriffPlayer,
  );

  factory SheriffAction.fromJson(Map<String, dynamic> json) => _$SheriffActionFromJson(json);

  Map<String, dynamic> toJson() => _$SheriffActionToJson(this);
}
