import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';

class MapTileLayer extends StatelessWidget {
  const MapTileLayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      tileProvider: CachedTileProvider(
        maxStale: Duration(days: 360),
        store: HiveCacheStore(
          null,
          hiveBoxName: "dio_cache",
        ),
      ),
      userAgentPackageName: 'com.example.app',
    );
  }
}
