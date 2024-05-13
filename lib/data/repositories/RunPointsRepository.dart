part of repositories;

class RunPointsRepository {
  final LazyBox<RunPointsData> recordsLazyBox;

  RunPointsRepository.RunPointsRepository({required this.recordsLazyBox});

  Future<RunPointsData> add(RunPointsData runRecordData) async {
    await recordsLazyBox.add(runRecordData);

    return runRecordData;
  }

  Future<RunPointsData?> getByKey(int key) async {
    return await recordsLazyBox.get(key);
  }

  Future<void> removeByKey(int key) async {
    await recordsLazyBox.delete(key);
  }
}

class RunPointsRepositoryFactory {
  static const String runPointsBoxName = "RunPoints";
  Future<RunPointsRepository> create() async {
    if (Hive.isBoxOpen(runPointsBoxName)) {
      return RunPointsRepository.RunPointsRepository(recordsLazyBox: Hive.lazyBox(runPointsBoxName));
    }
    try {
      final runsLazyBox = await Hive.openLazyBox<RunPointsData>(runPointsBoxName);

      return RunPointsRepository.RunPointsRepository(recordsLazyBox: runsLazyBox);
    } catch (ex) {
      rethrow;
    }
  }
}
