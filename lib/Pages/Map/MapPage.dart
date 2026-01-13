import 'package:flutter/material.dart';
import 'package:run_tracker/Routing/export.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(Object context) {
    return Scaffold(
      drawer: AppMainDrawer(),
      body: Center(child: Text("It's map page")),
    );
  }
}
