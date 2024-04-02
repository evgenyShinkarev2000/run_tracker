import 'package:flutter/material.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/helpers/extensions/DateTimeExtension.dart';
import 'package:run_tracker/services/RunRecordService.dart';
import 'package:run_tracker/services/models/RunRecordModel.dart';

class RunRecordPointsTab extends StatelessWidget {
  final RunRecordModel runRecordModel;

  RunRecordPointsTab({required this.runRecordModel});

  @override
  Widget build(BuildContext context) {
    final points = RunRecordService.GetGeolocationsFromModel(runRecordModel);
    final style = context.themeDate.textTheme.bodyLarge;

    return ListView(children: [
      ...points.map((p) => ListTile(
            leading: Text(
              toFormatedDateTime(p.dateTime),
              style: style,
            ),
            title: Text(
              "${p.geolocation.longitude}, ${p.geolocation.latitude}",
              style: style,
            ),
          )),
    ]);
  }

  String toFormatedDateTime(DateTime dateTime) => dateTime.hhmmss;
}
