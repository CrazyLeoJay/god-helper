// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GameFactory.dart';

// **************************************************************************
// AppCodeGenerator
// **************************************************************************

extension GameFactoryRoleGeneratorExtends on GameFactory {
  List<RoleGenerator> get _$Generators => [
        WolfRoleGenerator(factory: this),
        SeerRoleGenerator(factory: this),
        WitchRoleGenerator(factory: this),
        HunterRoleGenerator(factory: this),
        WolfKingRoleGenerator(factory: this),
        GuardRoleGenerator(factory: this),
        BombRoleGenerator(factory: this),
        WhiteWolfKingRoleGenerator(factory: this),
        FoolRoleGenerator(factory: this),
        WolfBeautyRoleGenerator(factory: this),
        FoxRoleGenerator(factory: this),
        BearRoleGenerator(factory: this),
        BloodMoonApostlesRoleGenerator(factory: this),
        MachineWolfRoleGenerator(factory: this),
        RobbersRoleGenerator(factory: this),
        ForbiddenElderRoleGenerator(factory: this),
        BarbarianChildRoleGenerator(factory: this),
        KnightRoleGenerator(factory: this),
        WitcherRoleGenerator(factory: this),
      ];

  Map<Role, RoleGenerator> get _$GeneratorMap {
    Map<Role, RoleGenerator> map = {};
    for (var value in _$Generators) {
      map[value.role] = value;
    }
    return map;
  }

  RoleGenerator? getRoleGenerator(Role role) => _$GeneratorMap[role];

  Map<Role, JsonEntityData<RoleAction>> _$nightActionJsonTransition(
    GameFactory factory,
  ) {
    Map<Role, JsonEntityData<RoleAction>> map = {};
    for (var value in _$Generators) {
      var action = value
          .getNightRoundGenerator(NightFactory(0, factory))
          ?.actionJsonConvertor();
      if (action == null) continue;
      map[value.role] = action;
    }
    return map;
  }

  Map<Role, JsonEntityData<RoleAction>> _$dayActionJsonTransition(
    GameFactory factory,
  ) {
    Map<Role, JsonEntityData<RoleAction>> map = {};
    for (var value in _$Generators) {
      var action = value
          .getDayRoundGenerator(DayFactory(0, factory))
          ?.actionJsonConvertor();
      if (action == null) continue;
      map[value.role] = action;
    }
    return map;
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtherFactory _$OtherFactoryFromJson(Map<String, dynamic> json) => OtherFactory(
      (json['gameId'] as num).toInt(),
      gameOver: json['gameOver'] as bool? ?? false,
    )
      ..maxRound = (json['maxRound'] as num).toInt()
      ..sheriffTools =
          SheriffTools.fromJson(json['sheriffTools'] as Map<String, dynamic>);

Map<String, dynamic> _$OtherFactoryToJson(OtherFactory instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'maxRound': instance.maxRound,
      'sheriffTools': instance.sheriffTools,
      'gameOver': instance.gameOver,
    };
