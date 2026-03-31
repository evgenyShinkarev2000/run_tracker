import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/export.dart';

final messageServiceProvider = Provider<IMessageService>((ref) {
  final logger = ref.watch(loggerProvider);
  final rootNavigatorKey = ref.watch(rootNavigatorKeyProvider);
  final service = AppMessageService(logger, rootNavigatorKey);

  return service;
});
