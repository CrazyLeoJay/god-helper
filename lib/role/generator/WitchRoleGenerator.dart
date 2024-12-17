import 'package:annotation/annotation.dart';
import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:god_helper/entity/Role.dart';
import 'package:god_helper/entity/RuleConfig.dart';
import 'package:god_helper/exceptions.dart';
import 'package:god_helper/extend.dart';
import 'package:god_helper/framework/GameFactory.dart';
import 'package:god_helper/framework/impl/FrameworkEntity.dart';
import 'package:god_helper/framework/impl/NightFactory.dart';
import 'package:json_annotation/json_annotation.dart';

part 'WitchRoleGenerator.g.dart';

/// 女巫玩家生成器
class WitchRoleGenerator extends RoleGenerator<WitchAction, WitchAction, WitchExtraConfig> {
  WitchRoleGenerator({required super.factory}) : super(role: Role.WITCH);

  static WitchAction getRoleNightAction(RoundActions actions) {
    return actions.getRoleAction(Role.WITCH, WitchActionJsonData());
  }

  static WitchAction? getRoleNightActionNullable(RoundActions actions) {
    return actions.getRoleActionNullable(Role.WITCH, WitchActionJsonData());
  }

  @override
  TempExtraGenerator<WitchExtraConfig>? extraRuleGenerator() {
    return _WitchTempExtraGenerator(super.factory, super.role);
  }

  @override
  RoleNightGenerator<WitchAction>? getNightRoundGenerator(NightFactory nightFactory) {
    return _WitchNightRoleRoundGenerator(nightFactory);
  }
}

@JsonSerializable()
class WitchExtraConfig extends RoleTempConfig<WitchExtraConfig> {
  WitchSelfSaveRuleType witchRule = WitchSelfSaveRuleType.ONLY_FIRST_DAY_NOT_SELF_SAVE;

  WitchExtraConfig({
    this.witchRule = WitchSelfSaveRuleType.ONLY_FIRST_DAY_NOT_SELF_SAVE,
  });

  factory WitchExtraConfig.get(GameFactory factory) {
    return factory.extraRule.get(Role.WITCH, WitchExtraConfig());
  }

  factory WitchExtraConfig.fromJson(Map<String, dynamic> json) => _$WitchExtraConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WitchExtraConfigToJson(this);

  @override
  WitchExtraConfig createForMap(Map<String, dynamic> map) {
    return WitchExtraConfig.fromJson(map);
  }

  @override
  WitchExtraConfig emptyReturn() => this;

  bool isCanSaveSelf(int round) {
    switch (witchRule) {
      case WitchSelfSaveRuleType.ALL_NOT_SAVE:
        return false;
      case WitchSelfSaveRuleType.ALL_SELF_SAVE:
        return true;
      case WitchSelfSaveRuleType.ONLY_FIRST_DAY_SELF_SAVE:
        return round == 1;
      case WitchSelfSaveRuleType.ONLY_FIRST_DAY_NOT_SELF_SAVE:
        return round != 1;
    }
  }
}

class _WitchTempExtraGenerator extends TempExtraGenerator<WitchExtraConfig> {
  _WitchTempExtraGenerator(super.factory, super.role);

  @override
  WitchExtraConfig initExtraConfigEntity() => WitchExtraConfig();

  @override
  List<String> configResultMessage() => ["女巫自救规则：${config.witchRule.desc}"];

  @override
  Widget tempView({bool isPreview = false}) {
    return WitchExtraRuleView(
      defaultValue: config.witchRule,
      isPreview: isPreview,
      onChange: (witchRule) {
        config.witchRule = witchRule;
        saveConfig();
      },
    );
  }
}

@ToJsonEntity()
@JsonSerializable()
class WitchAction extends RoleAction {
  /// 是否使用药
  bool used = false;

  /// 使用的是解药还是毒药
  bool? isSave;

  /// 目标
  int? target;

  /// 本局回合是否有救药
  /// 仅代表本局回合是否有药，不做运算判断
  bool haveSaveMedicine = true;

  /// 本局回合是否有毒药
  /// 仅代表本局回合是否有药，不做运算判断
  bool haveKillMedicine = true;

  @override
  bool get isYes {
    if (used) {
      // 如果用了药，只要目标不存在，则都视为失败
      if ((target ?? 0) <= 0) return false;
    }
    return super.isYes;
  }

