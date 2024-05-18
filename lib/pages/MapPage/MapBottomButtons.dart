import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/Router.dart';
import 'package:run_tracker/bloc/cubits/RunRecorderCubit.dart';
import 'package:run_tracker/components/pulse/PulseDialog.dart';
import 'package:run_tracker/core/PulseRecorder.dart';
import 'package:run_tracker/core/RunRecord.dart';
import 'package:run_tracker/core/RunRecorder.dart';
import 'package:run_tracker/helpers/extensions/DateTimeExtension.dart';
import 'package:run_tracker/pages/MapPage/MapIconButton.dart';
import 'package:run_tracker/pages/MapPage/SaveRecordDialog.dart';
import 'package:run_tracker/pages/MapPage/StopRecordingDialog.dart';
import 'package:run_tracker/services/RunRecordService.dart';

class MapBottomButtons extends StatefulWidget {
  const MapBottomButtons({super.key});

  @override
  State<StatefulWidget> createState() => _MapBottomButtonsState(goingMode: GoingMode.ready, isLocked: false);
}

class _MapBottomButtonsState extends State<MapBottomButtons> {
  GoingMode goingMode;
  bool isLocked;

  _MapBottomButtonsState({
    required this.goingMode,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildIcons(context),
          ),
        ],
      ),
    );
  }

  List<Widget> buildIcons(BuildContext context) {
    final isPlayShow = (goingMode == GoingMode.ready || goingMode == GoingMode.pause) && !isLocked;
    // final isPauseShow = goingMode == GoingMode.play && !isLocked;
    final isPauseShow = false;
    final isLockedShow = goingMode != GoingMode.ready && isLocked;
    final isUnlockedShow = goingMode != GoingMode.ready && !isLocked;
    final isStopShow = goingMode != GoingMode.ready && !isLocked;
    final isAddPlacemarkShow = goingMode != GoingMode.ready && !isLocked;
    final isAddHeartRateShow = goingMode != GoingMode.ready && !isLocked;

    return [
      isStopShow
          ? MapIconButton(
              onPressed: () => stopTap(context),
              icon: Icon(CupertinoIcons.stop),
            )
          : null,
      isPlayShow ? MapIconButton(onPressed: () => playTap(context), icon: Icon(CupertinoIcons.play)) : null,
      isPauseShow
          // ignore: dead_code
          ? MapIconButton(
              onPressed: () => pauseTap(context),
              icon: Icon(CupertinoIcons.pause),
            )
          : null,
      isLockedShow
          ? MapIconButton(
              onPressed: lockTap,
              icon: Icon(CupertinoIcons.lock),
            )
          : null,
      isUnlockedShow
          ? MapIconButton(
              onPressed: unlockTap,
              icon: Icon(CupertinoIcons.lock_open),
            )
          : null,
      isAddPlacemarkShow
          ? MapIconButton(
              onPressed: () {},
              icon: Icon(CupertinoIcons.placemark),
            )
          : null,
      isAddHeartRateShow
          ? MapIconButton(
              onPressed: () => addHeartRateTap(context),
              icon: Icon(CupertinoIcons.heart),
            )
          : null,
    ].nonNulls.toList();
  }

  void playTap(BuildContext context) {
    final runRecorderCubit = context.read<RunRecorderCubit>();

    switch (goingMode) {
      case GoingMode.ready:
        runRecorderCubit.startTap();
        setState(() {
          goingMode = GoingMode.play;
          isLocked = true;
        });
        break;
      case GoingMode.pause:
        runRecorderCubit.resumeTap();
        setState(() {
          goingMode = GoingMode.play;
        });
      default:
        break;
    }
  }

  void lockTap() => setState(() {
        isLocked = false;
      });

  void unlockTap() => setState(() {
        isLocked = true;
      });

  void pauseTap(BuildContext context) {
    final runRecorderCubit = context.read<RunRecorderCubit>();
    runRecorderCubit.pauseTap();

    setState(() {
      goingMode = GoingMode.pause;
    });
  }

  void stopTap(BuildContext context) {
    showStopRecordingDialog(context);
  }

  void showStopRecordingDialog(BuildContext context) {
    cancelStopRecordingTap() {
      context.pop();
    }

    confirmStopRecordingTap() {
      final runRecorder = context.read<RunRecorderCubit>();
      runRecorder.stopTap();
      context.pop();
      showSaveRecordDialog(context);
    }

    showDialog(
        context: context,
        builder: (context) => StopRecordingDialog(
              onCancel: cancelStopRecordingTap,
              onConfirm: confirmStopRecordingTap,
            ));
  }

  void showSaveRecordDialog(BuildContext context) {
    final runRecorderCubit = context.read<RunRecorderCubit>();
    final pulseRecorder = context.read<PulseRecorder>();
    final runRecordService = context.read<RunRecordService>();

    saveRecordTap(String title) {
      runRecordService
          .saveRecord(RunRecord(
            title: title,
            runPoints: runRecorderCubit.GetRunPoints(),
            pulseMeasurements: pulseRecorder.pulseMeasurement.toList(),
          ))
          .then((value) => context.go(Routes.historyPage));
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => SaveRecordDialog(
        onSave: saveRecordTap,
        titleInitial: runRecorderCubit.GetStartDateTime().toLocal().appFormatedDateTime,
      ),
    );
  }

  void addHeartRateTap(BuildContext context) {
    final pulseRecorder = context.read<PulseRecorder>();

    showDialog(
      context: context,
      builder: (context) => PulseDialog(
        onSave: pulseRecorder.addMeasurement,
      ),
    );
  }

  static GoingMode _runPhaseToGoingMode(RunRecorderPhase phase) {
    switch (phase) {
      case RunRecorderPhase.ready:
        return GoingMode.ready;
      case RunRecorderPhase.paused:
        return GoingMode.pause;
      case RunRecorderPhase.writing:
        return GoingMode.play;
      case RunRecorderPhase.stopped:
        return GoingMode.ready;
    }
  }
}

enum GoingMode {
  ready,
  play,
  pause,
}
