import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Components/export.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Providers/Settings/export.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/export.dart';
import 'package:run_tracker/localization/BuildContextExtension.dart';

class LocationPermissionPage extends StatelessWidget {
  const LocationPermissionPage({super.key});
  //TODO можно сделать красивее
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.appLocalization.settingLocation)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Consumer(
            builder: (context, ref, child) {
              final permission = ref.watch(locationPermissionProvider);
              final requirement = ref.watch(locationRequirementProvider);
              if (!permission.hasValue || !requirement.hasValue) {
                return AppLoader();
              }

              final locationService = ref.watch(
                positionServiceProvider,
              );
              final appLocationService = ref.watch(
                appLocationPermissionServiceProvider,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Text("Simple status: ${permission.requireValue.toSimple()}"),
                  Text("Detailed status: ${permission.requireValue}"),
                  Row(
                    spacing: 10,
                    children: [
                      Text("Use geolocation"),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: LocationRequirement.values
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.name),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              appLocationService.setLocationRequirement(v);
                            }
                          },
                          value: requirement.requireValue,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: locationService.initializePermission,
                        child: Text(
                          context
                              .appLocalization
                              .locationPermissionButtonRefresh,
                        ),
                      ),
                      TextButton(
                        onPressed: locationService.requestPermission,
                        child: Text(
                          context
                              .appLocalization
                              .locationPermissionButtonRequestPermission,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
