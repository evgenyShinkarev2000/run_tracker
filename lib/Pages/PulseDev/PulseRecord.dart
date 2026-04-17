import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Pages/PulseDev/DashboardChart.dart';
import 'package:run_tracker/Pages/PulseDev/TransformMethods.dart';
import 'package:run_tracker/Providers/Camera/export.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/Camera/export.dart';
import 'package:run_tracker/Services/Pulse/BrightnessWithDuration.dart';
import 'package:run_tracker/Services/Pulse/PPGSerializer.dart';

class PulseRecord extends ConsumerStatefulWidget {
  const PulseRecord({super.key});

  @override
  ConsumerState<PulseRecord> createState() => _PulseRecordState();
}

class _PulseRecordState extends ConsumerState<PulseRecord> {
  final CameraFrameBrightness frameBrightness = CameraFrameBrightness();
  List<BrightnessWithDuration> brightData = [];
  List<FlSpot> brightSpots = [];
  List<FlSpot> processedSpots = [];
  double intervalSeconds = 10;
  double minX = 0;
  late double maxX = intervalSeconds;
  bool isPaused = true;
  DateTime? firstDataFrameTimestamp;
  bool isExporting = false;
  late final CameraFrameWithFlashProvider cameraService;
  late final StreamSubscription<CameraImage> cameraSubsription;
  DateTime? prevFrameTimestamp;
  final IntervalAverageGeneric<(double, double)> fpsAverage =
      IntervalAverageGeneric(
        getX: (t) => t.$1,
        getY: (t) => t.$2,
        intervalSize: 3,
      );
  TransformBuilder _transform = _buildTransform();
  final ValueNotifier<double> fps = ValueNotifier(0);
  bool showRawChart = false;
  bool processFrame = false;
  bool showProcessedChart = false;
  bool showPreview = false;

  @override
  void initState() {
    super.initState();
    cameraService = ref.read(cameraFrameServiceProvider);
    cameraSubsription = cameraService.stream.listen(_handleFrameReceive);
  }

