import 'package:flutter/material.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';

class RunRecordRow extends StatelessWidget {
  final String title;
  final String value;
  final String? unit;
  final bool isSelected;

  RunRecordRow(this.title, this.value, {this.unit, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    final style = context.themeDate.textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      color: isSelected ? Colors.grey[100] : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: style.bodyLarge,
          ),
          Row(
            children: [
              Text(
                unit != null ? "$value," : value,
                style: style.bodyLarge,
              ),
              unit != null ? Text(" $unit", style: style.bodySmall) : null,
            ].nonNulls.toList(),
          ),
        ],
      ),
    );
  }
}
