import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:god_helper/db/Dao.dart';
import 'package:god_helper/db/DbEntity.dart';
import 'package:god_helper/db/tables.dart';
import 'package:god_helper/extend.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'DB.g.dart'; //

var _dbName = "my_database";

LazyDatabase _appOpenConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    // final Directory dbFolder = await getApplicationDocumentsDirectory();
    final Directory dbFolder = await appDir();
    // 打印目录文件
    // if (kDebugMode) {
    //   var list = dbFolder.listSync();
    //   for (var value in list) {
    //     print(value.path);
    //   }
    // }
    // final file = File(p.join(dbFolder.path, 'db.sqlite'));
    final file = File(p.join(dbFolder.path, '$_dbName.sqlite'));

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    // 特定于Android的解决方法是必要的，因为sqlite3尝试使用/tmp在类unix系统上存储私有数据，这在Android上是禁止的。
    // 我们也利用这个机会来解决一些旧的Android设备通过dart:ffi加载自定义库的问题。
    final cachebase = (await tempDir()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(
      file,
      // logStatements: kDebugMode,
    );
  });
}

@DriftDatabase(tables: [GameData, GameTemplateConfig], daos: [GameDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  static QueryExecutor _openConnection() {
    // driftDatabase from package:drift_flutter stores the database in
    // getApplicationDocumentsDirectory().

    // return driftDatabase(name: 'my_database');
    return _appOpenConnection();
  }

  static Future<AppDatabase> init() async => await AppDatabase();

  /// 数据库升级、迁移
  /// https://drift.simonbinder.eu/Migrations/step_by_step/?h=migration
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        if (from == 1 && to == 2) {
          await m.addColumn(gameData, gameData.saveRule);
          await m.addColumn(gameData, gameData.isBeginGame);
        } else if (from == 2 && to == 3) {
          await m.addColumn(gameData, gameData.isBeginGame);
        } else if (from == 3 && to == 4) {
        } else if (from == 4 && to == 5) {
          await m.addColumn(gameTemplateConfig, gameTemplateConfig.delete);
        }
      },
    );
  }
}
