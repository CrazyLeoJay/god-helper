import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:god_helper/db/Dao.dart';
import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/framework/GameFactory.dart';

class AppService {
  final GameDao _dao;

  AppService(this._dao);

  /// 根据模板创建一个新游戏并返回
  Future<GameFactory> createNewGame(GameFactory factory) async {
    var entity = factory.entity;
    var tempId = entity.tempConfig!.id;
    // if (entity.isSystemConfig) {}
    entity.isBeginGame = true;

    if (kDebugMode) print("json ${jsonEncode(entity)}");

    var id = await _dao.createGame(
      name: entity.name,
      configTemplateId: tempId,
      isDefaultConfig: entity.isSystemConfig,
      extraRule: factory.extraRule,
      saveRule: factory.saveRule,
      isBeginGame: entity.isBeginGame,
    );

    var dbEntity = await _dao.getGameForId(id);
    var e = await GameDetailEntity.forDb(dbEntity);
    return GameFactory.create(e);
  }

  /// 获取所有游戏
  Future<List<GameDetailEntity>> allGames() async {
    var games = await _dao.allGames();
    List<GameDetailEntity> list = [];
    for (var value in games) {
      list.add(await GameDetailEntity.forDb(value));
    }
    return list;
  }

  /// 删除游戏
  Future<void> deleteGame(int id) async {
    await _dao.deleteGame(id);
  }

  /// 获取所有模板
  Future<List<GameTemplateConfigEntity>> gameTemps() async {
    return await _dao.gameTemps();
  }

  /// 创建游戏模板
  Future<int> createTemp(GameTemplateConfigEntity data) async {
    return await _dao.createTemp(data);
  }

  /// 根据模板id获取模板
  Future<GameTemplateConfigEntity> getTempForId(int configTemplateId) async {
    return await _dao.getTempForId(configTemplateId);
  }

  Future<int> updateGameExtraRule(int id, RoleTempConfig config) async {
    return await _dao.updateGameExtraRule(id, config);
  }

  Future<void> gameFinish(GameDetailEntity entity) async {
    await _dao.updateGameFinish(entity.id, true);
    if (kDebugMode) {
      var future = await _dao.getGameForId(entity.id);
      print("更新玩家结束状态: ${entity.id} is finish  select verify: entity.isFinish=${future.isFinish}");
    }
  }

  removeTemp(int id) async {
    await _dao.removeTemp(id);
  }
}
