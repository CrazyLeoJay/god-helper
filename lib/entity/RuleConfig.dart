import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:god_helper/component/component.dart';
import 'package:god_helper/entity/Entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'RuleConfig.g.dart';

abstract class BaseRoleExtraRule {}

/// 女巫规则
@JsonSerializable()
class WitchRule implements BaseRoleExtraRule {
  /// 自救行为
  final WitchSelfSaveRuleType selfSave;

  const WitchRule({
    this.selfSave = WitchSelfSaveRuleType.ONLY_FIRST_DAY_SELF_SAVE,
  });

  @override
  factory WitchRule.fromJson(Map<String, dynamic> e) => _$WitchRuleFromJson(e);

  Map<String, dynamic> toJson() => _$WitchRuleToJson(this);

  Widget configView(OnWitchRuleChangeOnNew onChange) =>
      WitchExtraRuleView(onChange: (type) => WitchRule(selfSave: type));
}

typedef OnWitchRuleChangeOnNew = void Function(WitchRule witchRule);

/// 女巫自救规则类型
enum WitchSelfSaveRuleType {
  /// 不自救
  ALL_NOT_SAVE("女巫整局都不可以自救"),

  /// 每晚都可以自救
  ALL_SELF_SAVE("女巫每晚都可以自救"),

  /// 仅第一晚可以自救
  ONLY_FIRST_DAY_SELF_SAVE("女巫仅第一晚可以自救"),

  /// 仅第一晚不可以自救
  ONLY_FIRST_DAY_NOT_SELF_SAVE("女巫仅第一晚不可以自救"),
  ;

  final String desc;

  const WitchSelfSaveRuleType(this.desc);
}

/// 狼人胜利规则
enum WinRule {
  KILL_SIDE(desc: "屠边"),
  KILL_ALL_CITY(desc: "屠城"),
  ;

  final String desc;

  const WinRule({required this.desc});

  static RadioGroup<WinRule> createSelectView({
    required Function(WinRule value) callback,
    WinRule? defaultValue,
  }) {
    return RadioGroup(
      config: RadioConfig<WinRule>.grid(
        defaultValue: defaultValue,
        gridChildAspectRatio: 5 / 2,
        selectItem: WinRule.values,
        showText: (value) => value.desc,
        callback: (value) => callback,
      ),
    );
  }
}

/// 狼人胜利条件转换器
class WolfWinRuleConverter implements drift.TypeConverter<WinRule, int> {
  @override
  WinRule fromSql(int fromDb) {
    return WinRule.values[fromDb];
  }

  @override
  int toSql(WinRule value) {
    return value.index;
  }
}

/// 警长竞选规则
enum SheriffRace {
  /// 不竞选
  none(desc: "不竞选警长"),

  /// 仅仅第一天竞选
  onlyFirstDay(desc: "竞选警长。仅第一天竞选"),

  /// 如果没有，则第二天竞选
  notForSecond(desc: "竞选警长。如果第一天没有选出警长，需要第二天继续选择"),
  ;

  final String desc;

  const SheriffRace({required this.desc});

  static RadioGroup<SheriffRace> createSelectView({
    required Function(SheriffRace value) callback,
    SheriffRace? defaultValue,
  }) {
    return RadioGroup(
      config: RadioConfig<SheriffRace>.list(
        defaultValue: defaultValue,
        selectItem: SheriffRace.values,
        showText: (value) => value.desc,
        callback: (value) => callback,
      ),
    );
  }
}

@JsonSerializable()
class SheriffExtraConfig with ToJsonInvoke {
  SheriffRace sheriffRace;

  SheriffExtraConfig({this.sheriffRace = SheriffRace.onlyFirstDay});

  factory SheriffExtraConfig.fromJson(Map<String, dynamic> e) => _$SheriffExtraConfigFromJson(e);

  @override
  Map<String, dynamic> toJson() => _$SheriffExtraConfigToJson(this);
}
