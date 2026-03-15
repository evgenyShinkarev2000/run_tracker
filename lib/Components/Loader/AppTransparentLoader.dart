import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:run_tracker/Theme/export.dart';

class AppTransparentLoader extends StatelessWidget {
  const AppTransparentLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      alignment: AlignmentGeometry.center,
      child: LoadingAnimationWidget.waveDots(
        color: context.themeData.colorScheme.primary.withValues(alpha: 0.75),
        size: 50,
      ),
    );
  }
}
