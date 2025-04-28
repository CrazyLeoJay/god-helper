import 'package:flutter/material.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/res/app.dart';

class CTheme {
  final BuildContext context;

  CTheme(this.context);

  App get app => context.app;

  TextStyle get titleStyle => app.baseFont.copyWith(fontSize: 28);

  TextStyle get secondTitleStyle => app.baseFont.copyWith(fontSize: 26);

  TextStyle get subTitleStyle => secondTitleStyle;

  TextStyle get thirdTitleStyle => app.baseFont.copyWith(fontSize: 24);

  TextStyle get fourthTitleStyle => app.baseFont.copyWith(fontSize: 22);

  TextStyle get contentStyle => app.baseFont.copyWith(fontSize: 18);

  Color get selectColor => Colors.orange;
}

extension ThemeStateContext on BuildContext {
  CTheme get theme => CTheme(this);
}

extension ThemeState on State {
  CTheme get theme => CTheme(context);
}

extension MyTextStyle on TextStyle {
  TextStyle copyToClick() => copyWith(color: Colors.deepPurple);
}
