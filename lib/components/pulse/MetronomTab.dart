import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/helpers/extensions/StringExtension.dart';

import 'PulseLabel.dart';

class MetronomTab extends StatefulWidget {
  final void Function() onClick;
  final int pulse;

  MetronomTab({required this.onClick, required this.pulse});

  @override
  State<MetronomTab> createState() => _MetronomTabState();
}

class _MetronomTabState extends State<MetronomTab> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            context.appLocalization.pulseMeasureMetronomIntructionClickAtDrum.capitalize(),
            style: context.themeData.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTapDown: (_) => handlePressed(),
          child: IndexedStack(
            index: isPressed ? 1 : 0,
            children: [
              Image.asset(
                "assets/images/drum.png",
              ),
              Image.asset("assets/images/drum-pressed.png"),
            ],
          ),
        ),
        SizedBox(height: 8),
        PulseLabel(
          pulse: widget.pulse,
        ),
      ],
    );
  }

  void handlePressed() {
    widget.onClick();

    setState(() {
      isPressed = true;
    });

    Future.delayed(
        Duration(milliseconds: 80),
        () => setState(() {
              isPressed = false;
            }));
  }
}
