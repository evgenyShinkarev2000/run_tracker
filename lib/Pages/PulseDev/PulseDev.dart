import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/Pages/PulseDev/CompressorTestDashboards.dart';
import 'package:run_tracker/Pages/PulseDev/PulseDashboards.dart';
import 'package:run_tracker/Pages/PulseDev/PulseRecord.dart';

class PulseDev extends StatelessWidget {
  const PulseDev({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragDown: (details) => {},
      child: Scaffold(
        appBar: AppBar(
          title: Text("pulse dev"),
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: DefaultTabController(
          length: 3,
          initialIndex: 1,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: "recording"),
                  Tab(text: "dashboard"),
                  Tab(text: "compressor"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    PulseRecord(),
                    PulseDashboard(),
                    CompressorTestDashboards(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
