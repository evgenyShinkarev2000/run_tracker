import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';

import 'SettingVariantView.dart';

class ChooseSettingVariantDialog<T extends Enum> extends StatelessWidget {
  final List<SettingVariantView<T>> variants;
  final T? selected;
  final T? defaultVariant;
  final void Function(T variant) onSelect;

  ChooseSettingVariantDialog({required this.variants, required this.onSelect, this.selected, this.defaultVariant});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: variants.length,
          itemBuilder: (context, index) {
            final processedVariant = variants[index];
            final isSelected = selected != null && selected == processedVariant.variant;

            return ListTile(
              title: Text(processedVariant.title),
              trailing: isSelected ? Icon(CupertinoIcons.check_mark) : null,
              selected: isSelected,
              onTap: () {
                onSelect(processedVariant.variant);
                context.pop();
              },
            );
          },
        ),
      ),
      actions: [
        defaultVariant != null
            ? TextButton(
                onPressed: () {
                  onSelect(defaultVariant!);
                  context.pop();
                },
                child: Text(context.appLocalization.settingVariantDialogButtonDefault),
              )
            : null,
        TextButton(onPressed: context.pop, child: Text(context.appLocalization.nounCancel)),
      ].nonNulls.toList(),
    );
  }
}
