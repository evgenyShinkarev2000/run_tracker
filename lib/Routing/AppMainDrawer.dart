import 'package:flutter/material.dart';
import 'package:run_tracker/Routing/AppRoutes.dart';
import 'package:run_tracker/Routing/DrawerItem.dart';
import 'package:run_tracker/localization/export.dart';

class AppMainDrawer extends StatelessWidget {
  const AppMainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerItem(path: "/", title: context.appLocalization.menuMain),
          DrawerItem(
            path: AppRoutes.Map,
            title: context.appLocalization.menuMap,
          ),
          DrawerItem(
            path: AppRoutes.History,
            title: context.appLocalization.menuHistory,
          ),
          DrawerItem(
            path: AppRoutes.Statistics,
            title: context.appLocalization.menuStatistic,
          ),
          DrawerItem(
            path: AppRoutes.Pulse,
            title: context.appLocalization.menuPulse,
          ),
          DrawerItem(
            path: AppRoutes.Settings,
            title: context.appLocalization.menuSettings,
          ),
        ],
      ),
    );
  }
}
