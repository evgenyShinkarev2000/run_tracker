import 'package:run_tracker/Core/Exceptions/export.dart';
import 'package:run_tracker/Core/Logging/export.dart';

mixin LoggerWithLogMethods implements ILogger {
  @override
  void logTrace(
    String? message, {
    AppException? appException,
    Map<String, dynamic>? data,
  }) {
    log(LogLevel.Trace, message, appException: appException, data: data);
  }

  @override
  void logDebug(
    String? message, {
    AppException? appException,
    Map<String, dynamic>? data,
  }) {
    log(LogLevel.Debug, message, appException: appException, data: data);
  }

  @override
  void logInformation(
    String? message, {
    AppException? appException,
    Map<String, dynamic>? data,
  }) {
    log(LogLevel.Information, message, appException: appException, data: data);
  }

  @override
  void logWarning(
    String? message, {
    AppException? appException,
    Map<String, dynamic>? data,
  }) {
    log(LogLevel.Warning, message, appException: appException, data: data);
  }

  @override
  void logError(
    String? message, {
    AppException? appException,
    Map<String, dynamic>? data,
  }) {
    log(LogLevel.Error, message, appException: appException, data: data);
  }

  @override
  void logCritical(
    String? message, {
    AppException? appException,
    Map<String, dynamic>? data,
  }) {
    log(LogLevel.Critical, message, appException: appException, data: data);
  }
}
