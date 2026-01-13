import 'package:go_router/go_router.dart';
import 'package:run_tracker/Pages/export.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => MyHomePage()),
    GoRoute(path: '/Map', builder: (context, state) => MapPage()),
  ],
);
