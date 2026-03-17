import 'package:drift/drift.dart';
import 'package:run_tracker/Core/Units/export.dart';

class DistanceConverter extends TypeConverter<Distance, double> {
  const DistanceConverter();

  @override
  Distance fromSql(double fromDb) {
    return Distance(fromDb);
  }

  @override
  double toSql(Distance value) {
    return value.meters;
  }
}
