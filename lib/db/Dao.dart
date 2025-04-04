import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:god_helper/db/DB.dart';
import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/db/tables.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/framework/GameFactory.dart';

part 'Dao.g.dart';

@DriftAccessor(tables: [GameData, GameTemplateConfig])
class GameDao extends DatabaseAccessor<AppDatabase> {
  GameDao(super.attachedDatabase);

  Future<int> createTemp(GameTemplateConfigEntity data) async {
    return await db.managers.gameTemplateConfig.create((row) => row(
          name: data.name,
          weight: data.weight,
          roleConfig: jsonEncode(data.roleConfig),
          extraRule: jsonEncode(data.extraRule),
          playerCount: data.playerCount,
        ));
  }

  Future<List<GameTemplateConfigEntity>> gameTemps() async {
    return await db.managers.gameTemplateConfig.orderBy((o) => o.id.desc()).get();
  }

  Future<GameTemplateConfigEntity> getTempForId(int configTemplateId) async {
    return (db.select(db.gameTemplateConfig)..where((tbl) => tbl.id.equals(configTemplateId))).getSingle();
  }

  Future<int> createGame({
    required String name,
    required TempExtraRule extraRule,
    required PlayersSaveRule saveRule,
    required int configTemplateId,
    required bool isDefaultConfig,
    required bool isBeginGame,
  }) async {
    return await db.managers.gameData.create((row) => row(
          name: name,
          extraRule: jsonEncode(extraRule),
          saveRule: jsonEncode(saveRule),
          configTemplateId: configTemplateId,
          isDefaultConfig: isDefaultConfig,
          isBeginGame: Value(isBeginGame),
        ));
  }

  Future<GameEntity> getGameForId(int id) async {
    return await (db.select(db.gameData)
          ..where(
            (tbl) => tbl.id.equals(id),
          ))
        .getSingle();
  }

  Future<List<GameEntity>> allGames() async {
    return await db.managers.gameData.orderBy((o) => o.id.desc()).get();
  }

  Future<int> deleteGame(int gameId) async {
    return await (db.delete(db.gameData)..where((tbl) => tbl.id.equals(gameId))).go();
  }

  Future<int> updateGameExtraRule(int id, RoleTempConfig<dynamic> config) async {
    return await (db.update(db.gameData)..where((tbl) => tbl.id.equals(id)))
        .write(GameDataCompanion(extraRule: Value(jsonEncode(config.toJson()))));
  }

  Future<int> updateGameFinish(int id, bool isFinish) async {
    return await (db.update(db.gameData)..where((tbl) => tbl.id.equals(id)))
        .write(GameDataCompanion(isFinish: Value(isFinish)));
  }

  Future<int> removeTemp(int id) async {
    return await (db.delete(db.gameTemplateConfig)..where((tbl) => tbl.id.equals(id))).go();
  }
}
