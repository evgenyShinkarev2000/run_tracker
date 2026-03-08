// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ResumePoint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResumePoint _$ResumePointFromJson(Map<String, dynamic> json) => ResumePoint(
  id: (json['id'] as num).toInt(),
  trackRecordId: (json['trackRecordId'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ResumePointToJson(ResumePoint instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trackRecordId': instance.trackRecordId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
