import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Pages/TrackRecord/TrackRecordAppBarMenu.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Routing/export.dart';
import 'package:run_tracker/Services/Track/export.dart';
import 'package:run_tracker/Services/export.dart';
import 'package:run_tracker/Theme/export.dart';

class TrackRecordAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final TrackRecordWithSummaryAndPointAndPulse? trackRecord;

  const TrackRecordAppBar({super.key, required this.trackRecord})
    : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: context.appRouter.goHistory,
        icon: Icon(Icons.arrow_back),
      ),
      backgroundColor: context.themeData.colorScheme.inversePrimary,
      title: Consumer(
        builder: (context, ref, widget) {
          final userDateTimeConverter = ref.watch(
            userDateTimeConverterProvider,
          );
          final appDateTimeFormat = ref.watch(appDateTimeFormatProvider);

          return Text(
            trackRecord?.summary.start
                    ?.fromUtcToUser(userDateTimeConverter)
                    .applyFormat(appDateTimeFormat.fullDateFullTime) ??
                "",
          );
        },
      ),
      actions: [
        trackRecord == null
            ? null
            : TrackRecordAppBarMenu(trackRecord: trackRecord!),
      ].nonNulls.toList(),
    );
  }
}
