import 'package:run_tracker/Core/Exceptions/export.dart';

class DartExceptionWrapper extends AppException {
  final Object dartException;

  DartExceptionWrapper(this.dartException, [StackTrace? stackTrace])
    : super(message: dartException.toString(), stackTrace: stackTrace);

  @override
  String getName() {
    return "DartExceptionWrapper";
  }
}
