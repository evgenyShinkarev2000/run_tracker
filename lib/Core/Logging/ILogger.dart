import 'package:run_tracker/Core/Exceptions/export.dart';

abstract interface class ILogger {
  void logTrace(
    String? message, {
    AppException? appException,
    Map<String, dynamic>? data,
  });
  void logDebug(
    String? message, {
    AppException? appException,
    Map<String, dynamic>? data,
  });
  void logInformation(
    String? message, {
    AppException? appException,
    Map<String, dynamic>? data,
  });
  void logWarning(
    String? message, {
    AppException? appException,
    Map<String, dynamic>? data,
  });
  void logError(
    String? message, {
    AppException? appException,
    Map<String, dynamic>? data,
  });
  void logCritical(
    String? message, {
    AppException? appException,
    Map<String, dynamic>? data,
  });
  void log(
    LogLevel logLevel,
    String? message, {
    AppException? appException,
    Map<String, dynamic>? data,
  });
}

enum LogLevel {
  Trace,
  Debug,
  Information,
  Warning,
  Error,
  Critical,
}
