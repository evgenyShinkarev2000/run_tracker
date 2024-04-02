import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapContribution extends StatelessWidget {
  const MapContribution({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichAttributionWidget(
      attributions: [
        TextSourceAttribution(
          "OpenStreetMap contribution",
          onTap: () => launchUrlString(
              'https://openstreetmap.org/copyright'),
        ),
      ],
    );
  }
}
