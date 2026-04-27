extension DurationExtension on Duration {
  int get seconds => inSeconds % 60;
  int get minutes => inMinutes % 60;
  int get hours => inHours % 24;
  double get inSecondsDouble => inMicroseconds / Duration.microsecondsPerSecond;

  String get HHmmss =>
      "${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";

  String get mmss =>
      "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";

  String get HH_noPad_mmss {
    return hours == 0
        ? mmss
        : "${hours.toString()}:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
  }

  String get HH_noPad_mm {
    return "$hours:${minutes.toString().padLeft(2, "0")}";
  }
}
