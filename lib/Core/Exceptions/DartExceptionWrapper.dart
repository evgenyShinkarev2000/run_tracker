part of 'AppException.dart';

class _DartExceptionWrapper extends AppException {
  final Object dartException;

  _DartExceptionWrapper(this.dartException, [StackTrace? stackTrace])
    : super(message: dartException.toString(), stackTrace: stackTrace);

  @override
  String getName() {
    return "DartExceptionWrapper";
  }
}
