import 'dart:async';
import 'dart:math';

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

abstract class PositionDataProvider
    implements IStreamProvider<AppPosition>, IValueRepository<AppPosition> {}

class GeolocatorPositionDataProvider extends PositionDataProvider
    implements IDisposable {
  StreamController<AppPosition>? _streamController;

  final ILogger _logger;

  GeolocatorPositionDataProvider(this._logger);

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

  //TODO при получении разрешения нужно брать новый getPositionStream
  @override
  Stream<AppPosition> get stream {
    if (_streamController == null) {
      _streamController = StreamController.broadcast();
      _streamController!.addStream(
        Geolocator.getPositionStream()
            .handleError((Object e, StackTrace s) {
              //TODO пока игнорируем, потом нужно создать отдельный сервис, который бы учитывал настройки геолокации.
              _logger.logWarning(
                "Exception thrown in GeolocatorPositionDataProvider in Geolocator.getPositionStream().handleError",
                appException: DartExceptionWrapper(e, stackTrace: s),
              );
            })
            .map(_fromGeolocatorPosition),
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
      timestamp: position.timestamp.toUtc(),
    );
  }
}
