import 'package:hive/hive.dart';
import 'package:run_tracker/data/models/RunPointsData.dart';

class RunPointsRepository {
  final LazyBox<RunPointsData> _recordsLazyBox;

  RunPointsRepository.RunPointsRepository(
      {required LazyBox<RunPointsData> recordsLazyBox})
      : _recordsLazyBox = recordsLazyBox;

  Future<RunPointsData> add(RunPointsData runRecordData) async {
    await _recordsLazyBox.add(runRecordData);

    return runRecordData;
  }

  Future<RunPointsData?> getByKey(int key) async {
    return await _recordsLazyBox.get(key);
  }
}

class RunPointsRepositoryFactory {
  static const String runPointsBoxName = "RunPoints";
  Future<RunPointsRepository> create() async {
    if (Hive.isBoxOpen(runPointsBoxName)) {
      return RunPointsRepository.RunPointsRepository(
          recordsLazyBox: Hive.lazyBox(runPointsBoxName));
    }
    try {
      final runsLazyBox =
          await Hive.openLazyBox<RunPointsData>(runPointsBoxName);
      return RunPointsRepository.RunPointsRepository(
          recordsLazyBox: runsLazyBox);
    } catch (ex) {
      rethrow;
    }
  }
}
