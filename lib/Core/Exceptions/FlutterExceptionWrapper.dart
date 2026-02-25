import 'package:flutter/material.dart';
import 'package:run_tracker/Core/Exceptions/export.dart';

class FlutterExceptionWrapper extends AppException {
  final FlutterErrorDetails flutterErrorDetails;

  FlutterExceptionWrapper(
    this.flutterErrorDetails, {
    super.message,
    super.stackTrace,
    super.data,
    super.innerException,
  });

  @override
  String getName() {
    return "FlutterExceptionWrapper";
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map["flutterErrorDetails"] = flutterErrorDetails.toString(
      minLevel: DiagnosticLevel.debug,
    );

    return map;
  }
}
