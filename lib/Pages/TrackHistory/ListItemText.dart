import 'package:flutter/material.dart';

class ListItemText extends StatelessWidget {
  final String title;
  final String? value;
  final String? unit;

  const ListItemText({
    super.key,
    required this.title,
    required this.value,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      _buildText(),
      overflow: TextOverflow.fade,
      maxLines: 1,
      softWrap: false,
    );
  }

  String _buildText() {
    if (value == null) {
      return "$title:";
    }
    if (unit == null) {
      return "$title: $value";
    }

    return "$title: $value $unit";
  }
}
