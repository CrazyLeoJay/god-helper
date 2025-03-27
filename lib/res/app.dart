import 'package:flutter/material.dart';
import 'package:god_helper/framework/Theme.dart';
import 'package:god_helper/res/ThemeDiy.dart';
import 'package:god_helper/tools/AppData.dart';

class App extends LeoJayApp {
  _AppStrings get str => _AppStrings();

  _AppDefaultSize get defSize => _AppDefaultSize();

  AppData get data => AppData();

  AppTheme appTheme = AppTheme.DEFAULT;

  App({super.ct = ColorTheme.LIGHT, required super.child, this.appTheme = AppTheme.DEFAULT}) {
    data.init();
  }

  TextStyle get baseFont => font.base;

  static App of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<App>()!;
  }

  @override
  bool updateShouldNotify(App oldWidget) {
    // Assets.theme.dieNotes.role.icons.lg.
    return super.updateShouldNotify(oldWidget);
  }

  void test() {}
}

class _AppStrings {
  String get gameRuleSelect => "板子规则选择";

  String get gameRuleConfig => "板子规则配置";

  String get saveAndCallback => "保存配置并返回";
}

class _AppDefaultSize {
  double defaultCircle = 36;

  // double get iconSize => 30;
  double get iconSize => 45;
}
