import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get appFormatedDateOnly => DateFormat("y.MM.dd").format(this);
  String get appFormatedTimeOnly => DateFormat("HH:mm:ss").format(this);
  String get appFormatedDateTime => DateFormat("y.MM.dd HH:mm:ss").format(this);
}
