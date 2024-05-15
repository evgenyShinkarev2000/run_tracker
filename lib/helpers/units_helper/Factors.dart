part of units_helper;

class Factors {
  static double toMeters(DistanceUnit distanceUnit) {
    switch (distanceUnit) {
      case DistanceUnit.meter:
        return 1;
      case DistanceUnit.kilometer:
        return 1000;
    }
  }

  static double toSeconds(TimeUnit timeUnit) {
    switch (timeUnit) {
      case TimeUnit.second:
        return 1;
      case TimeUnit.minute:
        return 60;
      case TimeUnit.hour:
        return 3600;
    }
  }
}
