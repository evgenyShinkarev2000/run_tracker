import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Services/export.dart';

extension PositionPointExtension on PositionPoint {
  double? tryFindDistanceMeters(PositionPoint point) =>
      AppPosition.tryFindDistanceByCoordinates(
        latitude,
        longitude,
        altitude,
        point.latitude,
        point.longitude,
        point.altitude,
      );
}
