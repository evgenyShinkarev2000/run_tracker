import 'package:run_tracker/services/settings/settings.dart';

extension SettingValueExtension<T> on SettingBase<T> {
  T? get valueOrDefault => value ?? defaultValue;
}

extension SettingVariantExtension<T extends Enum> on SettingVariant<T, dynamic> {
  T? get variantOrDefault => variant ?? defaultVariant;
}
