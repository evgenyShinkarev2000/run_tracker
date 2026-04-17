import 'package:cancellation_token/cancellation_token.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Providers/Track/export.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Routing/export.dart';
import 'package:run_tracker/localization/export.dart';

class AppBarMenu extends ConsumerStatefulWidget {
  const AppBarMenu({super.key});

  @override
  ConsumerState<AppBarMenu> createState() => _AppBarMenuState();
}

class _AppBarMenuState extends ConsumerState<AppBarMenu> {
  final CancellationToken ct = CancellationToken();

  @override
  void dispose() {
    ct.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      routeSettings: RouteSettings(name: "TrackHistoryAppBarMenu"),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () => _importGpx(context),
          child: Row(
            spacing: 16,
            children: [
              Icon(Icons.arrow_downward),
              Text(context.appLocalization.importGPX),
            ],
          ),
        ),
      ],
    );
  }

  void _importGpx(BuildContext context) async {
    final messageService = ref.read(messageServiceProvider);
    final importService = ref.read(gpxImportProvider);
    final noFileMessage = context.appLocalization.importNoFile;
    final importFailedMessage = context.appLocalization.importFailed;

    final result = await FilePicker.platform.pickFiles(
      dialogTitle: context.appLocalization.importPickGPXFile,
      allowedExtensions: ["gpx"],
      type: FileType.custom,
    );
    ct.throwIfCancelled();
    if (result == null || result.files.isEmpty) {
      messageService.warning(noFileMessage);
      return;
    }

    final fileContent = await result.xFiles.first.readAsString();
    ct.throwIfCancelled();

    TrackRecord? trackRecord;
    try {
      trackRecord = await importService.importTrackRecord(fileContent);
    } catch (ex, s) {
      messageService.showAndLogError(
        AppException.caught(ex, s),
        importFailedMessage,
      );
      return;
    }
    ct.throwIfCancelled();

    if (context.mounted) {
      context.appRouter.goTrackRecord(trackRecord.id);
    }
  }
}
