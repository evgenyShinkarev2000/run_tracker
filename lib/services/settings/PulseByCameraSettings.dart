import 'package:run_tracker/services/settings/Setting.dart';
import 'package:run_tracker/services/settings/SettingFactory.dart';
import 'package:run_tracker/services/settings/SettingSetBase.dart';

class PulseByCameraSettings extends SettingSetBase {
  final SettingFactory _settingFactory;

  late final SettingValue<int> pulseMovingAverageCount;

  PulseByCameraSettings(SettingFactory settingFactory, {super.prefix})
      : _settingFactory = settingFactory,
        super(name: "PulseByCamera");

  @override
  Future<void> init() async {
    await initFutures(() => [
          _settingFactory
              .initSettingInt(buildSettingName("PulseMovingAverageCount"), 5)
              .then((value) => pulseMovingAverageCount = value),
        ]);
  }
}
