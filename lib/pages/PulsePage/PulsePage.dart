import 'package:flutter/material.dart';
import 'package:run_tracker/components/drawer/AppMainDrawer.dart';
import 'package:run_tracker/components/pulse/PulseDialog.dart';

class PulsePage extends StatefulWidget {
  @override
  State<PulsePage> createState() => _PulsePageState();
}

class _PulsePageState extends State<PulsePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(),
      drawer: AppMainDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: PulseDialog(),
      ),
    );
  }
}
