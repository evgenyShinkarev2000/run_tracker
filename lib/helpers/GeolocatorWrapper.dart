import 'dart:async';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:run_tracker/core/AppGeolocation.dart';

class GeolocatorWrapper {
  GeolocatorWrapper();

  Future<Position> determinePosition() async {
    try {
      await checkPermission();

      return await Geolocator.getCurrentPosition();
    } catch (ex) {
      rethrow;
    }
  }

  Stream<Position> getPositionStream(Duration? updateInterval) {
    if (Platform.isAndroid) {
      return Geolocator.getPositionStream(locationSettings: AndroidSettings(intervalDuration: updateInterval));
    }

    return Geolocator.getPositionStream();
  }

  Future<Position?> getLastPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (ex) {
      rethrow;
    }
  }

  Future checkPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return throw LocationServiceDisabledException();
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw PermissionDeniedException("Can't get location permissions");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw PermissionDeniedException("App require location permission to work");
    }
  }

  static double distanceBetweenPositions(Position start, Position end) =>
      Geolocator.distanceBetween(start.altitude, start.longitude, end.altitude, end.longitude);

  static double distanceBetween(double startLatitude, double startLongitude, double endLatitude, double endLongitude) =>
      Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);

  static double distanceBetweenGeolocations(AppGeolocation start, AppGeolocation end) =>
      distanceBetween(start.latitude, start.longitude, end.latitude, end.longitude);

  static double distanceBetweenGeoAndPos(AppGeolocation geo, Position position) =>
      distanceBetween(geo.latitude, geo.longitude, position.latitude, position.longitude);
}
