import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @menuMain.
  ///
  /// In en, this message translates to:
  /// **'main'**
  String get menuMain;

  /// No description provided for @menuActivities.
  ///
  /// In en, this message translates to:
  /// **'activities'**
  String get menuActivities;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'settings'**
  String get menuSettings;

  /// No description provided for @menuMap.
  ///
  /// In en, this message translates to:
  /// **'map'**
  String get menuMap;

  /// No description provided for @menuHistory.
  ///
  /// In en, this message translates to:
  /// **'history'**
  String get menuHistory;

  /// No description provided for @menuPulse.
  ///
  /// In en, this message translates to:
  /// **'pulse'**
  String get menuPulse;

  /// No description provided for @menuStatistic.
  ///
  /// In en, this message translates to:
  /// **'statistics'**
  String get menuStatistic;

  /// No description provided for @dashSpeed.
  ///
  /// In en, this message translates to:
  /// **'speed'**
  String get dashSpeed;

  /// No description provided for @dashPace.
  ///
  /// In en, this message translates to:
  /// **'pace'**
  String get dashPace;

  /// No description provided for @dashTime.
  ///
  /// In en, this message translates to:
  /// **'time'**
  String get dashTime;

  /// No description provided for @dashDistance.
  ///
  /// In en, this message translates to:
  /// **'distance'**
  String get dashDistance;

  /// No description provided for @runCardCoverName.
  ///
  /// In en, this message translates to:
  /// **'name'**
  String get runCardCoverName;

  /// No description provided for @runCardCoverSpeed.
  ///
  /// In en, this message translates to:
  /// **'speed'**
  String get runCardCoverSpeed;

  /// No description provided for @runCardCoverBeginDateTime.
  ///
  /// In en, this message translates to:
  /// **'begin'**
  String get runCardCoverBeginDateTime;

  /// No description provided for @runCardCoverEndDateTime.
  ///
  /// In en, this message translates to:
  /// **'end'**
  String get runCardCoverEndDateTime;

  /// No description provided for @runCardCoverDuration.
  ///
  /// In en, this message translates to:
  /// **'duration'**
  String get runCardCoverDuration;

  /// No description provided for @runCardCoverDistance.
  ///
  /// In en, this message translates to:
  /// **'distance'**
  String get runCardCoverDistance;

  /// No description provided for @runCardCoverPace.
  ///
  /// In en, this message translates to:
  /// **'pace'**
  String get runCardCoverPace;

  /// No description provided for @runcardCoverPulse.
  ///
  /// In en, this message translates to:
  /// **'pulse'**
  String get runcardCoverPulse;

  /// No description provided for @stopRecordingDialogQuestion.
  ///
  /// In en, this message translates to:
  /// **'stop recording?'**
  String get stopRecordingDialogQuestion;

  /// No description provided for @saveRecordDialogTitleValidatorMessage.
  ///
  /// In en, this message translates to:
  /// **'title length must be longer {length}'**
  String saveRecordDialogTitleValidatorMessage(int length);

  /// No description provided for @unitShortKm.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get unitShortKm;

  /// No description provided for @unitShortM.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get unitShortM;

  /// No description provided for @unitShortSecond.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get unitShortSecond;

  /// No description provided for @unitShortMinute.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get unitShortMinute;

  /// No description provided for @unitShortHour.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get unitShortHour;

  /// No description provided for @unitShortKmPerHour.
  ///
  /// In en, this message translates to:
  /// **'km/h'**
  String get unitShortKmPerHour;

  /// No description provided for @unitShortMinPerKm.
  ///
  /// In en, this message translates to:
  /// **'min/km'**
  String get unitShortMinPerKm;

  /// No description provided for @unitShortBPM.
  ///
  /// In en, this message translates to:
  /// **'bpm'**
  String get unitShortBPM;

  /// No description provided for @nounDistance.
  ///
  /// In en, this message translates to:
  /// **'distance'**
  String get nounDistance;

  /// No description provided for @nounTime.
  ///
  /// In en, this message translates to:
  /// **'time'**
  String get nounTime;

  /// No description provided for @nounInterval.
  ///
  /// In en, this message translates to:
  /// **'interval'**
  String get nounInterval;

  /// No description provided for @nounSpeed.
  ///
  /// In en, this message translates to:
  /// **'speed'**
  String get nounSpeed;

  /// No description provided for @nounPace.
  ///
  /// In en, this message translates to:
  /// **'pace'**
  String get nounPace;

  /// No description provided for @nounUnits.
  ///
  /// In en, this message translates to:
  /// **'units'**
  String get nounUnits;

  /// No description provided for @nounPulse.
  ///
  /// In en, this message translates to:
  /// **'pulse'**
  String get nounPulse;

  /// No description provided for @nounCancel.
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get nounCancel;

  /// No description provided for @nounError.
  ///
  /// In en, this message translates to:
  /// **'error'**
  String get nounError;

  /// No description provided for @nounNoData.
  ///
  /// In en, this message translates to:
  /// **'no data'**
  String get nounNoData;

  /// No description provided for @nounHeight.
  ///
  /// In en, this message translates to:
  /// **'height'**
  String get nounHeight;

  /// No description provided for @nounWeek.
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get nounWeek;

  /// No description provided for @nounMonth.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get nounMonth;

  /// No description provided for @nounYear.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get nounYear;

  /// No description provided for @verbConfirm.
  ///
  /// In en, this message translates to:
  /// **'confirm'**
  String get verbConfirm;

  /// No description provided for @verbContinue.
  ///
  /// In en, this message translates to:
  /// **'continue'**
  String get verbContinue;

  /// No description provided for @verbCancel.
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get verbCancel;

  /// No description provided for @verbSave.
  ///
  /// In en, this message translates to:
  /// **'save'**
  String get verbSave;

  /// No description provided for @verbRemove.
  ///
  /// In en, this message translates to:
  /// **'remove'**
  String get verbRemove;

  /// No description provided for @verbExport.
  ///
  /// In en, this message translates to:
  /// **'export'**
  String get verbExport;

  /// No description provided for @runRecordBarIntervalType.
  ///
  /// In en, this message translates to:
  /// **'interval type'**
  String get runRecordBarIntervalType;

  /// No description provided for @pulseMeasureTabMetronome.
  ///
  /// In en, this message translates to:
  /// **'metronome'**
  String get pulseMeasureTabMetronome;

  /// No description provided for @pulseMeasureTabCamera.
  ///
  /// In en, this message translates to:
  /// **'camera'**
  String get pulseMeasureTabCamera;

  /// No description provided for @pulseMeasureCameraInstructionInitial.
  ///
  /// In en, this message translates to:
  /// **'press your finger firmly against the camera and flash'**
  String get pulseMeasureCameraInstructionInitial;

  /// No description provided for @pulseMeasureTabTimer.
  ///
  /// In en, this message translates to:
  /// **'timer'**
  String get pulseMeasureTabTimer;

  /// No description provided for @pulseMeasureTabManual.
  ///
  /// In en, this message translates to:
  /// **'manual'**
  String get pulseMeasureTabManual;

  /// No description provided for @pulseMeasureMetronomInstructionClickAtDrum.
  ///
  /// In en, this message translates to:
  /// **'touch the screen for every heartbeat'**
  String get pulseMeasureMetronomInstructionClickAtDrum;

  /// No description provided for @pulseMeasureManualInstruction.
  ///
  /// In en, this message translates to:
  /// **'enter pulse'**
  String get pulseMeasureManualInstruction;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'theme'**
  String get settingsTheme;

  /// No description provided for @settingVariantDialogButtonDefault.
  ///
  /// In en, this message translates to:
  /// **'by default'**
  String get settingVariantDialogButtonDefault;

  /// No description provided for @settingVariantThemeLigth.
  ///
  /// In en, this message translates to:
  /// **'light'**
  String get settingVariantThemeLigth;

  /// No description provided for @settingVariantThemeDark.
  ///
  /// In en, this message translates to:
  /// **'dark'**
  String get settingVariantThemeDark;

  /// No description provided for @settingLocation.
  ///
  /// In en, this message translates to:
  /// **'geolocation'**
  String get settingLocation;

  /// No description provided for @settingDevMode.
  ///
  /// In en, this message translates to:
  /// **'developer mode'**
  String get settingDevMode;

  /// No description provided for @historyPageNoRecords.
  ///
  /// In en, this message translates to:
  /// **'no records'**
  String get historyPageNoRecords;

  /// No description provided for @historyPageCreateRecord.
  ///
  /// In en, this message translates to:
  /// **'record a track'**
  String get historyPageCreateRecord;

  /// No description provided for @runRecordBuildingScreenshot.
  ///
  /// In en, this message translates to:
  /// **'building screenshot'**
  String get runRecordBuildingScreenshot;

  /// No description provided for @runRecordPageShare.
  ///
  /// In en, this message translates to:
  /// **'share'**
  String get runRecordPageShare;

  /// No description provided for @runRecordSaveAsImage.
  ///
  /// In en, this message translates to:
  /// **'save as image'**
  String get runRecordSaveAsImage;

  /// No description provided for @runRecordPageShareError.
  ///
  /// In en, this message translates to:
  /// **'failed to share'**
  String get runRecordPageShareError;

  /// No description provided for @locationPermissionMessageLoading.
  ///
  /// In en, this message translates to:
  /// **'obtaining the status of geolocation services'**
  String get locationPermissionMessageLoading;

  /// No description provided for @locationPermissionMessagePermited.
  ///
  /// In en, this message translates to:
  /// **'the application has access to geolocation services'**
  String get locationPermissionMessagePermited;

  /// No description provided for @locationPermissionMessageDenied.
  ///
  /// In en, this message translates to:
  /// **'the app is denied access to location services'**
  String get locationPermissionMessageDenied;

  /// No description provided for @locationPermissionMessageIgnore.
  ///
  /// In en, this message translates to:
  /// **'the application does not use geolocation'**
  String get locationPermissionMessageIgnore;

  /// No description provided for @locationPermissionButtonRefresh.
  ///
  /// In en, this message translates to:
  /// **'refresh'**
  String get locationPermissionButtonRefresh;

  /// No description provided for @locationPermissionButtonRequestPermission.
  ///
  /// In en, this message translates to:
  /// **'request permission'**
  String get locationPermissionButtonRequestPermission;

  /// No description provided for @locationPermissionButtonIgnore.
  ///
  /// In en, this message translates to:
  /// **'ignore'**
  String get locationPermissionButtonIgnore;

  /// No description provided for @validationValueMusntBeNull.
  ///
  /// In en, this message translates to:
  /// **'value musn\'t be null'**
  String get validationValueMusntBeNull;

  /// No description provided for @trackRecordAbortDialogContent.
  ///
  /// In en, this message translates to:
  /// **'the recording was interrupted'**
  String get trackRecordAbortDialogContent;

  /// No description provided for @importGPX.
  ///
  /// In en, this message translates to:
  /// **'import GPX'**
  String get importGPX;

  /// No description provided for @importPickGPXFile.
  ///
  /// In en, this message translates to:
  /// **'pick GPX file'**
  String get importPickGPXFile;

  /// No description provided for @importNoFile.
  ///
  /// In en, this message translates to:
  /// **'no file selected'**
  String get importNoFile;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'import failed'**
  String get importFailed;

  /// No description provided for @chartMenuOutlierFilter.
  ///
  /// In en, this message translates to:
  /// **'outlier filter'**
  String get chartMenuOutlierFilter;

  /// No description provided for @chartMenuShowMarkers.
  ///
  /// In en, this message translates to:
  /// **'show markers'**
  String get chartMenuShowMarkers;

  /// No description provided for @chartMenuResolutionFilter.
  ///
  /// In en, this message translates to:
  /// **'resolution filter'**
  String get chartMenuResolutionFilter;

  /// No description provided for @chartMenuDownsampling.
  ///
  /// In en, this message translates to:
  /// **'down sampling'**
  String get chartMenuDownsampling;

  /// No description provided for @confirmRemoveRequest.
  ///
  /// In en, this message translates to:
  /// **'confirm deletion'**
  String get confirmRemoveRequest;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
