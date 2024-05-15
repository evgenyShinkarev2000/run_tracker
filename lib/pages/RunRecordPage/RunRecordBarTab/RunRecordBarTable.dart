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
    final style = context.themeData.textTheme.bodyLarge;

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
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  row.value,
                  style: style,
                ),
                SizedBox(width: 16),
                row.length != null
                    ? Expanded(
                        child: LayoutBuilder(builder: (context, boxConstrains) {
                          return Row(
                            children: [
                              Container(
                                width: row.length! * boxConstrains.maxWidth,
                                height: 16,
                                color: Color.lerp(context.themeData.colorScheme.background,
                                    context.themeData.colorScheme.primary, 0.7),
                              ),
                            ],
                          );
                        }),
                      )
                    : null,
              ].nonNulls.toList(),
            ),
          );
        },
        separatorBuilder: (_, __) => Divider(),
      ),
    );
  }
}
