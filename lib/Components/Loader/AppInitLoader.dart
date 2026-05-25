import 'package:flutter/material.dart';
import 'package:run_tracker/Components/export.dart';
import 'package:run_tracker/Theme/export.dart';

class AppInitLoader extends StatelessWidget {
  const AppInitLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: AppLoader()),
      theme: appTheme,
    );
  }
}
