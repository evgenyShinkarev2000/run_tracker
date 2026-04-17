import 'package:cancellation_token/cancellation_token.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/AppDatabase.dart';

abstract class BaseSettingRepository<T> {
  @protected
  abstract final String key;

  final AppDatabase _appDatabase;

  BaseSettingRepository(this._appDatabase);

  @protected
  Future<T?> protectedGet([CancellationToken? ct]) async {
    ct?.throwIfCancelled();

    final selectStatement = _appDatabase.settings.select();
    selectStatement.where((s) => s.name.equals(key));
    Setting? setting;
    try {
      setting = await selectStatement.getSingleOrNull();
    } catch (ex) {
      throw AppException(
        message: "Exception when get setting for key $key",
        innerException: AppException.inner(ex),
        data: {"key": key},
      );
    }
    ct?.throwIfCancelled();

    if (setting == null) {
      return null;
    }

    T? model;
    try {
      model = protectedDeserialize(setting.value);
    } catch (ex) {
      throw AppException(
        message: "Exception when deserialize setting for key $key",
        innerException: AppException.inner(ex),
        data: {"key": key, "serializedValue": setting.value},
      );
    }

    return model;
  }

  @protected
  Future<void> protectedSet(T model, [CancellationToken? ct]) async {
    ct?.throwIfCancelled();

    String? serialized;
    try {
      serialized = protectedSerialize(model);
    } catch (ex) {
      throw AppException(
        message: "Exception when serialize setting for key $key",
        innerException: AppException.inner(ex),
        data: {"key": key, "model.toString": model.toString()},
      );
    }
    try {
      await _appDatabase.settings.insertOnConflictUpdate(
        Setting(name: key, value: serialized),
      );
    } catch (ex) {
      throw AppException(
        message: "Exception when set setting for key $key",
        innerException: AppException.inner(ex),
        data: {"key": key, "serializedValue": serialized},
      );
    }
  }

  String protectedSerialize(T model);
  T protectedDeserialize(String serializedModel);
}

abstract class StringSettingRepository extends BaseSettingRepository<String> {
  StringSettingRepository(super.appDatabase);

  @override
  String protectedDeserialize(String serializedModel) => serializedModel;

  @override
  String protectedSerialize(String model) => model;
}

abstract class BoolSettingRepository extends BaseSettingRepository<bool> {
  BoolSettingRepository(super.appDatabase);

  @override
  bool protectedDeserialize(String serializedModel) {
    return bool.parse(serializedModel);
  }

  @override
  String protectedSerialize(bool model) {
    return model.toString();
  }
}

abstract class DurationSettingRepository
    extends BaseSettingRepository<Duration> {
  DurationSettingRepository(super.appDatabase);

  @override
  Duration protectedDeserialize(String serializedModel) {
    return Duration(microseconds: int.parse(serializedModel));
  }

  @override
  String protectedSerialize(Duration model) {
    return model.inMicroseconds.toString();
  }
}

abstract class EnumSettingRepository<T extends Enum>
    extends BaseSettingRepository<T> {
  @protected
  abstract final List<T> enumValues;

  EnumSettingRepository(super.appDatabase);

  @override
  T protectedDeserialize(String serializedModel) {
    return enumValues.firstWhere((e) => e == serializedModel);
  }

  @override
  String protectedSerialize(T model) {
    return model.name;
  }
}
