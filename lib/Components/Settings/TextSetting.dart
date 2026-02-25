import 'package:flutter/material.dart';
import 'package:run_tracker/Components/Settings/SettingItemWithDialog.dart';
import 'package:run_tracker/Components/Settings/TextInput.dart';

class TextSetting extends StatefulWidget {
  final String? name;
  final String? value;
  final IconData? iconData;
  final Future<bool> Function(String?)? onSave;
  final Future<bool> Function()? onReset;
  final bool isLoading;

  const TextSetting({
    super.key,
    this.value,
    this.onSave,
    this.name,
    this.iconData,
    this.onReset,
    this.isLoading = false,
  });

  @override
  State<TextSetting> createState() => _TextSettingState();
}

class _TextSettingState extends State<TextSetting> {
  String? value;

  @override
  Widget build(BuildContext context) {
    return SettingItemWithDialog(
      name: widget.name,
      iconData: widget.iconData,
      content: widget.value == null ? null : Text(widget.value!),
      builder: () => TextInput(value: value, onChanged: _handleValueChanged),
      onTap: _updateActualValue,
      onReset: widget.onReset,
      onSave: _save,
      onCancel: _updateActualValue,
      isLoading: widget.isLoading,
    );
  }

  void _handleValueChanged(String? value) {
    this.value = value;
  }

  Future<bool> _updateActualValue() {
    setState(() {
      value = widget.value;
    });

    return Future.value(true);
  }

  Future<bool> _save() async {
    return await widget.onSave?.call(value) ?? Future.value(true);
  }
}
