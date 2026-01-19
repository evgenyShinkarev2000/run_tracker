import 'package:cancellation_token/cancellation_token.dart';

abstract interface class IValueRepository<T> {
  Future<T> Get([CancellationToken? ct]);
}

abstract interface class ISetValueRepository<T>{
  Future<void> Set(T model, [CancellationToken? ct]);
}
