import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:user_location_repository/user_location_repository.dart';

part 'user_location_event.dart';

part 'user_location_state.dart';

class UserLocationBloc extends Bloc<UserLocationEvent, UserLocationState> {

  final logger = Logger(printer: PrettyPrinter());

  UserLocationBloc({required UserLocationRepository userLocationRepository})
      : _userLocationRepository = userLocationRepository,
        super(const UserLocationState.unknown()) {
    on<UserLocationChangedEvent>(_onUserLocationChanged);
    on<UserPositionMoved>(_onUserPositionMoved);
    _userLocationStatusSubscription = _userLocationRepository.status
        .listen((status) => add(UserLocationChangedEvent(status)));
  }

  @override
  Future<void> close() {
    _userLocationStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onUserLocationChanged(
      UserLocationChangedEvent event, Emitter<UserLocationState> emit) async {
    switch (event.status) {
      case UserLocationStatus.unknown:
        return emit(const UserLocationState.unknown());
      case UserLocationStatus.initialized:
        final coordination = await _tryGetLatlng();
        return emit(UserLocationState.fetched(coordination));
    }
  }

  void _onUserPositionMoved(UserPositionMoved event, Emitter<UserLocationState> emit) {
    logger.d("user position is moving.");
    emit(UserLocationState.fetched(event.currPosition));
  }

  final UserLocationRepository _userLocationRepository;
  late StreamSubscription<UserLocationStatus> _userLocationStatusSubscription;

  Future<LatLng> _tryGetLatlng() async {
    try {
      final coordination = await _userLocationRepository.getCurrLatlng();
      if (null == coordination) return const LatLng(0.0, 0.0);
      return coordination;
    } catch (_) {
      return const LatLng(0.0, 0.0);
    }
  }
}