  @override
  void dispose() {
    cameraSubsription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisSize: .min,
        children: [
          Flexible(
            child: Row(
              children: [
                TextButton(onPressed: _reset, child: Text("reset")),
                isPaused
                    ? TextButton(onPressed: _resume, child: Text("resume"))
                    : TextButton(onPressed: _pause, child: Text("pause")),
                TextButton(
                  onPressed: isExporting ? null : _exportWithLock,
                  child: Text("export"),
                ),
              ],
            ),
          ),
          Flexible(
            child: Slider(
              min: 5,
              max: 15,
              value: intervalSeconds,
              onChanged: _handleIntervalChange,
            ),
          ),
          Flexible(
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                direction: .horizontal,
                children: [
                  SizedBox(
                    width: 200,
                    child: CheckboxListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      value: showPreview,
                      onChanged: _handleShowPreviewChanged,
                      title: Text("show preview"),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: CheckboxListTile(
                      dense: true,
                      value: showRawChart,
                      onChanged: _handleShowChartChanged,
                      title: Text("show chart"),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: CheckboxListTile(
                      dense: true,
                      value: showProcessedChart,
                      onChanged: _handleShowProcessedChartChanged,
                      title: Text("show processed chart"),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: CheckboxListTile(
                      dense: true,
                      value: processFrame,
                      onChanged: _handleProcessFrameChanged,
                      title: Text("process frame"),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: fps,
                    builder: (context, value, _) =>
                        Text("fps: ${value.toStringAsFixed(1)}"),
                  ),
                ],
              ),
            ),
          ),
          showRawChart
              ? Flexible(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: DashboardChart(
                      spots: brightSpots,
                      minX: minX,
                      maxX: maxX,
                    ),
                  ),
                )
              : null,
          showProcessedChart
              ? Flexible(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: DashboardChart(
                      spots: processedSpots,
                      minX: minX,
                      maxX: maxX,
                    ),
                  ),
                )
              : null,
          showPreview
              ? Flexible(
                  child: ValueListenableBuilder(
                    valueListenable: cameraService.cameraController,
                    builder: (context, value, _) => value == null
                        ? Center(child: Text("waiting camera..."))
                        : CameraPreview(value),
                  ),
                )
              : null,
        ].nonNulls.toList(),
      ),
    );
  }

  void _handleFrameReceive(CameraImage image) {
    final timestamp = DateTime.timestamp();
    if (prevFrameTimestamp != null) {
      final frameFps =
          1 / timestamp.difference(prevFrameTimestamp!).inSecondsDouble;
      fpsAverage.add((timestamp.millisecondsSinceEpoch / 1000, frameFps));
      fps.value = fpsAverage.average;
    }
    prevFrameTimestamp = timestamp;

    if (isPaused) {
      return;
    }

    firstDataFrameTimestamp ??= timestamp;
    final brightness = frameBrightness.findBrightness(image);
    final duration = timestamp.difference(firstDataFrameTimestamp!);
    brightData.add(
      BrightnessWithDuration(brightness: brightness, duration: duration),
    );
    final brightSpot = FlSpot(duration.inSecondsDouble, brightness);
    brightSpots.add(brightSpot);
    if (processFrame) {
      processedSpots.addAll(_transform.add(brightSpot));
    }

    setState(() {
      _updateChartWindow();
    });
  }

  void _handleIntervalChange(double? interval) {
    if (interval == null) {
      return;
    }

    setState(() {
      intervalSeconds = interval;
      _updateChartWindow();
    });
  }

  void _updateChartWindow() {
    if (brightSpots.isEmpty) {
      return;
    }

    minX = brightSpots.last.x - intervalSeconds;
    if (minX < 0) {
      minX = 0;
    }
    maxX = minX + intervalSeconds;
  }

  void _reset() {
    setState(() {
      brightData = [];
      brightSpots = [];
      processedSpots = [];
      _transform = _buildTransform();
      _updateChartWindow();
    });
  }

  void _pause() {
    setState(() {
      isPaused = true;
    });
  }

  void _resume() {
    setState(() {
      isPaused = false;
    });
  }

  void _exportWithLock() async {
    if (isExporting) {
      return;
    }
    setState(() {
      isExporting = true;
    });
    try {
      await _export();
    } finally {
      if (mounted) {
        setState(() {
          isExporting = false;
        });
      }
    }
  }

  void _handleShowPreviewChanged(bool? value) {
    if (value == null) {
      return;
    }
    setState(() {
      showPreview = value;
    });
  }

  void _handleShowChartChanged(bool? value) {
    if (value == null) {
      return;
    }

    setState(() {
      showRawChart = value;
    });
  }

  void _handleProcessFrameChanged(bool? value) {
    if (value == null) {
      return;
    }

    setState(() {
      processFrame = value;
    });
  }

  void _handleShowProcessedChartChanged(bool? value) {
    if (value == null) {
      return;
    }

    setState(() {
      showProcessedChart = value;
    });
  }

  Future<void> _export() async {
    final currentData = brightData.toList();
    final messageService = ref.read(messageServiceProvider);
    final serializer = PPGSerializer();
    String? csvString;
    try {
      csvString = await serializer.exportCSVString(currentData);
    } catch (ex, s) {
      messageService.showAndLogError(
        AppException.caught(ex, s),
        "can't export",
      );
      return;
    }
    final fileName = "ppg_${DateTime.timestamp().toIso8601String()}.csv";
    String? savedPath;
    try {
      savedPath = await FilePicker.platform.saveFile(
        bytes: utf8.encode(csvString),
        dialogTitle: "Save $fileName",
        type: .custom,
        allowedExtensions: ["csv"],
        fileName: fileName,
      );
    } catch (ex, s) {
      messageService.showAndLogError(
        AppException.caught(ex, s),
        "Can't save $fileName",
      );
      return;
    }
    if (savedPath != null) {
      messageService.info("File $fileName saved to $savedPath");
    } else {
      messageService.info("File $fileName saved");
    }
  }

  static TransformBuilder _buildTransform() {
    return TransformBuilder()
      ..removeOffset(0.3)
      ..average(0.3)
      ..average(0.2)
      ..average(0.1);
  }
}
