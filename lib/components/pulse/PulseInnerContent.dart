import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/bloc/cubits/PulseCameraCubit.dart';
import 'package:run_tracker/bloc/cubits/PulseMetronomeCubit.dart';
import 'package:run_tracker/components/pulse/CameraTab.dart';
import 'package:run_tracker/components/pulse/MetronomTab.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';

class PulseInnerContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PulseInnerContentState();
}

class _PulseInnerContentState extends State<PulseInnerContent> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          DefaultTabController(
            length: 4,
            child: TabBar(
              unselectedLabelStyle: context.themeDate.textTheme.titleMedium,
              labelStyle:
                  context.themeDate.textTheme.titleMedium!.copyWith(color: context.themeDate.colorScheme.primary),
              padding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              onTap: (index) => setState(() {
                selectedTabIndex = index;
              }),
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
                  child: Builder(builder: (context) {
                    final pulseMetronomeCubit = context.read<PulseMetronomeCubit>();

                    return BlocBuilder<PulseMetronomeCubit, PulseMetronomeCubitState>(
                      builder: (context, state) => MetronomTab(
                        onClick: pulseMetronomeCubit.metronomeTap,
                        pulse: state.pulseBPM,
                      ),
                    );
                  }),
                );
              case 1:
                return BlocProvider<PulseCameraCubit>(
                  create: (context) => PulseCameraCubit(),
                  child: CameraTab(),
                );
              case 2:
                return Text("tim");
              default:
                return Text("metr");
            }
          }),
        ],
      ),
    );
  }
}
