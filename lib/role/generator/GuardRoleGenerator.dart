import 'package:annotation/annotation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/exceptions.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/framework/impl/NightFactory.dart';
import 'package:god_helper/role/generator/DefaultEmptyGenerator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'GuardRoleGenerator.g.dart';

/// 守卫
var _role = Role.GUARD;

class GuardRoleGenerator extends RoleGenerator<GuardNightAction, EmptyAction, EmptyRoleTempConfig> {
  GuardRoleGenerator({required super.factory}) : super(role: _role);

  @override
  RoleNightGenerator<GuardNightAction>? getNightRoundGenerator(NightFactory nightFactory) {
    return _GuardRoleRoundGenerator(nightFactory: nightFactory);
  }
}

@ToJsonEntity()
@JsonSerializable()
class GuardNightAction extends RoleAction {
  int? protectedPlayer;
  bool isAbandonUseSkill = false;

  GuardNightAction({
    this.protectedPlayer,
    this.isAbandonUseSkill = false,
    super.isKillNotUseSkill = false,
  }) : super(_role);

  factory GuardNightAction.fromJson(Map<String, dynamic> json) => _$GuardNightActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GuardNightActionToJson(this);

  @override
  void setToPlayerDetail(PlayerDetail detail, PlayerStateMap states) {
    super.setToPlayerDetail(detail, states);
    if (isAbandonUseSkill) return;
    if (!isYes) throw AppError.roleActionNotYes.toExc(args: [role.roleName]);
    if ((protectedPlayer ?? 0) > 0) {
      states.set(protectedPlayer!, PlayerStateType.isProtectedForGuard);
    }
  }

  /// 放弃使用技能
  void abandonUseSkill() {
    protectedPlayer = null;
    isAbandonUseSkill = true;
    isYes = true;
  }

  /// 选择保护玩家
  void protectPlayer(int protectedPlayer) {
    this.protectedPlayer = protectedPlayer;
    isAbandonUseSkill = false;
    isYes = true;
  }
}

class _GuardRoleRoundGenerator extends RoleNightGenerator<GuardNightAction> with _GuardHelper {
  final NightFactory nightFactory;

  _GuardRoleRoundGenerator({required this.nightFactory}) : super(roundFactory: nightFactory, role: _role);

  @override
  Widget actionWidget(Function() updateCallback) {
    return _GuardNightWidget(
      nightFactory,
      action,
      this,
      selectListener: (protectedPlayer, updateWidget) {
        action.protectPlayer(protectedPlayer);
        saveAction();
        updateWidget();
      },
      cancelListener: (updateWidget) {
        action.abandonUseSkill();
        saveAction();
        updateWidget();
      },
    );
  }

  @override
  JsonEntityData<GuardNightAction> actionJsonConvertor() {
    return GuardNightActionJsonData();
  }
}

mixin _GuardHelper on RoleNightGenerator<GuardNightAction> {
  /// 获取上一晚上守护的玩家Id
  int? _lastRoundProtectPlayer() {
    if (roundFactory.round < 3) return null;
    if (roundFactory is! NightFactory) return null;
    // var factory = (roundFactory as NightFactory);
    var lastNight = super.factory.getNight(round - 2);
    var action = lastNight.actions.getRoleAction(role, actionJsonConvertor());
    return action.protectedPlayer;
    // return null;
  }

  List<int> get _livePlayerIds {
    List<Player> players = roundFactory.playerDetails.getLivePlayer();
    List<int> list = players.map((e) => e.number).toList();
    int lastRoundProtectPlayer = _lastRoundProtectPlayer() ?? 0;
    if (lastRoundProtectPlayer > 0 && list.contains(lastRoundProtectPlayer)) {
      list.remove(lastRoundProtectPlayer);
    }
    return list;
  }
}

class _GuardNightWidget extends StatefulWidget {
  final NightFactory factory;
  final GuardNightAction action;
  final _GuardHelper helper;
  final Function(int protectedPlayer, Function() updateWidget) selectListener;
  final Function(Function() updateWidget) cancelListener;

  const _GuardNightWidget(
    this.factory,
    this.action,
    this.helper, {
    required this.selectListener,
    required this.cancelListener,
  });

  @override
  State<_GuardNightWidget> createState() => _GuardNightWidgetState();
}

class _GuardNightWidgetState extends State<_GuardNightWidget> {
  NightFactory get _factory => widget.factory;

  GuardNightAction get _action => widget.action;

  List<int> get _livePlayer => widget.helper._livePlayerIds;

  /// 上一晚上守护的玩家
  int? get _lastNightSafePlayer => widget.helper._lastRoundProtectPlayer();

  bool get _isLastSafe => _lastNightSafePlayer != null;

  int _protectPlayer = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            style: context.app.baseFont,
            children: [
              TextSpan(
                text: _role.roleName,
                style: context.app.baseFont.copyWith(color: Colors.red),
              ),
              const TextSpan(text: "，请选择今晚你要守护的玩家"),
            ],
          ),
        ),
        if (_isLastSafe) const Text('(守卫不能连续两晚守护同一个玩家)'),
        if (_isLastSafe) Text('昨晚守护了 $_lastNightSafePlayer 号玩家'),
        RichText(
          text: TextSpan(
            style: context.app.baseFont,
            children: [
              const TextSpan(text: "今晚保护\t\t"),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: PlayerSingleSelectButton(
                  selectConfig: SelectConfig(
                    selectableList: _livePlayer,
                    selectable: !_action.isYes,
                    defaultSelect: _protectPlayer,
                    callback: (t) => _protectPlayer = t,
                  ),
                ),
              ),
              const TextSpan(text: "\t\t号玩家"),
            ],
          ),
        ),
        _button(),
      ],
    );
  }

  final _isShow = IsShowState();

  Widget _button() {
    if (_action.isYes) {
      if (_action.isAbandonUseSkill) {
        return const Text("守卫没有守护任何人");
      } else {
        return Text("守卫选择保护$_protectPlayer号玩家");
      }
    } else {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                if (!_factory.isAction(context, _role, _isShow)) return;
                widget.cancelListener(() => setState(() {}));
                setState(() {});
              },
              child: const Text("不做任何行为"),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () {
                if (!_factory.isAction(context, _role, _isShow)) return;
                if (_protectPlayer <= 0) {
                  showSnackBarMessage("还没有选择要保护的玩家", isShow: _isShow);
                  return;
                }
                widget.selectListener(_protectPlayer, () => setState(() {}));
              },
              child: const Text("确认是否守卫该玩家"),
            ),
          ),
        ],
      );
    }
  }
}
