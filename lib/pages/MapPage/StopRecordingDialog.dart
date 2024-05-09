import 'package:flutter/material.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';

class StopRecordingDialog extends StatelessWidget {
  final Function() onCancel;
  final Function() onConfirm;

  const StopRecordingDialog({super.key, required this.onConfirm, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final titleLabel = context.appLocalization.stopRecordingDialogQuestion;
    final confirmLabel = context.appLocalization.verbCanfirm;
    final cancelLabel = context.appLocalization.verbCancel;

    return AlertDialog(
      title: Text(titleLabel),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
