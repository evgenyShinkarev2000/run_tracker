import 'package:flutter/widgets.dart';
import 'package:run_tracker/Components/Map/Components/ControlButtons.dart';

class BottomButtons extends StatelessWidget {
  const BottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: AlignmentGeometry.bottomCenter,
        child: ControlButtons(),
      ),
    );
  }
}
