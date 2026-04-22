import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/Pages/Pulse/PulseCard.dart';
import 'package:run_tracker/Services/Pulse/export.dart';
import 'package:run_tracker/localization/export.dart';

class PulseDialog extends StatefulWidget {
  final void Function(PulseMeasurement model) onSave;

  const PulseDialog({super.key, required this.onSave});

  @override
  State<PulseDialog> createState() => _PulseDialogState();
}

class _PulseDialogState extends State<PulseDialog> {
  PulseMeasureKind _measureKind = .metronome;
  double? _pulseBPM;
  DateTime? _measuredAt;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 500,
        width: 1000,
        child: PulseCard(
          onPulseChanged: _handlePulseChanged,
          onPulseMeasureKindChanged: _handlePulseMeasureKindChanged,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(context.appLocalization.verbCancel),
        ),
        TextButton(
          onPressed: _pulseBPM == null ? null : _handleSaveTap,
          child: Text(context.appLocalization.verbSave),
        ),
      ],
    );
  }

  void _handleSaveTap() {
    if (_pulseBPM == null || _measuredAt == null) {
      return;
    }

    widget.onSave(
      PulseMeasurement(
        pulseMeasureKind: _measureKind,
        pulseBPM: _pulseBPM!,
        measuredAt: _measuredAt!,
      ),
    );
    context.pop();
  }

  void _handlePulseChanged(double? pulse) {
    setState(() {
      _pulseBPM = pulse;
      _measuredAt = DateTime.timestamp();
    });
  }

  void _handlePulseMeasureKindChanged(PulseMeasureKind measureKind) {
    _measureKind = measureKind;
  }
}
