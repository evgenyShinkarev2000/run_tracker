import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final IconData? iconData;
  final String? name;
  final Widget? content;
  final VoidCallback? onTap;
  final bool isLoading;

  const SettingItem({
    super.key,
    this.iconData,
    this.name,
    this.content,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: isLoading ? null : onTap,
      leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyMedium,
      leading: iconData != null ? Icon(iconData) : null,
      title: name != null ? Text(name!) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isLoading ? null : content,
          isLoading ? CupertinoActivityIndicator() : null,
          SizedBox(width: 8),
          isLoading ? null : Icon(Icons.arrow_forward_ios_outlined),
        ].nonNulls.toList(),
      ),
    );
  }
}
