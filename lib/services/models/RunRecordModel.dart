import 'package:run_tracker/data/models/RunCoverData.dart';
import 'package:run_tracker/data/models/RunPointsData.dart';

class RunRecordModel {
  RunCoverData runCoverData;
  RunPointsData runPointsData;

  RunRecordModel({required this.runCoverData, required this.runPointsData});
}
