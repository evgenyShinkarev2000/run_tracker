import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/Router.dart';
import 'package:run_tracker/components/drawer/AppMainDrawer.dart';
import 'package:run_tracker/data/mappers/RunPointGeolocationDataToCore.dart';
import 'package:run_tracker/helpers/SpeedHelper.dart';
import 'package:run_tracker/pages/HistoryPage/RunCoverCard.dart';
import 'package:run_tracker/services/RunRecordService.dart';

class HistoryPage extends StatelessWidget {
  static final RunPointGeolocationDataToCore _runPointGeolocationDataToCore = RunPointGeolocationDataToCore();

  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final runRecordService = context.read<RunRecordService>();
    return Scaffold(
      appBar: AppBar(),
      drawer: AppMainDrawer(),
      body: FutureBuilder(
        future: Future.wait(runRecordService.getIterator()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text("loading"));
          } else if (snapshot.hasError) {
            return Center(child: Text("error"));
          }
          final runRecordModels = snapshot.requireData;
          if (runRecordModels.isEmpty) {
            return Center(child: Text("no data"));
          }

          return ListView.builder(
            itemCount: runRecordModels.length,
            itemBuilder: (context, index) {
              final runRecordModel = runRecordModels[index];
              final geoPoints = [
                runRecordModel.runPointsData.start.geolocation,
                ...runRecordModel.runPointsData.geolocations,
                runRecordModel.runPointsData.stop.geolocation
              ].nonNulls.map((rpgd) => _runPointGeolocationDataToCore.map(rpgd).geolocation);
              final runCover = runRecordModel.runCoverData;

              return Builder(builder: (context) {
                return RunCoverCard(
                    onTap: () => _handleCardTap(context, runCover.key!),
                    geolocations: geoPoints,
                    name: runCover.title,
                    beginDateTime: runCover.startDateTime,
                    duration: Duration(microseconds: runCover.duration),
                    distance: runCover.distance,
                    pace: SpeedHelper.speedToPace(runCover.averageSpeed) ?? Duration(),
                    pulse: runCover.averagePulse?.round() ?? 0);
              });
            },
          );
        },
      ),
    );
  }

  void _handleCardTap(BuildContext context, int runCoverKey) {
    context.go("${Routes.runRecordPage}/$runCoverKey");
  }
}
