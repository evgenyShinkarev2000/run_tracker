import 'package:cancellation_token/cancellation_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Components/export.dart';
import 'package:run_tracker/Pages/TrackRecord/TrackRecordTabBar.dart';
import 'package:run_tracker/Providers/Track/export.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Routing/export.dart';
import 'package:run_tracker/Services/Track/export.dart';
import 'package:run_tracker/Services/export.dart';
import 'package:run_tracker/Theme/export.dart';
import 'package:run_tracker/localization/export.dart';

class TrackRecordPage extends ConsumerStatefulWidget {
  final int? trackRecordId;

  const TrackRecordPage({super.key, required this.trackRecordId});

  @override
  ConsumerState<TrackRecordPage> createState() => _TrackRecordPageState();
}

class _TrackRecordPageState extends ConsumerState<TrackRecordPage> {
  late final Future<TrackRecordWithSummaryAndPoints?> trackRecordFuture;

  final CancellationToken ct = CancellationToken();

  @override
  void initState() {
    super.initState();

    trackRecordFuture = widget.trackRecordId == null
        ? Future.value(null)
        : ref
              .read(trackServiceProvider)
              .getTrackRecordWithSummaryAndPointsOrGenerateById(
                widget.trackRecordId!,
                ct,
              );
  }

  @override
  void dispose() {
    ct.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: trackRecordFuture,
      builder: (context, snapshot) => Scaffold(
        appBar: AppBar(
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
                snapshot.data?.summary.start
                        ?.applyConverter(userDateTimeConverter)
                        .applyFormat(appDateTimeFormat.fullDateFullTime) ??
                    "",
              );
            },
          ),
        ),
        body: switch (snapshot.connectionState) {
          ConnectionState.done =>
            snapshot.data == null
                ? Center(child: Text(context.appLocalization.nounNoData))
                : TrackRecordTabBar(trackRecord: snapshot.data!),
          _ => AppLoader(),
        },
      ),
    );
  }
}
