import 'package:run_tracker/Core/Units/export.dart';

extension DurationUnitExtension on Duration {
  Pace operator /(Distance distance) {
    return Pace(inMicroseconds / 60_000 / distance.meters);
  }
}
