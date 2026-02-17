import 'package:latlong2/latlong.dart';
import 'package:run_tracker/Data/export.dart';

extension AppPositionExtension on AppPosition{
  LatLng ToLatLng(){
    return LatLng(latitude?.value ?? double.nan, longitude?.value ?? double.nan);
  }

  bool get HasLatLng => latitude != null && longitude != null;
}