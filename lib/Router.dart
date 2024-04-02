import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:run_tracker/bloc/cubits/CounterCubit.dart';
import 'package:run_tracker/bloc/cubits/DashBoardDurationCubit.dart';
import 'package:run_tracker/bloc/cubits/DashBoardGeolocationCubit.dart';
import 'package:run_tracker/bloc/cubits/GeolocationProviderCubit.dart';
import 'package:run_tracker/bloc/cubits/LocationMarkerPositionCubit.dart';
import 'package:run_tracker/bloc/cubits/PositionSignificantCubit.dart';
import 'package:run_tracker/bloc/cubits/RunRecorderCubit.dart';
import 'package:run_tracker/components/future_builder_loader/MultiFutureBuilderLoader.dart';
import 'package:run_tracker/core/RunRecorder.dart';
import 'package:run_tracker/data/repositories/RunCoverRepository.dart';
import 'package:run_tracker/data/repositories/RunPointsRepository.dart';
import 'package:run_tracker/helpers/GeolocationProvider.dart';
import 'package:run_tracker/helpers/GeolocatorWrapper.dart';
import 'package:run_tracker/pages/ActivityPage.dart';
import 'package:run_tracker/pages/HistoryPage/HistoryPage.dart';
import 'package:run_tracker/pages/MapPage/MapPage.dart';
import 'package:run_tracker/pages/PulsePage/PulsePage.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordPage.dart';
import 'package:run_tracker/pages/SettingPage/SettingPage.dart';
import 'package:run_tracker/services/RunRecordService.dart';

class Routes {
  static const activityPage = "/ActivityPage";
  static const settingPage = "/SettingPage";
  static const mapPage = "/MapPage";
  static const historyPage = "/HistoryPage";
  static const runRecordPage = "/RunRecordPage";
  static const pulsePage = "/PulsePage";
}

final AppRouterConfig = GoRouter(routes: [
  GoRoute(
    path: "/",
    redirect: (c, grs) => Future(() => Routes.activityPage),
  ),
  GoRoute(
    path: Routes.settingPage,
    builder: (c, grs) => SettingPage(),
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
    builder: (c, grs) => MultiFutureBuilderLoader(
      register: (helper) {
        helper.register(RunCoverRepositoryFactory().create());
        helper.register(RunPointsRepositoryFactory().create());
      },
      loader: (_, __) => Container(),
      builder: (context, store) {
        return MultiProvider(
          providers: [
            Provider<RunCoverRepository>(create: (_) => store.get()),
            Provider<RunPointsRepository>(create: (_) => store.get()),
            Provider<GeolocatorWrapper>(create: (_) => GeolocatorWrapper()),
            ProxyProvider<GeolocatorWrapper, IGeolocationProvider>(
              update: (context, geoWrapper, _) {
                final geolocationProviderKind = context.read<GeolocationProviderCubit>().state;

                return GeolocationProviderFactory(geoWrapper).create(geolocationProviderKind);
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
    builder: (context, state) => PulsePage(),
  ),
]);
