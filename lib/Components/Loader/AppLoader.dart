import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:run_tracker/Theme/export.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.themeData.primaryColor.withValues(alpha: 0.75);

    return Center(
      child: LoadingAnimationWidget.waveDots(color: color, size: 50),
    );
  }
}
