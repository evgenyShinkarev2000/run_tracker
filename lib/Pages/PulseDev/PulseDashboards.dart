import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Pages/PulseDev/PulseCharts.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/Pulse/BrightnessWithDuration.dart';
import 'package:run_tracker/Services/Pulse/PPGSerializer.dart';

class PulseDashboard extends ConsumerStatefulWidget {
  const PulseDashboard({super.key});

  @override
  ConsumerState<PulseDashboard> createState() => _PulseDashboardState();
}

class _PulseDashboardState extends ConsumerState<PulseDashboard> {
  final GlobalKey<PulseChartsState> _pulseDashboard = GlobalKey(
    debugLabel: "pulseDashboard",
  );

  bool isImporting = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            TextButton(
              onPressed: isImporting ? null : _importWithLock,
              child: Text("import"),
            ),
          ],
        ),
        Expanded(child: PulseCharts(key: _pulseDashboard)),
      ],
    );
  }

  void _importWithLock() async {
    if (isImporting) {
      return;
    }
    setState(() {
      isImporting = true;
    });

    try {
      await _import();
    } finally {
      setState(() {
        isImporting = false;
      });
    }
  }

  Future<void> _import() async {
    final messageService = ref.read(messageServiceProvider);

    String? csvString;
    try {
      final files = await FilePicker.platform.pickFiles(
        type: .custom,
        allowedExtensions: ["csv"],
        allowMultiple: false,
        dialogTitle: "choose ppg csv",
      );
      if (files == null || files.xFiles.isEmpty) {
        messageService.warning("Need choose ppg csv to import");
        return;
      }
      csvString = await files.xFiles.first.readAsString();
    } catch (ex, s) {
      messageService.showAndLogError(
        AppException.caught(ex, s),
        "Can't read file",
      );
      return;
    }

    List<BrightnessWithDuration>? brightData;

    try {
      brightData = await PPGSerializer().importCSVString(csvString);
    } catch (ex, s) {
      messageService.showAndLogError(
        AppException.caught(ex, s),
        "Can't import file",
      );
      return;
    }

    messageService.info("file imported, updating...");

    _pulseDashboard.currentState?.updateCharts(brightData);
  }
}
