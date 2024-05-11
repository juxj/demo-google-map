import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:user_location_repository/user_location_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final logger = Logger(printer: PrettyPrinter());

  HomeBloc({required UserLocationRepository userLocationRepository})
      : _userLocationRepository = userLocationRepository,
        super(const HomeState()) {
    on<RequestLocationSubmitEvent>(onRequestUserLocationSubmit);
  }

  Future<void> onRequestUserLocationSubmit(
      RequestLocationSubmitEvent event, Emitter<HomeState> emit) async {
    await _userLocationRepository.requestCurrLocation();
  }

  final UserLocationRepository _userLocationRepository;
}
