import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Pages/Statistics/StatisticsInterval.dart';
import 'package:run_tracker/Pages/Statistics/StatisticsService.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/export.dart';
import 'package:run_tracker/Theme/export.dart';
import 'package:run_tracker/localization/export.dart';

class DropdownControls extends ConsumerStatefulWidget {
  final StatisticsInterval intervalKind;
  final void Function(StatisticsInterval) intervalKindChanged;
  final DateTime userStartDateTime;
  final void Function(DateTime) startUserDateTimeChanged;
  final bool isLoading;

  const DropdownControls({
    super.key,
    required this.intervalKind,
    required this.intervalKindChanged,
    required this.userStartDateTime,
    required this.startUserDateTimeChanged,
    this.isLoading = false,
  });

  @override
  ConsumerState<DropdownControls> createState() => _DropdownControlsState();
}

class _DropdownControlsState extends ConsumerState<DropdownControls> {
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      children: [
        DropdownMenu(
          width: 120,
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            visualDensity: VisualDensity.compact,
            suffixIconConstraints: BoxConstraints.expand(width: 40, height: 40),
          ),
          initialSelection: widget.intervalKind,
          onSelected: widget.isLoading ? null : _handleIntervalChanged,
          dropdownMenuEntries: [
            DropdownMenuEntry(
              value: StatisticsInterval.week,
              label: context.appLocalization.nounWeek,
            ),
            DropdownMenuEntry(
              value: StatisticsInterval.month,
              label: context.appLocalization.nounMonth,
            ),
            DropdownMenuEntry(
              value: StatisticsInterval.year,
              label: context.appLocalization.nounYear,
            ),
          ],
        ),
        InkWell(
          onTap: widget.isLoading ? null : () => _handleDateTap(context, ref),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: context.themeData.colorScheme.outline,
                ),
              ),
            ),
            child: Row(
              spacing: 16,
              children: [
                Center(child: Text(_getDateLabel())),
                Icon(
                  Icons.arrow_drop_down,
                  color: context.themeData.colorScheme.secondary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getDateLabel() {
    final formater = ref.read(appDateTimeFormatProvider);

    return StatisticsService.normilizeLocalDateTime(
      widget.userStartDateTime,
      widget.intervalKind,
    ).applyFormat(formater.fullDateOnly);
  }

  void _handleIntervalChanged(StatisticsInterval? interval) {
    if (interval == null) {
      return;
    }

    widget.intervalKindChanged(interval);
  }

  void _handleDateTap(BuildContext context, WidgetRef ref) {
    showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      currentDate: widget.userStartDateTime,
    ).then((value) {
      if (value != null) {
        widget.startUserDateTimeChanged(value);
      }
    });
  }
}
