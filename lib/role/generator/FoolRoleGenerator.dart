import 'package:annotation/annotation.dart';
import 'package:flutter/cupertino.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/DayFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/role/generator/DefaultEmptyGenerator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'FoolRoleGenerator.g.dart';

// 白痴
var _role = Role.FOOL;

class FoolRoleGenerator extends RoleGenerator<EmptyAction, FoolDayAction, EmptyRoleTempConfig> {
  FoolRoleGenerator({required super.factory}) : super(role: _role);

  @override
  RoleRoundGenerator<FoolDayAction>? getDayRoundGenerator(DayFactory dayFactory) {
    return _FoolDayRoleRoundGenerator(dayFactory);
  }
}

@ToJsonEntity()
@JsonSerializable()
class FoolDayAction extends RoleAction {
  bool isVoteOut = false;

  FoolDayAction() : super(Role.FOOL);

  factory FoolDayAction.fromJson(Map<String, dynamic> json) => _$FoolDayActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FoolDayActionToJson(this);

  @override
  void setToPlayerDetail(PlayerDetail detail, PlayerStateMap states) {
    super.setToPlayerDetail(detail, states);

    if (isVoteOut) {
      // 如果白痴存活，应该有个防投的buff，可以抵挡一次被投票出局
      var player = detail.getForRole(role);
      if (!player.isBuff(PlayerBuffType.foolVoteOutDefense)) {
        states.set(player.number, PlayerStateType.foolShowIdentity);
        states.setBuff(player.number, PlayerBuffType.foolVoteOutDefense);
      }
    }
  }
}

/// 白痴白天行为
/// 应该是被投票后显示
class _FoolDayRoleRoundGenerator extends RoleRoundGenerator<FoolDayAction> with _FoolDayHelper {
  final DayFactory dayFactory;

  _FoolDayRoleRoundGenerator(this.dayFactory) : super(role: _role, roundFactory: dayFactory);

  @override
  Future<void> preAction() async {
    var player = dayFactory.playerDetails.getForRole(role);
    if (!player.live) return super.preAction();

    /// 如果是被投票出局
    if (isVoteOut) {
      action.isVoteOut = true;
      action.isYes = true;
      saveAction();
    }
    return super.preAction();
  }

  @override
  JsonEntityData<FoolDayAction> actionJsonConvertor() => FoolDayActionJsonData();

  @override
  Widget actionWidget(Function() updateCallback) {
    return Column(
      children: [
        isVoteOut ? const Text('白痴被投票出局了，触发被动，依旧存活。') : const Text("不是投票出局，被动技能无法发动"),
      ],
    );
  }
}

mixin _FoolDayHelper on RoleRoundGenerator<FoolDayAction> {
  DayFactory get _dayFactory => roundFactory as DayFactory;

  bool get isVoteOut {
    if (_dayFactory.dayAction.isYesVotePlayer) {
      /// 如果是被投票出局
      if (_dayFactory.dayAction.votePlayer == player.number) {
        return true;
      }
    }
    return false;
  }
}
