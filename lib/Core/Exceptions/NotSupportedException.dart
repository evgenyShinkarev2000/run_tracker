import 'package:run_tracker/Core/export.dart';

class NotSupportedException extends AppException {
  NotSupportedException({
    super.message,
    super.stackTrace,
    super.data,
    super.innerException,
  });

  @override
  String getName() => "NotSupportedException";
}
