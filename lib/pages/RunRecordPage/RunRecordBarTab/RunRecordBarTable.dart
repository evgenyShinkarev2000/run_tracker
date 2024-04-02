import 'package:flutter/material.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordBarTab/RunRecordBarTab.dart';

class RunRecordBarTable extends StatelessWidget {
  final List<RunRecordBarRowModel<String, String>> rowModels;

  const RunRecordBarTable({
    super.key,
    required this.rowModels,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.themeDate.textTheme.bodyLarge;
    return Expanded(
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        itemCount: rowModels.length,
        itemBuilder: (context, index) {
          final row = rowModels[index];

          return ListTile(
            minLeadingWidth: 48,
            leading: Text(
              row.label,
              style: style,
            ),
            title: Text(
              row.value,
              style: style,
            ),
          );
        },
        separatorBuilder: (_, __) => Divider(),
      ),
    );
  }
}
