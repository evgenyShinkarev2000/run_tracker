part of settings;

class GeolocationSettings extends SettingSetBase {
  final SettingFactory _settingFactory;

  late final SettingValue<GeolocationProviderKind> providerKind;

  GeolocationSettings(SettingFactory settingFactory, {super.prefix})
      : _settingFactory = settingFactory,
        super(name: "Geolocation");

  @override
  Future<void> init() async {
    await initFutures(() => [
          _settingFactory
              .initSettingEnum(
                buildSettingName("ProviderKind"),
                GeolocationProviderKind.values,
                GeolocationProviderKind.Subscription,
              )
              .then((value) => providerKind = value),
        ]);
  }
}
