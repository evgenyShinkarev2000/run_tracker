import 'package:flutter/material.dart';
import 'package:run_tracker/Theme/export.dart';
import 'package:run_tracker/localization/export.dart';

class PulseLabel extends StatelessWidget {
  final double? pulseBPM;
  const PulseLabel({super.key, this.pulseBPM});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${context.appLocalization.nounPulse}, ${context.appLocalization.unitShortBPM}:",
          style: context.themeData.textTheme.titleMedium,
        ),
        Text(
          pulseBPM?.round().toString() ?? "",
          style: context.themeData.textTheme.headlineSmall,
        ),
      ],
    );
  }
}
