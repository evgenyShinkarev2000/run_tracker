import 'package:flutter/material.dart';
import 'package:run_tracker/Components/Map/Components/export.dart';

class RightPanel extends StatelessWidget {
  final bool isNavigationLoading;
  final NavigationButtonState navigationState;
  final void Function(NavigationButtonState state) onNavigationStateChange;

  const RightPanel({
    super.key,
    required this.onNavigationStateChange,
    required this.isNavigationLoading,
    required this.navigationState,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NavigationButton(
              state: navigationState,
              onStateChange: onNavigationStateChange,
              isLoading: isNavigationLoading,
            ),
          ],
        ),
      ],
    );
  }
}
