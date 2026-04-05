import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Providers/export.dart';

final isDevModeRepositoryProvider = Provider<IsDevModeRepository>((ref) {
  final repository = DriftIsDevModelRepository(ref.watch(appDatabaseProvider));
  ref.onDispose(repository.dispose);

  return repository;
});

final _isDevModeStreamProvider = StreamProvider((ref) {
  return ref.watch(isDevModeRepositoryProvider).stream;
});

final isDevModeProvider = Provider((ref) {
  return ref.watch(_isDevModeStreamProvider).value ?? false;
});
