import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/Components/Settings/SettingDialog.dart';
import 'package:run_tracker/Components/Settings/SettingItem.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Providers/export.dart';

class SettingItemWithDialog extends ConsumerWidget {
  final String? name;
  final Widget? content;
  final Widget Function()? builder;
  final Future<bool> Function()? onCancel;
  final Future<bool> Function()? onSave;
  final Future<bool> Function()? onReset;
  final Future<bool> Function()? onTap;
  final IconData? iconData;
  final bool isLoading;

  const SettingItemWithDialog({
    super.key,
    this.name,
    this.content,
    this.builder,
    this.onCancel,
    this.onSave,
    this.onReset,
    this.iconData,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingItem(
      iconData: iconData,
      name: name,
      content: content,
      onTap: () => _tap(context, ref),
      isLoading: isLoading,
    );
  }

  void _showDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return SettingDialog(
          title: name,
          content: builder?.call(),
          onCancel: () => _closeDialog(context, ref),
          onSave: () => _save(context, ref),
          onReset: () => _reset(context, ref),
        );
      },
    );
  }

  static Future<void> _invoke(
    Future<bool> Function() task,
    BuildContext context,
    WidgetRef ref,
  ) async {
    var shouldClose = false;
    var messageService = ref.read(messageServiceProvider);
    try {
      shouldClose = await task.call();
    } catch (ex, st) {
      messageService.showAndLogError(DartExceptionWrapper(ex, stackTrace: st));
    }
    if (shouldClose && context.mounted) {
      context.pop();
    }
  }

  void _tap(BuildContext context, WidgetRef ref) async {
    var shouldOpenDialog = false;
    var messageService = ref.read(messageServiceProvider);
    try {
      shouldOpenDialog = onTap == null ? true : await onTap!.call();
    } catch (ex, st) {
      messageService.showAndLogError(DartExceptionWrapper(ex, stackTrace: st));
    }
    if (shouldOpenDialog && context.mounted) {
      _showDialog(context, ref);
    }
  }

  void _closeDialog(BuildContext context, WidgetRef ref) async {
    if (onCancel != null) {
      await _invoke(onCancel!, context, ref);
    }
  }

  void _save(BuildContext context, WidgetRef ref) async {
    if (onSave != null) {
      await _invoke(onSave!, context, ref);
    }
  }

  void _reset(BuildContext context, WidgetRef ref) async {
    if (onReset != null) {
      await _invoke(onReset!, context, ref);
    }
  }
}
