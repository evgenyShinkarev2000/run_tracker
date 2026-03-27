import 'package:intl/intl.dart';
import 'package:run_tracker/Services/export.dart';

extension DateTimeExtension on DateTime {
  String applyFormat(DateFormat format) => format.format(this);
  DateTime applyConverter(UserDateTimeConverter converter) =>
      converter.toUserDateTime(this);
}
