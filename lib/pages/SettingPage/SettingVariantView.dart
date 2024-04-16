import 'package:run_tracker/services/settings/Setting.dart';

class SettingVariantView<T extends Enum> {
  final T variant;
  final String title;

  SettingVariantView({required this.title, required this.variant});
}

extension IterableSettingVariantExtension<T extends Enum> on Iterable<SettingVariantView<T>> {
  String? getSelectedOrDefaultTitle(SettingVariant<T, dynamic> settingVariant) {
    if (settingVariant.variant != null) {
      return where((element) => element.variant == settingVariant.variant).firstOrNull?.title;
    }
    if (settingVariant.defaultVariant != null) {
      return where((element) => element.variant == settingVariant.defaultVariant).firstOrNull?.title;
    }

    return null;
  }
}
