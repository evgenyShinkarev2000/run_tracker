import 'package:run_tracker/Core/export.dart';

abstract interface class IMessageService {
  void showAndLogError(AppException exception, [String? message]);
  void warning(String message);
}

class AppMessageService implements IMessageService {
  final ILogger _logger;

  AppMessageService(this._logger);

  @override
  void showAndLogError(AppException exception, [String? message]) {
    _logger.logError(message, appException: exception);
  }

  @override
  void warning(String message) {
    _logger.logWarning(message);
  }
}
