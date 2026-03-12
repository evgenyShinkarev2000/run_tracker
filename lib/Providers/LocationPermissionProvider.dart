import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Services/export.dart';

final locationPermissionServiceProvider = Provider<LocationPermissionService>((
  ref,
) {
  final service = GeolocatorLocationPermissionService();
  ref.onDispose(service.dispose);

  return service;
});

final locationPermissionProvider = StreamProvider((ref) {
  return ref.watch(locationPermissionServiceProvider).stream;
});
