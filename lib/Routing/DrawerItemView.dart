import 'package:flutter/material.dart';

class DrawerItemView extends StatelessWidget {
  final bool isActive;
  final VoidCallback? onTap;
  final String title;

  const DrawerItemView(
    this.title, {
    super.key,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: isActive,
      title: Text(title),
      onTap: onTap,
    );
  }
}
