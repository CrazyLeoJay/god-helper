import 'dart:convert';
import 'dart:math';

import 'package:annotation/annotation.dart';
import 'package:drift/drift.dart' as drift;
import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/entity/RuleConfig.dart';
import 'package:god_helper/exceptions.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/temp.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Entity.g.dart';

/// 这个类是为了防止默认的 drift 导入失效
/// 不用，也不要删除
class _DriftTest extends drift.TypeConverter<String, String> {
  @override
  String fromSql(String fromDb) => fromDb;

  @override
  String toSql(String value) => value;
}

/// 游戏数据
@JsonSerializable()
class GameDetailEntity {
  final int id;
  String name;
  bool isSystemConfig = false;

  GameTemplateConfigEntity tempConfig;

  DateTime? createTime;

  TempExtraRule extraRule = TempExtraRule();
  PlayersSaveRule saveRule = PlayersSaveRule();

  /// 是否已经开始游戏，
  /// 默认应该是false
  /// 这里为了方便开发，设置为true
  bool isBeginGame = false;

  /// 游戏是否已经结束
  bool isFinish = false;

  GameDetailEntity({
    this.id = 0,
    required this.name,
    required this.tempConfig,
    this.isSystemConfig = false,
    this.createTime,
    this.isBeginGame = false,
    this.isFinish = false,
  });

  static Future<GameDetailEntity> forDb(GameEntity entity) async {
    GameTemplateConfigEntity temp =
        entity.isDefaultConfig ? getDefaultGameConfig(entity.configTemplateId)! : await entity.tempConfig;
    return GameDetailEntity(
      id: entity.id,
      name: entity.name,
      tempConfig: temp,
      isSystemConfig: false,
      createTime: entity.createTime,
      isBeginGame: entity.isBeginGame,
      isFinish: entity.isFinish,
    );
  }

  factory GameDetailEntity.fromJson(Map<String, dynamic> json) => _$GameDetailEntityFromJson(json);

  Map<String, dynamic> toJson() => _$GameDetailEntityToJson(this);

  factory GameDetailEntity.generateDebugData() {
    return GameDetailEntity(
      id: 0,
      name: "测试数据",
      tempConfig: getDefaultGameConfig(4)!,
      isSystemConfig: true,
      isBeginGame: true,
    );
  }

  factory GameDetailEntity.generateForTemp(
    GameTemplateConfigEntity temp, {
    required bool isSystemConfig,
    String name = "",
    int id = -2,
  }) {
    return GameDetailEntity(
      id: id,
      name: name,
      tempConfig: temp,
      isSystemConfig: isSystemConfig,
    );
  }
}

/// 玩家保护规则
@ToJsonConverter()
@JsonSerializable(constructor: "createForJson")
class PlayersSaveRule extends JsonEntityData<PlayersSaveRule> {
  /// 首刀保护玩家号码牌
  List<int> firstKillSavePlayers = [];

  /// 首验保护玩家号码牌
  List<int> firstVerifySavePlayers = [];

  /// 首毒保护玩家号码牌
  List<int> firstPoisonSavePlayers = [];

  PlayersSaveRule();

  PlayersSaveRule.createForJson({
    required this.firstKillSavePlayers,
    required this.firstVerifySavePlayers,
    required this.firstPoisonSavePlayers,
  });

  factory PlayersSaveRule.fromJson(Map<String, dynamic> json) => _$PlayersSaveRuleFromJson(json);

  Map<String, dynamic> toJson() => _$PlayersSaveRuleToJson(this);

  /// 根据玩家数量移除不存在的玩家号码牌
  void removeForPlayerCount(int count) {
    if (firstKillSavePlayers.isNotEmpty) {
      firstKillSavePlayers.removeWhere((element) => element >= count);
    }
    if (firstVerifySavePlayers.isNotEmpty) {
      firstVerifySavePlayers.removeWhere((element) => element >= count);
    }
    if (firstPoisonSavePlayers.isNotEmpty) {
      firstPoisonSavePlayers.removeWhere((element) => element >= count);
    }
  }

  void clear() {
    firstKillSavePlayers.clear();
    firstVerifySavePlayers.clear();
    firstPoisonSavePlayers.clear();
  }

  @override
  PlayersSaveRule createForMap(Map<String, dynamic> map) {
    return PlayersSaveRule.fromJson(map);
  }

