import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:god_helper/exceptions.dart';
import 'package:god_helper/framework/AppFactory.dart';
import 'package:god_helper/res/app.dart';
import 'package:god_helper/tools/AppData.dart';
import 'package:god_helper/view/ui_pad/UiPadRouteFactory.dart';

Map<K, V> listToMap<T, K, V>(List<T> list, K Function(T element) keyExtractor, V Function(T element) valueExtractor) {
  Map<K, V> map = {};
  for (var element in list) {
    K key = keyExtractor(element);
    V value = valueExtractor(element);
    map[key] = value;
  }
  return map;
}

extension ListTools<T> on List<T> {
  Map<K, V> toMap<K, V>({
    required K Function(T element) key,
    required V Function(T element) value,
  }) =>
      listToMap(this, key, value);
}

/// 带参数的回调结果
typedef Callback<T> = void Function(T t);

/// 统一的结束回调
typedef FinishCallback = void Function();

extension AppState<T extends StatefulWidget> on State<T> {
  App get app => context.app;

  AppData get data => context.data;

  AppRoute get route => context.route;
  UiPadRouteFactory get padRoute => context.padRoute;

  TextStyle get defaultFont => app.font.base;

  void showSnackBar(SnackBar sb, {required IsShowState isShow}) => context.showSnackBar(sb, isShow: isShow);

  void showSnackBarMessage(String message, {required IsShowState isShow}) =>
      context.showSnackBarMessage(message, isShow: isShow);

  void showSnackBarWidget(Widget content, {required IsShowState isShow}) =>
      context.showSnackBarWidget(content, isShow: isShow);

  void showSnackBarRich(TextSpan textSpan, {required IsShowState isShow}) =>
      context.showSnackBarRich(textSpan, isShow: isShow);
}

extension AppBuildContextExtends on BuildContext {
  App get app => App.of(this);

  AppData get data => AppData();

  TextStyle get defaultFont => app.font.base;

  AppRoute get route => AppFactory().getRoute(this);
  UiPadRouteFactory get padRoute => AppFactory.single().getPadRoute(this);

  void showSnackBar(SnackBar sb, {required IsShowState isShow}) {
    if (isShow.isShow) return;
    isShow.isShow = true;
    ScaffoldMessenger.of(this).showSnackBar(sb).closed.then(
      (value) {
        isShow.isShow = false;
      },
    );
  }

  void showSnackBarMessage(String message, {required IsShowState isShow}) => showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: "好的",
            onPressed: () {},
          ),
        ),
        isShow: isShow,
      );

  void showSnackBarWidget(Widget content, {required IsShowState isShow}) => showSnackBar(
        SnackBar(
          content: content,
          action: SnackBarAction(
            label: "好的",
            onPressed: () {},
          ),
        ),
        isShow: isShow,
      );

  void showSnackBarRich(TextSpan textSpan, {required IsShowState isShow}) => showSnackBar(
        SnackBar(
          content: RichText(text: textSpan),
          action: SnackBarAction(
            label: "好的",
            onPressed: () {},
          ),
        ),
        isShow: isShow,
      );
}

class IsShowState {
  bool isShow = false;
}

extension ExceptionTools on AppException {
  void printMessage() {
    if (kDebugMode) {
      print(toString());
    }
  }
}

Future<bool> assetsExists(String assetName) async {
  try {
    // 尝试加载资产文件
    await rootBundle.load(assetName);
    // 如果没有抛出异常，则文件存在
    return true;
  } catch (e) {
    // 如果抛出异常，则文件不存在
    return false;
  }
}

Future<ByteData> loadAssets(String assets) {
  return rootBundle.load(assets);
}
