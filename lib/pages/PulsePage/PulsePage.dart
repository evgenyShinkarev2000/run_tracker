import 'package:flutter/material.dart';
import 'package:run_tracker/components/drawer/AppMainDrawer.dart';
import 'package:run_tracker/components/pulse/PulseDialog.dart';
import 'package:run_tracker/components/pulse/PulseInnerContent.dart';

class PulsePage extends StatefulWidget {
  @override
  State<PulsePage> createState() => _PulsePageState();
}

class _PulsePageState extends State<PulsePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: AppMainDrawer(),
      body: PulseInnerContent(),
      // body: Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 8),
      //   child: PulseDialog(),
      // ),
    );
  }
}
