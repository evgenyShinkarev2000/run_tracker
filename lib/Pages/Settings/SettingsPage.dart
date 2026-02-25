import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Components/export.dart';
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
                  iconData: Icons.language_outlined,
                  isLoading: mapUri.isLoading,
                  value: mapUri.value,
                  onSave: save,
                  onReset: reset,
                );
              },
            ),
            SettingItem(
              name: "talker",
              onTap: () => _showTalkerPage(context),
              iconData: Icons.warning_amber,
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
      isScrollControlled: true,
      builder: (context) {
        return TalkerPage();
      },
    );
  }
}