  WitchAction() : super(Role.WITCH);

  factory WitchAction.fromJson(Map<String, dynamic> json) => _$WitchActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WitchActionToJson(this);

  WitchActionSelect getSelect() {
    if (used) {
      if (isSave == true) {
        return WitchActionSelect.SAVE;
      } else {
        return WitchActionSelect.KILL;
      }
    } else {
      return WitchActionSelect.NONE;
    }
  }

  /// 使用解药
  void save(int save) {
    if (save <= 0) throw AppError.withNightSaveNoSelectPlayer.toExc(obj: role);
    used = true;
    isSave = true;
    target = save;
  }

  /// 毒掉
  void kill(int kill) {
    if (kill <= 0) throw AppError.withNightKillNoSelectPlayer.toExc(obj: role);
    used = true;
    isSave = false;
    target = kill;
  }

  /// 啥也没做
  /// 其实不用调用，但为了保险起见
  void none() {
    used = false;
    isSave = null;
    target = null;
  }

  int? getKillForPoison() {
    if (!isYes) throw AppError.witchNoActionYes.toExc();
    // 没有用药
    if (!used) return null;
    // 如果是救人，则没有数据
    if (null == isSave || isSave == true) return null;
    return target;
  }

  /// 检查药品使用情况，并设置是否可以用药
  ///
  /// nowRound 为当前回合
  Future<void> checkMedicine(GameFactory factory, int nowRound) async {
    /// 方案一：检查每一回合女巫的行为，来判断是否用过药
    for (int round = 1; round < nowRound; round++) {
      var action = WitchRoleGenerator.getRoleNightAction(factory.getRoundFactory(round).actions);

      /// 如果action不存在，或者没有用过药，这个回合跳过
      if (!action.used) continue;

      /// 如果用过药，则需要判断用了那个药，并设置本action状态
      if (action.isSave == true) {
        haveSaveMedicine = false;
      } else {
        haveKillMedicine = false;
      }
    }

    // /// 方案二：通过检查是否有人被用药来来判断是否有药。
    // var processes = factory.getProcesses();
    // for (int round = 1; round < nowRound; round++) {
    //   var process = processes[round];
    //   /// 遍历每一回合的玩家状态
    //   process.playerStateMap.forEach((key, value) {
    //     /// 如果玩家被毒过，则女巫没有毒药
    //     if (value.get(PlayerStateType.isKillWithPoison)) {
    //       haveKillMedicine = false;
    //     }
    //
    //     /// 如果玩家被救过，则女巫没有解药
    //     if (value.get(PlayerStateType.isSaveWithMedicine)) {
    //       haveSaveMedicine = false;
    //     }
    //   });
    // }
  }

  @override
  void setToPlayerDetail(PlayerDetail detail, PlayerStateMap states) {
    var player = detail.getForRole(Role.WITCH);
    states.set(
      player.number,
      PlayerStateType.isHaveAntidote,
      value: haveSaveMedicine,
    );
    states.set(
      player.number,
      PlayerStateType.isHavePoison,
      value: haveKillMedicine,
    );

    // 如果没有用药就跳过
    if (used) {
      // 如果用药了，但没有目标需要抛出异常
      if (null == target || (target ?? 0) <= 0) {
        throw AppError.witchTargetIsNull.toExc();
      }
      if (isSave == true) {
        states.set(target!, PlayerStateType.isSaveWithMedicine);
        // 女巫用了解药
        states.set(player.number, PlayerStateType.isUsedAntidote);
        player.putBuff(PlayerBuffType.witchUsedAntidote);
      } else {
        states.set(target!, PlayerStateType.isKillWithPoison);
        // 女巫用了毒药
        states.set(player.number, PlayerStateType.isUsedPoison);
        states.setKillPlayer(player.number, [target!]);
        player.putBuff(PlayerBuffType.witchUsedPoison);
      }
    }
  }
}

enum WitchActionSelect {
  SAVE("救人"),
  KILL("毒人"),
  NONE("啥也不干");

  final String desc;

  const WitchActionSelect(this.desc);
}

class _WitchNightRoleRoundGenerator extends RoleNightGenerator<WitchAction> {
  final NightFactory nightFactory;

