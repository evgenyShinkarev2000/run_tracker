import 'package:flutter/material.dart';
import 'package:run_tracker/Components/export.dart';
import 'package:run_tracker/Pages/Map/MapScope.dart';
import 'package:run_tracker/Routing/export.dart';
import 'package:run_tracker/Theme/export.dart';
import 'package:run_tracker/localization/export.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.themeData.colorScheme.inversePrimary,
        title: Text(context.appLocalization.menuMap),
      ),
      drawer: AppMainDrawer(),
      body: Center(child: MapScope(mapWidget: FullMap())),
    );
  }
}
