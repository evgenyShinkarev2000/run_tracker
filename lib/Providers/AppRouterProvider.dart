import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Routing/export.dart';

final appRouterProvider = Provider((ref) {
  final talker = ref.watch(talkerProvider);
  final router = buildAppRouter(talker);
  ref.onDispose(router.dispose);

  return router;
});
