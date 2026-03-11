import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Services/export.dart';
import 'package:rxdart/subjects.dart';

class AppLocationPermissionService
    implements IStreamProvider<AppLocationPermission>, IDisposable {
  @override
  Stream<AppLocationPermission> get stream => _behaviorSubject.stream;
  AppLocationPermission get state => _behaviorSubject.value;

  Stream<bool> get needShowDialogStream => _needShowDialogSubject.stream;
  bool get needShowDialog => _needShowDialogSubject.value;

  final LocationPermissionService _locationService;
  final LocationRequirementRepository _locationRequirementRepository;

  final BehaviorSubject<AppLocationPermission> _behaviorSubject =
      BehaviorSubject.seeded(AppLocationPermission.Loading);
  final BehaviorSubject<bool> _needShowDialogSubject = BehaviorSubject.seeded(
    true,
  );

  late final StreamSubscription<DetailedLocationPermission>
  _permissionSubscription;
  late final StreamSubscription<LocationRequirement> _requirementSubscription;

  SimpleLocationPermission _lastSimplePermission =
      SimpleLocationPermission.Loading;
  LocationRequirement? _lastLocationRequirement;

  AppLocationPermissionService(
    this._locationService,
    this._locationRequirementRepository,
  ) {
    _permissionSubscription = _locationService.stream.listen(
      _receiveDetailedLocationPermission,
    );
    _requirementSubscription = _locationRequirementRepository.stream.listen(
      _receiveLocationRequirement,
    );
  }

  @override
  @mustCallSuper
  void dispose() {
    _needShowDialogSubject.close();
    _behaviorSubject.close();
    _permissionSubscription.cancel();
    _requirementSubscription.cancel();
  }

  Future<void> setLocationRequirement(LocationRequirement requirement) async {
    await _locationRequirementRepository.Set(requirement);
  }

  bool _needShowLocationDialog() {
    return switch (_lastLocationRequirement) {
      null => true,
      LocationRequirement.RequireAndUse =>
        switch (_locationService.SimpleState) {
          SimpleLocationPermission.Denied ||
          SimpleLocationPermission.Loading => true,
          SimpleLocationPermission.Permited => false,
        },
      LocationRequirement.SilentUse || LocationRequirement.Ignore => false,
    };
  }

  void _receiveDetailedLocationPermission(
    DetailedLocationPermission permission,
  ) {
    final simplePermission = permission.toSimple();
    if (simplePermission == _lastSimplePermission) {
      return;
    }
    _lastSimplePermission = simplePermission;
    _updateState();
  }

  void _receiveLocationRequirement(LocationRequirement requirement) {
    if (_lastLocationRequirement == requirement) {
      return;
    }
    _lastLocationRequirement = requirement;
    _updateState();
  }

  void _updateState() {
    switch (_lastLocationRequirement) {
      case LocationRequirement.Ignore:
        _behaviorSubject.add(AppLocationPermission.Disabled);
        break;
      case LocationRequirement.RequireAndUse || LocationRequirement.SilentUse:
        _behaviorSubject.add(AppLocationPermission.Enabled);
        break;
      case null:
        if (_behaviorSubject.value != AppLocationPermission.Loading) {
          _behaviorSubject.add(AppLocationPermission.Loading);
        }
        break;
    }

    final needShowLocationDialog = _needShowLocationDialog();
    if (needShowLocationDialog != _needShowDialogSubject.value) {
      _needShowDialogSubject.add(needShowLocationDialog);
    }
  }
}

/// Учитывает настройки приложения
enum AppLocationPermission { Loading, Enabled, Disabled }
