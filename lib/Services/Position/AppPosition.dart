import 'dart:math';

import 'package:geolocator/geolocator.dart';

class AppPositionComponent {
  final double value;
  final double? accuracy;

  const AppPositionComponent(this.value, [this.accuracy]);
}

class AppPosition {
  /// From the equator. The latitude of this position in degrees normalized to the interval -90.0
  /// to +90.0 (both inclusive).
  final AppPositionComponent? latitude;

  /// From the Greenwich meridian. The longitude of the position in degrees normalized to the interval -180
  /// (exclusive) to +180 (inclusive).
  final AppPositionComponent? longitude;

  /// The altitude of the device in meters.
  final AppPositionComponent? altitude;

  /// The heading in which the device is traveling in degrees.
  final AppPositionComponent? heading;

  /// The speed at which the devices is traveling in meters per second over
  /// ground.
  final AppPositionComponent? speed;

  final double? horizontalAccuracy;

  final DateTime? timestamp;

  const AppPosition({
    this.latitude,
    this.longitude,
    this.altitude,
    this.heading,
    this.speed,
    this.horizontalAccuracy,
    this.timestamp,
  });

  static double? tryFindDistanceByCoordinates(
    double? startLatitude,
    double? startLongitude,
    double? startAltitude,
    double? endLatitude,
    double? endLongitude,
    double? endAltitude,
  ) {
    if (startLatitude == null ||
        startLongitude == null ||
        endLatitude == null ||
        endLongitude == null) {
      return null;
    }

    final horizontalDistance = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );

    if (startAltitude == null || endAltitude == null) {
      return horizontalDistance;
    }

    final verticalDistance = startAltitude + endAltitude;

    return sqrt(
      horizontalDistance * horizontalDistance +
          verticalDistance * verticalDistance,
    );
  }

  double? tryFindDistanceTo(AppPosition position) =>
      AppPosition.tryFindDistanceByCoordinates(
        latitude?.value,
        longitude?.value,
        altitude?.value,
        position.latitude?.value,
        position.longitude?.value,
        position.altitude?.value,
      );
}