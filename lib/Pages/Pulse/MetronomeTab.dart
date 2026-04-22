import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Pages/Pulse/InstructionText.dart';
import 'package:run_tracker/Pages/Pulse/PulseLabel.dart';
import 'package:run_tracker/Providers/Pulse/export.dart';
import 'package:run_tracker/Services/Pulse/export.dart';
import 'package:run_tracker/Theme/export.dart';
import 'package:run_tracker/localization/export.dart';

class MetronomeTab extends ConsumerStatefulWidget {
  final void Function(double? pulseBPM)? onPulseChanged;

  const MetronomeTab({super.key, this.onPulseChanged});

  @override
  ConsumerState<MetronomeTab> createState() => _MetronomeTabState();
}

class _MetronomeTabState extends ConsumerState<MetronomeTab> {
  late final StreamSubscription<double> _pulseSubscription;
  late final PulseMetronome _metronome;

  DateTime? prevTap;

  @override
  void initState() {
    super.initState();

    _metronome = ref.read(pulseMetronomeFactoryProvider).build();
    _pulseSubscription = _metronome.pulseBPMStream.listen(_listenPulse);
  }

  @override
  void dispose() {
    _pulseSubscription.cancel();
    _metronome.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        spacing: 8,
        children: [
          InstructionText(
            text: context
                .appLocalization
                .pulseMeasureMetronomInstructionClickAtDrum,
          ),
          StreamBuilder(
            stream: _metronome.pulseBPMStream,
            builder: (context, snapshot) => PulseLabel(pulseBPM: snapshot.data),
          ),
          Expanded(
            child: GestureDetector(
              behavior: .translucent,
              onTapDown: _handleTap,
              child: Container(
                alignment: .center,
                child: Icon(
                  size: 32,
                  Icons.touch_app,
                  color: context.themeData.colorScheme.secondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleTap(TapDownDetails details) {
    final timestamp = DateTime.timestamp();
    if (prevTap == null ||
        timestamp.difference(prevTap!) > Duration(milliseconds: 100)) {
      prevTap = timestamp;
      _metronome.tap(timestamp);
    }
  }

  void _listenPulse(double pulseBpm) {
    widget.onPulseChanged?.call(pulseBpm);
  }
}
