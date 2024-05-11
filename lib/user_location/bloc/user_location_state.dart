part of 'user_location_bloc.dart';

class UserLocationState extends Equatable {
  const UserLocationState._({
    this.status = UserLocationStatus.unknown,
    this.coordinates = const LatLng(0.0, 0.0),
  });

  const UserLocationState.unknown() : this._(status: UserLocationStatus.unknown, coordinates: const LatLng(0.0, 0.0));

  const UserLocationState.fetched(LatLng coordination)
      : this._(status: UserLocationStatus.initialized, coordinates: coordination );


  final UserLocationStatus status;
  final LatLng coordinates;

  @override
  List<Object?> get props => [status, coordinates];
}
