extension DateTimeExtension on DateTime {
  String get hhmmss => getTimeString();
  String get dmmyyyy => getDateString();
  String get dateSpaceTime => "$dmmyyyy $hhmmss";

  String getDateString({String? delimiter = "-"}) => "$day$delimiter${month.toString().padLeft(2, "0")}$delimiter$year";

  String getTimeString({String? delimiter = ":", includeMiliseconds = false}) {
    var token =
        "${hour.toString().padLeft(2, "0")}$delimiter${minute.toString().padLeft(2, "0")}$delimiter${second.toString().padLeft(2, "0")}";
    if (includeMiliseconds) {
      token = "$token$delimiter${millisecond.toString().padLeft(3, "0")}";
    }

    return token;
  }
}
