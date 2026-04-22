import 'package:flutter/material.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Theme/export.dart';

class InstructionText extends StatefulWidget {
  final String text;
  const InstructionText({super.key, required this.text});

  @override
  State<InstructionText> createState() => _InstructionTextState();
}

class _InstructionTextState extends State<InstructionText> {
  late String _capitalizedText;

  @override
  void initState() {
    super.initState();

    _capitalizedText = widget.text.capitalize();
  }

  @override
  void didUpdateWidget(covariant InstructionText oldWidget) {
    if (oldWidget.text != widget.text) {
      _capitalizedText = widget.text.capitalize();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _capitalizedText,
      style: context.themeData.textTheme.titleMedium,
      textAlign: TextAlign.center,
    );
  }
}
