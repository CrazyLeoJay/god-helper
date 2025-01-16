import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/extend.dart';

// 资源界面
class ResourceView extends StatefulWidget {
  const ResourceView({super.key});

  @override
  State<ResourceView> createState() => _ResourceViewState();
}

class _ResourceViewState extends State<ResourceView> {
  final _circleSize = 70.0;

  TextStyle get _font => app.baseFont.copyWith();

  TextStyle get _titleFont => _font.copyWith(fontSize: 30);

  TextStyle get _roleFont => _font.copyWith(fontSize: _circleSize * 0.2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("资源预览", style: _titleFont),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(children: [
              Text(
                "角色",
                style: _titleFont,
              )
            ]),
            AutoGridView(
              circleSize: _circleSize,
              childAspectRatio: 9 / 12,
              padding: 16.0,
              data: Role.all,
              itemBuilder: (t) {
                return Column(
                  children: [
                    Container(
                      // circleSize: _circleSize,
                      width: _circleSize,
                      height: _circleSize,
                      // color: Colors.black,
                      child: t.icon(
                        size: _circleSize * 0.5,
                        color: Colors.red,
                      ),
                    ),
                    Center(child: Text(t.roleName, style: _roleFont)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
