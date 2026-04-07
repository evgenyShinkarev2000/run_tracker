import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Providers/Camera/export.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/Camera/export.dart';
import 'package:run_tracker/Services/Pulse/BrightnessWithDuration.dart';
import 'package:run_tracker/Services/Pulse/PPGSerializer.dart';

class PulseDev extends ConsumerStatefulWidget {
  const PulseDev({super.key});

  @override
  ConsumerState<PulseDev> createState() => _PulseDevState();
}

class _PulseDevState extends ConsumerState<PulseDev> {
  final CameraFrameBrightness frameBrightness = CameraFrameBrightness();
  List<BrightnessWithDuration> brightData = [];
  List<FlSpot> brightSpots = [];
  double intervalSeconds = 10;
  double minX = 0;
  late double maxX = intervalSeconds;
  bool isPaused = true;
  DateTime? firstFrameTimestamp;
  bool isExporting = false;
  late final CameraFrameWithFlashProvider cameraService;
  late final StreamSubscription<CameraImage> cameraSubsription;

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
    return Scaffold(
      appBar: AppBar(
        title: Text("pulse dev"),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: .min,
          children: [
            Flexible(
              fit: .loose,
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
              fit: .loose,
              child: Slider(
                min: 5,
                max: 15,
                value: intervalSeconds,
                onChanged: _handleIntervalChange,
              ),
            ),
            Flexible(
              fit: .loose,
              child: AspectRatio(
                aspectRatio: 2,
                child: brightSpots.isEmpty
                    ? Center(child: Text("no data"))
                    : LineChart(
                        LineChartData(
                          minX: minX,
                          maxX: maxX,
                          clipData: FlClipData.all(),
                          titlesData: FlTitlesData(
                            rightTitles: AxisTitles(),
                            topTitles: AxisTitles(),
                          ),
                          lineBarsData: [LineChartBarData(spots: brightSpots)],
                        ),
                      ),
              ),
            ),
            Flexible(
              fit: .loose,
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: cameraService.cameraController,
                  builder: (context, value, _) => value == null
                      ? Center(child: Text("waiting camera..."))
                      : CameraPreview(value),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleFrameReceive(CameraImage image) {
    if (isPaused) {
      return;
    }
    final timestamp = DateTime.timestamp();
    firstFrameTimestamp ??= timestamp;
    final brightness = frameBrightness.findBrightness(image);
    final duration = timestamp.difference(firstFrameTimestamp!);
    brightData.add(
      BrightnessWithDuration(brightness: brightness, duration: duration),
    );
    brightSpots.add(FlSpot(duration.inSecondsDouble, brightness));
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

  Future<void> _export() async {
    final currentData = brightData.toList();
    final messageService = ref.read(messageServiceProvider);
    final serializer = PPGSerializer();
    String? csvString;
    try {
      csvString = await serializer.exportCSVString(currentData);
    } catch (ex, s) {
      messageService.showAndLogError(
        DartExceptionWrapper(ex, s),
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
        DartExceptionWrapper(ex, s),
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
}
