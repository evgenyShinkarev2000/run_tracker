import 'package:flutter/material.dart';

class SummaryRow extends StatelessWidget {
  final String title;
  final String? value;
  final String? unit;

  const SummaryRow({super.key, required this.title, this.value, this.unit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(title), Text(_buildText())],
    );
  }

  String _buildText() {
    if (value == null) {
      return unit == null ? "" : "\u2014, $unit";
    }
    return unit == null ? value! : "$value, $unit";
  }
}
