// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DefaultFactoryConfig.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefaultCacheEntity _$DefaultCacheEntityFromJson(Map<String, dynamic> json) => DefaultCacheEntity(
      (json['gameId'] as num).toInt(),
      $enumDecode(_$RoleEnumMap, json['role']),
    )
      ..playerId = (json['playerId'] as num).toInt()
      ..isRecordFinish = json['isRecordFinish'] as bool;

Map<String, dynamic> _$DefaultCacheEntityToJson(DefaultCacheEntity instance) => <String, dynamic>{
      'gameId': instance.gameId,
      'role': _$RoleEnumMap[instance.role]!,
      'playerId': instance.playerId,
      'isRecordFinish': instance.isRecordFinish,
    };

const _$RoleEnumMap = {
  Role.EMPTY: 'EMPTY',
  Role.SHERIFF: 'SHERIFF',
  Role.CITIZEN: 'CITIZEN',
  Role.WOLF: 'WOLF',
  Role.SEER: 'SEER',
  Role.WITCH: 'WITCH',
  Role.HUNTER: 'HUNTER',
  Role.GUARD: 'GUARD',
  Role.FOOL: 'FOOL',
  Role.WOLF_KING: 'WOLF_KING',
  Role.WHITE_WOLF_KING: 'WHITE_WOLF_KING',
  Role.WOLF_AMOR: 'WOLF_AMOR',
  Role.BOMB: 'BOMB',
};
