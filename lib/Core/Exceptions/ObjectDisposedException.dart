import 'package:run_tracker/Core/Exceptions/export.dart';

class ObjectDisposedException extends AppException {
  ObjectDisposedException({
    super.message,
    super.stackTrace,
    super.data,
    super.innerException,
  });

  @override
  String getName() {
    return "DisposedException";
  }
}
