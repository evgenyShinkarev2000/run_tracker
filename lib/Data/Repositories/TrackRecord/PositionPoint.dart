import 'package:run_tracker/Data/Repositories/TrackRecord/BasePoint.dart';
import 'package:run_tracker/Data/Repositories/TrackRecord/ITrackRecordPointVisitor.dart';

class PositionPoint extends BasePoint {
  @override
  final int id;
  @override
  final int trackRecordId;
  @override
  final DateTime createdAt;

  /// From the equator. The latitude of this position in degrees normalized to the interval -90.0
  /// to +90.0 (both inclusive).
  final double? latitude;

  /// From the Greenwich meridian. The longitude of the position in degrees normalized to the interval -180
  /// (exclusive) to +180 (inclusive).
  final double? longitude;

  /// The altitude of the device in meters.
  final double? altitude;

  PositionPoint({
    required this.id,
    required this.trackRecordId,
    required this.createdAt,
    required this.latitude,
    required this.longitude,
    required this.altitude,
  }) : assert(createdAt.isUtc);

  factory PositionPoint.insert({
    required int trackRecordId,
    required DateTime createdAt,
    required double? latitude,
    required double? longitude,
    required double? altitude,
  }) => PositionPoint(
    id: 0,
    trackRecordId: trackRecordId,
    createdAt: createdAt,
    latitude: latitude,
    longitude: longitude,
    altitude: altitude,
  );

  @override
  TResult accept<TResult>(ITrackRrecordPointVisitor<TResult> visitor) {
    return visitor.visitPositionPoint(this);
  }
}
