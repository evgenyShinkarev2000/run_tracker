import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/bloc/cubits/PulseCameraCubit.dart';
import 'package:run_tracker/components/pulse/PulseLabel.dart';
import 'package:run_tracker/components/pulse/PulsePlot.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/helpers/extensions/StringExtension.dart';

class CameraTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.appLocalization.pulseMeasureCameraInstructionInitial.capitalize(),
          style: context.themeDate.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          width: 400,
          height: 150,
          child: BlocBuilder<PulseCameraCubit, PulseCameraCubitState>(builder: (context, state) {
            return PulsePlot(
              points: state.lumies,
            );
          }),
        ),
        SizedBox(height: 8),
        BlocBuilder<PulseCameraCubit, PulseCameraCubitState>(
          builder: (context, state) => PulseLabel(pulse: state.pulse?.round() ?? 0),
        ),
      ],
    );
  }
}