  @override
  PlayersSaveRule emptyReturn() {
    return this;
  }
}

/// 角色设置
class RoleDescription {
  // 角色id
  final int id;

  /// 角色姓名
  final String name;

  /// 阵营，好人阵营还是狼人阵营或者是三方阵营
  final Camp camp;

  /// 身份，好人（三方也算好人）还是狼人
  /// true:好人
  /// false:狼人
  final bool identity;

  final BaseRoleExtraRule? extraRule;

  const RoleDescription(this.id, this.name, this.camp, this.identity, {this.extraRule});

  /// 角色技能补充规则
// TextColumn get extraRule => text()();
}

/// 每局的玩家详情，记录当期最真实的情况。
@ToJsonConverter()
@JsonSerializable()
class PlayerDetail extends NoSqlDataEntity<PlayerDetail> {
  List<Player> players = List.empty();

  int get count => players.length;

  PlayerDetail(super.gameId);

  factory PlayerDetail.fromJson(Map<String, dynamic> e) => _$PlayerDetailFromJson(e);

  Map<String, dynamic> toJson() => _$PlayerDetailToJson(this);

  Map<int, Player> get playerMap {
    var map = <int, Player>{};
    for (var p in players) {
      map[p.number] = p;
    }
    return map;
  }

  int get wolfCount {
    int i = 0;
    for (var value in players) {
      if (!value.identity) i++;
    }
    return i;
  }

  get godCount {
    int i = 0;
    for (Player value in players) {
      if (value.identity && value.roleType == RoleType.GOD) i++;
    }
    return i;
  }

  bool get isAllInit {
    bool i = true;
    for (Player value in players) {
      i = i && value.isInit;
    }
    return i;
  }

  void init(GameFactory factory) {
    var temp = factory.entity.tempConfig;
    if (players.isNotEmpty) return;
    players = List.generate(
      temp.playerCount,
      (index) => Player(number: index + 1),
    );
  }

  Player get(int playerId) => playerMap[playerId] ?? (throw AppError.noSearchPlayer.toExc());

  Player? getNullable(int number) => playerMap[number];

  List<int> getWolfNumbers() {
    List<int> wolfNumbers = [];
    for (var value in players) {
      if (!value.identity) wolfNumbers.add(value.number);
    }
    return wolfNumbers;
  }

  List<int> getCitizenNumber() {
    List<int> numbers = [];
    for (var value in players) {
      if (value.role == Role.citizen) numbers.add(value.number);
    }
    return numbers;
  }

  /// 获取有能力的角色和玩家编码
  Map<Role, int> getHasPowerRoleNumber() {
    Map<Role, int> map = {};
    for (var value in players) {
      if (value.role == Role.citizen) continue;
      if (value.role == Role.wolf) continue;
      map[value.role] = value.number;
    }
    return map;
  }

  Player getForRole(Role role) {
    for (var value in players) {
      if (value.role == role) return value;
    }
    throw AppError.noSearchPlayer.toExc();
  }

  Player? getForRoleNullable(Role role) {
    for (var value in players) {
      if (value.role == role) return value;
    }
    return null;
  }

  List<Player> getCanBombWolf(int bombPlayer) {
    List<Player> list = [];
    for (var value in players) {
      // 存活且为狼人阵营的角色可以自爆
      if ((bombPlayer == value.number) || (value.live && !value.identity)) list.add(value);
    }
    return list;
  }

  /// 获取存活的玩家
  List<Player> getLivePlayer() {
    List<Player> list = [];
    for (var value in players) {
      // 存活且为狼人阵营的角色可以自爆
      if (value.live) list.add(value);
    }
    return list;
  }

  @override
  PlayerDetail createForMap(Map<String, dynamic> map) {
    return PlayerDetail.fromJson(map);
  }

  @override
  PlayerDetail emptyReturn() => this;

  @override
  String getSaveKey() {
    return "game_${gameId}_player_detail";
  }

  void checkLive(PlayerStateMap playerStates) {
    for (var player in players) {
      PlayerStates state = playerStates.get(player.number);
      // 检查是否活着
      // 这里修改的是针对于全局游戏的玩家状态
      player.checkLive(state);
    }
  }

