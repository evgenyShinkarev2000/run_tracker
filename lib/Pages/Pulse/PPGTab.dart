import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Core/Flutter/ManualValueNotifier.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Pages/Pulse/InstructionText.dart';
import 'package:run_tracker/Pages/Pulse/PulseChart.dart';
import 'package:run_tracker/Pages/Pulse/PulseLabel.dart';
import 'package:run_tracker/Providers/Pulse/PulsePPGServiceProvider.dart';
import 'package:run_tracker/Services/Pulse/export.dart';
import 'package:run_tracker/localization/export.dart';

class PPGTab extends ConsumerStatefulWidget {
  final void Function(double? pulseBPM)? onPulseChanged;

  const PPGTab({super.key, this.onPulseChanged});

  @override
  ConsumerState<PPGTab> createState() => _PPGTabState();
}

class _PPGTabState extends ConsumerState<PPGTab> {
  static const double _chartShowIntervalSeconds = 5;
  late final PPGCameraService _ppgService;
  late final StreamSubscription<BrightnessWithDuration> _spotSubscription;
  late final StreamSubscription<double> _pulseSubscription;

  double _minX = -_chartShowIntervalSeconds;
  double _maxX = 0;
  double _minY = -1;
  double _maxY = 1;
  final ManualValueNotifier<List<FlSpot>> _spots = ManualValueNotifier(
    _buildDefaultSpots(),
  );
  final ValueNotifier<double?> _pulse = ValueNotifier(null);

  @override
  void initState() {
    super.initState();

    _ppgService = ref.read(pulsePPGServiceFactoryProvider).build();
    _spotSubscription = _ppgService.spotStream.listen(_handleSpot);
    _pulseSubscription = _ppgService.pulseStream.listen(_handlePulse);
    _ppgService.start();
  }

  @override
  void dispose() {
    _spotSubscription.cancel();
    _pulseSubscription.cancel();
    _ppgService.dispose();
    _spots.dispose();
    _pulse.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 8,
        children: [
          InstructionText(
            text: context.appLocalization.pulseMeasureCameraInstructionInitial,
          ),
          Flexible(
            child: AspectRatio(
              aspectRatio: 2.5,
              child: ValueListenableBuilder(
                valueListenable: _spots,
                builder: (context, value, child) {
                  return PulseChart(
                    spots: value,
                    minX: _minX,
                    maxX: _maxX,
                    minY: _minY,
                    maxY: _maxY,
                  );
                },
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _pulse,
            builder: (context, value, child) => PulseLabel(pulseBPM: value),
          ),
          Center(
            child: IconButton(
              iconSize: 40,
              onPressed: _handleResetPressed,
              icon: Icon(Icons.restart_alt),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSpot(BrightnessWithDuration measure) {
    _spots.value.add(FlSpot(measure.seconds, measure.brightness));
    _maxX = measure.seconds;
    _minX = _maxX - _chartShowIntervalSeconds;
    final minMaxY = _spots.value.reversed
        .takeWhile((s) => s.x > _minX)
        .selectMinMaxNum((s) => s.y);
    if (minMaxY == null) {
      return;
    }
    _maxY = max(minMaxY.$1.abs(), minMaxY.$2.abs());
    _minY = -_maxY;
    _spots.notifyListeners();
  }

  void _handlePulse(double pulsePerMinute) {
    _pulse.value = pulsePerMinute;
    widget.onPulseChanged?.call(pulsePerMinute);
  }

  void _handleResetPressed() {
    _minX = -_chartShowIntervalSeconds;
    _maxX = 0;
    _minY = -1;
    _maxY = 1;
    _spots.value.clear();
    _spots.notifyListeners();
    _pulse.value = null;
    widget.onPulseChanged?.call(null);
    _ppgService.restart();
  }

  static List<FlSpot> _buildDefaultSpots() {
    return [FlSpot(-_chartShowIntervalSeconds, 0), FlSpot(0, 0)];
  }
}
