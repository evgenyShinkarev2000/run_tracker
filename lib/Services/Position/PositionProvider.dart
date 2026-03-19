import 'package:run_tracker/Data/Contracts/export.dart';
import 'package:run_tracker/Services/Position/export.dart';

abstract class PositionProvider implements IStreamProvider<AppPosition> {}

class AdapterPositionProvider extends PositionProvider {
  @override
  Stream<AppPosition> get stream => _positionService.positionStream;

  final PositionService _positionService;

  AdapterPositionProvider(this._positionService);
}
