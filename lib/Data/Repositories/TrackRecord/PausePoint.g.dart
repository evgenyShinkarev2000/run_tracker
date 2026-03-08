// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PausePoint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PausePoint _$PausePointFromJson(Map<String, dynamic> json) => PausePoint(
  id: (json['id'] as num).toInt(),
  trackRecordId: (json['trackRecordId'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PausePointToJson(PausePoint instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trackRecordId': instance.trackRecordId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
