import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Data/Contacts/ICommonValueRepository.dart';
import 'package:run_tracker/Data/export.dart';

final localeRepositoryProvider = Provider<ICommonValueRepository<Locale>>((
  ref,
) {
  return MemoryLocaleRepository();
});

final localeProvider = StreamProvider<Locale>((ref) {
  var repo = ref.watch(localeRepositoryProvider);

  return repo.StreamValueWithLastOrGet();
}, dependencies: [localeRepositoryProvider]);
