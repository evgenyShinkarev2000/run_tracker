import 'package:go_router/go_router.dart';
import 'package:run_tracker/Pages/TrackHistory/export.dart';
import 'package:run_tracker/Pages/export.dart';
import 'package:run_tracker/Routing/AppRoutes.dart';
import 'package:talker_flutter/talker_flutter.dart';

final List<RouteBase> appRoutes = [
  GoRoute(path: '/', builder: (context, state) => MyHomePage()),
  GoRoute(path: AppRoutes.Map, builder: (context, state) => MapPage()),
  GoRoute(
    path: AppRoutes.Settings,
    builder: (context, state) => SettingsPage(),
  ),
  GoRoute(
    path: AppRoutes.History,
    builder: (context, state) => TrackHistoryPage(),
  ),
];

GoRouter buildAppRouter(Talker talker) {
  return GoRouter(routes: appRoutes, observers: [TalkerRouteObserver(talker)]);
}
