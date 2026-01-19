import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Providers/AppDatabaseProvider.dart';

final localeRepositoryProvider = Provider<LocaleRepository>((ref) {
  var appDatabase = ref.watch(appDatabaseProvider);

  return DriftLocaleRepository(appDatabase);
});

final localeProvider = StreamProvider<Locale>((ref) {
  var repo = ref.watch(localeRepositoryProvider);
  ref.onDispose(repo.Dispose);

  return repo.stream;
}, dependencies: [localeRepositoryProvider]);
