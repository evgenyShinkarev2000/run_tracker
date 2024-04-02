import 'package:go_router/go_router.dart';

extension GoRouterAppExtension on GoRouter {

  bool currentRouteHas(String route) {
    final uriString = routeInformationProvider.value.uri.toString();

    return uriString.contains(route);
  }

  bool currentRouteEqual(String route) {
    final uriString = routeInformationProvider.value.uri.toString();

    return uriString.compareTo(route) == 0;
  }
}
