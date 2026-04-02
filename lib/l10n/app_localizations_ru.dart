// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get menuMain => 'главная';

  @override
  String get menuActivities => 'активности';

  @override
  String get menuSettings => 'настройки';

  @override
  String get menuMap => 'карта';

  @override
  String get menuHistory => 'история';

  @override
  String get menuPulse => 'пульс';

  @override
  String get menuStatistic => 'статистика';

  @override
  String get dashSpeed => 'скорость';

  @override
  String get dashPace => 'темп';

  @override
  String get dashTime => 'время';

  @override
  String get dashDistance => 'дистанция';

  @override
  String get runCardCoverName => 'название';

  @override
  String get runCardCoverSpeed => 'скорость';

  @override
  String get runCardCoverBeginDateTime => 'начало';

  @override
  String get runCardCoverEndDateTime => 'конец';

  @override
  String get runCardCoverDuration => 'длительность';

  @override
  String get runCardCoverDistance => 'дистанция';

  @override
  String get runCardCoverPace => 'темп';

  @override
  String get runcardCoverPulse => 'пульс';

  @override
  String get stopRecordingDialogQuestion => 'остановить запись?';

  @override
  String saveRecordDialogTitleValidatorMessage(int length) {
    return 'Название должно быть длинее $length';
  }

  @override
  String get unitShortKm => 'км';

  @override
  String get unitShortM => 'м';

  @override
  String get unitShortSecond => 'с';

  @override
  String get unitShortMinute => 'мин';

  @override
  String get unitShortHour => 'ч';

  @override
  String get unitShortKmPerHour => 'км/ч';

  @override
  String get unitShortMinPerKm => 'мин/км';

  @override
  String get unitShortBPM => 'уд/мин';

  @override
  String get nounDistance => 'дистанция';

  @override
  String get nounTime => 'время';

  @override
  String get nounInterval => 'интервал';

  @override
  String get nounSpeed => 'скорость';

  @override
  String get nounPace => 'темп';

  @override
  String get nounUnits => 'единицы измерения';

  @override
  String get nounPulse => 'пульс';

  @override
  String get nounCancel => 'отмена';

  @override
  String get nounError => 'ошибка';

  @override
  String get nounNoData => 'нет данных';

  @override
  String get nounHeight => 'высота';

  @override
  String get nounWeek => 'неделя';

  @override
  String get nounMonth => 'месяц';

  @override
  String get nounYear => 'год';

  @override
  String get verbConfirm => 'подтвердить';

  @override
  String get verbContinue => 'продолжить';

  @override
  String get verbCancel => 'отменить';

  @override
  String get verbSave => 'сохранить';

  @override
  String get verbRemove => 'удалить';

  @override
  String get verbExport => 'экспортировать';

  @override
  String get runRecordBarIntervalType => 'тип интервала';

  @override
  String get pulseMeasureTabMetronome => 'метроном';

  @override
  String get pulseMeasureTabCamera => 'камера';

  @override
  String get pulseMeasureCameraInstructionInitial =>
      'плотно прижмите палец к камере и вспышки';

  @override
  String get pulseMeasureTabTimer => 'таймер';

  @override
  String get pulseMeasureTabManual => 'вручную';

  @override
  String get pulseMeasureMetronomIntructionClickAtDrum =>
      'нажимайте барабан на каждый удар сердца';

  @override
  String get settingsLanguage => 'язык';

  @override
  String get settingsTheme => 'тема';

  @override
  String get settingVariantDialogButtonDefault => 'по умолчанию';

  @override
  String get settingVariantThemeLigth => 'светлая';

  @override
  String get settingVariantThemeDark => 'темная';

  @override
  String get settingLocation => 'геолокация';

  @override
  String get historyPageNoRecords => 'нет записей';

  @override
  String get historyPageCreateRecord => 'записать трек';

  @override
  String get runRecordPageShare => 'поделиться';

  @override
  String get runRecordPageShareError => 'сервис недоступен';

  @override
  String get locationPermissionMessageLoading =>
      'получение статуса сервисов геолокации';

  @override
  String get locationPermissionMessagePermited =>
      'приложение имеет доступ к сервисам геолокации';

  @override
  String get locationPermissionMessageDenied =>
      'приложению запрещен доступ к сервисам геолокации';

  @override
  String get locationPermissionMessageIgnore =>
      'приложение не использует геолокацию';

  @override
  String get locationPermissionButtonRefresh => 'обновить';

  @override
  String get locationPermissionButtonRequestPermission =>
      'запросить разрешение';

  @override
  String get locationPermissionButtonIgnore => 'игнорировать';

  @override
  String get validationValueMusntBeNull => 'значение не должно быть null';

  @override
  String get trackRecordAbortDialogContent => 'запись была прервана';

  @override
  String get importGPX => 'импортировать GPX';

  @override
  String get importPickGPXFile => 'выберите GPX файл';

  @override
  String get importNoFile => 'файл не выбран';

  @override
  String get importFailed => 'не удалось импортировать';

  @override
  String get chartMenuOutlierFilter => 'фильтр выбросов';

  @override
  String get chartMenuShowMarkers => 'показывать точки';

  @override
  String get chartMenuResolutionFilter => 'фильтр разрешения';

  @override
  String get chartMenuDownsampling => 'понижение разрешения';
}
