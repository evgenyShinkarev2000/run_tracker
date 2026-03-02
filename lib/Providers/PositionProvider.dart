import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Data/Providers/export.dart';

final positionDataProvider = Provider<PositionDataProvider>((ref) {
  final provider = GeolocatorPositionDataProvider();
  ref.onDispose(provider.dispose);

  return provider;
});

final positionProvider = StreamProvider((ref) {
  final dataProvider = ref.watch(positionDataProvider);

  return dataProvider.stream;
});
