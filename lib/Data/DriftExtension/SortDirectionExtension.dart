import 'package:run_tracker/Core/Exceptions/export.dart';
import 'package:run_tracker/Data/Contracts/export.dart';
import 'package:drift/drift.dart';

extension SortDirectionExtension on SortDirection {
  OrderingMode get drift => switch (this) {
    SortDirection.Ascending => OrderingMode.asc,
    SortDirection.Descending => OrderingMode.desc,
    _ => throw AppException(message: "Unknown sort direction $this"),
  };
}
