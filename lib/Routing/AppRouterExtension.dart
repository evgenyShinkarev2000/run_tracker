import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/Routing/AppRoutes.dart';

extension BuildContextExtension on BuildContext {
  GoRouter get appRouter => GoRouter.of(this);
}

extension GoRouterExtension on GoRouter {
  void goHome() => go("/");
  void goMap() => go(AppRoutes.Map);
  void goHistory() => go(AppRoutes.History);
}
