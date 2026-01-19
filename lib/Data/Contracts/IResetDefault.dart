import 'package:cancellation_token/cancellation_token.dart';

abstract interface class IResetDefault {
  Future<void> ResertToDefault([CancellationToken? ct]);
}
