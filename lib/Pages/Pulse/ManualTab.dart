import 'package:flutter/material.dart';
import 'package:run_tracker/Pages/Pulse/InstructionText.dart';
import 'package:run_tracker/Pages/Pulse/NumberCarousel.dart';
import 'package:run_tracker/Theme/export.dart';
import 'package:run_tracker/localization/export.dart';

class ManualTab extends StatefulWidget {
  final void Function(double? pulseBPM)? onPulseChanged;

  const ManualTab({super.key, this.onPulseChanged});

  @override
  State<ManualTab> createState() => _ManualTabState();
}

class _ManualTabState extends State<ManualTab> {
  final TextEditingController _controller = TextEditingController(text: "120");
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<NumberCarouselState> _carousel = GlobalKey(
    debugLabel: "ManualTab_NumberCarouselState",
  );

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        spacing: 8,
        children: [
          InstructionText(
            text: context.appLocalization.pulseMeasureManualInstruction,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: .center,
              children: [
                Flexible(
                  child: Container(
                    width: 40,
                    height: 30,
                    alignment: .bottomLeft,
                    padding: EdgeInsets.only(bottom: 3),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color:
                              context.themeData.colorScheme.secondaryContainer,
                        ),
                      ),
                    ),
                    child: EditableText(
                      onEditingComplete: _handleEditingComplete,
                      controller: _controller,
                      focusNode: _focusNode,
                      style: context.themeData.textTheme.titleMedium!,
                      cursorColor:
                          context.themeData.colorScheme.secondary,
                      backgroundCursorColor:
                          context.themeData.colorScheme.surface,
                    ),
                  ),
                ),
                Flexible(
                  child: SizedBox(
                    width: 60,
                    child: NumberCarousel(
                      key: _carousel,
                      initialValue: 120,
                      onChanged: _handleCarouselChanged,
                      min: 40,
                      max: 240,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleCarouselChanged(int value) {
    _controller.value = TextEditingValue(text: value.toString());
    widget.onPulseChanged?.call(value.toDouble());
  }

  void _handleEditingComplete() {
    final value = int.tryParse(_controller.text);
    if (value == null) {
      return;
    }

    _carousel.currentState?.scrollTo(value);
  }
}
