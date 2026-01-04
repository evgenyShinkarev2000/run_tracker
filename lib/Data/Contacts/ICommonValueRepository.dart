import 'package:run_tracker/Data/Contacts/IStreamValueRepository.dart';
import 'package:run_tracker/Data/Contacts/IValueRepository.dart';

abstract mixin class ICommonValueRepository<T>
    implements IValueRepository<T>, IStreamValueRepository<T> {
  Stream<T> StreamValueWithLastOrGet();
}
