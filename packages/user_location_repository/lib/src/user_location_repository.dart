import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

enum UserLocationStatus { unknown, initialized }
enum RequestUserLocationStatus { success, failed }

class UserLocationRepository {
  final logger = Logger(printer: PrettyPrinter());
  final _controller = StreamController<UserLocationStatus>();

  LatLng? _currLatlng;

  Stream<UserLocationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield UserLocationStatus.unknown;
    yield* _controller.stream;
  }

  Future<LatLng?> getCurrLatlng() async {
    if (_currLatlng != null) return _currLatlng;
    return Future.delayed(
        const Duration(milliseconds: 300), () => _getCurrLocation());
  }


  Future<void> requestCurrLocation() async {
    _currLatlng = await _getCurrLocation();
    logger.d(_currLatlng?.latitude.toString());
    logger.d(_currLatlng?.longitude.toString());
    _controller.add(UserLocationStatus.initialized);
  }

  Future<LatLng?> _getCurrLocation() async {
    await Geolocator.requestPermission();
    var locationPermissions = await Geolocator.checkPermission();
    if (locationPermissions.name == LocationPermission.denied ||
        locationPermissions.name == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }

    if (locationPermissions.name == LocationPermission.denied ||
        locationPermissions.name == LocationPermission.deniedForever) {
      logger.d("location request denied.");
      return null;
    }

    var currPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _currLatlng = LatLng(currPosition.latitude, currPosition.longitude);
    return _currLatlng;
  }

  Future<void> initialized({required LatLng location}) async {
    _currLatlng = location;
    await Future.delayed(
      const Duration(milliseconds: 300),
      () => _controller.add(UserLocationStatus.initialized),
    );
  }

  void dispose() => _controller.close();
}
