import 'package:hive/hive.dart';
import 'package:run_tracker/data/models/RunCoverData.dart';

class RunCoverRepository {
  final LazyBox<RunCoverData> _runCoverLazyBox;
  RunCoverRepository({required LazyBox<RunCoverData> runsLazyBox})
      : _runCoverLazyBox = runsLazyBox;

  Future<RunCoverData> add(RunCoverData runData) async {
    await _runCoverLazyBox.add(runData);

    return runData;
  }

  Iterable<Future<RunCoverData>> getIterator() {
    return _runCoverLazyBox.keys.map((key) async {
      final runCoverData = await _runCoverLazyBox.get(key);

      return runCoverData!;
    });
  }

  Future<RunCoverData?> getByKey(int key) async {
    return await _runCoverLazyBox.get(key);
  }
}

class RunCoverRepositoryFactory {
  static const String runCoverBoxName = "RunCovers";
  Future<RunCoverRepository> create() async {
    if (Hive.isBoxOpen(runCoverBoxName)) {
      return RunCoverRepository(runsLazyBox: Hive.lazyBox(runCoverBoxName));
    }
    try {
      final runsLazyBox = await Hive.openLazyBox<RunCoverData>(runCoverBoxName);
      return RunCoverRepository(runsLazyBox: runsLazyBox);
    } catch (ex) {
      rethrow;
    }
  }
}
