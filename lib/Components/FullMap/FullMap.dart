import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Components/export.dart';
import 'package:run_tracker/Providers/export.dart';

class FullMap extends ConsumerWidget {
  const FullMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final urlTempalte = ref.watch(mapUriTemplateProvider);
    if (urlTempalte.isLoading) {
      return AppLoader();
    }

    return FlutterMap(
      options: MapOptions(interactionOptions: InteractionOptions()),
      children: [
        TileLayer(
          urlTemplate: urlTempalte.value,
          userAgentPackageName: "run_tracker",
          tileProvider: NetworkTileProvider(
            cachingProvider: BuiltInMapCachingProvider.getOrCreateInstance(),
          ),
        ),
      ],
    );
  }
}
