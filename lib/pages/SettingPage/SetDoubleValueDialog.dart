import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/helpers/extensions/DoubleExtension.dart';
import 'package:run_tracker/pages/SettingPage/SettingDialog.dart';

class SetDoubleValueDialog extends StatefulWidget {
  final int fractionalCount;
  final String? title;
  final double? min;
  final double? max;
  final double? initialValue;
  final double? defaultValue;
  final void Function(double value) onSave;

  SetDoubleValueDialog({
    required this.onSave,
    int? fractionalCount,
    this.title,
    this.initialValue,
    this.min,
    this.max,
    this.defaultValue,
  }) : fractionalCount = fractionalCount ?? 2;

  @override
  State<SetDoubleValueDialog> createState() => _SetDoubleValueDialogState();
}

class _SetDoubleValueDialogState extends State<SetDoubleValueDialog> {
  late double value;

  @override
  void initState() {
    value = widget.initialValue ?? widget.min ?? 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SettingDialog(
      title: widget.title,
      onSelectDefault: widget.defaultValue != null
          ? () {
              widget.onSave(widget.defaultValue!);
              context.pop();
            }
          : null,
      onSave: (context) {
        widget.onSave(value);
        context.pop();
      },
      content: SizedBox(
        width: double.maxFinite,
        child: IntrinsicHeight(
          child: Theme(
            data: context.themeData.copyWith(
                sliderTheme: context.themeData.sliderTheme.copyWith(showValueIndicator: ShowValueIndicator.always)),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Slider(
                label: value.toString(),
                value: value,
                onChanged: (v) {
                  setState(() {
                    value = v.roundTo(widget.fractionalCount);
                  });
                },
                min: widget.min ?? 0,
                max: widget.max ?? 1,
                inactiveColor:
                    Color.lerp(context.themeData.colorScheme.background, context.themeData.colorScheme.primary, 0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
