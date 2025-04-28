import 'package:drift/drift.dart';
import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/entity/Entity.dart';

/// 游戏配置
/// 每一行都代表一局游戏
@UseRowClass(GameEntity, constructor: "forDB")
class GameData extends Table {
  /// 对局自增ID
  /// 对局流程会通过这个字段与流程相关表坐关联，
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  /// 游戏配置ID
  IntColumn get configTemplateId => integer()();

  /// 是否使用了系统默认配置。
  /// 如果使用了默认的系统配置，则直接从代码中读取，否则从 GameTemplateConfig 表中获取
  BoolColumn get isDefaultConfig => boolean()();

  /// 补充规则，
  /// 补充规则在游戏模板配置选中以后，会有一个默认的配置，但用户可以修改这个配置。
  TextColumn get extraRule => text().map(const TempExtraRuleDriftConverter())();

  /// 玩家保护机制保存
  TextColumn get saveRule => text().map(const PlayersSaveRuleDriftConverter())();

  /// 是否开始游戏
  BoolColumn get isBeginGame => boolean().withDefault(const Constant(false))();

  /// 游戏是否已经结束
  BoolColumn get isFinish => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createTime => dateTime().withDefault(Constant(DateTime.now()))();
}

/// 游戏配置，即游戏板子配置。
@UseRowClass(GameTemplateConfigEntity, constructor: "forDB")
class GameTemplateConfig extends Table {
  /// 模板id
  IntColumn get id => integer().autoIncrement()();

  /// 模板名称
  TextColumn get name => text()();

  /// 游戏人数
  IntColumn get playerCount => integer()();

  /// 角色配比数据
  TextColumn get roleConfig => text().map(const TemplateRoleConfigDriftConverter())();

  /// 补充规则。角色限制配置，这个用于初始化游戏配置中的补充规则
  TextColumn get extraRule => text().map(const TempExtraRuleDriftConverter())();

  /// 排序权重
  IntColumn get weight => integer()();

  DateTimeColumn get createTime => dateTime().withDefault(Constant(DateTime.now()))();

  BoolColumn get delete => boolean().withDefault(const Constant(false))();

}
