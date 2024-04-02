import 'package:flutter_bloc/flutter_bloc.dart';

enum GeolocationProviderKind {
  Subscription,
  Timer,
  TimerWithSubscription,
  Combined,
}

class GeolocationProviderCubit extends Cubit<GeolocationProviderKind> {
  GeolocationProviderCubit(super.initialState);

  void set(GeolocationProviderKind geolocationProviderKind) {
    emit(geolocationProviderKind);
  }
}
