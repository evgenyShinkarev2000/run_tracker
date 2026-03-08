import 'package:run_tracker/Core/export.dart';

class EntityNotFoundException extends AppException {
  EntityNotFoundException({
    super.message,
    super.stackTrace,
    super.data,
    super.innerException,
  });

  @override
  String getName() {
    return "EntityNotFoundException";
  }

  factory EntityNotFoundException.fromTypeAndPrimaryKey(
    String type,
    String primaryKey, {
    Map<String, dynamic>? data,
  }) {
    return EntityNotFoundException(
      message: "Entity of type $type with primary key $primaryKey not found",
      data: data,
    );
  }
}
