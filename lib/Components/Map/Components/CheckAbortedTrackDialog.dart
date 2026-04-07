import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Providers/Track/export.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/localization/export.dart';

class CheckAbortedTrackDialog extends ConsumerStatefulWidget {
  const CheckAbortedTrackDialog({super.key});

  @override
  ConsumerState<CheckAbortedTrackDialog> createState() =>
      _CheckAbortedTrackDialogState();
}

class _CheckAbortedTrackDialogState
    extends ConsumerState<CheckAbortedTrackDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(context.appLocalization.trackRecordAbortDialogContent),
      actions: [
        TextButton(
          onPressed: () => isLoading ? null : _cancel(context),
          child: Text(context.appLocalization.verbCancel),
        ),
        TextButton(
          onPressed: () => isLoading ? null : _continue(context),
          child: Text(context.appLocalization.verbContinue),
        ),
      ],
    );
  }

  void _cancel(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final messageService = ref.read(messageServiceProvider);
    try {
      await ref.read(trackManagerProvider).dropAborted();
    } catch (ex, s) {
      messageService.showAndLogError(DartExceptionWrapper(ex, s));
    }
    setState(() {
      isLoading = false;
    });
  }

  void _continue(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final messageService = ref.read(messageServiceProvider);
    try {
      await ref.read(trackManagerProvider).continueAborted();
    } catch (ex, s) {
      messageService.showAndLogError(DartExceptionWrapper(ex, s));
    }
    setState(() {
      isLoading = false;
    });
  }
}
