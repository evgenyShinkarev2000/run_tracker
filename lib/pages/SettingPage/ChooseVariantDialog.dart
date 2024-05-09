import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/pages/SettingPage/SettingDialog.dart';

import 'SettingVariantView.dart';

class ChooseVariantDialog<T extends Enum> extends StatelessWidget {
  final List<SettingVariantView<T>> variants;
  final T? selected;
  final T? defaultVariant;
  final String? title;
  final void Function(T variant) onSelect;

  ChooseVariantDialog({required this.variants, required this.onSelect, this.selected, this.defaultVariant, this.title});

  @override
  Widget build(BuildContext context) {
    return SettingDialog(
      title: title,
      onSelectDefault: defaultVariant != null
          ? () {
              onSelect(defaultVariant!);
              context.pop();
            }
          : null,
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
    );
  }
}
