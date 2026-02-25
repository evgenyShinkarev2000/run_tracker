import 'package:run_tracker/Core/Exceptions/export.dart';

class DartExceptionWrapper extends AppException {
  final Object dartException;

  DartExceptionWrapper(
    this.dartException, {
    super.message,
    super.stackTrace,
    super.data,
    super.innerException,
  });

  @override
  String getName() {
    return "DartExceptionWrapper";
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map["dartException"] = dartException;

    return map;
  }
}
