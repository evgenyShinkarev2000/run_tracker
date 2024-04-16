import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/bloc/cubits/PulseCameraCubit.dart';
import 'package:run_tracker/components/pulse/PulsePlot.dart';
import 'package:run_tracker/helpers/extensions/IterableExtension.dart';

class CameraTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<PulseCameraCubit, PulseCameraCubitState>(
          builder: (context, state) => Text("pulse: ${state.pulse ?? 0} bpm"),
        ),
        BlocBuilder<PulseCameraCubit, PulseCameraCubitState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("frame rate: ${state.frameRate.toString()}"),
              ],
            );
          },
        ),
        BlocBuilder<PulseCameraCubit, PulseCameraCubitState>(
          buildWhen: (previous, current) => previous.cameraPreview != current.cameraPreview,
          builder: (context, state) => state.cameraPreview == null
              ? Text("launching camera")
              : Container(
                  width: 200,
                  height: 200,
                  child: Center(child: state.cameraPreview),
                ),
        ),
        Container(
          width: 400,
          height: 200,
          child: BlocBuilder<PulseCameraCubit, PulseCameraCubitState>(
            builder: (context, state) => PulsePlot(
              points: state.lumies
                  .map((lumy) => FlSpot(lumy.dateTime.microsecondsSinceEpoch.toDouble(), lumy.data))
                  .toList(),
            ),
          ),
        ),
        Container(
          width: 400,
          height: 200,
          child: BlocBuilder<PulseCameraCubit, PulseCameraCubitState>(
            builder: (context, state) => LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    dotData: FlDotData(show: false),
                    spots: state.lumiesDerivative
                        .map((point) => FlSpot(point.dateTime.microsecondsSinceEpoch.toDouble(), point.data))
                        .toList(),
                  ),
                  state.lumiesDerivative.isNotEmpty
                      ? LineChartBarData(
                          dotData: FlDotData(show: false),
                          spots: [
                            FlSpot(
                                state.lumiesDerivative
                                    .min((p) => p.dateTime)!
                                    .dateTime
                                    .microsecondsSinceEpoch
                                    .toDouble(),
                                0),
                            FlSpot(
                                state.lumiesDerivative
                                    .max((p) => p.dateTime)!
                                    .dateTime
                                    .microsecondsSinceEpoch
                                    .toDouble(),
                                0)
                          ],
                          color: Colors.red,
                        )
                      : null,
                ].nonNulls.toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
