import 'dart:async';
import 'dart:ui' as ui;
import 'package:FordhamAR/utils/cardInfo.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'ar_photo.dart';

class GoogleMaps extends StatefulWidget {
  final Function selectedLocation;
  final ARKitController arkitController;

  const GoogleMaps({
    super.key,
    required this.selectedLocation,
    required this.arkitController,
  });

  @override
  State<GoogleMaps> createState() => GoogleMapsState();
}

class GoogleMapsState extends State<GoogleMaps> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late GoogleMapController mapController;
  final List<Marker> _markers = <Marker>[];
  final Map<MarkerId, Marker> markers = {};
  final Map<PolylineId, Polyline> polylines = {};
  final List<LatLng> polylineCoordinates = [];
  final PolylinePoints polylinePoints = PolylinePoints();
  Position? _lastKnownPosition;
  StreamSubscription<Position>? _positionStreamSubscription;

  // Constants
  static const double LOCATION_CHANGE_THRESHOLD = 30.48; // 100 feet in meters
  static const double PROXIMITY_THRESHOLD = 30.48; // 100 feet in meters

  // Initial camera position
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(40.861396722773854, -73.88536423152142),
    zoom: 15.5,
  );

  final List<Map<String, dynamic>> locations = cardInfo;

  @override
  void initState() {
    super.initState();
    loadData();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> loadData() async {
    try {
      for (int i = 0; i < locations.length; i++) {
        final Uint8List markerIcon = await getImages("assets/icons/1.png", 130);

        _markers.add(
          Marker(
            markerId: MarkerId(i.toString()),
            icon: BitmapDescriptor.fromBytes(markerIcon),
            position: locations[i]["location"],
            infoWindow: InfoWindow(
              title: locations[i]["name"],
            ),
            onTap: () {
              widget.selectedLocation(i, locations[i]["name"]);
              final panoramaImage = locations[i]["panoramaImage"];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PanoramaPage(
                    arkitController: widget.arkitController,
                    panaoramaImage: panoramaImage,

                  ),
                ),
              );
            },
          ),
        );
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error loading markers: $e');
    }
  }

  Future<void> _startLocationUpdates() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Handle location services not enabled
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle permission denied
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle permission denied forever
      return;
    }

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(
      _checkAndNotifyLocationChange,
      onError: (error) {
        debugPrint('Location stream error: $error');
      },
    );
  }

  void _checkAndNotifyLocationChange(Position position) {
    bool locationChanged = _lastKnownPosition == null ||
        Geolocator.distanceBetween(
              _lastKnownPosition!.latitude,
              _lastKnownPosition!.longitude,
              position.latitude,
              position.longitude,
            ) >
            LOCATION_CHANGE_THRESHOLD;

    if (locationChanged) {
      _lastKnownPosition = position;
      _checkProximityToLocations(position);
    }
  }

  void _checkProximityToLocations(Position userPosition) {
    bool isNearLocation = false;

    for (int i = 0; i < locations.length; i++) {
      double distanceInMeters = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        locations[i]["location"].latitude,
        locations[i]["location"].longitude,
      );

      if (distanceInMeters <= PROXIMITY_THRESHOLD) {
        widget.selectedLocation(i, locations[i]["name"]);
        isNearLocation = true;
        break;
      }
    }

    if (!isNearLocation && locations.isNotEmpty) {
      widget.selectedLocation(0, locations[0]["name"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          initialCameraPosition: locations.isNotEmpty
              ? CameraPosition(target: locations[0]["location"], zoom: 17.5)
              : _kGoogle,
          markers: Set<Marker>.of(_markers),
          myLocationButtonEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            mapController = controller;
          },
        ),
      ),
    );
  }
}
