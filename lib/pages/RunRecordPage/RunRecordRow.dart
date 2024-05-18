import 'package:flutter/material.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';

import '../../components/ValueWithUnit.dart';

class RunRecordRow extends StatelessWidget {
  final String title;
  final String? value;
  final String? unit;
  final bool isSelected;

  RunRecordRow(this.title, {this.value, this.unit, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      color: isSelected ? context.themeData.colorScheme.primary.withOpacity(0.05) : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.themeData.textTheme.bodyLarge,
          ),
          ValueWithUnit(value: value, unit: unit),
        ],
      ),
    );
  }
}