  List<Player> getNoInitPlayer() {
    List<Player> list = [];
    for (var value in players) {
      if (!value.isInit) list.add(value);
    }
    return list;
  }

  /// 给角色设置新buff
  void addNewBuff(Map<int, PlayerBuffs> buffs) {
    for (int playerNumber in buffs.keys) {
      Set list = buffs[playerNumber]?.list ?? {};
      for (var type in list) {
        get(playerNumber).putBuff(type);
      }
    }
  }

  /// 获取狼人，可以参与刀人的玩家
  /// 有些角色会转换为狼人角色，需要这里做出额外判断
  /// 参考参数 Role.isActionForWolf 注释
  List<Player> getWolfKillActionPlayer() {
    List<Player> list = [];
    for (var value in players) {
      if (value.roleType == RoleType.WOLF && value.role.isActionForWolf) list.add(value);
    }
    return list;
  }

  /// 获取是狼人阵营，但不睁眼的玩家
  List<Player> getWolfKillNoActionPlayer() {
    List<Player> list = [];
    for (var value in players) {
      if (value.roleType == RoleType.WOLF && !value.role.isActionForWolf) list.add(value);
    }
    return list;
  }
}

/// 单个玩家
@JsonSerializable()
class Player {
  /// 玩家编号
  int number;

  /// 角色
  Role role;

  /// 是否是好人
  /// 从开局到结束都不会变
  bool identity;

  /// 是否存活
  bool live;

  /// 玩家是否已经初始化过，则，已经给过身份。如果已经给过身份，则后面不能再次选择该玩家
  bool isInit = false;

  late RoleType roleType;

  List<PlayerBuffType> buffs = [];

  Player({
    required this.number,
    // 默认好身份
    this.identity = true,
    // 默认橘色为村名
    this.role = Role.citizen,
    // 默认存活
    this.live = true,
    this.isInit = false,
    RoleType? roleType,
    List<PlayerBuffType>? buffs,
  }) {
    if (roleType == null) {
      this.roleType = role.type;
    } else {
      this.roleType = roleType;
    }

    if (null != buffs) this.buffs = buffs;
  }

  factory Player.fromJson(Map<String, dynamic> e) => _$PlayerFromJson(e);

  Map<String, dynamic> toJson() => _$PlayerToJson(this);

  void updateRole(Role role, RoleType type) {
    this.role = role;
    identity = role.defaultIdentity;
    roleType = type;
    isInit = true;
    // if(kDebugMode) print("player update ${number} isInit ${isInit}");
  }

  /// 根据附加状态检查玩家是否已经出局
  void checkLive(PlayerStates state) {
    // 如果玩家存活，则判断玩家是否存活
    // 每一回合的玩家状态都会刷新
    if (live && state.isDead) live = false;
  }

  /// 添加buff，如果buff早已存在，则返回false
  bool putBuff(PlayerBuffType buff) {
    if (buffs.contains(buff)) return false;
    buffs.add(buff);
    return true;
  }

  /// 判断是否包含该buff
  bool isBuff(PlayerBuffType buff) => buffs.contains(buff);
}

@JsonSerializable()
class PlayerStates {
  Map<PlayerStateType, bool> states = {};

  /// 击杀的玩家
  /// 玩家可能用各种手段击杀其他玩家，这里做一个记录
  /// 一般是只能击杀一个玩家，但架不住有些强力角色可以一次性带走多玩家
  List<int> killPlayer = [];

  /// 如果玩家被有身份的其他玩家使用技能导致出局，需要一个凶手
  /// 被毒、被枪、被摄梦二摄等
  /// 不记录：被奶穿、被狼刀、
  int? murderer;

  PlayerStates({
    Map<PlayerStateType, bool>? states,
    List<int>? killPlayer,
    this.murderer,
  }) {
    if (states != null) this.states = states;
    if (killPlayer != null) this.killPlayer = killPlayer;
  }

  factory PlayerStates.fromJson(Map<String, dynamic> e) => _$PlayerStatesFromJson(e);

  Map<String, dynamic> toJson() => _$PlayerStatesToJson(this);

  bool get(PlayerStateType type) => states[type] ?? false;

  void set(PlayerStateType type, bool value) => states[type] = value;

  void remove(PlayerStateType type) => states.remove(type);

  List<PlayerStateType> get keys => states.keys.toList();

  get length => keys.length;

