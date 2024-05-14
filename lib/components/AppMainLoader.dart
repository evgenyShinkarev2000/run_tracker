import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';

class AppMainLoader extends StatelessWidget {
  const AppMainLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.themeData.primaryColor.withOpacity(0.75);

    return Material(
      child: Center(child: LoadingAnimationWidget.waveDots(color: color, size: 50)),
    );
  }
}
