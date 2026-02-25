import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Data/export.dart';

@Deprecated("use talker")
final logRepositoryProvider = Provider<LogRepository>((ref) {
  return MemoryLogRepository();
});
