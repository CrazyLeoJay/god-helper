import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:json_annotation/json_annotation.dart';

part 'DefaultFactoryConfig.g.dart';

/// 默认的玩家选择器
class DefaultPlayerIdentityGenerator extends PlayerIdentityGenerator {
  DefaultPlayerIdentityGenerator(super.factory, super.role);

  @override
  Widget widget() {
    return RolePlayerNumberCommentRecordWidget(
      factory: super.factory,
      role: role,
      defaultValue: cache.getRoleNumber(role),
      isRecordFinish: cache.isRoleRecordFinish[role] ?? false,
      finishAndSaveCallback: (player) {
        cache.setRoleIdentity(role, player);
        cache.setRolePlayerRecordFinish(role);
        cache.save();
        if (kDebugMode) print("cache ${jsonEncode(cache)}");
      },
    );
  }
}

@JsonSerializable()
class DefaultCacheEntity extends NoSqlDataEntity<DefaultCacheEntity> {
  Role role;

  int playerId = 0;

  bool isRecordFinish = false;

  DefaultCacheEntity(super.gameId, this.role);

  factory DefaultCacheEntity.fromJson(Map<String, dynamic> json) => _$DefaultCacheEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DefaultCacheEntityToJson(this);

  @override
  DefaultCacheEntity createForMap(Map<String, dynamic> map) {
    return DefaultCacheEntity.fromJson(map);
  }

  @override
  DefaultCacheEntity emptyReturn() => this;

  @override
  String getSaveKey() {
    return "game_${gameId}_identity_${role.name}";
  }
}

/// 角色玩家通用记录器
class RolePlayerNumberCommentRecordWidget extends StatefulWidget {
  final GameFactory factory;
  final Role role;
  final int defaultValue;
  final bool isRecordFinish;
  final Function(int player) finishAndSaveCallback;

  const RolePlayerNumberCommentRecordWidget({
    super.key,
    required this.factory,
    required this.role,
    required this.defaultValue,
    required this.isRecordFinish,
    required this.finishAndSaveCallback,
  });

  @override
  State<RolePlayerNumberCommentRecordWidget> createState() => _RolePlayerNumberCommentRecordWidgetState();
}

class _RolePlayerNumberCommentRecordWidgetState extends State<RolePlayerNumberCommentRecordWidget> {
  GameFactory get factory => widget.factory;

  int _selectIndex = 0;
  bool _isRecordFinish = false;

  List<int> get noIdentityPlayerIds => factory.players.getNoIdentityPlayerIds();

  @override
  void initState() {
    super.initState();
    _selectIndex = widget.defaultValue;
    _isRecordFinish = widget.isRecordFinish;
  }

  @override
  Widget build(BuildContext context) {
    // var roleNumber = widget.gamePlayerStateNote.getRoleNumber(widget.role);
    // if (kDebugMode) {
    //   print("get role ${widget.role.desc.name} number is $roleNumber");
    // }
    return Column(
      children: [
        RichText(
          text: TextSpan(
            style: app.baseFont.copyWith(color: Colors.black),
            children: [
              const TextSpan(text: "(上帝记录)"),
              const WidgetSpan(child: SizedBox(width: 4)),
              TextSpan(
                text: widget.role.desc.name,
                style: app.baseFont.copyWith(color: Colors.red),
              ),
              const WidgetSpan(child: SizedBox(width: 4)),
              const TextSpan(text: "是"),
              const WidgetSpan(child: SizedBox(width: 8)),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: PlayerSingleSelectButton.initConfig(
                  config: SelectConfig(
                    circleSize: 35,
                    selectableList: noIdentityPlayerIds,
                    defaultSelect: _selectIndex,
                    callback: (t) => setState(() => _selectIndex = t),
                    selectable: !_isRecordFinish,
                  ),
                ),
              ),
              const WidgetSpan(child: SizedBox(width: 8)),
              const TextSpan(text: "号玩家"),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _yesPlayerIdentityButton(),
      ],
    );
  }

  Widget _yesPlayerIdentityButton() => _isRecordFinish
      ? const Text("已确认身份，请进行今晚操作")
      : TextButton(onPressed: () => _yesPlayerIdentity(), child: const Text("确认他的身份?"));

  final _isShowState = IsShowState();

  /// 确定玩家身份
  void _yesPlayerIdentity() {
    if (_selectIndex <= 0 || _selectIndex > factory.entity.tempConfig!.roleConfig.count()) {
      showSnackBarMessage("还未选择玩家", isShow: _isShowState);
      return;
    }

    var role = factory.players.cache.checkPlayerIsConfig(_selectIndex);
    if ((role) != null) {
      showSnackBarMessage("该玩家已经配置过身份，他的身份是：${role.desc.name}", isShow: _isShowState);
      return;
    }

    _isRecordFinish = true;
    widget.finishAndSaveCallback(_selectIndex);
    setState(() {});
  }
}
