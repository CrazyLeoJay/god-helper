import 'package:annotation/annotation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/exceptions.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/DayFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/role/generator/DefaultEmptyGenerator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'BombRoleGenerator.g.dart';

var _role = Role.BOMB;

class BombRoleGenerator extends RoleGenerator<EmptyAction, BombDayAction, EmptyRoleTempConfig> {
  BombRoleGenerator({required super.factory}) : super(role: _role);

  @override
  RoleRoundGenerator<BombDayAction>? getDayRoundGenerator(DayFactory dayFactory) {
    return _BombDayRoleRoundGenerator(dayFactory: dayFactory);
  }

  /// 胜利规则
  @override
  AbstractWinRule? checkWinRule() {
    return _BombWinRule(factory: super.factory, role: role);
  }
}

@ToJsonEntity()
@JsonSerializable()
class BombDayAction extends RoleAction {
  List<int> votePlayer = [];

  BombDayAction() : super(_role);

  factory BombDayAction.fromJson(Map<String, dynamic> json) => _$BombDayActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BombDayActionToJson(this);

  void bombPlayer(List<int> votePlayer) {
    this.votePlayer = votePlayer;
    this.isYes = true;
  }

  @override
  void setToPlayerDetail(PlayerDetail detail, PlayerStateMap states) {
    super.setToPlayerDetail(detail, states);
    if (votePlayer.isEmpty) throw AppError.roleActionNotYes.toExc(args: [role]);
    if (!isYes) throw AppError.roleActionNotYes.toExc(args: [role]);
    var player = detail.getForRole(role);
    // states.set(player.number, PlayerStateType.isYesVotePlayer);
    for (int player in votePlayer) {
      states.set(player, PlayerStateType.dieForBomb);
    }
    states.setKillPlayer(player.number, votePlayer);
  }
}

/// 炸弹人胜利判断
class _BombWinRule extends AbstractWinRule {
  _BombWinRule({required super.factory, required super.role});

  @override
  bool isWin() {
    /// todo 炸弹人胜利条件编写
    return false;
  }

  @override
  RoleWinEntity winEntity() {
    return RoleWinEntity(role, "炸弹人被投票带走");
  }
}

class _BombDayRoleRoundGenerator extends RoleRoundGenerator<BombDayAction> with _BombDayHelper {
  final DayFactory dayFactory;

  _BombDayRoleRoundGenerator({required this.dayFactory}) : super(roundFactory: dayFactory, role: _role);

  @override
  Future<void> preAction() {
    if (!isVoteOut) {
      /// 如果不是被投票出局，就直接结束行为
      action.isYes = true;
      saveAction();
    }
    return super.preAction();
  }

  @override
  JsonEntityData<BombDayAction> actionJsonConvertor() {
    return BombDayActionJsonData();
  }

  @override
  Widget actionWidget(Function() updateCallback) {
    return _BombDayWidget(
      factory: dayFactory,
      action: action,
      helper: this,
      bombCallback: (List<int> votePlayer, dynamic Function() updateWidget) {
        action.bombPlayer(votePlayer);
        saveAction();
        updateWidget();

        /// 通知上级视图更新
        updateCallback();
      },
    );
  }
}

mixin _BombDayHelper on RoleRoundGenerator<BombDayAction> {
  DayFactory get _dayFactory => roundFactory as DayFactory;

  List<int> get _livePlayerNumber {
    return _dayFactory.getNowLivePlayer().map((e) => e.number).toList();
  }

  bool get isVoteOut {
    if (roundFactory.round < 2) return false;
    var player = _dayFactory.details.getForRole(role);
    if (_dayFactory.dayAction.isYesVotePlayer) {
      return _dayFactory.dayAction.votePlayer == player.number;
    }
    return false;
  }

  Player get outPlayer => _dayFactory.details.getForRole(role);

  /// 是否继续执行action
  bool isCanContinueAction() {
    /// 如果白天已经不能继续游戏，则对于白狼王，需要判断是否是白狼王自爆
    if (!_dayFactory.isCanContinueAction()) {
      // 炸弹人被投票出局，不会影响其他人的技能，所以直接返回false
      return false;
    }
    return !action.isYes;
  }
}

/// 白天炸弹人被投票的组件
class _BombDayWidget extends StatefulWidget {
  final DayFactory factory;
  final BombDayAction action;
  final _BombDayHelper helper;
  final Function(List<int> votePlayer, Function() updateWidget) bombCallback;

  const _BombDayWidget({
    required this.factory,
    required this.action,
    required this.helper,
    required this.bombCallback,
  });

  @override
  State<_BombDayWidget> createState() => _BombDayWidgetState();
}

class _BombDayWidgetState extends State<_BombDayWidget> {
  BombDayAction get _action => widget.action;

  /// 还存活的玩家
  List<int> get _livePlayerNumber => widget.helper._livePlayerNumber;

  /// 是否被淘汰出局
  bool get _isVoteOut => widget.helper.isVoteOut;

  Player get _outPlayer => widget.helper.outPlayer;

  bool get isYes => !widget.helper.isCanContinueAction();

  /// 投票给炸弹人的玩家
  List<int> select = [];

  @override
  void initState() {
    super.initState();
    select = _action.votePlayer;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVoteOut) {
      return const Text("炸弹人没有被投票带走,无法发动技能。");
    } else {
      return Column(
        children: [
          const Divider(height: 1),
          Row(children: [
            Text(
              "玩家 ${_outPlayer.number}号 ${_role.roleName}出局",
              style: app.baseFont.copyWith(fontSize: 18),
            )
          ]),
          const Text("炸弹人被投票带走"),
          const Text("以下玩家投票给炸弹人"),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black.withOpacity(0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: PlayerMultiSelectButton(
              selectConfig: SelectConfig(
                selectableList: _livePlayerNumber,
                selectable: !isYes,
                defaultSelect: select,
                callback: (t) => setState(() => select = t),
              ),
            ),
          ),
          _button(),
        ],
      );
    }
  }

  final isShow = IsShowState();

  Widget _button() {
    if (isYes) {
      return const Text("投票玩家全部出局");
    } else {
      return TextButton(
          onPressed: () {
            if (select.isEmpty) {
              showSnackBarMessage("还未选择投票给炸弹人的玩家", isShow: isShow);
              return;
            }
            widget.bombCallback(select, () => setState(() {}));
          },
          child: const Text("确认投票的玩家"));
    }
  }
}
