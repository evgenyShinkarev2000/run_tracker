import 'package:flutter/material.dart';
import 'package:run_tracker/Theme/export.dart';
import 'package:run_tracker/localization/export.dart';

class NiceChartHeader extends StatefulWidget {
  final String? title;
  final bool useOutlier;
  final bool allowOutlier;
  final void Function(bool) onUseOutlierChange;
  final bool useResolution;
  final void Function(bool) onUseResolutionChange;
  final bool useDownSampling;
  final void Function(bool) onUseDownSamplingChange;
  final bool showMarkers;
  final void Function(bool) onShowMarkersChange;

  const NiceChartHeader({
    super.key,
    this.title,
    required this.useOutlier,
    required this.allowOutlier,
    required this.onUseOutlierChange,
    required this.useResolution,
    required this.onUseResolutionChange,
    required this.useDownSampling,
    required this.onUseDownSamplingChange,
    required this.showMarkers,
    required this.onShowMarkersChange,
  });

  @override
  State<NiceChartHeader> createState() => _NiceChartHeaderState();
}

class _NiceChartHeaderState extends State<NiceChartHeader> {
  late final ValueNotifier<bool> useResolution;
  late final ValueNotifier<bool> useDownSampling;
  late final ValueNotifier<bool> showMarkers;
  late final ValueNotifier<bool> useOutlier;

  @override
  void initState() {
    super.initState();

    useResolution = ValueNotifier(widget.useResolution);
    useDownSampling = ValueNotifier(widget.useDownSampling);
    showMarkers = ValueNotifier(widget.showMarkers);
    useOutlier = ValueNotifier(widget.useOutlier);
  }

  @override
  void dispose() {
    useResolution.dispose();
    useDownSampling.dispose();
    showMarkers.dispose();
    useOutlier.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NiceChartHeader oldWidget) {
    if (useResolution.value != widget.useResolution) {
      Future.microtask(() => useResolution.value = widget.useResolution);
    }
    if (useDownSampling.value != widget.useDownSampling) {
      Future.microtask(() => useDownSampling.value = widget.useDownSampling);
    }
    if (showMarkers.value != widget.showMarkers) {
      Future.microtask(() => showMarkers.value = widget.showMarkers);
    }
    if (useOutlier.value != widget.useOutlier) {
      Future.microtask(() => useOutlier.value = widget.useOutlier);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.title ?? "", style: context.themeData.textTheme.titleMedium,),
        PopupMenuButton(
          routeSettings: RouteSettings(name: "${widget.title}_chartSettings"),
          constraints: BoxConstraints.tightFor(width: 250),
          itemBuilder: (context) => [
            widget.allowOutlier ? PopupMenuItem(
              child: ValueListenableBuilder(
                valueListenable: useOutlier,
                builder: (context, value, child) => CheckboxListTile(
                  value: value,
                  onChanged: (v) => _handleChange(widget.onUseOutlierChange, v),
                  title: Text(context.appLocalization.chartMenuOutlierFilter),
                ),
              ),
            ) : null,
            PopupMenuItem(
              child: ValueListenableBuilder(
                valueListenable: useDownSampling,
                builder: (context, value, child) {
                  return CheckboxListTile(
                    value: value,
                    onChanged: (v) =>
                        _handleChange(widget.onUseDownSamplingChange, v),
                    title: Text(context.appLocalization.chartMenuDownsampling),
                  );
                },
              ),
            ),
            PopupMenuItem(
              child: ValueListenableBuilder(
                valueListenable: useResolution,
                builder: (context, value, child) {
                  return CheckboxListTile(
                    value: value,
                    onChanged: (v) =>
                        _handleChange(widget.onUseResolutionChange, v),
                    title: Text(
                      context.appLocalization.chartMenuResolutionFilter,
                    ),
                  );
                },
              ),
            ),
            PopupMenuItem(
              child: ValueListenableBuilder(
                valueListenable: showMarkers,
                builder: (context, value, child) {
                  return CheckboxListTile(
                    value: value,
                    onChanged: (v) =>
                        _handleChange(widget.onShowMarkersChange, v),
                    title: Text(context.appLocalization.chartMenuShowMarkers),
                  );
                },
              ),
            ),
          ].nonNulls.toList(),
        ),
      ],
    );
  }

  void _handleChange(void Function(bool) callback, bool? value) {
    if (value == null) {
      return;
    }

    callback(value);
  }
}
