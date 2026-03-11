import 'package:flutter/material.dart';
import 'package:run_tracker/Theme/export.dart';

class SmallDash extends StatelessWidget {
  final String value;
  final String label;

  const SmallDash({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: context.themeData.textTheme.displaySmall,
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
        ),
        Text(
          label,
          style: context.themeData.textTheme.labelMedium,
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
        ),
      ],
    );
  }
}
