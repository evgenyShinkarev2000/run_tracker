import 'package:json_annotation/json_annotation.dart';
import 'package:run_tracker/Data/Contracts/export.dart';
import 'package:run_tracker/Data/Repositories/TrackRecord/BasePoint.dart';
import 'package:run_tracker/Data/Repositories/TrackRecord/ITrackRecordPointVisitor.dart';

part 'PausePoint.g.dart';

@JsonSerializable()
class PausePoint extends BasePoint implements IDiscriminator {
  static const String Discriminator = "PausePoint";

  @override
  String get discriminator => Discriminator;

  @override
  final int id;
  @override
  final int trackRecordId;
  @override
  final DateTime createdAt;

  PausePoint({
    required this.id,
    required this.trackRecordId,
    required this.createdAt,
  }) : assert(createdAt.isUtc);

  factory PausePoint.fromJson(Map<String, dynamic> json) =>
      _$PausePointFromJson(json);

  factory PausePoint.insert({
    required int trackRecordId,
    required DateTime createdAt,
  }) => PausePoint(id: 0, trackRecordId: trackRecordId, createdAt: createdAt);

  Map<String, dynamic> toJson() => _$PausePointToJson(this);

  @override
  TResult accept<TResult>(ITrackRrecordPointVisitor<TResult> visitor) {
    return visitor.visitPausePoint(this);
  }
}
