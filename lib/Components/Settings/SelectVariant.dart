import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/Components/Settings/SettingItemWithDialog.dart';

class SelectVariant<T> extends StatelessWidget {
  final String? name;
  final T? value;
  final Iterable<T> items;
  final IconData? iconData;
  final Widget Function(T) builder;
  final Future<bool> Function(T?)? onSave;
  final Future<bool> Function()? onReset;
  final bool isLoading;

  const SelectVariant({
    super.key,
    required this.builder,
    this.name,
    this.value,
    this.items = const [],
    this.iconData,
    this.onSave,
    this.onReset,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SettingItemWithDialog(
      name: name,
      isLoading: isLoading,
      iconData: iconData,
      onReset: onReset,
      content: value == null ? null : builder.call(value!),
      builder: () => _buildDialogContent(context),
    );
  }

  Future<void> _save(BuildContext context, T? value) async {
    final shouldClose = await onSave?.call(value) ?? true;
    if (context.mounted && shouldClose) {
      context.pop();
    }
  }

  Widget _buildDialogContent(BuildContext context) {
    final listTiles = items.map((i) {
      final isSelected = value == i;
      return ListTile(
        title: builder.call(i),
        trailing: isSelected ? Icon(Icons.check) : null,
        selected: isSelected,
        onTap: () => _save(context, i),
      );
    }).toList();

    return SizedBox(
      width: double.maxFinite,
      child: ListView(children: listTiles),
    );
  }
}
