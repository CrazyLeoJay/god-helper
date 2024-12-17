import 'package:annotation/annotation.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/framework/impl/NightFactory.dart';
import 'package:god_helper/role/generator/DefaultEmptyGenerator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'BearRoleGenerator.g.dart';

var _role = Role.bear;

/// 熊
class BearRoleGenerator extends RoleGenerator<EmptyAction, EmptyAction, EmptyRoleTempConfig> {
  BearRoleGenerator({required super.factory}) : super(role: _role);

  @override
  SecondSkillCheck? summarySecondSkillCheck(RoundFactory factory) {
    if (factory.isNight) {
      return _BearSecondSkillCheck(factory as NightFactory);
    }
    return super.summarySecondSkillCheck(factory);
  }
}

class _BearSecondSkillCheck extends SecondSkillCheck {
  final NightFactory factory;

  _BearSecondSkillCheck(this.factory);

  @override
  void check(PlayerDetail details, PlayerStateMap states) {
    var player = details.getForRole(_role);
    var leftPlayer = _leftPlayer(details, player);
    // 查看前一个玩家是否有狼
    if(!leftPlayer.identity){
      states.set(player.number, PlayerStateType.theBearGrowled);
      return;
    }
    // 查看后一个玩家是否有狼
    var rightPlayer = _rightPlayer(details, player);
    if(!rightPlayer.identity){
      states.set(player.number, PlayerStateType.theBearGrowled);
      return;
    }
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
}

@ToJsonEntity()
@JsonSerializable()
class BearNightAction extends RoleAction {
  BearNightAction() : super(_role);

  factory BearNightAction.fromJson(Map<String, dynamic> json) => _$BearNightActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BearNightActionToJson(this);
}
