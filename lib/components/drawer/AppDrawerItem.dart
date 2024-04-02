import 'package:flutter/material.dart';

class AppDrawerItem extends StatelessWidget {
  final bool isActive;
  final Function()? onTap;
  final String title;

  const AppDrawerItem(
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
