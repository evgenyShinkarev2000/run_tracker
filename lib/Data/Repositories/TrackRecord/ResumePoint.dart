import 'package:json_annotation/json_annotation.dart';
import 'package:run_tracker/Data/Repositories/TrackRecord/BasePoint.dart';
import 'package:run_tracker/Data/Repositories/TrackRecord/ITrackRecordPointVisitor.dart';

part "ResumePoint.g.dart";

@JsonSerializable()
class ResumePoint extends BasePoint {
  @override
  final int id;
  @override
  final int trackRecordId;
  @override
  final DateTime createdAt;

  ResumePoint({
    required this.id,
    required this.trackRecordId,
    required this.createdAt,
  }) : assert(createdAt.isUtc);

  factory ResumePoint.fromJson(Map<String, dynamic> json) =>
      _$ResumePointFromJson(json);

  factory ResumePoint.insert({
    required int trackRecordId,
    required DateTime createdAt,
  }) => ResumePoint(id: 0, trackRecordId: trackRecordId, createdAt: createdAt);

  Map<String, dynamic> toJson() => _$ResumePointToJson(this);

  @override
  TResult accept<TResult>(ITrackRecordPointVisitor<TResult> visitor) {
    return visitor.visitResumePoint(this);
  }
}
