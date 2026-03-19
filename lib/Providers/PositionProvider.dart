import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/Position/export.dart';

final positionStreamProvider = Provider<PositionProvider>((ref) {
  final provider = AdapterPositionProvider(ref.watch(positionServiceProvider));

  return provider;
});

final positionProvider = StreamProvider((ref) {
  final dataProvider = ref.watch(positionStreamProvider);

  return dataProvider.stream;
});
