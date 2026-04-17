import 'dart:convert';

import 'package:run_tracker/Core/export.dart';
import 'package:talker/talker.dart' as talk;

class TalkerLoggerAdapter with LoggerWithLogMethods implements ILogger {
  static final JsonEncoder _encoder = JsonEncoder.withIndent(
    " ",
    UnknownTypeSerializer.Default.visit,
  );
  static final StringBuffer _stringBuffer = StringBuffer();

  final talk.Talker _talker;

  TalkerLoggerAdapter(this._talker);

  @override
  void log(
    LogLevel logLevel,
    String? message, {
    AppException? appException,
    Map<String, dynamic>? data,
  }) {
    try {
      _logInternal(logLevel, message, appException: appException, data: data);
    } finally {
      _stringBuffer.clear();
    }
  }

  void _logInternal(
    LogLevel logLevel,
    String? message, {
    AppException? appException,
    Map<String, dynamic>? data,
  }) {
    _stringBuffer.writeln(message);
    if (appException != null) {
      _stringBuffer.write("exception: ");
      _stringBuffer.writeln(
        _encoder.convert(appException.toJson(includeStack: false)),
      );
    }
    if (data != null) {
      _stringBuffer.write("data: ");
      _stringBuffer.writeln(_encoder.convert(data));
    }
    if (appException?.stackTrace != null) {
      _stringBuffer.writeln("strack trace: ");
      _stringBuffer.writeln(appException?.stackTrace.toString());
    }

    _talker.log(_stringBuffer.toString(), logLevel: mapLogLevel(logLevel));
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
