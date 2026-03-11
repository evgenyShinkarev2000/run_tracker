import 'package:flutter/material.dart';
import 'package:run_tracker/Core/Exceptions/export.dart';

class FlutterExceptionWrapper extends AppException {
  final FlutterErrorDetails flutterErrorDetails;

  FlutterExceptionWrapper(this.flutterErrorDetails)
    : super(
        message: flutterErrorDetails.toString(minLevel: DiagnosticLevel.debug),
        stackTrace: flutterErrorDetails.stack,
      );

  @override
  String getName() {
    return "FlutterExceptionWrapper";
  }
}
