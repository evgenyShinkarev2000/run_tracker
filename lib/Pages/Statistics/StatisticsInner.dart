import 'package:flutter/material.dart' hide Interval;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Components/Loader/export.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Pages/Statistics/DropdownControls.dart';
import 'package:run_tracker/Pages/Statistics/StatisicsSummary.dart';
import 'package:run_tracker/Pages/Statistics/StatisticsCharts.dart';
import 'package:run_tracker/Pages/Statistics/StatisticsInterval.dart';
import 'package:run_tracker/Pages/Statistics/StatisticsService.dart';
import 'package:run_tracker/Pages/Statistics/StatisticsServiceProvider.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/export.dart';

class StatisticsInner extends ConsumerStatefulWidget {
  const StatisticsInner({super.key});

  @override
  ConsumerState<StatisticsInner> createState() => _StatisticsInnerState();
}

class _StatisticsInnerState extends ConsumerState<StatisticsInner> {
  bool _isLoading = true;
  List<Interval> _intervals = [];
  StatisticsInterval _intervalKind = .week;
  late DateTime _lastSelectedUserTime;

  @override
  void initState() {
    super.initState();

    final converter = ref.read(userDateTimeConverterProvider);
    _lastSelectedUserTime = DateTime.timestamp().fromUtcToUser(converter);

    _updateIntervals();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        DropdownControls(
          intervalKind: _intervalKind,
          intervalKindChanged: _handleIntervalKindChanged,
          userStartDateTime: _lastSelectedUserTime,
          startUserDateTimeChanged: _handleStartDateTimeChanged,
        ),
        _isLoading
            ? AppLoader()
            : Flexible(
                child: SingleChildScrollView(
                  scrollDirection: .vertical,
                  child: Column(
                    spacing: 8,
                    children: [
                      StatisticsSummary(intervals: _intervals),
                      AspectRatio(
                        aspectRatio: 1.6,
                        child: StatisticsCharts(
                          intervalKind: _intervalKind,
                          intervals: _intervals,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  void _handleIntervalKindChanged(StatisticsInterval intervalKind) {
    setState(() {
      _intervalKind = intervalKind;
      _updateIntervals();
    });
  }

  void _handleStartDateTimeChanged(DateTime dateTime) {
    setState(() {
      _lastSelectedUserTime = dateTime;
      _updateIntervals();
    });
  }

  Future<void> _updateIntervals() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _updateIntervalsInternal();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateIntervalsInternal() async {
    final messageService = ref.read(messageServiceProvider);
    final converter = ref.read(userDateTimeConverterProvider);

    try {
      final normilizedUtc = StatisticsService.normilizeLocalDateTime(
        _lastSelectedUserTime,
        _intervalKind,
      ).fromUserToUtc(converter);
      _intervals = await ref
          .read(statisticsServiceProvider)
          .getByIntervalAndStartDate(_intervalKind, normilizedUtc);
    } catch (ex, s) {
      messageService.showAndLogError(AppException.caught(ex, s));
    }
  }
}
