import 'package:flutter/material.dart';

@Deprecated("use UserTimeConverterProvider")
class UserDateTime<T extends DateTime?> extends StatelessWidget {
  final DateTime? utcDateTime;
  final Widget Function(BuildContext context, T userDateTime) builder;

  UserDateTime({super.key, required this.utcDateTime, required this.builder})
    : assert(utcDateTime == null || utcDateTime.isUtc);

  static UserDateTime<DateTime?> nullable({
    Key? key,
    required DateTime? utcDateTime,
    required Widget Function(BuildContext context, DateTime? userDateTime)
    builder,
  }) {
    return UserDateTime(key: key, utcDateTime: utcDateTime, builder: builder);
  }

  static UserDateTime<DateTime> notNull({
    Key? key,
    required DateTime utcDateTime,
    required Widget Function(BuildContext context, DateTime userDateTime)
    builder,
  }) {
    return UserDateTime(key: key, utcDateTime: utcDateTime, builder: builder);
  }

  @override
  Widget build(BuildContext context) {
    if (utcDateTime == null) {
      return builder(context, null as T);
    }

    return builder(context, utcDateTime!.toLocal() as T);
  }
}
