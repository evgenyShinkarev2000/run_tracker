import 'package:run_tracker/Data/Contracts/export.dart';

extension IterableExtension<T> on Iterable<T> {
  Iterable<T> pagination(PaginationModel paginationModel) {
    return skip(paginationModel.skip).take(paginationModel.take);
  }
}
