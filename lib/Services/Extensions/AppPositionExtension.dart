import 'package:latlong2/latlong.dart';
import 'package:run_tracker/Services/Position/export.dart';

extension AppPositionExtension on AppPosition{
  LatLng toLatLng(){
    return LatLng(latitude?.value ?? double.nan, longitude?.value ?? double.nan);
  }

  bool get hasLatLng => latitude != null && longitude != null;
}