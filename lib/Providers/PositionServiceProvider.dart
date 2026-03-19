import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/export.dart';

final positionServiceProvider = Provider<PositionService>((
  ref,
) {
  final service = GeolocatorPositionService(ref.watch(loggerProvider));
  ref.onDispose(service.dispose);

  return service;
});

final locationPermissionProvider = StreamProvider((ref) {
  return ref.watch(positionServiceProvider).permissionStream;
});
