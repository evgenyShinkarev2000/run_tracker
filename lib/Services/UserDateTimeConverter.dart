import 'package:run_tracker/Core/export.dart';

class UserDateTimeConverter {
  DateTime toUserDateTime(DateTime utcDateTime) {
    if (!utcDateTime.isUtc) {
      throw AppException(
        message:
            "expected DateTime.isUtc, got ${utcDateTime.toIso8601String()}",
      );
    }

    return utcDateTime.toLocal();
  }

  DateTime? tryToUserDateTime(DateTime? utcDateTime) {
    if (utcDateTime == null) {
      return null;
    }

    return toUserDateTime(utcDateTime);
  }
}
