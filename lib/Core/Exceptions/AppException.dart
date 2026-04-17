import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:run_tracker/Core/export.dart';

part 'DartExceptionWrapper.dart';

class AppException implements Exception, IJsonSerializable {
  final String? message;
  final Map<String, dynamic> data;
  StackTrace? get stackTrace => _stackTrace;
  StackTrace? _stackTrace;
  final AppException? innerException;

  AppException({
    this.message,
    Map<String, dynamic>? data,
    StackTrace? stackTrace,
    this.innerException,
  }) : data = data ?? {},
       _stackTrace = stackTrace;

  factory AppException.inner(Object ex) =>
      ex is AppException ? ex : _DartExceptionWrapper(ex);

  factory AppException.caught(Object ex, StackTrace s) {
    if (ex is AppException) {
      ex._stackTrace ??= s;
      return ex;
    }

    return _DartExceptionWrapper(ex, s);
  }

  @protected
  String getName() => "AppException";

  @override
  String toString() => jsonEncode(toJson());

  @override
  Map<String, dynamic> toJson({bool includeStack = true}) {
    Map<String, dynamic> map = {"name": getName()};
    if (message != null) {
      map["message"] = message;
    }
    if (data.isNotEmpty) {
      map["data"] = data;
    }
    if (includeStack && stackTrace != null) {
      map["stackTrace"] = stackTrace.toString();
    }
    if (innerException != null) {
      map["innerException"] = innerException!.toJson();
    }

    return map;
  }
}
