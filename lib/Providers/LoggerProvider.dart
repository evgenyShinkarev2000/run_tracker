import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/export.dart';

final loggerProvider = Provider<ILogger>((ref) {
  final talker = ref.watch(talkerProvider);
  final logger = TalkerLoggerAdapter(talker);

  return logger;
});
