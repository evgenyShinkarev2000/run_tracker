part of repositories;

class RunCoverRepository {
  final Box<RunCoverData> _runCoverLazyBox;
  RunCoverRepository({required Box<RunCoverData> runsLazyBox}) : _runCoverLazyBox = runsLazyBox;

  Future<RunCoverData> add(RunCoverData runData) async {
    await _runCoverLazyBox.add(runData);

    return runData;
  }

  Iterable<Future<RunCoverData>> getIterator() {
    return _runCoverLazyBox.values.map((runCover) => Future.value(runCover));
  }

  Future<RunCoverData?> getByKey(int key) {
    return Future.value(_runCoverLazyBox.get(key));
  }

  Future<void> removeByKey(int key) async {
    await _runCoverLazyBox.delete(key);
  }
}

class RunCoverRepositoryFactory {
  static const String runCoverBoxName = "RunCovers";
  Future<RunCoverRepository> create() async {
    if (Hive.isBoxOpen(runCoverBoxName)) {
      return RunCoverRepository(runsLazyBox: Hive.box(runCoverBoxName));
    }
    try {
      final runsLazyBox = await Hive.openBox<RunCoverData>(runCoverBoxName);

      return RunCoverRepository(runsLazyBox: runsLazyBox);
    } catch (ex) {
      rethrow;
    }
  }
}
