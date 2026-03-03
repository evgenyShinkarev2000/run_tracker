// final needShowLocationDialogProvider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/export.dart';

final needShowLocationDialogProvider = Provider((ref) {
  var asyncValue = ref.watch(_needShowLocationDialogStreamProvider);
  if (asyncValue.hasValue) {
    return asyncValue.requireValue;
  }

  return true;
});

final _needShowLocationDialogStreamProvider = StreamProvider((ref) {
  return ref.watch(appLocationPermissionServiceProvider).needShowDialogStream;
});
