import 'package:flutter/material.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordBarTab/RunRecordBarHeader.dart';

import 'BarModel.dart';

class RunRecordBarTable extends StatelessWidget {
  final List<BarModel> rowModels;
  final double gap;
  final UnitType unitType;

  Widget get Gap => SizedBox(width: gap);
  Widget get GetDivider => VerticalDivider(
        width: 0,
      );

  const RunRecordBarTable({
    super.key,
    required this.rowModels,
    required this.unitType,
    this.gap = 16,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.themeData.textTheme.bodyLarge;
    final textLength = getTextLength(context).ceilToDouble();

    return Expanded(
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        itemCount: rowModels.length,
        itemBuilder: (context, index) {
          final row = rowModels[index];
          final flex = (row.trackLength * 1000).round();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: Center(
                      child: Text(
                        row.leading,
                        style: style,
                      ),
                    ),
                  ),
                  Gap,
                  GetDivider,
                  Gap,
                  SizedBox(
                    width: textLength,
                    child: Center(
                      child: Text(
                        row.value,
                        style: style,
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                  Gap,
                  Expanded(
                    flex: flex,
                    child: Container(
                      height: 16,
                      color: Color.lerp(
                          context.themeData.colorScheme.background, context.themeData.colorScheme.primary, 0.7),
                    ),
                  ),
                  Expanded(
                    flex: 1000 - flex,
                    child: SizedBox(),
                  ),
                  Gap,
                  GetDivider,
                  Gap,
                  SizedBox(
                    width: 50,
                    child: Center(
                      child: Text(
                        row.trailing,
                        style: context.themeData.textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => Divider(
          height: 1,
        ),
      ),
    );
  }

  double getTextLength(BuildContext context) {
    var text = "00:00";
    switch (unitType) {
      case UnitType.speed:
        text = "00.0";
      case UnitType.pace:
        text = "00:00";
    }

    final painter = TextPainter(
      text: TextSpan(text: text, style: context.themeData.textTheme.bodyLarge),
      textDirection: TextDirection.ltr,
    );
    painter.layout();

    return painter.width;
  }
}
