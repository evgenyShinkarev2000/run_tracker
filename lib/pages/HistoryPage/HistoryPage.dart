import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/Router.dart';
import 'package:run_tracker/components/AppMainLoader.dart';
import 'package:run_tracker/components/drawer/AppMainDrawer.dart';
import 'package:run_tracker/data/mappers/mappers.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/helpers/units_helper/units_helper.dart';
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
            return AppMainLoader();
          } else if (snapshot.hasError) {
            return Center(
              child: Text(context.appLocalization.nounError),
            );
          }
          final runRecordModels = snapshot.requireData;
          if (runRecordModels.isEmpty) {
            return Center(child: Text(context.appLocalization.historyPageNoRecords));
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
                    pace: runCover.averageSpeed != null && !runCover.averageSpeed!.isNaN
                        ? Speed.fromMetersPerSecond(runCover.averageSpeed!).toPace().toDurationKm()
                        : null,
                    pulse: runCover.averagePulse?.round());
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
