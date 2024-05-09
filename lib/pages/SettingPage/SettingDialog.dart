import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';

class SettingDialog extends StatelessWidget {
  final String? title;
  final void Function()? onSelectDefault;
  final void Function(BuildContext context)? onSave;
  final Widget content;

  SettingDialog({required this.content, this.title, this.onSelectDefault, this.onSave});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null ? Text(title!) : null,
      content: content,
      actions: [
        onSelectDefault != null
            ? TextButton(
                onPressed: onSelectDefault,
                child: Text(context.appLocalization.settingVariantDialogButtonDefault),
              )
            : null,
        TextButton(onPressed: context.pop, child: Text(context.appLocalization.nounCancel)),
        onSave != null
            ? TextButton(
                onPressed: () => onSave!(context),
                child: Text(context.appLocalization.verbSave),
              )
            : null,
      ].nonNulls.toList(),
    );
  }
}
