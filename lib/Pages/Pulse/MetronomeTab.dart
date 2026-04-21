import 'package:flutter/material.dart';

class MetronomeTab extends StatefulWidget {
  const MetronomeTab({super.key});

  @override
  State<MetronomeTab> createState() => _MetronomeTabState();
}

class _MetronomeTabState extends State<MetronomeTab> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("metronome"));
  }
}
