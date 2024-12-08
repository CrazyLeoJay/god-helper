import 'package:flutter/material.dart';
import 'package:god_helper/extend.dart';

extension AppStyleContext on BuildContext {
  /// 标题
  Widget title(String title) {
    return Row(
      children: [
        Text(
          title,
          style: app.font.title,
        ),
      ],
    );
  }
}

extension AppStyleStateless on StatelessWidget {}

extension AppStyleStateful on State {
  Widget title(String title) => context.title(title);
}
