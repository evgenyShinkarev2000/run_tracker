import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChooseSettingVariant extends StatelessWidget {
  final String name;
  final void Function() onTap;
  final String? variantTitle;
  final IconData? icon;

  ChooseSettingVariant({required this.name, required this.onTap, this.variantTitle, this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyMedium,
      leading: icon != null ? Icon(icon) : null,
      title: Text(name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          variantTitle != null ? Text(variantTitle!) : null,
          SizedBox(
            width: 8,
          ),
          Icon(CupertinoIcons.forward),
        ].nonNulls.toList(),
      ),
    );
  }
}
