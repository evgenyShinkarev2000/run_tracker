import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/Router.dart';
import 'package:run_tracker/components/drawer/AppDrawerItem.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/helpers/GoRouterHelper.dart';

class AppMainDrawer extends StatelessWidget {
  const AppMainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final goRouter = GoRouter.of(context);
    final settings = context.appLocalization.menuSettings;
    final activities = context.appLocalization.menuActivities;
    final map = context.appLocalization.menuMap;
    final history = context.appLocalization.menuHistory;

    goSetting() => goRouter.go(Routes.settingPage);
    goActivity() => goRouter.go(Routes.activityPage);
    goMap() => goRouter.go(Routes.mapPage);
    goHistory() => goRouter.go(Routes.historyPage);
    goPulse() => goRouter.go(Routes.pulsePage);
    goStatistic() => goRouter.go(Routes.statisticPage);
    goHive() => goRouter.go(Routes.hivePage);

    return Drawer(
      child: ListView(
        children: [
          AppDrawerItem(
            activities,
            onTap: goActivity,
            isActive: goRouter.currentRouteHas(Routes.activityPage),
          ),
          AppDrawerItem(
            map,
            onTap: goMap,
            isActive: goRouter.currentRouteHas(Routes.mapPage),
          ),
          AppDrawerItem(
            history,
            onTap: goHistory,
            isActive: goRouter.currentRouteHas(Routes.historyPage),
          ),
          AppDrawerItem(
            context.appLocalization.menuStatistic,
            onTap: goStatistic,
            isActive: goRouter.currentRouteHas(Routes.statisticPage),
          ),
          AppDrawerItem(
            context.appLocalization.menuPulse,
            onTap: goPulse,
            isActive: goRouter.currentRouteHas(Routes.pulsePage),
          ),
          AppDrawerItem(
            settings,
            onTap: goSetting,
            isActive: goRouter.currentRouteHas(Routes.settingPage),
          ),
          AppDrawerItem(
            "hive",
            onTap: goHive,
            isActive: goRouter.currentRouteHas(Routes.hivePage),
          ),
        ],
      ),
    );
  }
}
