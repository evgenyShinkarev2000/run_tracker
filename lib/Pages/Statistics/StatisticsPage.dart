import 'package:flutter/material.dart';
import 'package:run_tracker/Pages/Statistics/StatisticsInner.dart';
import 'package:run_tracker/Routing/AppMainDrawer.dart';
import 'package:run_tracker/Theme/export.dart';
import 'package:run_tracker/localization/export.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.themeData.colorScheme.inversePrimary,
        title: Text(context.appLocalization.menuStatistic),
      ),
      drawer: AppMainDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: StatisticsInner(),
      ),
    );
  }
}
