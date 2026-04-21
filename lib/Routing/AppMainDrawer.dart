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
            path: AppRoutes.Pulse,
            title: context.appLocalization.menuPulse,
          ),
          DrawerItem(
            path: AppRoutes.Settings,
            title: context.appLocalization.menuSettings,
          ),
        ],
      ),
      // child: ListView(
      //   children: [
      //     AppDrawerItem(
      //       activities,
      //       onTap: goActivity,
      //       isActive: goRouter.currentRouteHas(Routes.activityPage),
      //     ),
      //     AppDrawerItem(
      //       map,
      //       onTap: goMap,
      //       isActive: goRouter.currentRouteHas(Routes.mapPage),
      //     ),
      //     AppDrawerItem(
      //       history,
      //       onTap: goHistory,
      //       isActive: goRouter.currentRouteHas(Routes.historyPage),
      //     ),
      //     AppDrawerItem(
      //       context.appLocalization.menuStatistic,
      //       onTap: goStatistic,
      //       isActive: goRouter.currentRouteHas(Routes.statisticPage),
      //     ),
      //     AppDrawerItem(
      //       context.appLocalization.menuPulse,
      //       onTap: goPulse,
      //       isActive: goRouter.currentRouteHas(Routes.pulsePage),
      //     ),
      //     AppDrawerItem(
      //       settings,
      //       onTap: goSetting,
      //       isActive: goRouter.currentRouteHas(Routes.settingPage),
      //     ),
      //     AppDrawerItem(
      //       "hive",
      //       onTap: goHive,
      //       isActive: goRouter.currentRouteHas(Routes.hivePage),
      //     ),
      //   ],
      // ),
    );
  }
}
