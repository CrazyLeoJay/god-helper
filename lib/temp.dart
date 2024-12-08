import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/entity/RuleConfig.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/role/generator/WitchRoleGenerator.dart';

/// 游戏默认的角色板子配置
List<GameTemplateConfigEntity> defaultGameTemplate = [
  GameTemplateConfigEntity(
    id: 1,
    name: "经典预女猎九人局",
    playerCount: 9,
    roleConfig: TemplateRoleConfig(
      citizenCount: 3,
      wolfCount: 3,
      roles: {
        RoleType.GOD: [Role.SEER, Role.WITCH, Role.HUNTER]
      },
    ),
    extraRule: TempExtraRule()
      ..winRule = WinRule.KILL_SIDE
      ..add(Role.SHERIFF, SheriffExtraConfig(sheriffRace: SheriffRace.onlyFirstDay))
      ..add(Role.WITCH, WitchExtraConfig(witchRule: WitchSelfSaveRuleType.ALL_NOT_SAVE)),
    weight: 1,
    isDefaultConfig: true,
  ),
  GameTemplateConfigEntity(
    id: 2,
    name: "预女猎守狼王12人局",
    playerCount: 12,
    roleConfig: TemplateRoleConfig(
      citizenCount: 4,
      wolfCount: 3,
      roles: {
        RoleType.GOD: [Role.SEER, Role.WITCH, Role.HUNTER, Role.GUARD],
        RoleType.WOLF: [Role.WOLF_KING],
      },
    ),
    extraRule: TempExtraRule()
      ..winRule = WinRule.KILL_SIDE
      ..add(Role.SHERIFF, SheriffExtraConfig(sheriffRace: SheriffRace.onlyFirstDay))
      ..add(Role.WITCH, WitchExtraConfig(witchRule: WitchSelfSaveRuleType.ONLY_FIRST_DAY_SELF_SAVE)),
    weight: 2,
    isDefaultConfig: true,
  ),
  GameTemplateConfigEntity(
    id: 3,
    name: "白狼王预女猎守12人局",
    playerCount: 12,
    roleConfig: TemplateRoleConfig(
      citizenCount: 4,
      wolfCount: 3,
      roles: {
        RoleType.GOD: [Role.SEER, Role.WITCH, Role.HUNTER, Role.GUARD],
        RoleType.WOLF: [Role.WHITE_WOLF_KING],
      },
    ),
    extraRule: TempExtraRule()
      ..winRule = WinRule.KILL_SIDE
      ..add(Role.SHERIFF, SheriffExtraConfig(sheriffRace: SheriffRace.onlyFirstDay))
      ..add(Role.WITCH, WitchExtraConfig(witchRule: WitchSelfSaveRuleType.ONLY_FIRST_DAY_SELF_SAVE)),
    weight: 3,
    isDefaultConfig: true,
  ),
  GameTemplateConfigEntity(
    id: 4,
    name: "预女猎守狼王炸弹人12人局",
    playerCount: 12,
    roleConfig: TemplateRoleConfig(
      citizenCount: 3,
      wolfCount: 3,
      roles: {
        RoleType.GOD: [Role.SEER, Role.WITCH, Role.HUNTER, Role.GUARD],
        RoleType.WOLF: [Role.WOLF_KING],
        RoleType.THIRD: [Role.BOMB],
      },
    ),
    extraRule: TempExtraRule()
      ..winRule = WinRule.KILL_SIDE
      ..add(Role.SHERIFF, SheriffExtraConfig(sheriffRace: SheriffRace.notForSecond))
      ..add(Role.WITCH, WitchExtraConfig(witchRule: WitchSelfSaveRuleType.ALL_NOT_SAVE)),
    weight: 3,
    isDefaultConfig: true,
  ),
  GameTemplateConfigEntity(
    id: 5,
    name: "白痴白狼王12人局",
    playerCount: 12,
    roleConfig: TemplateRoleConfig(
      citizenCount: 4,
      wolfCount: 3,
      roles: {
        // RoleType.CITIZEN: [Role.],
        RoleType.GOD: [Role.SEER, Role.WITCH, Role.HUNTER, Role.FOOL],
        RoleType.WOLF: [Role.WHITE_WOLF_KING],
      },
    ),
    extraRule: TempExtraRule()
      ..winRule = WinRule.KILL_SIDE
      ..add(Role.SHERIFF, SheriffExtraConfig(sheriffRace: SheriffRace.onlyFirstDay))
      ..add(Role.WITCH, WitchExtraConfig(witchRule: WitchSelfSaveRuleType.ALL_NOT_SAVE)),
    weight: 3,
    isDefaultConfig: true,
  ),
  // GameTemplateConfigEntity(
  //    id: 5,
  //    name: "炸弹人禁言长老12人局",
  //    playerCount: 12,
  //    roleConfig: TemplateRoleConfig(
  //      citizenCount: 2,
  //      wolfCount: 3,
  //      roles: {
  //        // RoleType.CITIZEN: [Role.],
  //        RoleType.GOD: [Role.SEER, Role.WITCH, Role.HUNTER, Role.FOOL],
  //        RoleType.WOLF: [Role.WOLF_KING],
  //        RoleType.THIRD: [Role.BOMB],
  //      },
  //    ),
  //    extraRule: TempExtraRule()
  //      ..winRule = WinRule.KILL_SIDE
  //      ..add(Role.SHERIFF, SheriffExtraConfig(sheriffRace: SheriffRace.onlyFirstDay))
  //      ..add(Role.WITCH, WitchExtraConfig(witchRule: WitchSelfSaveRuleType.ALL_NOT_SAVE)),
  //    weight: 3,
  //    isDefaultConfig: true,
  //  ),
];

/// 将list转为map，方便获取游戏默认配置
Map<int, GameTemplateConfigEntity> defaultGameTemplateMap = defaultGameTemplate.toMap(
  key: (element) => element.id,
  value: (element) => element,
);

/// 获取的游戏配置可能不存在
GameTemplateConfigEntity? getDefaultGameConfig(int id) {
  return defaultGameTemplateMap[id];
}
