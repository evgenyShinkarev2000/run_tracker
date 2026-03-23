import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Components/Loader/export.dart';
import 'package:run_tracker/Providers/Track/export.dart';
import 'package:run_tracker/Services/Track/export.dart';

class ControlButtons extends ConsumerStatefulWidget {
  const ControlButtons({super.key});

  @override
  ConsumerState<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends ConsumerState<ControlButtons> {
  @override
  Widget build(BuildContext context) {
    final trackState = ref.watch(trackStateProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 32,
      children: _buildButtons(trackState),
    );
  }

  List<Widget> _buildButtons(TrackState state) {
    switch (state) {
      case TrackState.Loading || TrackState.Aborted || TrackState.Completed:
        return [
          const ButtonLoader(),
        ];
      case TrackState.Ready:
        return [_buildButton(_start, Icons.play_arrow_outlined)];
      case TrackState.Running:
        return [
          SizedBox(width: 32),
          _buildButton(_pause, Icons.pause),
          _buildButton(_pulse, Icons.monitor_heart_outlined),
        ];
      case TrackState.Paused:
        return [
          _buildButton(_stop, Icons.stop),
          _buildButton(_resume, Icons.play_arrow_outlined),
          _buildButton(_pulse, Icons.monitor_heart_outlined),
        ];
    }
  }

  static Widget _buildButton(VoidCallback onPressed, IconData iconData) {
    return IconButton.outlined(
      onPressed: onPressed,
      icon: Icon(iconData),
      iconSize: 32,
    );
  }

  void _start() async {
    await ref.read(trackManagerProvider).start();
  }

  void _pause() async {
    await ref.read(trackManagerProvider).pause();
  }

  void _resume() async {
    await ref.read(trackManagerProvider).resume();
  }

  void _stop() async {
    await ref.read(trackManagerProvider).complete();
    //TODO переход к треку
  }

  void _pulse() {}
}
