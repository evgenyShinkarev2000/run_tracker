part of chart_tab;

class ChartHelper {
  static double getTextHeight(BuildContext context, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: context.themeData.textTheme.bodyMedium,
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: double.infinity, minWidth: 0);

    return textPainter.height;
  }

  static double getTextWidth(BuildContext context, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: context.themeData.textTheme.bodyMedium,
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
      textWidthBasis: TextWidthBasis.longestLine,
    );
    textPainter.layout();

    return textPainter.width * 1.8;
  }

  static Widget getLeftTitlesWithEndPointsOffset(double value, TitleMeta meta, String text, BuildContext context) {
    final textWidget = Text(
      text,
      maxLines: 1,
      textAlign: TextAlign.center,
    );
    if (value == meta.min) {
      final textHeight = ChartHelper.getTextHeight(context, text);

      return Padding(
        padding: EdgeInsets.only(bottom: textHeight / 2),
        child: textWidget,
      );
    } else if (value == meta.max) {
      final textHeight = ChartHelper.getTextHeight(context, text);

      return Padding(
        padding: EdgeInsets.only(top: textHeight / 2),
        child: textWidget,
      );
    }

    return textWidget;
  }

  static Widget getBottomTitlesWithEndPointsOffset(double value, TitleMeta meta, String text, BuildContext context) {
    final textWidget = Text(
      text,
      maxLines: 1,
    );

    if (value == meta.min) {
      final textWidth = ChartHelper.getTextWidth(context, text);

      return Padding(
        padding: EdgeInsets.only(left: textWidth / 2),
        child: textWidget,
      );
    } else if (value == meta.max) {
      final textWidth = ChartHelper.getTextWidth(context, text);

      return Padding(
        padding: EdgeInsets.only(right: textWidth / 2),
        child: textWidget,
      );
    }

    return textWidget;
  }
}
