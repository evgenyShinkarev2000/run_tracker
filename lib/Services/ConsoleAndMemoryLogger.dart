import 'dart:convert';

import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/Repositories/LogRepository.dart';

@Deprecated("use TalkerLoggerAdapter")
class ConsoleAndMemoryLogger with LoggerWithLogMethods implements ILogger {
  final LogRepository _logRepository;

  ConsoleAndMemoryLogger(this._logRepository);

  @override
  void log(
    LogLevel logLevel,
    String? message, {
    AppException? appException,
    Map<String, dynamic>? data,
  }) {
    final logModel = LogModel(
      logLevel: logLevel,
      message: message,
      data: data,
      appException: appException,
    );
    final serialized = jsonEncode(
      logModel,
      toEncodable: UnknownTypeSerializer.Default.visit,
    );
    // ignore: avoid_print
    print(serialized);
    _logRepository.add(logModel);
  }
}
