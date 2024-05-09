import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/components/pulse/PulseInnerContent.dart';
import 'package:run_tracker/core/PulseMeasurement.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';

class PulseDialog extends StatefulWidget {
  final Function(PulseMeasurementBase) onSave;

  PulseDialog({required this.onSave});

  @override
  State<PulseDialog> createState() => _PulseDialogState();
}

class _PulseDialogState extends State<PulseDialog> {
  late final PulseInnerContent pulseInnerContent;
  PulseMeasurementBase? pulseMeasurement;

  @override
  void initState() {
    pulseInnerContent = PulseInnerContent(
      onPulseUpdated: (pulseMeasurement) {
        setState(() {
          this.pulseMeasurement = pulseMeasurement;
        });
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(8),
      titlePadding: EdgeInsets.all(8),
      iconPadding: EdgeInsets.all(8),
      actionsPadding: EdgeInsets.all(8),
      contentPadding: EdgeInsets.all(8),
      content: pulseInnerContent,
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(context.appLocalization.verbCancel),
        ),
        TextButton(
            onPressed: pulseMeasurement != null
                ? () {
                    widget.onSave(pulseMeasurement!);
                    context.pop();
                  }
                : null,
            child: Text(context.appLocalization.verbSave)),
      ],
    );
  }
}
