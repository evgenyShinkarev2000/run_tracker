import 'package:flutter/material.dart';

class RunCoverCardLabel extends StatelessWidget{
  final String label;
  final String value;

  const RunCoverCardLabel({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(label),
      Spacer(),
      Text(value),
    ],);
  }

}