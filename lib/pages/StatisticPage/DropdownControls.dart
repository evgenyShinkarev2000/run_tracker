import 'package:flutter/material.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/helpers/extensions/DateTimeExtension.dart';
import 'package:run_tracker/pages/StatisticPage/BarChartTimeInterval.dart';
import 'package:run_tracker/pages/StatisticPage/Gistograms.dart';

class DropdownControls extends StatelessWidget {
  final BarChartTimeInterval timeIntervalSelection;
  final void Function(BarChartTimeInterval?) onTimeIntervalSelected;
  final DateTime startDateTime;
  final void Function(DateTime) onDateTimeSelected;

  DropdownControls({
    required this.timeIntervalSelection,
    required this.onTimeIntervalSelected,
    required this.startDateTime,
    required this.onDateTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownMenu(
            width: 120,
            initialSelection: timeIntervalSelection,
            onSelected: onTimeIntervalSelected,
            textStyle: context.themeData.textTheme.bodyMedium!.copyWith(overflow: TextOverflow.visible),
            dropdownMenuEntries: [
              DropdownMenuEntry(value: BarChartTimeInterval.week, label: context.appLocalization.nounWeek),
              DropdownMenuEntry(value: BarChartTimeInterval.month, label: context.appLocalization.nounMonth),
              DropdownMenuEntry(value: BarChartTimeInterval.year, label: context.appLocalization.nounYear),
            ],
            inputDecorationTheme: context.themeData.inputDecorationTheme.copyWith(
              isDense: true,
            ),
          ),
          SizedBox(width: 16),
          InkWell(
            onTap: () => handleDateTap(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: context.themeData.colorScheme.outline),
                ),
              ),
              child: Row(
                children: [
                  Center(
                    child: Text(getDateLabel()),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: context.themeData.colorScheme.secondary,
                    size: 18,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String getDateLabel() {
    switch (timeIntervalSelection) {
      case BarChartTimeInterval.week:
        return DateHelper.dateTimeToStartInterval(startDateTime, timeIntervalSelection).appFormatedDateOnly;
      case BarChartTimeInterval.month:
        return "${startDateTime.year}.${startDateTime.month.toString().padLeft(2, "0")}";
      case BarChartTimeInterval.year:
        return startDateTime.year.toString();
    }
  }

  void handleDateTap(BuildContext context) {
    showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      currentDate: startDateTime,
    ).then((value) {
      if (value != null) {
        onDateTimeSelected(value);
      }
    });
  }
}
