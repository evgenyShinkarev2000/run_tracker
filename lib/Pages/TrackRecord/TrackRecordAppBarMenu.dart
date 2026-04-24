import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/Components/export.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Pages/TrackRecord/LongScreenshot/LongScreenshot.dart';
import 'package:run_tracker/Providers/Repositories/export.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Routing/export.dart';
import 'package:run_tracker/Services/Track/export.dart';
import 'package:run_tracker/localization/export.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class TrackRecordAppBarMenu extends ConsumerStatefulWidget {
  final TrackRecordWithSummaryAndPointAndPulse trackRecord;

  const TrackRecordAppBarMenu({super.key, required this.trackRecord});

  @override
  ConsumerState<TrackRecordAppBarMenu> createState() =>
      _TrackRecordAppBarMenuState();
}

class _TrackRecordAppBarMenuState extends ConsumerState<TrackRecordAppBarMenu> {
  static final _canShare = _checkCanShare();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      routeSettings: RouteSettings(
        name: "trackRecordMenu/${widget.trackRecord.track.id}",
      ),
      itemBuilder: (context) => [
        _canShare
            ? PopupMenuItem(
                onTap: _share,
                child: Row(
                  spacing: 16,
                  children: [
                    Icon(Icons.share),
                    Text(context.appLocalization.runRecordPageShare),
                  ],
                ),
              )
            : null,
        PopupMenuItem(
          onTap: _saveAsImage,
          child: Row(
            spacing: 16,
            children: [
              Icon(Icons.image_outlined),
              Text(context.appLocalization.runRecordSaveAsImage),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: _showRemoveDialog,
          child: Row(
            spacing: 16,
            children: [
              Icon(Icons.delete_forever),
              Text(context.appLocalization.verbRemove),
            ],
          ),
        ),
      ].nonNulls.toList(),
    );
  }

  static bool _checkCanShare() =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Future<Uint8List> _buildImageBytes() async {
    final controller = ScreenshotController();

    return await controller.captureFromLongWidget(
      LongScreenshot(trackRecord: widget.trackRecord, mainContext: context),
      delay: Duration(milliseconds: 500),
      pixelRatio: 2,
      constraints: BoxConstraints(maxWidth: 1000, maxHeight: 10000),
    );
  }

  String _buildFileName() =>
      "${widget.trackRecord.track.createdAt.toIso8601String().replaceAll(RegExp(":|-"), "_")}.png";

  void _saveAsImage() async {
    final messageService = ref.read(messageServiceProvider);

    Uint8List? bytes;
    _showScreenshotLoader();
    try {
      bytes = await _buildImageBytes();
    } catch (ex, s) {
      messageService.showAndLogError(AppException.caught(ex, s));
      return;
    } finally {
      _hideScreenshotLoader();
    }

    try {
      FilePicker.platform.saveFile(
        bytes: bytes,
        fileName: _buildFileName(),
        type: .custom,
        allowedExtensions: ["png"],
      );
    } catch (ex, s) {
      messageService.showAndLogError(AppException.caught(ex, s));
    }
  }

  void _share() async {
    final messageService = ref.read(messageServiceProvider);
    final shareError = context.appLocalization.runRecordPageShareError;

    XFile? file;
    _showScreenshotLoader();
    try {
      file = XFile.fromData(await _buildImageBytes(), name: _buildFileName());
    } catch (ex, s) {
      messageService.showAndLogError(AppException.caught(ex, s));
      return;
    } finally {
      _hideScreenshotLoader();
    }

    final shareParams = ShareParams(
      files: [file],
      fileNameOverrides: [file.name],
    );

    ShareResult? shareResult;
    try {
      shareResult = await SharePlus.instance.share(shareParams);
    } catch (ex, s) {
      messageService.showAndLogError(AppException.caught(ex, s));
      return;
    }

    if (shareResult.status == .unavailable) {
      messageService.warning(shareError);
    }
  }

  void _showScreenshotLoader() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: .min,
            mainAxisAlignment: .center,
            spacing: 8,
            children: [
              Text(context.appLocalization.runRecordBuildingScreenshot),
              AppLoader(),
            ],
          ),
        );
      },
    );
  }

  void _hideScreenshotLoader() {
    if (!context.mounted) {
      return;
    }
    if (context.canPop()) {
      context.pop();
    }
  }

  void _showRemoveDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.appLocalization.confirmRemoveRequest),
        actions: [
          TextButton(
            onPressed: _remove,
            child: Text(context.appLocalization.verbRemove),
          ),
          TextButton(
            onPressed: context.pop,
            child: Text(context.appLocalization.verbCancel),
          ),
        ],
      ),
    );
  }

  void _remove() async {
    final repository = ref.read(trackRecordRepositoryProvider);
    final messageService = ref.read(messageServiceProvider);
    try {
      await repository.remove(widget.trackRecord.track.id);
    } catch (ex, s) {
      messageService.showAndLogError(AppException.caught(ex, s));
      return;
    }
    if (mounted) {
      context.appRouter.goHistory();
    }
  }
}
