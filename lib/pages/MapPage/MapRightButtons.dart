import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapRightButton extends StatelessWidget {
  final Function() onNavigateTap;
  final Function() onStopNavigateTap;
  final bool isNavigating;
  const MapRightButton(
      {super.key, required this.onNavigateTap,
      required this.isNavigating,
      required this.onStopNavigateTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              Spacer(flex: 5),
              isNavigating
                  ? IconButton(
                      onPressed: onNavigateTap,
                      icon: Icon(CupertinoIcons.location),
                    )
                  : null,
              !isNavigating
                  ? IconButton(
                      onPressed: onStopNavigateTap,
                      icon: Icon(CupertinoIcons.location_slash),
                    )
                  : null,
              Spacer(),
            ].nonNulls.toList(),
          ),
        ],
      ),
    );
  }
}
