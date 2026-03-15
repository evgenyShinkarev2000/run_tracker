import 'package:flutter/material.dart';
import 'package:run_tracker/Components/Loader/ButtonLoader.dart';

class NavigationButton extends StatelessWidget {
  final bool isLoading;
  final NavigationButtonState state;
  final Function(NavigationButtonState state)? onStateChange;

  const NavigationButton({
    super.key,
    this.onStateChange,
    this.state = NavigationButtonState.Free,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      onPressed: _onPressed,
      iconSize: 32,
      icon: isLoading ? const ButtonLoader() : _getIconByState(),
    );
  }

  Widget _getIconByState() {
    return switch (state) {
      NavigationButtonState.Free => const Icon(Icons.location_searching),
      NavigationButtonState.Navigated => const Icon(Icons.near_me_outlined),
      NavigationButtonState.Locked => const Icon(Icons.navigation),
    };
  }

  void _onPressed() {
    if (isLoading) {
      return;
    }
    switch (state) {
      case NavigationButtonState.Free:
        onStateChange?.call(NavigationButtonState.Navigated);
        break;
      case NavigationButtonState.Navigated:
        onStateChange?.call(NavigationButtonState.Locked);
        break;
      case NavigationButtonState.Locked:
        onStateChange?.call(NavigationButtonState.Free);
        break;
    }
  }
}

enum NavigationButtonState { Free, Navigated, Locked }
