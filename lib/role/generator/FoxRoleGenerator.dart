import 'package:annotation/annotation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/exceptions.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/framework/impl/NightFactory.dart';
import 'package:god_helper/role/generator/DefaultEmptyGenerator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'FoxRoleGenerator.g.dart';

// 狐狸
var _role = Role.fox;

/// 狐狸
class FoxRoleGenerator extends RoleGenerator<FoxNightAction, EmptyAction, EmptyRoleTempConfig> {
  FoxRoleGenerator({required super.factory}) : super(role: _role);

  @override
  RoleNightGenerator<FoxNightAction>? getNightRoundGenerator(NightFactory nightFactory) {
    return _FoxNightRoleRoundGenerator(nightFactory);
  }
}

@ToJsonEntity()
@JsonSerializable()
class FoxNightAction extends RoleAction {
  int? selectPlayer;
  List<int>? selectPlayers;
  bool? isWolf;
  bool isAbandon = false;

  FoxNightAction() : super(_role);

  factory FoxNightAction.fromJson(Map<String, dynamic> json) => _$FoxNightActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FoxNightActionToJson(this);

  void setSelect(int selectPlayer, List<int> selectPlayers, bool isWolf) {
    this.selectPlayer = selectPlayer;
    this.selectPlayers = selectPlayers;
    this.isWolf = isWolf;
    isAbandon = false;
    isYes = true;
  }

  void setCancel() {
    selectPlayer = null;
    selectPlayers = null;
    isWolf = null;
    isAbandon = true;
    isYes = true;
  }

  @override
  void setToPlayerDetail(PlayerDetail detail, PlayerStateMap states) {
    super.setToPlayerDetail(detail, states);
    if (!isYes) throw AppError.roleActionNotYes.toExc(args: [role.name]);
    // 放弃使用技能
    if (isAbandon) return;
    if (selectPlayer == null) throw AppError.roleNoSelectPlayer.toExc(args: [role.name]);
    if (isWolf == null) throw AppError.foxNotVerify.toExc(args: [role.name]);
    var player = detail.getForRole(role);
    if (isWolf == false) {
      states.set(selectPlayer!, PlayerStateType.verifyForFox);
      /// 没有狼人，技能失效
      player.putBuff(PlayerBuffType.foxVerifyThreeGoodPlayer);
      return;
    }

    /// 设置狐狸查验结果
    states.set(player.number, isWolf! ? PlayerStateType.foxVerifyWolf : PlayerStateType.foxVerifyNoWolf);
  }
}

class _FoxNightRoleRoundGenerator extends RoleNightGenerator<FoxNightAction> with _FoxNightHelper {
  final NightFactory _nightFactory;

  _FoxNightRoleRoundGenerator(this._nightFactory) : super(role: _role, roundFactory: _nightFactory);

  @override
  JsonEntityData<FoxNightAction> actionJsonConvertor() {
    return FoxNightActionJsonData();
  }

  @override
  Widget actionWidget(Function() updateCallback) {
    return _FoxNightView(
      _nightFactory,
      action,
      this,
      cancelListener: (finishCallback) {
        action.setCancel();
        saveAction();
        finishCallback();
      },
      resultListener: (selectPlayer, finishCallback) {
        var players = selectPlayers(selectPlayer);
        var isWolf = hasWolf(players);
        action.setSelect(selectPlayer, players.map((e) => e.number).toList(), isWolf);
        saveAction();
        finishCallback();
      },
    );
  }
}

mixin _FoxNightHelper on RoleNightGenerator<FoxNightAction> {
  NightFactory get _nightFactory => roundFactory as NightFactory;

  // get _player {
  //   if(_nightFactory.round == 1){
  //     return _nightFactory.factory.players.cache.getRoleNumber(role);
  //   }
  //   return _nightFactory.playerDetails.getForRole(role);
  // }

  bool get isHasSkill {
    if (_nightFactory.round == 1) {
      // 第一回合，100%有技能
      return true;
    } else {
      Player player = _nightFactory.playerDetails.getForRole(role);
      // 判断玩家是否有技能失效buff
      return !player.isBuff(PlayerBuffType.foxVerifyThreeGoodPlayer);
    }
  }

  /// 选择的三个玩家
  List<Player> selectPlayers(int selectPlayer) {
    var details = _nightFactory.playerDetails;
    var player = details.get(selectPlayer);
    List<Player> players = [
      _leftPlayer(details, player),
      player,
      _rightPlayer(details, player),
    ];
    return players;
  }

  Player _leftPlayer(PlayerDetail details, Player p) {
    Player player = p;
    do {
      var i = player.number - 1;
      // 如果已经是第一个玩家的上一个，则直接获取到最后一个玩家
      if (i <= 0) {
        player = details.players.last;
      } else {
        player = details.get(i);
      }
      if (player.live) return player;
    } while (true);
  }

  Player _rightPlayer(PlayerDetail details, Player p) {
    Player player = p;
    do {
      var i = player.number + 1;
      // 如果已经是第一个玩家的上一个，则直接获取到最后一个玩家
      if (i >= details.players.length) {
        player = details.players.first;
      } else {
        player = details.get(i);
      }
      if (player.live) return player;
    } while (true);
  }

  bool hasWolf(List<Player> veryPlayers) {
    for (var value in veryPlayers) {
      if (value.roleType == RoleType.WOLF) return true;
    }
    return false;
  }

  bool hasWolfForSelect(int selectPlayer) {
    var players = selectPlayers(selectPlayer);
    for (var value in players) {
      if (value.roleType == RoleType.WOLF) return true;
    }
    return false;
  }
}

