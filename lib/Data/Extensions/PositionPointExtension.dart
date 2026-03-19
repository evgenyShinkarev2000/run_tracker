import 'package:latlong2/latlong.dart';
import 'package:run_tracker/Data/Repositories/TrackRecord/export.dart';

extension PositionPointExtension on PositionPoint {
  LatLng toLatLng() {
    return LatLng(latitude ?? double.nan, longitude ?? double.nan);
  }

  bool get hasLatLng => latitude != null && longitude != null;
}
