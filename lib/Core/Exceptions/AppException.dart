import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:run_tracker/Core/export.dart';

class AppException implements Exception, IJsonSerializable {
  final String? message;
  final Map<String, dynamic> data;
  final StackTrace? stackTrace;
  final AppException? innerException;

  AppException({
    this.message,
    Map<String, dynamic>? data,
    this.stackTrace,
    this.innerException,
  }) : data = data ?? {};

  factory AppException.inner(Object ex) {
    if (ex is AppException) {
      return ex;
    }

    return DartExceptionWrapper(ex);
  }

  @protected
  String getName() => "AppException";

  @override
  String toString() => jsonEncode(toJson());

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {"name": getName()};
    if (message != null) {
      map["message"] = message;
    }
    if (data.isNotEmpty) {
      map["data"] = data;
    }
    if (stackTrace != null) {
      map["stackTrace"] = stackTrace.toString();
    }
    if (innerException != null) {
      map["innerException"] = innerException!.toJson();
    }

    return map;
  }
}
