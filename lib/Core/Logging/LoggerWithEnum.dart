import 'package:run_tracker/Core/Exceptions/export.dart';
import 'package:run_tracker/Core/Logging/export.dart';

mixin LoggerWithEnum implements ILogger {
  @override
  void log(
    LogLevel logLevel,
    String? message, {
    AppException? appException,
    Map<String, dynamic>? data,
  }) {
    switch (logLevel) {
      case LogLevel.Trace:
        logTrace(message, appException: appException, data: data);
        break;
      case LogLevel.Debug:
        logDebug(message, appException: appException, data: data);
        break;
      case LogLevel.Information:
        logInformation(message, appException: appException, data: data);
        break;
      case LogLevel.Warning:
        logWarning(message, appException: appException, data: data);
        break;
      case LogLevel.Error:
        logError(message, appException: appException, data: data);
        break;
      case LogLevel.Critical:
        logCritical(message, appException: appException, data: data);
        break;
    }
  }
}