  /// 是否死亡
  bool get isDead {
    // 晚上行为
    // 如果被狼人刀
    if (get(PlayerStateType.isWolfKill)) {
      // 没有被救，且没有被救
      if (!get(PlayerStateType.isSaveWithMedicine) && !get(PlayerStateType.isProtectedForGuard)) return true;
      // 被守卫了的同时被救，奶穿，还得死
      if (get(PlayerStateType.isSaveWithMedicine) && get(PlayerStateType.isProtectedForGuard)) return true;
      // 被女巫救了，没有被守卫，活下来
      // if (get(PlayerStateType.isSaveWithMedicine) && !get(PlayerStateType.isProtectedForGuard)) return false;
      // 被守卫了，但没有被救，活下来
      // if (!get(PlayerStateType.isSaveWithMedicine) && get(PlayerStateType.isProtectedForGuard)) return false;
    }

    var types = PlayerStateType.values;
    for (var value in types) {
      /// 如果该状态不至死，则直接跳过
      if (!value.ifKill) continue;

      /// 狼人行为已经设置过这里不做二次处理
      if (value == PlayerStateType.isWolfKill) continue;

      /// 如果是投票出局，这里需要判断是否有技能去挡刀
      if (value == PlayerStateType.isYesVotePlayer) {
        // 如果白痴翻牌，可以抵挡一次，需要狼人追刀
        if (get(PlayerStateType.foolShowIdentity)) continue;
        // 长老角色需要两刀才能出局
      }

      /// 其他状态，如果设置为 true，则直接去世出局
      if (get(value)) return true;
    }
    return false;
  }

  /// 获取状态描述
  /// 返回这个玩家受到的状态
  List<String> stateShowStr() {
    List<String> list = [];
    var types = PlayerStateType.values;
    for (var value in types) {
      switch (value) {
        /// 女巫的药剂使用时再提示
        case PlayerStateType.isHavePoison:
        case PlayerStateType.isHaveAntidote:
          break;
        case PlayerStateType.isUsedAntidote:
          if (get(PlayerStateType.isHaveAntidote)) {
            list.add("拥有一瓶解药, ${get(PlayerStateType.isUsedAntidote) ? "已使用" : "未使用"}");
          }
          break;
        case PlayerStateType.isUsedPoison:
          if (get(PlayerStateType.isHavePoison)) {
            list.add("拥有一瓶毒药, ${get(PlayerStateType.isUsedPoison) ? "已使用" : "未使用"}");
          }
          break;
        default:
          if (get(value)) list.add(value.desc);
          break;
      }
    }
    return list;
  }

  List<String> showInDayBeginStates() {
    List<String> list = [];
    var types = PlayerStateType.values;
    for (var value in types) {
      if (!value.isShowInDayBegin) continue;
      if (get(value)) list.add(value.desc);
    }
    return list;
  }
}

/// 玩家每一回合会被附加的状态
/// 当进入下一回合时，重新计算
enum PlayerStateType {
  isWolfKill("该玩家被狼刀了", ifKill: true),
  isProtectedForGuard("被守卫守护"),
  isKillWithPoison("被女巫毒药毒了", ifKill: true),
  isSaveWithMedicine("被女巫解药救了"),
  isCheckedForSeer("被预言家查验"),
  isKillWithHunter("被猎人射杀", ifKill: true),
  isKillWithWolfKing("被狼王射杀", ifKill: true),
  isHaveAntidote("有一瓶解药"),
  isUsedAntidote("用了解药"),
  isHavePoison("有一瓶毒药"),
  isUsedPoison("用了毒药"),
  isWolfBomb("该狼人玩家自爆了", ifKill: true),
  isYesVotePlayer("玩家被推选出局", ifKill: true),
  isSheriff("被选举为警长"),
  transferSheriff("被上一任警长指认为警长"),
  destroySheriff("销毁了警徽"),
  abandonUsePower("放弃使用技能"),
  dieForBomb("被炸弹人炸死", ifKill: true),
  foolShowIdentity("白痴表明身份，抵挡一次投票出局"),
  isKillWithWhiteWolfKing("被白狼王带走", ifKill: true),
  isCharmFormWolfBeauty("被狼美人魅惑"),
  isDieBecauseWolfBeautyDie("由于是狼美人的魅惑对象，随着狼美人出局而出局", ifKill: true),
  barbarianChildExample("成为野孩子的榜样"),
  barbarianChildChangeWolfForExampleDie("由于榜样阵亡，野孩子变为狼人"),
  theBearGrowled("熊咆哮了!", isShowInDayBegin: true),
  bloodMoonApostlesBomb("血月使者自爆。进入黑夜后，所有好人玩家技能全部封禁！"),
  bannedOfShutUpForbiddenElder("玩家被禁言长老禁言了。", isShowInDayBegin: true),
  verifyForFox("被狐狸查验。"),
  foxVerifyWolf("狐狸查验到狼人。"),
  foxVerifyNoWolf("狐狸查验到都是好人。"),
  knightDuelFailure("骑士决斗失败。", ifKill: true),
  knightDuelSuccess("骑士决斗胜利。"),
  killForKnightDuel("被骑士决斗出局。", ifKill: true),
  liveForKnightDuel("被骑士决斗，但存活。"),
  killInWitcherHunt("被猎魔狩猎出局。", ifKill: true),
  killInWitcherHuntFailure("猎魔狩猎失败出局。", ifKill: true),
  ;

