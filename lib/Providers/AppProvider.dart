import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppProvider {
  static ProviderScope Build(Widget child) {
    return ProviderScope(child: child);
  }
}
