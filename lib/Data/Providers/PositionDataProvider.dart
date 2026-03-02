import 'dart:async';

import 'package:cancellation_token/cancellation_token.dart';
import 'package:geolocator/geolocator.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/Contracts/export.dart';

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
}

abstract class PositionDataProvider
    implements IStreamProvider<AppPosition>, IValueRepository<AppPosition> {}

class GeolocatorPositionDataProvider extends PositionDataProvider
    implements IDisposable {
  StreamController<AppPosition>? _streamController;

  @override
  void dispose() {
    if (_streamController != null) {
      _streamController!.close();
    }
  }

  @override
  Future<AppPosition> Get([CancellationToken? ct]) async {
    ct?.throwIfCancelled();
    final position = await Geolocator.getCurrentPosition();

    return _fromGeolocatorPosition(position);
  }

  @override
  Stream<AppPosition> get stream {
    if (_streamController == null) {
      _streamController = StreamController.broadcast();
      _streamController!.addStream(
        Geolocator.getPositionStream().map(_fromGeolocatorPosition),
      );
    }

    return _streamController!.stream;
  }

  static AppPosition _fromGeolocatorPosition(Position position) {
    return AppPosition(
      latitude: AppPositionComponent(position.latitude),
      longitude: AppPositionComponent(position.longitude),
      altitude: AppPositionComponent(
        position.altitude,
        position.altitudeAccuracy,
      ),
      heading: AppPositionComponent(position.heading, position.headingAccuracy),
      horizontalAccuracy: position.accuracy,
      speed: AppPositionComponent(position.speed, position.speedAccuracy),
      timestamp: position.timestamp,
    );
  }
}
