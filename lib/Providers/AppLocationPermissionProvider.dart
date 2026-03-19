import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/Position/export.dart';

final appLocationPermissionServiceProvider = Provider((ref) {
  final service = AppLocationPermissionService(
    ref.watch(positionServiceProvider),
    ref.watch(locationRequirementRepositoryProvider),
  );
  ref.onDispose(service.dispose);

  return service;
});

final appLocationPermissionProvider = StreamProvider((ref){
  final service = ref.watch(appLocationPermissionServiceProvider);
  return service.stream;
});