import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Providers/AppDatabaseProvider.dart';
import 'package:run_tracker/localization/export.dart';

final localeRepositoryProvider = Provider<LocaleRepository>((ref) {
  var appDatabase = ref.watch(appDatabaseProvider);
  var repository = DriftLocaleRepository(appDatabase);
  ref.onDispose(repository.dispose);

  return repository;
});

final localeProvider = StreamProvider<AppLocale>((ref) {
  var repo = ref.watch(localeRepositoryProvider);

  return repo.stream;
}, dependencies: [localeRepositoryProvider]);
