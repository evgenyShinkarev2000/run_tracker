import 'package:flutter/widgets.dart';
import 'package:run_tracker/Theme/export.dart';

class MapTabRow extends StatelessWidget {
  final String title;
  final String? value;
  final String? unit;
  final bool isSelected;

  const MapTabRow({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      color: isSelected
          ? context.themeData.colorScheme.secondaryContainer
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(_buildText()),
        ],
      ),
    );
  }

  String _buildText() {
    if (value == null) {
      return unit == null ? "" : "\u2014, $unit";
    }
    return unit == null ? value! : "$value, $unit";
  }
}
