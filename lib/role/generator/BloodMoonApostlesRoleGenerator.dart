import 'package:annotation/annotation.dart';
import 'package:flutter/cupertino.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/DayFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/role/generator/DefaultEmptyGenerator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'BloodMoonApostlesRoleGenerator.g.dart';

/// 血月使徒
var _role = Role.bloodMoonApostles;

class BloodMoonApostlesRoleGenerator
    extends RoleGenerator<EmptyAction, BloodMoonApostlesDayAction, EmptyRoleTempConfig> {
  BloodMoonApostlesRoleGenerator({required super.factory}) : super(role: _role);

  @override
  RoleDayRoundGenerator<BloodMoonApostlesDayAction>? getDayRoundGenerator(DayFactory dayFactory) {
    return _BloodMoonApostlesDayRoleRoundGenerator(dayFactory);
  }

  @override
  SecondSkillCheck? summarySecondSkillCheck(RoundFactory factory) {
    if (factory is DayFactory) {
      return _BloodMoonApostlesSecondSkillCheck(factory as DayFactory);
    }
    return super.summarySecondSkillCheck(factory);
  }
}

@ToJsonEntity()
@JsonSerializable()
class BloodMoonApostlesDayAction extends RoleAction {
  bool isBomb = false;

  BloodMoonApostlesDayAction() : super(_role);

  factory BloodMoonApostlesDayAction.fromJson(Map<String, dynamic> json) => _$BloodMoonApostlesDayActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BloodMoonApostlesDayActionToJson(this);

  @override
  void setToPlayerDetail(PlayerDetail detail, PlayerStateMap states) {
    super.setToPlayerDetail(detail, states);
    var player = detail.getForRole(role);
    if (isBomb) {
      states.set(player.number, PlayerStateType.bloodMoonApostlesBomb);
    }
  }
}

class _BloodMoonApostlesDayRoleRoundGenerator extends RoleDayRoundGenerator<BloodMoonApostlesDayAction> {
  final DayFactory _dayFactory;

  _BloodMoonApostlesDayRoleRoundGenerator(this._dayFactory) : super(roundFactory: _dayFactory, role: _role);

  @override
  JsonEntityData<BloodMoonApostlesDayAction> actionJsonConvertor() {
    return BloodMoonApostlesDayActionJsonData();
  }

  Player get _player => _dayFactory.playerDetails.getForRole(role);

  /// 是否是本角色自爆
  bool get _isBomb => _dayFactory.isYesWolfBomb && _player.number == _dayFactory.dayAction.wolfBombPlayer;

  @override
  Future<void> preAction() {
    if (_dayFactory.dayAction.isDieForId(player.number)) {
      action.isBomb = true;
      action.isYes = true;
      saveAction();
    }

    return super.preAction();
  }

  @override
  Widget? outWidget( Function() updateCallback) {
    if (_isBomb) {
      return const Column(
        children: [
          Wrap(children: [Text("血月使徒自爆，下一轮所有非狼人玩家，无法使用技能。")])
        ],
      );
    } else {
      return const Text("非自爆出局，没有任何行为。");
    }
  }
}

class _BloodMoonApostlesSecondSkillCheck extends SecondSkillCheck {
  final DayFactory _dayFactory;

  _BloodMoonApostlesSecondSkillCheck(this._dayFactory);

  Player get _player => _dayFactory.playerDetails.getForRole(_role);

  /// 是否是本角色自爆
  bool get _isBomb => _dayFactory.isYesWolfBomb && _player.number == _dayFactory.dayAction.wolfBombPlayer;

  @override
  void check(PlayerDetail details, PlayerStateMap states) {
    if (_isBomb) {
      _dayFactory.nextRoundConfig.sealingSkillForNoWolf();
    }
  }
}
