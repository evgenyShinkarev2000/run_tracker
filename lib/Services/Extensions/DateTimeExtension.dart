import 'package:intl/intl.dart';
import 'package:run_tracker/Services/export.dart';

extension DateTimeExtension on DateTime {
  String applyFormat(DateFormat format) => format.format(this);
  DateTime fromUtcToUser(UserDateTimeConverter converter) =>
      converter.toUserDateTime(this);
  DateTime fromUserToUtc(UserDateTimeConverter converter) =>
      converter.toUtcDateTime(this);
}
