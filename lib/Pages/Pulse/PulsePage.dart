import 'package:flutter/material.dart';
import 'package:run_tracker/Pages/Pulse/PulseCard.dart';
import 'package:run_tracker/Pages/TrackHistory/AppBarMenu.dart';
import 'package:run_tracker/Routing/export.dart';
import 'package:run_tracker/Theme/export.dart';
import 'package:run_tracker/localization/export.dart';

class PulsePage extends StatelessWidget{
  const PulsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.themeData.colorScheme.inversePrimary,
        title: Text(context.appLocalization.menuHistory),
        actions: [
          AppBarMenu(),
        ],
      ),
      drawer: AppMainDrawer(),
      body: Center(child: PulseCard(showManual: true,)),
    );
  }
}