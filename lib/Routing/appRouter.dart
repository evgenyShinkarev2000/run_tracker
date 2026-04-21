import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/Pages/Pulse/export.dart';
import 'package:run_tracker/Pages/TrackHistory/export.dart';
import 'package:run_tracker/Pages/TrackRecord/export.dart';
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
  GoRoute(
    path: "${AppRoutes.TrackRecord}/:trackRecordId",
    builder: (context, state) {
      final stringId = state.pathParameters["trackRecordId"];
      final id = stringId == null ? null : int.tryParse(stringId);

      return TrackRecordPage(trackRecordId: id);
    },
  ),
  GoRoute(path: AppRoutes.Pulse, builder: (context, state) => PulsePage()),
];

final rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: "instance rootNavigatorKey of GlobalKey<NavigatorState>",
);

GoRouter buildAppRouter(Talker talker) {
  return GoRouter(
    routes: appRoutes,
    observers: [TalkerRouteObserver(talker)],
    navigatorKey: rootNavigatorKey,
  );
}
