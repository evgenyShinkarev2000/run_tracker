extension DurationExtension on Duration {
  /// 0-59
  int get minutes => inMinutes % 60;

  /// 0-59
  int get seconds => inSeconds % 60;

  /// 0-23
  int get hours => inHours % 24;

  String get hhmmss => getFormatedTime();

  String get mmss => getFormatedTime(includeHours: false);

  String getFormatedTime({bool includeHours = true, bool includeMinutes = true, bool includeSeconds = true}) {
    final tokens = <String>[];
    if (includeHours) {
      tokens.add(hours.toString().padLeft(2, "0"));
    }
    if (includeMinutes) {
      tokens.add(minutes.toString().padLeft(2, "0"));
    }
    if (includeSeconds) {
      tokens.add(seconds.toString().padLeft(2, "0"));
    }

    return tokens.join(":");
  }
}
