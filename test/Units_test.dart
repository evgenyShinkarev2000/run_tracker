import 'package:flutter_test/flutter_test.dart';
import 'package:run_tracker/Core/Units/Speed.dart';

void main() {
  test("Speed and pace", () {
    final speed = Speed(1);
    expect(speed.kilometersPerHour, 3.6);
    final pace = speed.toPace();
    expect(pace.minutesPerKilometer, 60 / 3.6);
    expect(pace.toSpeed().metersPerSecond, speed.metersPerSecond);
  });

  test("critical values", () {
    var speed = Speed(0);
    final pace = speed.toPace();
    expect(pace.minutesPerKilometer, double.infinity);
    speed = pace.toSpeed();
    expect(speed.metersPerSecond, 0);
  });
}
