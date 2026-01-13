import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/Routing/AppRouterExtension.dart';
import 'package:run_tracker/Routing/DrawerItemView.dart';

class Draweritem extends StatelessWidget {
  final String path;
  final int layer;
  final String title;

  const Draweritem({
    super.key,
    required this.path,
    required this.title,
    this.layer = 0,
  });
  @override
  Widget build(BuildContext context) {
    final uri = context.appRouter.routeInformationProvider.value.uri;

    return DrawerItemView(
      title,
      isActive: _isActive(uri),
      onTap: () => context.go(path),
    );
  }

  bool _isActive(Uri uri) {
    if (uri.pathSegments.length <= layer) {
      return false;
    }

    return uri.pathSegments[layer] == path;
  }
}
