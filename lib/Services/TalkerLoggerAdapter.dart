import 'dart:convert';

import 'package:run_tracker/Core/export.dart';
import 'package:talker/talker.dart' as talk;

class TalkerLoggerAdapter with LoggerWithLogMethods implements ILogger {
  final talk.Talker _talker;

  TalkerLoggerAdapter(this._talker);

  @override
  void log(
    LogLevel logLevel,
    String? message, {
    AppException? appException,
    Map<String, dynamic>? data,
  }) {
    final Map<String, dynamic> map = {};
    if (appException != null) {
      final exceptionMap = appException.toJson();
      exceptionMap.remove("message");
      map["exception"] = exceptionMap;
    }
    if (data != null) {
      map["data"] = data;
    }
    final serialized = jsonEncode(
      map,
      toEncodable: UnknownTypeSerializer.Default.visit,
    );
    final formatedMessage = [
      message,
      appException?.message,
      serialized,
    ].nonNulls.join(" | ");

    _talker.log(formatedMessage, logLevel: mapLogLevel(logLevel));
  }

  static talk.LogLevel mapLogLevel(LogLevel logLevel) {
    return switch (logLevel) {
      LogLevel.Trace => talk.LogLevel.verbose,
      LogLevel.Debug => talk.LogLevel.debug,
      LogLevel.Information => talk.LogLevel.info,
      LogLevel.Warning => talk.LogLevel.warning,
      LogLevel.Error => talk.LogLevel.error,
      LogLevel.Critical => talk.LogLevel.critical,
    };
  }
}
