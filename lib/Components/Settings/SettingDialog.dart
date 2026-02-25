import 'package:flutter/material.dart';
import 'package:run_tracker/localization/export.dart';

class SettingDialog extends StatelessWidget {
  final String? title;
  final Widget? content;
  final VoidCallback? onReset;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;

  const SettingDialog({
    super.key,
    this.title,
    this.content,
    this.onReset,
    this.onSave,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title == null ? null : Text(title!),
      content: content,
      actions: [
        onReset != null
            ? TextButton(
                onPressed: onReset,
                child: Text(
                  context.appLocalization.settingVariantDialogButtonDefault,
                ),
              )
            : null,
        onCancel != null
            ? TextButton(
                onPressed: onCancel,
                child: Text(context.appLocalization.nounCancel),
              )
            : null,
        onSave != null
            ? TextButton(
                onPressed: onSave,
                child: Text(context.appLocalization.verbSave),
              )
            : null,
      ].nonNulls.toList(),
    );
  }
}
