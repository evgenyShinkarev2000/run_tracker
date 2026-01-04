import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Data/export.dart';

final localeRepositoryProvider = Provider<LocaleRepository>((ref) {
  return LocaleRepository();
});

final localeProvider = StreamProvider<Locale>((ref) {
  var repo = ref.watch(localeRepositoryProvider);

  return repo.stream;
}, dependencies: [localeRepositoryProvider]);
