extension DurationExtension on Duration {
  int get seconds => inSeconds % 60;
  int get minutes => inMinutes % 60;
  int get hours => inHours % 24;
  String get HHmmss =>
      "${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";

  String get mmss => "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
}

