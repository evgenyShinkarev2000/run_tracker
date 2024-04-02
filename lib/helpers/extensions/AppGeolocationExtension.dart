import 'package:latlong2/latlong.dart';
import 'package:run_tracker/core/AppGeolocation.dart';

extension AppGeolocationExtension on AppGeolocation{
  LatLng toLatLng(){
    return LatLng(latitude, longitude);
  }
} 