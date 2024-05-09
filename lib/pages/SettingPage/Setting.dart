import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/pages/SettingPage/ChooseVariantDialog.dart';
import 'package:run_tracker/pages/SettingPage/SetDoubleValueDialog.dart';
import 'package:run_tracker/pages/SettingPage/SettingVariantView.dart';

class Setting extends StatelessWidget {
  final String name;
  final void Function() onTap;
  final String? variantTitle;
  final IconData? icon;

  const Setting({super.key, required this.name, required this.onTap, this.variantTitle, this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyMedium,
      leading: icon != null ? Icon(icon) : null,
      title: Text(name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          variantTitle != null ? Text(variantTitle!) : null,
          SizedBox(
            width: 8,
          ),
          Icon(CupertinoIcons.forward),
        ].nonNulls.toList(),
      ),
    );
  }

  static Widget withVariantDialog<T extends Enum>({
    required String name,
    required List<SettingVariantView<T>> variants,
    required void Function(T variant) onSelect,
    String? variantTitle,
    IconData? icon,
    T? selected,
    T? defaultVariant,
  }) {
    return Builder(builder: (context) {
      showChooseVariantDialog() {
        showDialog(
            context: context,
            builder: (_) => ChooseVariantDialog<T>(
                  title: name,
                  variants: variants,
                  onSelect: onSelect,
                  selected: selected,
                  defaultVariant: defaultVariant,
                ));
      }

      return Setting(
        name: name,
        icon: icon,
        variantTitle: variantTitle,
        onTap: showChooseVariantDialog,
      );
    });
  }

  static Widget withDoubleSliderDialog({
    required String name,
    required void Function(double value) onSave,
    double? value,
    double? min,
    double? max,
    int? fractionalCount,
    double? defaultValue,
    IconData? icon,
  }) {
    return Builder(builder: (context) {
      showSetDoubleValueDialog() {
        showDialog(
          context: context,
          builder: (_) => SetDoubleValueDialog(
            title: name,
            initialValue: value,
            min: min,
            max: max,
            fractionalCount: fractionalCount,
            defaultValue: defaultValue,
            onSave: onSave,
          ),
        );
      }

      return Setting(
        name: name,
        icon: icon,
        variantTitle: value?.toString(),
        onTap: showSetDoubleValueDialog,
      );
    });
  }
}
