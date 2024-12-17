import 'dart:convert';

import 'package:annotation/annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/exceptions.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/DefaultFactoryConfig.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/role/generator/DefaultEmptyGenerator.dart';
import 'package:god_helper/role/generator/WolfRoleGenerator.dart';

/// 晚上数据
///
/// 1、当前回合的角色行为数据
/// 2、如果是第一天还需要设置保存用户数据
/// 3、
class NightFactory extends RoundFactory {
  NightFactory(super.round, super.factory);

  NightFactory.empty(GameFactory factory) : super(0, factory);

  PlayerIdentityCache get cache => super.factory.players.cache;

  bool isShowNext(Role roleList) => true;

  @override
  RoleNightGenerator<RoleAction>? getRoleGenerator(Role role) {
    return super.factory.generator.get(role)?.getNightRoundGenerator(this);
  }

  @override
  Map<Role, JsonEntityData<RoleAction>> initActionJsonEntityData() {
    return super.factory.nightActionJsonTransition;
  }

  /// 检查所有角色是否已经完成操作
  @override
  void checkFinish() {
    var cache = super.factory.players.cache;
    var roleConfig = super.factory.entity.tempConfig.roleConfig;
    // 普通狼
    var smallWolfCount = roleConfig.wolfCampCount;
    // 本局所有角色
    var thisRoundRoles = roleConfig.all;
    if (round == 1) {
      // 第一回合检查身份
      if (cache.wolfNumbers.length != smallWolfCount) {
        throw AppError.selectWolfCountTooSmall.toExc()
          ..obj = Role.WOLF
          ..message = "${cache.wolfNumbers.length} / ${smallWolfCount}";
      }
      var action = actions.getRoleAction(Role.WOLF, EmptyActionJsonData());
      if (!action.isYes) {
        throw AppError.roleNoFinishAction.toExc()
          ..obj = Role.WOLF
          ..message = "狼人还未刀人";
      }
    }
    // 需要设置玩家的角色
    var needSetRole = cache.rolePlayerNumberMap.keys;
    for (var value in thisRoundRoles) {
      // 先判断是否设置身份
      if (round == 1 && !needSetRole.contains(value)) {
        throw AppError.roleNoteSetPlayer.toExc(args: [value], obj: value)..message = "还未设置玩家身份";
      }
      // 判断action是否完成
      if (kDebugMode) print("to json $value");
      var action = getRoleAction(value);

      if (round != 1) {
        // 第一回合无需判断
        // 如果玩家已经阵亡，则无需判断
        var player = playerDetails.getForRole(value);
        if (!player.live) {
          if (action != null) {
            action.isYes = true;
            // 保存该行为
            saveAction(value, action);
          }
          continue;
        }
      }

      if (action != null) {
        if (kDebugMode) print("to json $value: ${jsonEncode(action)}");

        if (!action.isYes) {
          throw AppError.roleNoFinishAction.toExc()
            ..obj = value
            ..message = "该角色还有行为未完成";
        }
      }
    }
  }

  @override
  void thisRoundPlayerStateTransition(PlayerDetail details, PlayerStateMap playerStates) {
    for (var entity in actions.roleActionMap.entries) {
      var action = getRoleAction(entity.key);
      if (action == null) continue;
      /// 行为被封印，也无需判断，直接跳过
      if (action.sealing) continue;
      try {
        var player = details.getForRole(entity.key);
        // 如果玩家已经阵亡，则无需处理他的行为
        if (!player.live) continue;
        action.setToPlayerDetail(details, playerStates);
      } on AppException catch (e, stackTrace) {
        e.message = "role:${action.role}";
        if (kDebugMode) print('Stack Trace:\n$stackTrace');
        throw e
          ..obj = action.role
          ..printMessage();
      }
    }

    details.checkLive(playerStates);

    // 二次检查技能的延迟效果
    secondSkillCheckForSummary(details, playerStates);
    details.checkLive(playerStates);
  }