  final String desc;

  /// 该状态是否致死
  final bool ifKill;

  /// 是否在一天开始的时候显示该状态
  final bool isShowInDayBegin;

  const PlayerStateType(
    this.desc, {
    this.ifKill = false,
    this.isShowInDayBegin = false,
  });
}

/// 玩家buff类型
/// 长时间持有，当当前回合结束时，会结算玩家回合状态，有时候会得到一些buff
enum PlayerBuffType {
  /// 白痴被投票出局防御一次
  foolVoteOutDefense("白痴被投票，翻牌，抵挡一次投票放逐"),
  foxVerifyThreeGoodPlayer("狐狸验证了三个好人，技能失效"),
  witchUsedAntidote("女巫使用了解药。"),
  witchUsedPoison("女巫使用了毒药。"),
  ;

  final String desc;

  const PlayerBuffType(this.desc);
}

/// 玩家状态集合工具类
@JsonSerializable()
class PlayerStateMap {
  Map<int, PlayerStates> states = {};

  /// 玩家增加的buff
  Map<int, PlayerBuffs> buffs = {};

  PlayerStateMap({Map<int, PlayerStates>? states, Map<int, PlayerBuffs>? buffs}) {
    if (states != null) this.states = states;
    if (buffs != null) this.buffs = buffs;
  }

  factory PlayerStateMap.fromJson(Map<String, dynamic> e) => _$PlayerStateMapFromJson(e);

  Map<String, dynamic> toJson() => _$PlayerStateMapToJson(this);

  PlayerStates get(int number) => states[number] ??= PlayerStates();

  PlayerStates getNoSet(int number) => states[number] ?? PlayerStates();

  PlayerStates? getNullable(int number) => states[number];

  void set(int number, PlayerStateType type, {bool value = true}) {
    if (number <= 0) throw AppError.putZeroPlayerToStateMap.toExc();
    if (value) {
      get(number).set(type, true);
    } else {
      getNullable(number)?.remove(type);
    }
  }

  List<int> get keys => states.keys.toList(growable: false)..sort();

  Iterable<MapEntry<int, PlayerStates>> get entities => states.entries;

  Iterable<PlayerStates> get values => states.values;

  int get length => states.length;

  bool get isEmpty => states.isEmpty;

  bool get isNotEmpty => states.isNotEmpty;

  void forEach(void Function(int key, PlayerStates value) action) => states.forEach(action);

  int? getSheriffPlayerNumber() {
    for (var item in states.entries) {
      /// 如果是被推选为警长或者被禅让为警长，都为警长
      var iisSheriff = item.value.get(PlayerStateType.isSheriff) || item.value.get(PlayerStateType.transferSheriff);
      if (iisSheriff) return item.key;
    }
    return null;
  }

  /// 获取拥有该状态的玩家
  /// 必须同时拥有，并为true
  List<int> getPlayerForType(List<PlayerStateType> types) {
    List<int> ids = [];
    forEach(
      (key, value) {
        var bool = false;
        for (var type in types) {
          bool = bool && value.get(type);
        }
        if (bool) ids.add(key);
      },
    );
    return ids;
  }

