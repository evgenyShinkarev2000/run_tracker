import 'package:flutter/material.dart';

extension WidgetBindingExtension on WidgetsBinding {
  int findDefaultLogicalWidth() {
    final screen = WidgetsBinding.instance.platformDispatcher.views.first;

    return (screen.physicalSize.width / screen.devicePixelRatio).floor();
  }
}