  PlayerIdentityGenerator getIdentityGenerator(Role role) {
    return super.factory.generator.get(role)?.playerIdentityGenerator() ??
        DefaultPlayerIdentityGenerator(super.factory, role);
  }

  /// 判断该角色行为是否已经操作过
  /// 可以进行下一个角色
  bool roleCanNext(Role role) {
    if (round == 1) {
      if (!super.factory.players.cache.isRecordFinish(role)) {
        /// 如果是第一天还没有确定身份，则不可以跳过
        return false;
      }
    } else {
      var player = super.factory.players.details.getForRole(role);
      if (!player.live) {
        /// 如果玩家已经阵亡，则可以继续下一个玩家行为
        return true;
      }
    }

    // RoleAction? action = getActionGenerator(role)?.getAction();
    RoleAction? action = getRoleAction(role);

    /// 没有行为，可以跳过
    if (action == null) return true;

    /// 如果已经完成，则可以跳过
    if (action.isYes) return true;

    /// 如果还没有确认角色身份，则需要确认后跳转
    if (action.canSkip) {
      // 可以跳过情况下，需要判断角色是否已经确认过玩家身份
      return super.factory.players.cache.getRoleNumber(role) > 0;
    }

    return false;
  }

  bool roleCanSkip(Role role) {
    /// 大于第一回合，并且没有Action设置
    /// 则表示这个角色的Action可以跳过
    return round > 1 && (getRoleAction(role)?.canSkip ?? false);
  }

  /// 是否可以执行Action
  /// 1、是否已经确认了身份
  /// 2、是否有前置操作未执行
  bool isAction(BuildContext context, Role role, IsShowState isShow) {
    // 判断是身份是否设置
    // 由于只有第一回合需要设置身份，否则无法进入后面的回合，所以这里仅第一回合判断
    if (round == 1) {
      if (kDebugMode) {
        print("isAction cache : ${jsonEncode(super.factory.players.cache)}");
      }
      if (!super.factory.players.cache.isRecordFinish(role)) {
        context.showSnackBarMessage("${role.roleName} 还没有完成玩家确认", isShow: isShow);
        return false;
      }
    }

    List<Role> afterRoles = role.afterWithRole ?? [];
    if (afterRoles.isNotEmpty) {
      for (var value in afterRoles) {
        // 如果玩家已经阵亡，就直接跳过
        if (!isRolePlayerLive(value)) continue;
        RoleAction? ea = getRoleAction(value);
        // 如果不存在行为数据，直接跳过
        if (ea == null) continue;
        if (!ea.isYes) {
          context.showSnackBarMessage(
            "${role.roleName}：需要角色 ${value.roleName} 睁眼后，才能行动",
            isShow: isShow,
          );
          return false;
        }
      }
    }

    return true;
  }

  /// 获取还存活的玩家
  List<Player> getLivePlayer() => playerDetails.getLivePlayer();

  /// 检查玩家是不是好人
  bool checkIdentityIsGoodboy(int player) {
    if (round == 1) {
      return !super.factory.players.cache.wolfNumbers.contains(player);
    } else {
      return playerDetails.getNullable(player)?.identity ?? true;
    }
  }

  /// 获取狼热击杀的对象
  int? wolfKillWho() {
    var action = WolfRoleGenerator.getRoleNightAction(actions);
    return action.killPlayer;
  }

  int getRoleNumber(Role role) {
    if (round == 1) {
      return cache.getRoleNumber(role);
    } else {
      return playerDetails.getForRole(role).number;
    }
  }

  Player? getPlayer(Role witch) => playerDetails.getForRoleNullable(Role.WITCH);

  ///  该角色对应的玩家是否存活
  ///  在晚上，仅需要判断天黑前玩家的存活状态即可
  bool isRolePlayerLive(Role role) {
    if (round == 1) {
      return true;
    } else {
      return playerDetails.getForRole(role).live;
    }
  }

  List<int> getLivePlayerIds()=> getLivePlayer().map((e) => e.number).toList(growable: false);
}
