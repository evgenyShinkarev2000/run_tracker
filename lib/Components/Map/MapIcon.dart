import 'package:flutter/material.dart';
import 'package:run_tracker/Components/export.dart';

class MapIcon extends StatelessWidget {
  final IconData iconData;

  const MapIcon(this.iconData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      alignment: AlignmentGeometry.topCenter,
      children: [
        Icon(size: 32, CustomIcons.place_no_dot),
        Container(
          padding: EdgeInsets.only(top: 4),
          child: Icon(size: 16, iconData),
        ),
      ],
    );
  }
}
