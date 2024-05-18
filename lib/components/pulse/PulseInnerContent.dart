import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/bloc/cubits/PulseCameraCubit.dart';
import 'package:run_tracker/bloc/cubits/PulseMetronomeCubit.dart';
import 'package:run_tracker/components/pulse/CameraTab.dart';
import 'package:run_tracker/components/pulse/MetronomTab.dart';
import 'package:run_tracker/core/PulseMeasurement.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/helpers/extensions/SettingExtension.dart';
import 'package:run_tracker/services/settings/settings.dart';

class PulseInnerContent extends StatefulWidget {
  final void Function(PulseMeasurementBase?)? onPulseUpdated;

  PulseInnerContent({this.onPulseUpdated});

  @override
  State<StatefulWidget> createState() => _PulseInnerContentState();
}

class _PulseInnerContentState extends State<PulseInnerContent> {
  int selectedTabIndex = 0;
  StreamSubscription? pulseSubscription;

  @override
  void dispose() {
    pulseSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultTabController(
          length: 4,
          child: TabBar(
            unselectedLabelStyle: context.themeData.textTheme.titleMedium,
            labelStyle: context.themeData.textTheme.titleMedium!.copyWith(color: context.themeData.colorScheme.primary),
            padding: EdgeInsets.zero,
            indicatorPadding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            onTap: (index) {
              resetSubscriptionAndPulse();

              setState(() {
                selectedTabIndex = index;
              });
            },
            tabs: [
              Tab(text: context.appLocalization.pulseMeasureTabMetronome),
              Tab(text: context.appLocalization.pulseMeasureTabCamera),
              Tab(text: context.appLocalization.pulseMeasureTabTimer),
              Tab(text: context.appLocalization.pulseMeasureTabManual),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Builder(builder: (context) {
          switch (selectedTabIndex) {
            case 0:
              return BlocProvider<PulseMetronomeCubit>(
                create: (context) => PulseMetronomeCubit(),
                child: BlocBuilder<PulseMetronomeCubit, PulseMetronomeCubitState>(builder: (context, state) {
                  final pulseMetronomeCubit = context.read<PulseMetronomeCubit>();
                  pulseSubscription = pulseMetronomeCubit.stream.listen((state) {
                    if (state.pulseBPM != null) {
                      widget.onPulseUpdated
                          ?.call(PulseMeasurementByMetronome(dateTime: DateTime.now(), pulse: state.pulseBPM!));
                    }
                  });

                  return MetronomTab(
                    onClick: pulseMetronomeCubit.metronomeTap,
                    pulse: state.pulseBPM?.round() ?? 0,
                  );
                }),
              );
            case 1:
              final appSetting = context.read<SettingsProvider>().appSettings;

              return BlocProvider<PulseCameraCubit>(
                create: (context) {
                  final pulseCameraCubit =
                      PulseCameraCubit(cameraUnstableTime: appSetting.pulseByCamera.cameraUnstableTime.valueOrDefault);
                  pulseCameraCubit.stream.listen((state) {
                    if (state.pulse != null) {
                      widget.onPulseUpdated
                          ?.call(PulseMeasurementByCamera(dateTime: DateTime.now(), pulse: state.pulse!));
                    }
                  });

                  return pulseCameraCubit;
                },
                child: CameraTab(),
              );
            default:
              return Text("developing...");
          }
        }),
      ],
    );
  }

  void resetSubscriptionAndPulse() {
    pulseSubscription?.cancel();
    widget.onPulseUpdated?.call(null);
  }
}