  /// 获取持有该状态的玩家，并仅仅返回一个
  /// 这里当确定逻辑是只返回一个玩家时使用
  int? getPlayerForTypeSingle(List<PlayerStateType> types) {
    if (types.isEmpty) return null;
    for (var playerId in keys) {
      // 获取状态
      var playerState = states[playerId];
      if (playerState == null) continue;
      // 判断玩家是否拥有所有状态
      var bool = true;
      for (var type in types) {
        bool = bool && playerState.get(type);
      }
      if (bool) return playerId;
    }
    return null;
  }

  List<int> outPlayerIds() {
    List<int> ids = [];
    for (var playerIds in keys) {
      if (states[playerIds]?.isDead ?? false) ids.add(playerIds);
    }
    return ids;
  }

  void addMap(PlayerStateMap map) {
    for (var value in map.keys) {
      PlayerStates? state = getNullable(value);
      if (state == null) {
        this.states[value] = map.get(value);
      } else {
        var s = map.getNoSet(value);
        state.states.addAll(s.states);
        state.murderer = s.murderer;
        state.killPlayer = ([...state.killPlayer, ...s.killPlayer]).toSet().toList()..sort();
      }
    }
  }

  void setKillPlayer(int id, List<int> list) {
    get(id).killPlayer = list;
    for (var value in list) {
      var murderer = get(value).murderer;
      if (murderer == null) {
        /// 如果重复被杀，则进保留第一个击杀的玩家信息
        get(value).murderer = id;
      }
    }
  }

  void setBuff(int number, PlayerBuffType buff) {
    (buffs[number] ??= PlayerBuffs()).addBuff(buff);
  }
}

@JsonSerializable()
class PlayerBuffs {
  Set<PlayerBuffType> list = {};

  PlayerBuffs({Set<PlayerBuffType>? list}) {
    if (null != list) this.list = list;
  }

  factory PlayerBuffs.fromJson(Map<String, dynamic> e) => _$PlayerBuffsFromJson(e);

  Map<String, dynamic> toJson() => _$PlayerBuffsToJson(this);

  void addBuff(PlayerBuffType buff) {
    // if (list.contains(buff)) return;
    list.add(buff);
  }
}

/// 模板的角色配置
@ToJsonConverter()
@JsonSerializable()
class TemplateRoleConfig {
  /// 普通村名的数量
  /// 这里不包含有技能的村民
  final int citizenCount;

  /// 普通狼人数量
  /// 不包含带技能的狼人
  final int wolfCount;

  final Map<RoleType, List<Role>> roles;

  TemplateRoleConfig({
    this.citizenCount = 0,
    this.wolfCount = 0,
    required this.roles,
  });

  /// 有技能的村民
  List<Role> get citizen => roles[RoleType.CITIZEN] ?? [];

  /// 神位
  List<Role> get gods => roles[RoleType.GOD] ?? [];

  /// 狼神位
  List<Role> get wolfs => roles[RoleType.WOLF] ?? [];

  /// 三方神位
  List<Role> get thirds => roles[RoleType.THIRD] ?? [];

  factory TemplateRoleConfig.fromJson(Map<String, dynamic> e) => _$TemplateRoleConfigFromJson(e);

  Map<String, dynamic> toJson() => _$TemplateRoleConfigToJson(this);

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Role> get all {
    List<Role> list = [];
    list.addAll(citizen);
    list.addAll(gods);
    list.addAll(wolfs);
    list.addAll(thirds);
    return list;
  }

  /// 获取所有有动作的角色
  /// 由于狼人阵营是要在同一时间同时睁眼，所以这里将所有睁眼狼人设置为同一项，狼人
  ///
  /// 所以这里返回的值，删除所有带技能的狼人角色，加入一个普通狼人角色。
  ///
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Role> get allForActions {
    // List<Role> list = [];
    // list.add(Role.WOLF);
    // list.addAll(gods);
    // // list.addAll(wolfs);
    // list.addAll(thirds);
    // list.addAll(citizen);

    List<Role> list = [...all, Role.wolf];
    list.removeWhere((element) => !element.inNightSingleAction);

    /// 排序
    list.sort();
    return list;
  }

  /// 狼人阵营人数
  int get wolfCampCount => wolfCount + wolfs.length;

  int get godsLength => gods.length;

