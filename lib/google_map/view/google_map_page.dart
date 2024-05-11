import 'dart:async';
import 'dart:ui' as ui;

import 'package:demo_google_map/user_location/bloc/user_location_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';

class GoogleMapDemoPage extends StatefulWidget {
  const GoogleMapDemoPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const GoogleMapDemoPage());
  }

  @override
  State<GoogleMapDemoPage> createState() => _GoogleMapDemoPageState();
}

class _GoogleMapDemoPageState extends State<GoogleMapDemoPage>
    with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor currentLocationIcon;
  LocationData? currentLocation;

  final logger = Logger(printer: PrettyPrinter());

  @override
  void initState() {
    // getCurrentLocation();
    super.initState();
  }

  void getCurrentLocation() async {
    currentLocationIcon = BitmapDescriptor.fromBytes(await getBytesFromAsset(
        path: "assets/images/currentLocation.png", width: 140));

    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        logger.d('new location: ${newLoc.latitude}, ${newLoc.longitude}');
        currentLocation = newLoc;
        context.select((UserLocationBloc bloc) {
          bloc.add(
              UserPositionMoved(LatLng(newLoc.latitude!, newLoc.longitude!)));
        });
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        setState(() {});
      },
    );
  }

  Widget googleMapWidget(LatLng coordinates) {
    return GoogleMap(
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      zoomControlsEnabled: true,
      initialCameraPosition: CameraPosition(zoom: 16, target: coordinates),
      onMapCreated: (controller) async {
        _controller.complete(controller);
      },
      onCameraMove: (position) async {},
      onCameraMoveStarted: () async {},
      markers: {
        Marker(
            markerId: const MarkerId("1"),
            icon: BitmapDescriptor.defaultMarker,
            position: coordinates),
      },
    );
  }

  Future<Uint8List> getBytesFromAsset(
      {required String path, required int width}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Google Map Demo"),
        ),
        body: Stack(
          children: [
            Builder(builder: (context) {
              var coordinates = context
                  .select((UserLocationBloc bloc) => bloc.state.coordinates);
              return googleMapWidget(coordinates);
            }),

          ],
        ));
  }
}
