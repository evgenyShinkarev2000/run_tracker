import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:run_tracker/Core/export.dart';

abstract interface class IMessageService {
  void showAndLogError(AppException exception, [String? message]);
  void warning(String message);
  void info(String message);
}

class AppMessageService implements IMessageService {
  final ILogger _logger;
  final GlobalKey<NavigatorState> _rootNavigatorKey;
  final FToast _toast = FToast();

  AppMessageService(this._logger, this._rootNavigatorKey);

  @override
  void showAndLogError(AppException exception, [String? message]) {
    _logger.logError(message, appException: exception);
    _showToastMessage(message ?? exception.message ?? exception.toString());
  }

  @override
  void warning(String message) {
    _logger.logWarning(message);
    _showToastMessage(message);
  }

  @override
  void info(String message) {
    _logger.logInformation(message);
    _showToastMessage(message);
  }

  void _showToastMessage(String message) {
    if (_rootNavigatorKey.currentContext == null) {
      _logger.logWarning(
        "_rootNavigatorKey.currentContext is null, skip message",
      );
      return;
    }
    if (!_rootNavigatorKey.currentContext!.mounted) {
      _logger.logWarning(
        "_rootNavigatorKey.currentContext.mounted == true, skip message",
      );
      return;
    }
    final toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: Text(message),
    );

    _toast.init(_rootNavigatorKey.currentContext!).showToast(child: toast);
  }
}
