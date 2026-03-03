import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Components/Loader/export.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/export.dart';
import 'package:run_tracker/localization/export.dart';

class LocationPermissionDialog extends ConsumerStatefulWidget {
  const LocationPermissionDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LocationPermissionDialogState();
}

class _LocationPermissionDialogState
    extends ConsumerState<LocationPermissionDialog> {
  @override
  void initState() {
    super.initState();
    ref.read(locationPermissionServiceProvider).initialize();
  }

  @override
  Widget build(BuildContext context) {
    final locationPermissionService = ref.watch(
      locationPermissionServiceProvider,
    );
    final appLocationPermissionService = ref.watch(
      appLocationPermissionServiceProvider,
    );
    final asyncDetailedLocationPermission = ref.watch(
      locationPermissionProvider,
    );

    if (!asyncDetailedLocationPermission.hasValue) {
      return AppLoader();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _getMessageByPermission(
          context,
          asyncDetailedLocationPermission.requireValue.toSimple(),
        ),
        TextButton(
          onPressed: locationPermissionService.initialize,
          child: Text(context.appLocalization.locationPermissionButtonRefresh),
        ),
        TextButton(
          onPressed: locationPermissionService.requestPermission,
          child: Text(
            context.appLocalization.locationPermissionButtonRequestPermission,
          ),
        ),
        TextButton(
          onPressed: () => appLocationPermissionService.setLocationRequirement(
            LocationRequirement.SilentUse,
          ),
          child: Text(context.appLocalization.locationPermissionButtonIgnore),
        ),
      ],
    );
  }

  Widget _getMessageByPermission(
    BuildContext context,
    SimpleLocationPermission permission,
  ) {
    final text = switch (permission) {
      SimpleLocationPermission.Loading =>
        context.appLocalization.locationPermissionMessageLoading,
      SimpleLocationPermission.Denied =>
        context.appLocalization.locationPermissionMessageDenied,
      SimpleLocationPermission.Permited =>
        context.appLocalization.locationPermissionMessagePermited,
    };

    return Text(text);
  }
}
