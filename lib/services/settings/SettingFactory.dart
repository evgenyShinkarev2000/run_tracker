import 'package:run_tracker/data/models/SettingData.dart';
import 'package:run_tracker/data/repositories/SettingRepository.dart';
import 'package:run_tracker/helpers/extensions/IterableExtension.dart';
import 'package:run_tracker/services/settings/Setting.dart';

class SettingFactory {
  final void Function() _onChange;
  final SettingRepository _settingRepository;

  SettingFactory(
    SettingRepository settingRepository,
    void Function() onChange,
  )   : _settingRepository = settingRepository,
        _onChange = onChange;

  Future<SettingValue<T>> initSettingValue<T>(
    String name,
    String? Function(T? value) justifyValue,
    T? Function(String? string) parseValue, [
    T? defaultValue,
  ]) async {
    final settingData = await _settingRepository.getByKey(name);

    return SettingValue(
      name: name,
      value: settingData != null ? parseValue(settingData.value) : null,
      onChange: (name, value) async {
        await _settingRepository.put(name, SettingData(value: justifyValue(value)));
        _onChange();
      },
      defaultValue: defaultValue,
    );
  }

  Future<SettingVariant<TVariant, TValue>> initSettingVariant<TVariant extends Enum, TValue>(
      String name,
      String? Function(TVariant? variant) justifyVariant,
      TVariant? Function(String? string) parseVariant,
      TValue? Function(TVariant? variant) variantToValue,
      [TVariant? defaultVariant]) async {
    final settingData = await _settingRepository.getByKey(name);

    onChange(name, variant) async {
      await _settingRepository.put(name, SettingData(value: justifyVariant(variant)));
      _onChange();
    }

    if (settingData?.value != null) {
      final variant = parseVariant(settingData!.value);
      final value = variantToValue(variant);

      return SettingVariant(
        name: name,
        variantToValue: variantToValue,
        variant: variant,
        value: value,
        onChange: onChange,
        defaultVariant: defaultVariant,
      );
    }

    return SettingVariant(
      name: name,
      variantToValue: variantToValue,
      onChange: onChange,
      defaultVariant: defaultVariant,
    );
  }

  Future<SettingVariant<TVariant, TValue>> initSettingVariantWithStringSerializer<TVariant extends Enum, TValue>(
    String name,
    Iterable<TVariant> enumValues,
    TValue? Function(TVariant) variantToValue, [
    TVariant? defaultVariant,
  ]) async {
    return initSettingVariant(
      name,
      (variant) => variant?.name,
      (string) => string != null ? enumValues.byName(string) : null,
      (variant) => variant != null ? variantToValue(variant) : null,
      defaultVariant,
    );
  }

  Future<SettingValue<int>> initSettingInt(String name, [int? defaultValue]) async {
    return initSettingValue(
      name,
      (value) => value.toString(),
      (string) => string != null ? int.tryParse(string) : null,
      defaultValue,
    );
  }

  Future<SettingValue<double>> initSettingDouble(String name, [double? defaultValue]) async {
    return initSettingValue(
      name,
      (value) => value.toString(),
      (string) => string != null ? double.tryParse(string) : null,
      defaultValue,
    );
  }

  Future<SettingValue<Duration>> initSettingDuration(String name, [Duration? defaultValue]) async {
    return initSettingValue(name, (value) => value?.inMicroseconds.toString(), (string) {
      if (string == null) {
        return null;
      }

      final microseconds = int.tryParse(string);
      if (microseconds == null) {
        return null;
      }

      return Duration(microseconds: microseconds);
    }, defaultValue);
  }

  Future<SettingValue<T>> initSettingEnum<T extends Enum>(String name, Iterable<T> enumValues, [T? defaultValue]) {
    return initSettingValue<T>(
      name,
      (value) => value?.name,
      (string) => string != null ? enumValues.byName(string) : null,
      defaultValue,
    );
  }
}
