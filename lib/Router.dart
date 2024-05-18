import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_ui/hive_ui.dart';
import 'package:provider/provider.dart';
import 'package:run_tracker/bloc/cubits/CounterCubit.dart';
import 'package:run_tracker/bloc/cubits/DashBoardDurationCubit.dart';
import 'package:run_tracker/bloc/cubits/DashBoardGeolocationCubit.dart';
import 'package:run_tracker/bloc/cubits/LocationMarkerPositionCubit.dart';
import 'package:run_tracker/bloc/cubits/PositionSignificantCubit.dart';
import 'package:run_tracker/bloc/cubits/RunRecorderCubit.dart';
import 'package:run_tracker/components/AppMainLoader.dart';
import 'package:run_tracker/components/drawer/AppMainDrawer.dart';
import 'package:run_tracker/components/future_builder_loader/MultiFutureBuilderLoader.dart';
import 'package:run_tracker/core/PulseRecorder.dart';
import 'package:run_tracker/core/RunRecorder.dart';
import 'package:run_tracker/data/models/models.dart';
import 'package:run_tracker/data/repositories/repositories.dart';
import 'package:run_tracker/helpers/GeolocationProvider.dart';
import 'package:run_tracker/helpers/GeolocatorWrapper.dart';
import 'package:run_tracker/helpers/extensions/SettingExtension.dart';
import 'package:run_tracker/pages/ActivityPage.dart';
import 'package:run_tracker/pages/HistoryPage/HistoryPage.dart';
import 'package:run_tracker/pages/MapPage/MapPage.dart';
import 'package:run_tracker/pages/PulsePage/PulsePage.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordPage.dart';
import 'package:run_tracker/pages/SettingPage/SettingPage.dart';
import 'package:run_tracker/pages/StatisticPage/StatisticPage.dart';
import 'package:run_tracker/services/RunRecordService.dart';
import 'package:run_tracker/services/settings/settings.dart';

class Routes {
  static const activityPage = "/ActivityPage";
  static const settingPage = "/SettingPage";
  static const mapPage = "/MapPage";
  static const historyPage = "/HistoryPage";
  static const runRecordPage = "/RunRecordPage";
  static const pulsePage = "/PulsePage";
  static const hivePage = "/HivePage";
  static const statisticPage = "/StatisticPage";
}

