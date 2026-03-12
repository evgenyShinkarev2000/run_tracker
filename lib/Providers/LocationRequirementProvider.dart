import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Providers/export.dart';

final locationRequirementRepositoryProvider = Provider<LocationRequirementRepository>((ref) {
  final repository = DriftLocationRequirementRepository(
    ref.watch(appDatabaseProvider),
  );
  ref.onDispose(repository.dispose);

  return repository;
});

final locationRequirementProvider = StreamProvider((ref) {
  return ref.watch(locationRequirementRepositoryProvider).stream;
});
