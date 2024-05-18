import 'package:flutter/material.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';

class ValueWithUnit extends StatelessWidget {
  const ValueWithUnit({
    super.key,
    required this.value,
    required this.unit,
  });

  final String? value;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        value != null
            ? Text(
                unit != null ? "$value," : value!,
                style: context.themeData.textTheme.bodyLarge,
              )
            : null,
        unit != null ? Text(" $unit", style: context.themeData.textTheme.bodySmall) : null,
      ].nonNulls.toList(),
    );
  }
}
