import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Data/Repositories/MapUriTemplateRepository.dart';
import 'package:run_tracker/Providers/AppDatabaseProvider.dart';
import 'package:run_tracker/Providers/AppSettingsProvider.dart';

final mapUriTemplateRepository = Provider<MapUriTemplateRepository>((ref) {
  final appDatabase = ref.watch(appDatabaseProvider);
  final appSettings = ref.watch(appSettingsProvider);
  final repository = DriftMapUriTemplateRepository(appDatabase, appSettings);
  ref.onDispose(repository.Dispose);

  return repository;
});

final mapUriTemplateProvider = StreamProvider<String>((ref) {
  final repository = ref.watch(mapUriTemplateRepository);

  return repository.stream;
});