final AppRouterConfig = GoRouter(routes: [
  GoRoute(
    path: "/",
    redirect: (c, grs) => Future(() => Routes.activityPage),
  ),
  GoRoute(
    path: Routes.settingPage,
    builder: (context, grs) => MultiFutureBuilderLoader(
      register: (storage) {
        final appSettings = context.read<SettingsProvider>().appSettings;

        storage.register(appSettings.init());
        storage.register(appSettings.geolocation.init());
        storage.register(appSettings.pulseByCamera.init());
      },
      loader: (_, __) => Container(),
      builder: (context, store) => SettingPage(),
    ),
  ),
  GoRoute(
    path: Routes.activityPage,
    builder: (context, grs) {
      return BlocProvider(
        create: (_) => CounterCubit(),
        child: ActivityPage(title: "example`"),
      );
    },
  ),
  GoRoute(
    path: Routes.mapPage,
    builder: (context, grs) => MultiFutureBuilderLoader(
      register: (store) {
        store.register(context.read<SettingsProvider>().appSettings.geolocation.init());
        store.register(RunCoverRepositoryFactory().create());
        store.register(RunPointsRepositoryFactory().create());
        store.register(GeolocatorWrapper.checkPermission());
        final appsettings = context.read<SettingsProvider>().appSettings;
        store.register(appsettings.pulseByCamera.init());
      },
      loader: (_, __) => Container(),
      builder: (context, store) {
        return MultiProvider(
          providers: [
            Provider<RunCoverRepository>(create: (_) => store.get()),
            Provider<RunPointsRepository>(create: (_) => store.get()),
            Provider<PulseRecorder>(create: (_) => PulseRecorder()),
            Provider<GeolocatorWrapper>(create: (_) => GeolocatorWrapper()),
            ProxyProvider<GeolocatorWrapper, IGeolocationProvider>(
              update: (context, geoWrapper, _) {
                final geolocationSettings = context.read<SettingsProvider>().appSettings.geolocation;

                return GeolocationProviderFactory(geoWrapper).create(geolocationSettings.providerKind.valueOrDefault!);
              },
              dispose: (context, geoRepo) => geoRepo.dispose(),
            ),
            ProxyProvider<IGeolocationProvider, IRunRecorder>(update: (context, geoProv, _) {
              return RunRecorder(geolocationProvider: geoProv);
            }, dispose: (context, runRecorder) {
              runRecorder.dispose();
            }),
            ProxyProvider2<RunCoverRepository, RunPointsRepository, RunRecordService>(
                update: (context, runCoverRepo, runPointsRepo, _) {
              return RunRecordService(runCoverRepository: runCoverRepo, runPointsRepository: runPointsRepo);
            }),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<PositionSignificantCubit>(
                create: (context) => PositionSignificantCubit(
                  geolocationWrapper: context.read<GeolocatorWrapper>(),
                  geoRepo: context.read<IGeolocationProvider>(),
                  initialState: PositionSignificantState(null, false),
                ),
              ),
              BlocProvider<DashBoardGeolocationCubit>(create: (context) {
                final runRecorder = context.read<IRunRecorder>();
                final geoRepo = context.read<IGeolocationProvider>();

                return DashBoardGeolocationCubit(
                  geoRepo: geoRepo,
                  runRecorder: runRecorder,
                );
              }),
              BlocProvider<RunRecorderCubit>(create: (context) {
                final runRecorderProxy = context.read<IRunRecorder>();

                return RunRecorderCubit(runRecorderProxy: runRecorderProxy);
              }),
              BlocProvider<DashBoardDurationCubit>(create: (context) {
                final runRecorderProxy = context.read<IRunRecorder>();

                return DashBoardDurationCubit(runRecorder: runRecorderProxy);
              }),
              BlocProvider<LocationMarkerPositionCubit>(create: (context) {
                final geoProvider = context.read<IGeolocationProvider>();

                return LocationMarkerPositionCubit(geolocationProvider: geoProvider);
              }),
            ],
            child: MapPage(),
          ),
        );
      },
    ),
  ),
  GoRoute(
    path: Routes.historyPage,
    builder: (context, state) => MultiFutureBuilderLoader(
      loader: (_, __) => Container(),
      register: (storage) {
        storage.register(RunCoverRepositoryFactory().create());
        storage.register(RunPointsRepositoryFactory().create());
      },
      builder: (context, storage) {
        return MultiProvider(
          providers: [
            Provider<RunCoverRepository>(create: (_) => storage.get()),
            Provider<RunPointsRepository>(create: (_) => storage.get()),
            ProxyProvider2<RunCoverRepository, RunPointsRepository, RunRecordService>(
                update: (context, runCoverRepo, runPointsRepo, _) {
              return RunRecordService(runCoverRepository: runCoverRepo, runPointsRepository: runPointsRepo);
            }),
          ],
          child: HistoryPage(),
        );
      },
    ),
  ),
  GoRoute(
    path: "${Routes.runRecordPage}/:id",
    builder: (context, state) => MultiFutureBuilderLoader(
      loader: (_, __) => Container(),
      register: (storage) {
        storage.register(RunCoverRepositoryFactory().create());
        storage.register(RunPointsRepositoryFactory().create());
      },
      builder: (context, store) => MultiProvider(
        providers: [
          Provider<RunCoverRepository>(create: (_) => store.get()),
          Provider<RunPointsRepository>(create: (_) => store.get()),
          ProxyProvider2<RunCoverRepository, RunPointsRepository, RunRecordService>(
              update: (context, runCoverRepo, runPointsRepo, _) {
            return RunRecordService(runCoverRepository: runCoverRepo, runPointsRepository: runPointsRepo);
          }),
        ],
        child: RunRecordPage(int.parse(state.pathParameters["id"]!)),
      ),
    ),
  ),
  GoRoute(
    path: Routes.pulsePage,
    builder: (context, state) => MultiFutureBuilderLoader(
      loader: (_, __) => Container(),
      register: (storage) {
        final appSettings = context.read<SettingsProvider>().appSettings;
        storage.register(appSettings.pulseByCamera.init());
      },
      builder: (context, store) => PulsePage(),
    ),
  ),
  GoRoute(
    path: Routes.statisticPage,
    builder: (context, state) => MultiFutureBuilderLoader(
      loader: (_, __) => AppMainLoader(),
      register: (builder) {
        builder.register(RunCoverRepositoryFactory().create());
      },
      builder: (context, store) => MultiProvider(
        providers: [
          Provider<RunCoverRepository>(create: (_) => store.get()),
        ],
        child: StatisticPage(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.hivePage,
    onExit: (_) async {
      await Hive.box<RunPointsData>(RunPointsRepositoryFactory.runPointsBoxName).close();

      return true;
    },
    builder: (context, state) => MultiFutureBuilderLoader(
      register: (storage) {
        if (!Hive.isBoxOpen(SettingRepositoryFactory.settingBoxName)) {
          storage.register(Hive.openBox<SettingData>(SettingRepositoryFactory.settingBoxName));
        }
        if (!Hive.isBoxOpen(RunCoverRepositoryFactory.runCoverBoxName)) {
          storage.register(Hive.openBox<RunCoverData>(RunCoverRepositoryFactory.runCoverBoxName));
        }
        try {
          final lazyBox = Hive.lazyBox<RunPointsData>(RunPointsRepositoryFactory.runPointsBoxName);

          storage.register(Future(() async {
            await lazyBox.close();
            await Hive.openBox<RunPointsData>(RunPointsRepositoryFactory.runPointsBoxName);
          }));
        } catch (e) {
          storage.register(Hive.openBox<RunPointsData>(RunPointsRepositoryFactory.runPointsBoxName));
        }
      },
      loader: (_, __) => AppMainLoader(),
      builder: (context, store) => Scaffold(
        appBar: AppBar(),
        drawer: AppMainDrawer(),
        body: HiveBoxesView(
          hiveBoxes: {
            Hive.box<SettingData>(SettingRepositoryFactory.settingBoxName): (json) => SettingData.fromJson(json),
            Hive.box<RunCoverData>(RunCoverRepositoryFactory.runCoverBoxName): (json) => RunCoverData.fromJson(json),
            Hive.box<RunPointsData>(RunPointsRepositoryFactory.runPointsBoxName): (json) =>
                RunPointsData.fromJson(json),
          },
          onError: (e) {},
        ),
      ),
    ),
  ),
]);
