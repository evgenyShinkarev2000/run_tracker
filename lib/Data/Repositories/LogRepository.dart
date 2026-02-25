import 'package:cancellation_token/cancellation_token.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/Contracts/export.dart';
import 'package:run_tracker/Data/Extensions/IterableExtension.dart';

@Deprecated("use talker")
abstract class LogRepository {
  Future<void> add(LogModel logModel, [CancellationToken? ct]);
  Future<List<LogModel>> get([QueryModel? queryModel, CancellationToken? ct]);
}

@Deprecated("use talker")
class MemoryLogRepository extends LogRepository {
  final CircularBuffer<LogModel> _buffer = CircularBuffer(10000);

  @override
  Future<void> add(LogModel logModel, [CancellationToken? ct]) {
    ct?.throwIfCancelled();
    _buffer.enqueue(logModel);

    return Future.value();
  }

  @override
  Future<List<LogModel>> get([QueryModel? queryModel, CancellationToken? ct]) {
    ct?.throwIfCancelled();
    final models = _buffer.toList();
    if (queryModel?.paginationModel == null) {
      return Future.value(models);
    }

    return Future.value(
      models.pagination(queryModel!.paginationModel!).toList(),
    );
  }
}

@Deprecated("use talker")
class LogModel {
  final DateTime createdAt = DateTime.now().toUtc();
  final LogLevel logLevel;
  final String? message;
  late final Map<String, dynamic>? data;

  LogModel({
    this.logLevel = LogLevel.Trace,
    this.message,
    this.data,
    AppException? appException,
  }) {
    if (appException != null) {
      data ??= {};
      data!["appException"] = appException.toJson();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {
      "logLevel": logLevel.name,
      "createdAt": createdAt.toIso8601String(),
    };
    if (message != null) {
      map["message"] = message;
    }
    if (data != null) {
      map["data"] = data;
    }

    return map;
  }
}
