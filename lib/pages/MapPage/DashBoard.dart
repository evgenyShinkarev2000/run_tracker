import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/themes/Theme.dart';
import 'package:run_tracker/bloc/cubits/DashBoardDurationCubit.dart';
import 'package:run_tracker/bloc/cubits/DashBoardGeolocationCubit.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/helpers/extensions/DurationExtension.dart';
import 'package:run_tracker/pages/MapPage/Dash.dart';

class DashBoardContainer extends StatelessWidget {
  const DashBoardContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashBoardGeolocationCubit, DashBoardGeolocationState>(
      builder: (context, state) => BlocBuilder<DashBoardDurationCubit, DashBoardDurationState>(
        builder: (context, durationState) {
          return DashBoard(
            speed: state.speed ?? 0,
            runningTime: durationState.runningTime,
            pace: state.pace != null && state.speed != null && state.speed! > 0.28 ? state.pace! : Duration(),
            distance: state.distance?.toInt() ?? 0,
          );
        },
      ),
    );
  }
}

class DashBoard extends StatelessWidget {
  final double speed;
  final Duration pace;
  final Duration runningTime;
  final int distance;

  const DashBoard(
      {super.key, required this.speed, required this.runningTime, required this.pace, required this.distance});

  @override
  Widget build(BuildContext context) {
    final localization = context.appLocalization;
    final speedLabel = localization.dashSpeed;
    final paceLabel = localization.dashPace;
    final runningTimeLabel = localization.dashTime;
    final distanceLabel = localization.dashDistance;
    final dashBoardTheme = context.themeDate.dashBoardTheme;

    return Container(
      decoration: BoxDecoration(
        color: dashBoardTheme.backgroundColor,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Dash(label: speedLabel, value: toSpeedView(speed)),
            ),
            VerticalDivider(color: dashBoardTheme.innerBorderColor),
            Expanded(
              child: Dash(label: paceLabel, value: toPaceView(pace)),
            ),
            VerticalDivider(color: dashBoardTheme.innerBorderColor),
            Expanded(
              child: Dash(
                label: runningTimeLabel,
                value: toRunningTimeView(runningTime),
              ),
            ),
            VerticalDivider(color: dashBoardTheme.innerBorderColor),
            Expanded(
              child: Dash(label: distanceLabel, value: distance.toString()),
            ),
          ],
        ),
      ),
    );
  }

  String toSpeedView(double speed) {
    final speedKmH = speed * 60 * 60 / 1000;

    return speedKmH.toStringAsFixed(1);
  }

  String toPaceView(Duration pace) {
    return "${pace.minutes}:${pace.seconds.toString().padLeft(2, "0")}";
  }

  String toRunningTimeView(Duration runningTime) =>
      "${runningTime.hours}:${runningTime.minutes.toString().padLeft(2, "0")}:${runningTime.seconds.toString().padLeft(2, "0")}";
}