  _WitchNightRoleRoundGenerator(this.nightFactory) : super(roundFactory: nightFactory, role: Role.WITCH);

  @override
  Future<void> preAction() async {
    // 加载界面前先检查一下用药情况
    await action.checkMedicine(super.factory, round);
    return await super.preAction();
  }

  @override
  Widget actionWidget(Function() updateCallback) {
    return _WitchActionComponent(super.factory, action, nightFactory, (action) {
      saveAction();
    });
  }

  @override
  JsonEntityData<WitchAction> actionJsonConvertor() => WitchActionJsonData();
}

/// 女巫动作组件
class _WitchActionComponent extends StatefulWidget {
  final GameFactory factory;
  final WitchAction action;
  final NightFactory nightFactory;
  final Function(WitchAction action) finishCallback;

  const _WitchActionComponent(
    this.factory,
    this.action,
    this.nightFactory,
    this.finishCallback,
  );

  @override
  State<_WitchActionComponent> createState() => _WitchActionComponentState();
}

class _WitchActionComponentState extends State<_WitchActionComponent> {
  WitchAction get _action => widget.action;

  /// 女巫额外配置
  WitchExtraConfig get extraConfig => WitchExtraConfig.get(widget.factory);

  NightFactory get _nightFactory => widget.nightFactory;

  WitchActionSelect _select = WitchActionSelect.NONE;

  int _killPlayer = 0;

  int? get wolfKillPlayer => _nightFactory.wolfKillWho();

  /// 是否可以自救
  bool get isCanSaveSelf => extraConfig.isCanSaveSelf(_nightFactory.round);

  /// 是否是自己被出局
  bool get isSelfOut => (thisPlayer ?? 0) > 0 && wolfKillPlayer == thisPlayer;

  int? get thisPlayer => _nightFactory.getPlayerNumber(Role.WITCH);

  bool get isLive => _nightFactory.getPlayer(Role.WITCH)?.live ?? true;

  final _isShowState = IsShowState();

