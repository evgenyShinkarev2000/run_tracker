part of repositories;

class RunCoverRepository {
  final Box<RunCoverData> runCoverBox;
  RunCoverRepository({required this.runCoverBox});

  Future<RunCoverData> add(RunCoverData runData) async {
    await runCoverBox.add(runData);

    return runData;
  }

  Iterable<Future<RunCoverData>> getIterator() {
    return runCoverBox.values.map((runCover) => Future.value(runCover));
  }

  Future<RunCoverData?> getByKey(int key) {
    return Future.value(runCoverBox.get(key));
  }

  Future<void> removeByKey(int key) async {
    await runCoverBox.delete(key);
  }
}

class RunCoverRepositoryFactory {
  static const String runCoverBoxName = "RunCovers";
  Future<RunCoverRepository> create() async {
    if (Hive.isBoxOpen(runCoverBoxName)) {
      return RunCoverRepository(runCoverBox: Hive.box(runCoverBoxName));
    }
    try {
      final runsLazyBox = await Hive.openBox<RunCoverData>(runCoverBoxName);

      return RunCoverRepository(runCoverBox: runsLazyBox);
    } catch (ex) {
      rethrow;
    }
  }
}
