import 'package:flutter/material.dart';
import 'package:run_tracker/Theme/export.dart';

class ButtonLoader extends StatelessWidget {
  const ButtonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(color: context.themeData.primaryColor, strokeWidth: 3);
  }
}
