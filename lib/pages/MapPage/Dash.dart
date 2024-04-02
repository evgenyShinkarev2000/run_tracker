import 'package:flutter/material.dart';

class Dash extends StatelessWidget {
  final String label;
  final String value;

  const Dash({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Text(value, style: textTheme.labelLarge),
          Text(
            label,
            style: textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
