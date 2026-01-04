import 'dart:async';

abstract interface class IStreamValueRepository<T> {
  Stream<T> get stream;
}
