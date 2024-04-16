class SettingVariant<TVariant extends Enum, TValue> extends SettingBase<TValue> {
  final Future<void> Function(String name, TVariant? variant)? onChange;
  final TValue? Function(TVariant?) variantToValue;
  final TVariant? defaultVariant;

  TVariant? get variant => _variant;
  TVariant? _variant;

  SettingVariant({
    required super.name,
    required this.variantToValue,
    super.value,
    TVariant? variant,
    this.defaultVariant,
    this.onChange,
  })  : _variant = variant,
        super(defaultValue: variantToValue(defaultVariant));

  Future<void> setVariant(TVariant? variant) async {
    _variant = variant;
    _value = variantToValue(variant);

    return await onChange?.call(name, variant);
  }
}

class SettingValue<TValue> extends SettingBase<TValue> {
  final Future<void> Function(String name, TValue? value)? onChange;

  SettingValue({
    required super.name,
    super.value,
    super.defaultValue,
    this.onChange,
  });

  Future<void> setValue(TValue? value) async {
    _value = value;

    return await onChange?.call(name, value);
  }
}

abstract class SettingBase<TValue> {
  final String name;

  final TValue? defaultValue;

  TValue? get value => _value;
  TValue? _value;

  SettingBase({
    required this.name,
    TValue? value,
    this.defaultValue,
  }) : _value = value;
}
