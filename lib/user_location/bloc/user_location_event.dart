part of 'user_location_bloc.dart';

sealed class UserLocationEvent extends Equatable {
  const UserLocationEvent();
}

final class UserLocationChangedEvent extends UserLocationEvent {
  const UserLocationChangedEvent(this.status);
  final UserLocationStatus status;

  @override
  List<Object> get props => [status];
}


final class UserPositionMoved extends UserLocationEvent {
  const UserPositionMoved(this.currPosition);
  final LatLng currPosition;
  @override
  List<Object> get props => [currPosition];
}