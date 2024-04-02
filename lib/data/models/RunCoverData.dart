import 'package:hive/hive.dart';
import 'package:run_tracker/data/AppHiveObject.dart';
import 'package:run_tracker/data/HiveTypeId.dart';

@HiveType(typeId: HiveTypeId.runCover)
class RunCoverData extends AppHiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime startDateTime;

  @HiveField(2)
  double? averageSpeed;

  // mks
  @HiveField(3)
  int duration;

  @HiveField(4)
  int? runPointsKey;

  @HiveField(5)
  double distance;

  RunCoverData(
      {required this.title,
      required this.startDateTime,
      required this.averageSpeed,
      required this.duration,
      required this.distance,
      this.runPointsKey});
}
