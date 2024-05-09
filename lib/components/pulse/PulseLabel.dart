import 'package:flutter/material.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';

class PulseLabel extends StatelessWidget {
  const PulseLabel({
    super.key,
    required this.pulse,
  });

  final int pulse;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${context.appLocalization.nounPulse}, ${context.appLocalization.unitShortBPM}:",
          style: context.themeDate.textTheme.titleMedium,
        ),
        SizedBox(width: 8),
        Text(
          pulse.toString(),
          style: context.themeDate.textTheme.headlineSmall,
        ),
      ],
    );
  }
}
