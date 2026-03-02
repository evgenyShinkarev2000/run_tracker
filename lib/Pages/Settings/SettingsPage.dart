import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Components/export.dart';
import 'package:run_tracker/Pages/Settings/DriftDbPage.dart';
import 'package:run_tracker/Pages/Settings/TalkerPage.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Routing/export.dart';
import 'package:run_tracker/Theme/export.dart';
import 'package:run_tracker/localization/export.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.themeData.colorScheme.inversePrimary,
        title: Text(context.appLocalization.menuMap),
      ),
      drawer: AppMainDrawer(),
      body: Center(
        child: ListView(
          children: [
            Consumer(
              builder: (context, ref, child) {
                final mapUri = ref.watch(mapUriTemplateProvider);
                final mapUriRepository = ref.watch(mapUriTemplateRepository);
                final messageService = ref.watch(messageServiceProvider);

                Future<bool> save(String? value) async {
                  if (value == null) {
                    messageService.warning(
                      context.appLocalization.validationValueMusntBeNull,
                    );
                    return false;
                  }
                  await mapUriRepository.Set(value);
                  return true;
                }

                Future<bool> reset() async {
                  await mapUriRepository.ResertToDefault();
                  return true;
                }

                return TextSetting(
                  name: "map uri",
                  iconData: Icons.map_outlined,
                  isLoading: mapUri.isLoading,
                  value: mapUri.value,
                  onSave: save,
                  onReset: reset,
                );
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                final appLocale = ref.watch(localeProvider);
                final repository = ref.watch(localeRepositoryProvider);

                Future<bool> save(AppLocale? locale) async {
                  await repository.Set(locale ?? AppLocales.fallback);

                  return true;
                }

                return SelectVariant<AppLocale>(
                  name: context.appLocalization.settingsLanguage,
                  iconData: Icons.language_outlined,
                  isLoading: appLocale.isLoading,
                  value: appLocale.value,
                  items: AppLocales.supported,
                  onSave: save,
                  builder: (locale) => Text(locale.displayName),
                );
              },
            ),
            SettingItem(
              name: "talker",
              onTap: () => _showTalkerPage(context),
              iconData: Icons.warning_amber,
            ),
            SettingItem(
              name: "db",
              onTap: () => _showDbPage(context),
              iconData: Icons.storage_outlined,
            ),
          ],
        ),
      ),
    );
  }

  void _showTalkerPage(BuildContext context) {
    showModalBottomSheet(
      routeSettings: RouteSettings(
        name: "${context.appRouter.state.path}/talker",
      ),
      context: context,
      constraints: BoxConstraints.expand(),
      isScrollControlled: true,
      builder: (context) {
        return TalkerPage();
      },
    );
  }

  void _showDbPage(BuildContext context) {
    showModalBottomSheet(
      routeSettings: RouteSettings(name: "${context.appRouter.state.path}/db"),
      context: context,
      constraints: BoxConstraints.expand(),
      isScrollControlled: true,
      builder: (context) {
        return DriftDbPage();
      },
    );
  }
}
