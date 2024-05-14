import 'package:flutter/material.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/theme/Theme.dart';

class MapIconButton extends StatelessWidget {
  final void Function() onPressed;
  final Icon icon;

  MapIconButton({required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      iconSize: context.themeData.mapScreenButtonTheme.size,
      color: context.themeData.mapScreenButtonTheme.color,
    );
  }
}