  int get citizenCampLength => citizen.length + citizenCount;

  /// 如果是屠边局，需要击杀多少民或者神
  /// 判断神和民的数量，以数量少的为准
  int get sideKillCount => min(min(godsLength, citizenCampLength), wolfCampCount);

  /// 总人数
  /// 用于在配置后计算是否符合总人数需求配置
  int count() => citizenCount + wolfCount + gods.length + wolfs.length + thirds.length + citizen.length;

  /// 自适应村名和普通狼人数量然后返回一个配置好的模板角色类型
  TemplateRoleConfig adaptiveConfig(int count) {
    // 有职位的角色数量
    int godCount = gods.length + wolfs.length + thirds.length;
    // 村名数量。 (2/3 * 总人数 - 有职位的角色数量) - 三方数量
    int citizenCount = ((2 * count) ~/ 3) - gods.length - thirds.length;
    // 狼人数量。 (1/3 * 总人数 - 有职位的角色数量)
    int wolfCount = count ~/ 3;

    if ((citizenCount + wolfCount) - (count - godCount) == -1) {
      // 如果计算结果的村名数量加普通狼人数量不够剩余的普通身份，则自动补充一个村名
      citizenCount += 1;
    } else if ((citizenCount + wolfCount) - (count - godCount) == -2) {
      // 如果计算结果的村名数量加普通狼人数量不够剩余的普通身份，差两个，则自动补充一个村名和一个狼人
      citizenCount += 1;
      wolfCount += 1;
    }

    // 如果还存在有技能的村民，普通村民数量需要减去
    citizenCount -= citizen.length;
    // 如果存在有技能的狼人，需要减去，即是普通狼人的数量
    wolfCount -= wolfs.length;
    return TemplateRoleConfig(
      citizenCount: citizenCount,
      wolfCount: wolfCount,
      roles: roles,
    );
  }

  /// 获取一个简单的名称
  String toSimpleName() {
    String name = "";
    for (var value in gods) {
      name += value.roleName.substring(0, 1);
    }
    for (var value in citizen) {
      name += value.roleName.substring(0, 1);
    }
    for (var value in wolfs) {
      name += value.roleName.substring(0, 1);
    }
    for (var value in thirds) {
      name += value.roleName.substring(0, 1);
    }

    return "${name}${count()}人局";
  }
}

/// 模板规则
@ToJsonConverter()
@JsonSerializable()
class TempExtraRule with ToJsonInvoke {
  Map<Role, Map<String, dynamic>> ruleMaps = {};

  WinRule winRule;

  TempExtraRule({
    Map<Role, Map<String, dynamic>>? ruleMaps,
    this.winRule = WinRule.KILL_SIDE,
  }) {
    if (ruleMaps != null) this.ruleMaps = ruleMaps;
  }

  factory TempExtraRule.fromJson(Map<String, dynamic> e) => _$TempExtraRuleFromJson(e);

  @override
  Map<String, dynamic> toJson() => _$TempExtraRuleToJson(this);

  factory TempExtraRule.forFactory(TempExtraRule extraRule) => TempExtraRule(
        ruleMaps: extraRule.ruleMaps,
        winRule: extraRule.winRule,
      );

  SheriffRace get sheriffRace => getSheriffConfig().sheriffRace;

  List<Role> get keys => ruleMaps.keys.toList(growable: false);

  void add(Role role, ToJsonInvoke rule) {
    ruleMaps[role] = rule.toJson();
  }

  SheriffExtraConfig getSheriffConfig() {
    return SheriffExtraConfig.fromJson(ruleMaps[Role.sheriff] ?? {});
  }

  void setSheriffConfig(SheriffRace config) {
    ruleMaps[Role.sheriff] = (getSheriffConfig()..sheriffRace = config).toJson();
  }

  /// 初始化警长配置
  void initSheriff() {
    ruleMaps[Role.sheriff] = SheriffExtraConfig().toJson();
  }

  T get<T>(Role role, RoleTempConfig<T> jed) {
    var map = ruleMaps[role];
    if (map == null) return jed.emptyReturn();
    return jed.createForMap(map);
  }

  void put<T>(Role role, RoleTempConfig<T> config) {
    ruleMaps[role] = config.toJson();
  }
}

mixin ToJsonInvoke {
  Map<String, dynamic> toJson();
}
