import 'package:flutter/material.dart';

class ListItemText extends StatelessWidget {
  final String title;
  final String? content;

  const ListItemText({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      "$title: $content",
      overflow: TextOverflow.fade,
      maxLines: 1,
      softWrap: false,
    );
  }
}
