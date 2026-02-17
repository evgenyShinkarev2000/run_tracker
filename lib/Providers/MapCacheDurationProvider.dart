import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Data/Repositories/MapCacheRepository.dart';
import 'package:run_tracker/Providers/AppDatabaseProvider.dart';
import 'package:run_tracker/Providers/AppSettingsProvider.dart';

final mapCacheDurationRepositoryProvider = Provider<MapCacheDurationRepository>((ref) {
  final appDatabase = ref.watch(appDatabaseProvider);
  final appSettings = ref.watch(appSettingsProvider);
  final repository = DriftMapCacheDurationRepository(appDatabase, appSettings);
  ref.onDispose(repository.Dispose);

  return repository;
});

final mapCacheDurationProvider = StreamProvider((ref) {
  return ref.watch(mapCacheDurationRepositoryProvider).stream;
});
