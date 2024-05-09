import 'package:hive_flutter/hive_flutter.dart';
import 'package:run_tracker/data/HiveTypeId.dart';

@HiveType(typeId: HiveTypeId.pulseMeasurement)
class PulseMeasurementData {
  @HiveField(0)
  final DateTime dateTime;

  @HiveField(1)
  final double pulse;

  PulseMeasurementData({
    required this.dateTime,
    required this.pulse,
  });
}
