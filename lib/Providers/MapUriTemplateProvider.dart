import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Data/Repositories/MapUriTemplateRepository.dart';
import 'package:run_tracker/Providers/AppDatabaseProvider.dart';

final mapUriTemplateRepository = Provider<MapUriTemplateRepository>((ref) {
  final appDatabase = ref.watch(appDatabaseProvider);
  final repository = DriftMapUriTemplateRepository(appDatabase);
  ref.onDispose(repository.Dispose);

  return repository;
});

final mapUriTemplateProvider = StreamProvider<String>((ref) {
  final repository = ref.watch(mapUriTemplateRepository);

  return repository.stream;
});
