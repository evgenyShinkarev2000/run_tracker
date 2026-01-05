import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Providers/AppDatabaseProvider.dart';

final localeRepositoryProvider = Provider<ICommonValueRepository<Locale>>((
  ref,
) {
  var appDatabase = ref.watch(appDatabaseProvider);

  return DriftLocaleRepository(appDatabase);
});

final localeProvider = StreamProvider<Locale>((ref) {
  var repo = ref.watch(localeRepositoryProvider);

  return repo.StreamValueWithLastOrGet();
}, dependencies: [localeRepositoryProvider]);
