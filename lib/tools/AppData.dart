import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:god_helper/extend.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 数据存储
class AppData {
  static final _appData = AppData._privateConstructor();

  /// 获取 SharedPreferences 单例
  Future<SharedPreferences> get _sharedPreferences async => SharedPreferences.getInstance();

  /// 对外可以获取的 SharedPreferences 对象
  Future<SharedPreferences> get sp async => _sharedPreferences;
  final noSql = _NoSql(dbName: "app_data_hive_db");

  // 保存文件
  final defaultConfigFile = _ConfigFile(path: 'app_data/default.txt');

  AppData._privateConstructor() {
    init();
  }

  factory AppData() => _appData;

  Future<void> init() async {
    noSql.init();
  }

  // 上面是单例设置，下面是数据存储部分

  //  sharedPreferences
  // shared_preferences 是Flutter中最常用的本地数据存储插件，适用于轻量级的数据存储，比如用户偏好设置、简单的配置信息等。

  /// 保存数据
  Future<void> _putString(String key, String value) async {
    SharedPreferences prefs = await _sharedPreferences;
    await prefs.setString(key, value);
  }

  /// 获取数据
  Future<String> _getString(String key) async {
    SharedPreferences prefs = await _sharedPreferences;
    return prefs.getString(key) ?? '默认值';
  }

  // nosql hive库 存储方式

  /// 指定文件名
  Future<File> _config(String name) async {
    return _ConfigFile(path: 'app_data/$name').getFile();
  }
}

class _NoSql {
  final String dbName;
  var _init = false;

  _NoSql({required this.dbName});

  Future<void> init() async {
    await Hive.initFlutter();
    var path = (await appDir()).path;
    Hive.openBox(dbName, path: path);
    _init = true;
  }

  /// nosql hive库 保存数据
  void save(dynamic key, dynamic value) {
    var box = Hive.box(dbName);
    box.put(key, value);
    if (kDebugMode) print("save($key) = $value");
  }

  /// nosql hive库 删除数据
  void delete(dynamic key) {
    var box = Hive.box(dbName);
    box.delete(key);
  }

  /// 获取数据
  E getData<E>(dynamic key, {E? defaultValue}) {
    var box = Hive.box(dbName);
    return box.get(key);
  }

  void clear() {
    var box = Hive.box(dbName);
    box.clear();
  }
}

class _ConfigFile {
  final String path;

  _ConfigFile({required this.path});

  /// 获取文件路径
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// 获取文件
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${this.path}');
  }

  /// 保存数据
  Future<File> writeData(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }

  /// 读取数据
  Future<String> readData() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return 'Error reading file';
    }
  }

  Future<File> getFile() async => _localFile;
}
