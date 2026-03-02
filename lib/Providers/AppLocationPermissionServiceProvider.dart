import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/export.dart';

final appLocationPermissionServiceProvider = Provider((ref) {
  final service = AppLocationPermissionService(
    ref.watch(locationPermissionServiceProvider),
    ref.watch(locationRequirementRepositoryProvider),
  );
  ref.onDispose(service.dispose);

  return service;
});
