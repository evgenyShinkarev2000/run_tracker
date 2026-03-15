import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:run_tracker/Data/Repositories/TrackRecord/export.dart';

part 'AppDatabase.g.dart';

class Settings extends Table {
  TextColumn get name => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {name};
}

class TrackRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isCompleted => boolean()();
}

class TrackRecordPositionPoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get trackRecordId => integer().references(TrackRecords, #id)();
  DateTimeColumn get createdAt => dateTime()();

  /// From the equator. The latitude of this position in degrees normalized to the interval -90.0
  /// to +90.0 (both inclusive).
  RealColumn get latitude => real().nullable()();

  /// From the Greenwich meridian. The longitude of the position in degrees normalized to the interval -180
  /// (exclusive) to +180 (inclusive).
  RealColumn get longitude => real().nullable()();

  /// The altitude of the device in meters.
  RealColumn get altitude => real().nullable()();
}

class TrackRecordPoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get trackRecordId => integer().references(TrackRecords, #id)();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get discriminator => textEnum<PointType>()();
  TextColumn get paylod => text().nullable()();
}

@DriftDatabase(
  tables: [
    Settings,
    TrackRecords,
    TrackRecordPositionPoints,
    TrackRecordPoints,
  ],
)
class AppDatabase extends _$AppDatabase {
  static DriftWebOptions? webOptions;

  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'run_tracker_db',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
      web: webOptions,
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }

  static void Initialize() {
    if (!kIsWeb) {
      return;
    }
    AppDatabase.webOptions = DriftWebOptions(
      sqlite3Wasm: Uri.parse("sqlite3.wasm"),
      driftWorker: Uri.parse("drift_worker.dart.js"),
    );
  }
}
