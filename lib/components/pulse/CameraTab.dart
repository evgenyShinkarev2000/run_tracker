import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/bloc/cubits/PulseCameraCubit.dart';

class CameraTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            height: 400,
            child: BlocBuilder<PulseCameraCubit, PulseCameraCubitState>(
              builder: (context, state) => LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      dotData: FlDotData(show: false),
                      spots: state.lumies
                          .map((lumy) => FlSpot(lumy.timeStamp.microsecondsSinceEpoch.toDouble(), lumy.averageLumy))
                          .toList(),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