  @override
  void initState() {
    super.initState();
    _select = _action.getSelect();
    _killPlayer = _action.target ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    if (!isLive) {
      return const Text("玩家已经阵亡，无法使用技能");
    }
    return Column(
      children: [
        Text("女巫药 (救/毒): ${_action.haveSaveMedicine ? 1 : 0}/${_action.haveKillMedicine ? 1 : 0}"),
        const SizedBox(height: 8),
        const Text("你有一瓶解药和一瓶毒药"),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: app.baseFont.copyWith(color: Colors.black),
            children: [
              const TextSpan(text: "昨天晚上"),
              (wolfKillPlayer ?? 0) > 0
                  ? TextSpan(
                      text: " $wolfKillPlayer号 ",
                      style: app.baseFont.copyWith(color: Colors.red, fontSize: 18),
                    )
                  : TextSpan(
                      text: " 没有 ",
                      style: app.baseFont.copyWith(fontSize: 18),
                    ),
              const TextSpan(text: "玩家被刀"),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text("请问你选择救人还是选择一个玩家毒掉。"),
        const SizedBox(height: 8),
        _witchSelectWidget(),
        const SizedBox(height: 8),
        _witchActionSelect[_select]!,
        const SizedBox(height: 8),
      ],
    );
  }

  /// 女巫选择面板
  Widget _witchSelectWidget() {
    var list = WitchActionSelect.values.toList();
    int? killWho = _nightFactory.wolfKillWho();
    if (
        // 狼没有行动或者没有出刀时，女巫无法用药
        killWho == null ||
            killWho <= 0 ||
            // 没有药的情况下，也不可以救人
            !_action.haveSaveMedicine) {
      list.remove(WitchActionSelect.SAVE);
    }

    // 没有药的情况下，也不可以毒人
    if (!_action.haveKillMedicine) {
      list.remove(WitchActionSelect.KILL);
    }

    return Row(
      children: [
        for (var value in list)
          Expanded(
            child: Material(
              elevation: 1,
              child: InkWell(
                  onTap: () => setState(() {
                        if (_action.isYes) return;
                        _select = value;
                      }),
                  child: Container(
                    height: 35,
                    color: _select == value ? Colors.blue : Colors.white,
                    alignment: Alignment.center,
                    child: Text(
                      value.desc,
                      style: app.baseFont.copyWith(
                        color: _select == value ? Colors.white : Colors.black,
                      ),
                    ),
                  )),
            ),
          )
      ],
    );
  }

  Map<WitchActionSelect, Widget> get _witchActionSelect {
    return {
      WitchActionSelect.SAVE: _saveWidget(),
      WitchActionSelect.KILL: _killWidget(),
      WitchActionSelect.NONE: Column(
        children: [
          const Text("不做任何行为"),
          _action.isYes
              ? const Text("女巫这个捞货什么都没干。。。")
              : TextButton(
                  onPressed: () {
                    try {
                      _action.none();
                    } on AppException catch (e) {
                      context.showSnackBarMessage(e.error.err, isShow: _isShowState);
                    }
                    _action.isYes = true;
                    widget.finishCallback(_action);
                    setState(() {});
                  },
                  child: const Text("确认你的选择"))
        ],
      ),
    };
  }

  Widget _saveWidget() {
    Text descWidget;
    if ((thisPlayer ?? 0) > 0 && _nightFactory.wolfKillWho() == thisPlayer) {
      if (isCanSaveSelf) {
        descWidget = const Text("你被刀了，可以自救，是否选择救自己");
      } else {
        descWidget = const Text("你被刀了，不可以自救");
      }
    } else {
      descWidget = Text("你选择救了 ${_nightFactory.wolfKillWho()} 号玩家");
    }

    Widget button;
    if (_action.isYes) {
      if (isSelfOut) {
        button = const Text("已经自救");
      } else {
        button = Text("已经救了 $wolfKillPlayer 号玩家");
      }
    } else {
      // 救人行为
      if (isSelfOut && !isCanSaveSelf) {
        // 如果女巫被刀，且无法自救，则不显示按钮
        button = const SizedBox();
      } else {
        button = TextButton(
          onPressed: () {
            if (!_nightFactory.isAction(context, Role.WITCH, _isShowState)) {
              return;
            }
            try {
              switch (_select) {
                case WitchActionSelect.SAVE:
                  _action.save(_nightFactory.wolfKillWho()!);
                  break;
                case WitchActionSelect.KILL:
                  _action.kill(_killPlayer);
                  break;
                case WitchActionSelect.NONE:
                  _action.none();
                  break;
                default:
                  break;
              }
            } on AppException catch (e) {
              context.showSnackBarMessage(e.error.err, isShow: _isShowState);
            }
            _action.isYes = true;
            widget.finishCallback(_action);
            setState(() {});
          },
          child: Text(isSelfOut ? "确认自救" : "确认你的选择: 救 $wolfKillPlayer 号玩家"),
        );
      }
    }

    return Column(
      children: [
        descWidget,
        button,
      ],
    );
  }

  Widget _killWidget() {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            style: app.baseFont.copyWith(color: Colors.black, fontSize: 14.0),
            children: [
              const TextSpan(text: "你选择毒掉 "),
              const WidgetSpan(child: SizedBox(width: 8)),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: PlayerSingleSelectButton.initConfig(
                  config: SelectConfig(
                    selectableList: _nightFactory.getLivePlayer().map((e) => e.number).toList(),
                    defaultSelect: _killPlayer,
                    selectable: !_action.isYes,
                    callback: (t) => setState(() {
                      _killPlayer = t;
                    }),
                  ),
                  // count: widget.factory.entity.tempConfig!.playerCount,
                ),
              ),
              const WidgetSpan(child: SizedBox(width: 8)),
              const TextSpan(text: "号玩家"),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _action.isYes
            ? Text("你使用了毒药，玩家 ${_action.target} 被你毒了")
            : TextButton(
                onPressed: () {
                  if (!_nightFactory.isAction(context, Role.WITCH, _isShowState)) {
                    return;
                  }
                  if (_killPlayer <= 0) {
                    context.showSnackBarMessage("如果要使用毒药，请选择一个玩家", isShow: _isShowState);
                    return;
                  }
                  try {
                    _action.kill(_killPlayer);
                  } on AppException catch (e) {
                    context.showSnackBarMessage(e.error.err, isShow: _isShowState);
                  }
                  _action.isYes = true;
                  widget.finishCallback(_action);
                  setState(() {});
                },
                child: Text(_killPlayer > 0 ? "确认你的选择: 毒 $_killPlayer 号玩家" : "确认你的选择"))
      ],
    );
  }
}
