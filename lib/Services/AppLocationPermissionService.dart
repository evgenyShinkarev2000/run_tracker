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

  final LocationPermissionService _locationService;
  final LocationRequirementRepository _locationRequirementRepository;

  final BehaviorSubject<AppLocationPermission> _behaviorSubject =
      BehaviorSubject.seeded(AppLocationPermission.Loading);

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
    _behaviorSubject.close();
    _permissionSubscription.cancel();
    _requirementSubscription.cancel();
  }

  Future<void> setLocationRequirement(LocationRequirement requirement) async {
    await _locationRequirementRepository.Set(requirement);
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
        _behaviorSubject.add(AppLocationPermission.Ignore);
        break;
      case LocationRequirement.Require:
        _behaviorSubject.add(
          _simplePermissionToAppPermission(_lastSimplePermission),
        );
        break;
      case null:
        if (_behaviorSubject.value != AppLocationPermission.Loading) {
          _behaviorSubject.add(AppLocationPermission.Loading);
        }
        break;
    }
  }

  static AppLocationPermission _simplePermissionToAppPermission(
    SimpleLocationPermission permission,
  ) {
    return switch (permission) {
      SimpleLocationPermission.Loading => AppLocationPermission.Loading,
      SimpleLocationPermission.Permited => AppLocationPermission.Permited,
      SimpleLocationPermission.Denied => AppLocationPermission.Denied,
    };
  }
}

enum AppLocationPermission { Loading, Denied, Permited, Ignore }

extension AppLocationPermissionExtension on AppLocationPermission {
  bool get needShowDialog => switch (this) {
    AppLocationPermission.Loading || AppLocationPermission.Denied => true,
    AppLocationPermission.Permited || AppLocationPermission.Ignore => false,
  };
}
