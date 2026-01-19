import 'dart:async';

abstract interface class IStreamProvider<T> {
  Stream<T> get stream;
}
