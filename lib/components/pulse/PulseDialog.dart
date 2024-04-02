import 'package:flutter/material.dart';
import 'package:run_tracker/components/pulse/PulseInnerContent.dart';

class PulseDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(8),
      titlePadding: EdgeInsets.all(8),
      iconPadding: EdgeInsets.all(8),
      actionsPadding: EdgeInsets.all(8),
      contentPadding: EdgeInsets.all(8),
      content: PulseInnerContent(),
    );
  }
}