class _FoxNightView extends StatefulWidget {
  final NightFactory _nightFactory;
  final FoxNightAction _action;
  final _FoxNightHelper _helper;
  final Function(Function() finishCallback) cancelListener;
  final Function(int selectPlayer, Function() finishCallback) resultListener;

  const _FoxNightView(
    this._nightFactory,
    this._action,
    this._helper, {
    required this.cancelListener,
    required this.resultListener,
  });

  @override
  State<_FoxNightView> createState() => _FoxNightViewState();
}

class _FoxNightViewState extends State<_FoxNightView> {
  NightFactory get _nightFactory => widget._nightFactory;

  FoxNightAction get _action => widget._action;

  _FoxNightHelper get _helper => widget._helper;

  List<int> get livePlayerIds => _nightFactory.getLivePlayerIds();

  int selectPlayer = 0;

  final double _circleSize = 35;

  var selectListener = ValueNotifier(1);

  @override
  void initState() {
    super.initState();
    selectPlayer = _action.selectPlayer ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    if (_helper.isHasSkill) {
      return Column(
        children: [
          const Text("请指定一个玩家进行验证"),
          RichText(
            text: TextSpan(
              style: app.baseFont,
              children: [
                const TextSpan(text: "选择玩家\t\t"),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: PlayerSingleSelectButton(
                    selectConfig: SelectConfig(
                      selectableList: livePlayerIds,
                      defaultSelect: selectPlayer,
                      callback: (t) => setState(() => selectPlayer = t),
                      updateDataToUiListener: selectListener,
                    ),
                  ),
                ),
                const TextSpan(text: "\t\t进行验证"),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: _circleSize + 5, child: const Center(child: Text("验证的玩家："))),
              _selectPlayersWidget(),
            ],
          ),
          _button()
        ],
      );
    } else {
      return const Text("狐狸技能已经失效，无法使用。");
    }
  }

  Widget _selectPlayersWidget() {
    if (selectPlayer <= 0) {
      return SizedBox(height: _circleSize + 5, child: Center(child: Text("还未选择验证的玩家")));
    }
    var players = _helper.selectPlayers(selectPlayer);

    return SizedBox(
      height: _circleSize + 20,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var player = players[index];
          var isWolf = player.role.type == RoleType.WOLF;
          return Center(
            child: Column(
              children: [
                Circle(
                  circleSize: _circleSize,
                  color: isWolf ? Colors.red : null,
                  child: Text(
                    "P${players[index].number}",
                    style: app.baseFont.copyWith(
                      color: isWolf ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Text(
                  players[index].role.name,
                  style: app.baseFont.copyWith(
                    fontSize: 8,
                    color: isWolf ? Colors.red : Colors.black,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemCount: players.length,
      ),
    );
  }

  final _isShow = IsShowState();

  PlayerSingleSelectButtonState? selectWidgetState;

  Widget _button() {
    if (_action.isYes) {
      if (_action.isAbandon) {
        return const Text("狐狸放弃使用技能");
      } else {
        // return Text("经过验证，他们中${_helper.hasWolfForSelect(selectPlayer)?"有狼人":"全是好人"}");
        return RichText(
          text: TextSpan(
            style: app.baseFont,
            children: [
              const TextSpan(text: "经过验证，他们中"),
              _helper.hasWolfForSelect(selectPlayer)
                  ? TextSpan(text: "有狼人", style: app.baseFont.copyWith(color: Colors.red))
                  : TextSpan(text: "全是好人", style: app.baseFont.copyWith(color: Colors.green))
            ],
          ),
        );
      }
    } else {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                if (!_nightFactory.isAction(context, _role, _isShow)) return;
                selectPlayer = 0;
                selectListener.value = -selectListener.value;
                // widget.cancelListener(() => setState(() {}));
              },
              child: const Text("不使用技能"),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () {
                if (!_nightFactory.isAction(context, _role, _isShow)) return;
                if (selectPlayer <= 0) {
                  showSnackBarMessage("还未选查验玩家", isShow: _isShow);
                  return;
                }
                widget.resultListener(selectPlayer, () => setState(() {}));
              },
              child: const Text("确认验证该玩家"),
            ),
          ),
        ],
      );
    }
  }
}
