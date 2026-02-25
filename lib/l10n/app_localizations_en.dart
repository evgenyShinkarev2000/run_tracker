// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get menuMain => 'main';

  @override
  String get menuActivities => 'activities';

  @override
  String get menuSettings => 'settings';

  @override
  String get menuMap => 'map';

  @override
  String get menuHistory => 'history';

  @override
  String get menuPulse => 'pulse';

  @override
  String get menuStatistic => 'statistics';

  @override
  String get dashSpeed => 'speed';

  @override
  String get dashPace => 'pace';

  @override
  String get dashTime => 'time';

  @override
  String get dashDistance => 'distance';

  @override
  String get runCardCoverName => 'name';

  @override
  String get runCardCoverSpeed => 'speed';

  @override
  String get runCardCoverBeginDateTime => 'begin';

  @override
  String get runCardCoverDuration => 'duration';

  @override
  String get runCardCoverDistance => 'distance';

  @override
  String get runCardCoverPace => 'pace';

  @override
  String get runcardCoverPulse => 'pulse';

  @override
  String get stopRecordingDialogQuestion => 'stop recording?';

  @override
  String saveRecordDialogTitleValidatorMessage(int length) {
    return 'title length must be longer $length';
  }

  @override
  String get unitShortKm => 'km';

  @override
  String get unitShortM => 'm';

  @override
  String get unitShortSecond => 's';

  @override
  String get unitShortMinute => 'min';

  @override
  String get unitShortHour => 'h';

  @override
  String get unitShortKmPerHour => 'km/h';

  @override
  String get unitShortMinPerKm => 'min/km';

  @override
  String get unitShortBPM => 'bpm';

  @override
  String get nounDistance => 'distance';

  @override
  String get nounTime => 'time';

  @override
  String get nounInterval => 'interval';

  @override
  String get nounSpeed => 'speed';

  @override
  String get nounPace => 'pace';

  @override
  String get nounUnits => 'units';

  @override
  String get nounPulse => 'pulse';

  @override
  String get nounCancel => 'cancel';

  @override
  String get nounError => 'error';

  @override
  String get nounNoData => 'no data';

  @override
  String get nounHeight => 'height';

  @override
  String get nounWeek => 'week';

  @override
  String get nounMonth => 'month';

  @override
  String get nounYear => 'year';

  @override
  String get verbCanfirm => 'confirm';

  @override
  String get verbCancel => 'cancel';

  @override
  String get verbSave => 'save';

  @override
  String get verbRemove => 'remove';

  @override
  String get verbExport => 'export';

  @override
  String get runRecordBarIntervalType => 'interval type';

  @override
  String get pulseMeasureTabMetronome => 'metronome';

  @override
  String get pulseMeasureTabCamera => 'camera';

  @override
  String get pulseMeasureCameraInstructionInitial =>
      'press your finger firmly against the camera and flash';

  @override
  String get pulseMeasureTabTimer => 'timer';

  @override
  String get pulseMeasureTabManual => 'manual';

  @override
  String get pulseMeasureMetronomIntructionClickAtDrum =>
      'touch the drum for every heartbeat';

  @override
  String get settingsLanguage => 'language';

  @override
  String get settingsTheme => 'theme';

  @override
  String get settingVariantDialogButtonDefault => 'by default';

  @override
  String get settingVariantThemeLigth => 'light';

  @override
  String get settingVariantThemeDark => 'dark';

  @override
  String get historyPageNoRecords => 'no records';

  @override
  String get runRecordPageShare => 'share';

  @override
  String get runRecordPageShareError => 'service is unavailable';

  @override
  String get locationPermissionMessageLoading =>
      'obtaining the status of geolocation services';

  @override
  String get locationPermissionMessagePermited =>
      'the application has access to geolocation services';

  @override
  String get locationPermissionMessageDenied =>
      'the app is denied access to location services';

  @override
  String get locationPermissionButtonRefresh => 'refresh';

  @override
  String get locationPermissionButtonRequestPermission => 'request permission';

  @override
  String get locationPermissionButtonIgnore => 'ignore';

  @override
  String get validationValueMusntBeNull => 'value musn\'t be null';
}
