import 'package:cancellation_token/cancellation_token.dart';

abstract class IValueRepository<T> {
  Future<T> Get([CancellationToken ct]);
  Future Set(T model, [CancellationToken ct]);
}
