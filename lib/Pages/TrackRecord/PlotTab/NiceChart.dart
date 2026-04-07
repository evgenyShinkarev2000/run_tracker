import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Pages/TrackRecord/PlotTab/NideChartHeader.dart';
import 'package:run_tracker/Pages/TrackRecord/PlotTab/PrepareSpot.dart';
import 'package:run_tracker/Theme/export.dart';
import 'package:run_tracker/localization/export.dart';

class NiceChart extends StatefulWidget {
  final List<FlSpot> rawSpots;
  final double? outlierInterval;
  final double aspectRatio;
  final double maxX;
  final bool isZeroBasedY;
  final String? title;
  final String Function(double)? mapXToView;
  final String Function(double)? mapYToView;

  const NiceChart({
    super.key,
    required this.rawSpots,
    required this.maxX,
    this.outlierInterval,
    this.title,
    this.isZeroBasedY = false,
    this.aspectRatio = 1.6,
    this.mapXToView,
    this.mapYToView,
  });

  @override
  State<NiceChart> createState() => _NiceChartState();
}

class _NiceChartState extends State<NiceChart> {
  bool useOutlier = true;
  bool useAverage = true;
  bool useDownSampling = true;
  bool? showMarkers;
  double? maxWidth;
  List<FlSpot> preparedSpots = [];
  double? minY;
  double? maxY;

  @override
  void initState() {
    super.initState();
    useOutlier = widget.outlierInterval != null;
    if (widget.isZeroBasedY) {
      minY = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        NiceChartHeader(
          title: widget.title,
          useOutlier: useOutlier,
          allowOutlier: widget.outlierInterval != null,
          onUseOutlierChange: _handleUseOutlierChange,
          useResolution: useAverage,
          onUseResolutionChange: _handleUseAverageChange,
          useDownSampling: useDownSampling,
          onUseDownSamplingChange: _handleUseDownSamplingChange,
          showMarkers: showMarkers ?? false,
          onShowMarkersChange: _handleShowMarkersChange,
        ),
        AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: widget.rawSpots.isEmpty
              ? Center(child: Text(context.appLocalization.nounNoData))
              : _renderChart(context),
        ),
      ],
    );
  }

  Widget _renderChart(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _setMaxWidth(constraints.maxWidth);
        final textStyle = context.themeData.textTheme.bodyMedium!;
        final touchTooltipBackgroundColor =
            context.themeData.colorScheme.surfaceContainer;
        Color getBackgroundColor(LineBarSpot _) => touchTooltipBackgroundColor;

        return LineChart(
          LineChartData(
            minX: 0,
            maxX: widget.maxX,
            minY: minY,
            maxY: maxY,
            titlesData: FlTitlesData(
              topTitles: AxisTitles(),
              rightTitles: AxisTitles(),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  interval: _getLeftLabelInterval(),
                  reservedSize: 32,
                  showTitles: true,
                  getTitlesWidget: _getLeftAxisRender,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  interval: _getBottomLabelInterval(),
                  reservedSize: 32,
                  showTitles: true,
                  getTitlesWidget: _getBottomAxisRender,
                ),
              ),
            ),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: getBackgroundColor,
                getTooltipItems: (touchedSpots) => touchedSpots
                    .map(
                      (e) => LineTooltipItem(
                        "${_mapYToView(e.y)}\n${_mapXToView(e.x)}",
                        textStyle,
                      ),
                    )
                    .toList(),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                curveSmoothness: 0.1,
                spots: preparedSpots,
                dotData: FlDotData(show: showMarkers ?? false),
              ),
            ],
          ),
        );
      },
    );
  }

  void _setMaxWidth(double maxWidth) {
    if (this.maxWidth != maxWidth) {
      this.maxWidth = maxWidth;
      _prepareSpots();
      showMarkers ??= maxWidth / preparedSpots.length > 20;
      Future.microtask(() => setState(() {}));
    }
  }

  void _prepareSpots() {
    Iterable<FlSpot> iterableSpots = widget.rawSpots;
    //TODO взвешенный фильтр
    if (useOutlier && widget.outlierInterval != null) {
      iterableSpots = PrepareSpots.centeredIntervalAverage
          .mapByCenteredAverage(iterableSpots, widget.outlierInterval!)
          .map((e) => e.$1.copyWith(y: e.$2));
    }
    if (useDownSampling && maxWidth != null) {
      iterableSpots = PrepareSpots.downSampler.downSample(
        iterableSpots.toList(),
        maxWidth!.floor(),
      );
    }
    if (useAverage && maxWidth != null) {
      iterableSpots = PrepareSpots.centeredIntervalAverage
          .mapByCenteredAverage(iterableSpots, (widget.maxX / maxWidth!) * 10)
          .map((e) => e.$1.copyWith(y: e.$2));
    }
    preparedSpots = iterableSpots.toList();

    final yMinMax = preparedSpots.selectMinMaxNum((e) => e.y);
    if (yMinMax != null) {
      final verticalOffset = yMinMax.$2 - yMinMax.$1;
      final padding = verticalOffset / 50;
      maxY = yMinMax.$2 + padding;
      if (!widget.isZeroBasedY) {
        minY = yMinMax.$1 - padding;
      }
    }
  }

  void _handleUseAverageChange(bool value) {
    setState(() {
      useAverage = value;
      _prepareSpots();
    });
  }

  void _handleUseDownSamplingChange(bool value) {
    setState(() {
      useDownSampling = value;
      _prepareSpots();
    });
  }

  void _handleShowMarkersChange(bool value) {
    setState(() {
      showMarkers = value;
      _prepareSpots();
    });
  }

  void _handleUseOutlierChange(bool value) {
    setState(() {
      useOutlier = value;
      _prepareSpots();
    });
  }

  String _mapXToView(double x) {
    return widget.mapXToView == null
        ? x.toStringAsFixed(1)
        : widget.mapXToView!(x);
  }

  String _mapYToView(double y) {
    return widget.mapYToView == null
        ? y.toStringAsFixed(1)
        : widget.mapYToView!(y);
  }

  Widget _getLeftAxisRender(double y, TitleMeta meta) {
    if (!_needRenderAxisLabel(y, meta)) {
      return SizedBox();
    }
    return SideTitleWidget(
      meta: meta,
      child: Text(_mapYToView(y), softWrap: false),
    );
  }

  Widget _getBottomAxisRender(double x, TitleMeta meta) {
    if (!_needRenderAxisLabel(x, meta)) {
      return SizedBox();
    }
    return SideTitleWidget(
      meta: meta,
      fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
      child: Text(_mapXToView(x)),
    );
  }

  bool _needRenderAxisLabel(double value, TitleMeta meta) {
    //TODO можно улучшить
    return meta.axisPosition == 0 ||
        meta.axisPosition == meta.parentAxisSize ||
        (meta.axisPosition - (meta.parentAxisSize / 2)).abs() < 1e-3;
  }

  double? _getLeftLabelInterval() {
    if (maxY == null || minY == null) {
      return null;
    }
    final interval = (maxY! - minY!) / 2;

    return interval <= 0 ? null : interval;
  }

  double? _getBottomLabelInterval() {
    final interval = widget.maxX / 2;

    return interval <= 0 ? null : interval;
  }
}
