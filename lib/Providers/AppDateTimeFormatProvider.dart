import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/localization/export.dart';

final appDateTimeFormatProvider = Provider((ref) {
  var locale = ref.watch(localeProvider).value ?? AppLocales.fallback;

  return AppDateTimeFormat(
    fullDateFullTime: DateFormat.yMd(locale.locale.languageCode).add_Hms(),
  );
});
