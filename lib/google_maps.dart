import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMaps extends StatefulWidget {
  GoogleMaps({super.key, required this.selectedLocation});

  Function selectedLocation;

  @override
  State<GoogleMaps> createState() => MapSampleState();
}

class MapSampleState extends State<GoogleMaps> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _locationLogTimer; // Timer to log location every 3 seconds
  Position? _lastKnownPosition;


  static const LatLng sourceLocation =
      LatLng(37.42796133580664, -122.085749655962);
  static const LatLng destination =
      LatLng(37.43296265331129, -122.08832357078792);

  late GoogleMapController mapController;
  final double _originLatitude = 37.42796133580664,
      _originLongitude = -122.085749655962;
  final double _destLatitude = 37.43296265331129,
      _destLongitude = -122.08832357078792;

  final Map<MarkerId, Marker> markers = {};
  final Map<PolylineId, Polyline> polylines = {};
  final List<LatLng> polylineCoordinates = [];
  final PolylinePoints polylinePoints = PolylinePoints();
  final String googleAPiKey = "API_KEY";
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;

  Uint8List? marketimages;
  List<String> images = [
    'assets/icons/3.png',
    'assets/images/keating hall.webp',
    'assets/images/Church.png',
    'assets/images/university.png',
    'assets/images/food-delivery.png',
    'assets/icons/1.png'
  ];

  final List<Marker> _markers = <Marker>[];
  final List<LatLng> _latLen = <LatLng>[
    LatLng(40.8598444, -73.8847904), //John Mulcahy Hall
    LatLng(
        40.8602013, -73.8844390), //Mulcahy - Keating: (40.8602013, -73.8844390)
    LatLng(40.8601683, -73.8836578), //Keating Back: (40.8601683, -73.8836578)
    LatLng(
        40.8606841, -73.8832300), //Keating Front 1: (40.8606841, -73.8832300)
    LatLng(40.8598103, -73.8824994), //O’Hare Hall: (40.8598103, -73.8824994)
    LatLng(40.8603633, -73.8817890), //Parking Area: (40.8603633, -73.8817890)
    LatLng(40.8611839, -73.8837628), //Moglia Stadium: (40.8611839, -73.8837628)
    LatLng(40.8618342, -73.8842409), //Moglia Way: (40.8618342, -73.8842409)


    LatLng(40.8633417, -73.8855467), //Tennis Court: (40.8633417, -73.8855467)
    LatLng(40.8634756, -73.8858471), //Cemetery: (40.8634756, -73.8858471)
    LatLng(
        40.8640126, -73.8862444), //Fordham Prep sch: (40.8640126, -73.8862444)
    LatLng(40.8638970, -73.8868402), //Loschert Hall: (40.8638970, -73.8868402)
    LatLng(40.86382521262713, -73.8863784953219), //Loschert Hall
    LatLng(
        40.8636748, -73.8866543), //St John and Tueds: (40.8636748, -73.8866543)
    LatLng(40.8632446,
        -73.8867571), //Church and Brownson: (40.8632446, -73.8867571)

    LatLng(40.8632266,
        -73.8865345), //Church and Crusifix: (40.8632266, -73.8865345)
    LatLng(40.8630526, -73.8862518), //Collings Hall: (40.8630526, -73.8862518)
    LatLng(
        40.8629180, -73.8860446), //Faber & Collings: (40.8629180, -73.8860446)
    LatLng(40.8625944, -73.8858394), //Loyola Hall: (40.8625944, -73.8858394)
    LatLng(40.8622184, -73.8856285), //Hughes Hall S: (40.8622184, -73.8856285)
    LatLng(40.8617097, -73.8858097), //Water Fall: (40.8617097, -73.8858097)
    LatLng(40.8619213, -73.8862813), //Cunniffee Hall: (40.8619213, -73.8862813)
    LatLng(40.8616210, -73.8864332), //Dealy Hall: (40.8616210, -73.8864332)
    LatLng(40.8614574, -73.8872238), //Duane: (40.8614574, -73.8872238)
    LatLng(40.8609952, -73.8882417), //Larking Hall: (40.8609952, -73.8882417)
    LatLng(40.86150607299467, -73.88896543957128), //Library
    LatLng(40.861226150882246, -73.89011879668851), //Gate
    LatLng(40.86236402896374, -73.88907875259216), //Campbell Hall
    LatLng(40.86278368807378, -73.88868700273055), //Salice Hall
    LatLng(40.86287763850865, -73.88902861442958), // Salice Hall Back
    LatLng(40.86253238516355, -73.88934538736315), //Campbell Hall Back
    LatLng(40.862966842701056, -73.88851991385981), //Conley Hall
    LatLng(40.86327172596001, -73.8885502213916), //Conley Hall Back
    LatLng(40.86325109170988, -73.88815617581797), //Conley Hall Side
    LatLng(40.862467046668414, -73.88849062920174), //Martyrs' Court
    LatLng(40.862849310672054, -73.88704789021529), //Collins Hall
    LatLng(40.86319213127064, -73.88784099212826), //Martyrs' Court Back
    LatLng(40.863002991029404, -73.88729173101204), //Queen's Court
    LatLng(40.862467028278516, -73.88645353154206), //Collins Hall
    LatLng(40.86359834230361, -73.8875415131169), //Alumni Court South
    LatLng(40.86381962609719, -73.88730816541958), //Amazon Locker
    LatLng(40.86393423956953, -73.8850119381504), //Tennis Court
    LatLng(40.86334881121144, -73.88466008803972), //Bahoshy Field
    LatLng(40.863883811300056, -73.88431932331652), //Field
    LatLng(40.86266254185804, -73.8840971040944), //McGinley Center
    LatLng(40.86304908748162, -73.88356374252838), //Bahoshy Softball Complex
    LatLng(40.86192025165094, -73.88440081502361), //Rose Hill Gymnasium
    LatLng(40.86147765821646, -73.88261187068268), //Jack Coffey Field
    LatLng(40.86077176290269, -73.88184148720234), //Xavier Way
    LatLng(40.85959805899672, -73.88272298718134), //Fordham Store || Bookstore
    LatLng(40.859256309232265, -73.88277484476826), //O'Hare Hall
    LatLng(40.85928992605681, -73.88348968026257), //Tierney Hall
    LatLng(40.8590798306726, -73.88227853215828), //RAM Van
    LatLng(40.85874927585338,
        -73.88180815161397), //Parking Regional Parking Facility
    LatLng(40.85841032410379, -73.88259706112997), // Communication Department
    LatLng(40.8586204225088, -73.88274521203577), // Canisius Hall
    LatLng(40.860569492650555, -73.88353242172421), // Keating Hall
    LatLng(40.86084401197889, -73.88397688062106), // Keating Hall
    LatLng(40.86098966739332, -73.88524730060098), // Edward's Parade
    LatLng(40.86135943400756, -73.88456579661496), // Edward's Parade
    LatLng(40.86284963153381, -73.88385094998279), // McShane Back
    LatLng(40.862900051308, -73.88366946285079), // Lombardi Memorial Center
    LatLng(40.86228100228768, -73.88272499491018), // Walsh Training Center
  ];

  final List marker_names = [
    "John Mulcahy Hall",
    "Mulcahy - Keating",
    "Keating Front",
    "O’Hare Hall",
    "Parking Area",
    "Moglia Stadium",
    "Moglia Way",
    "Mc Shane",
    "Tennis Court",
    "Cemetery",
    "Fordham Prep sch",
    "Loschert Hall",
    "Loschert Hall",
    "St John and Tueds",
    "Church and Brownson",
    "Church and Crusifix",
    "Collings Hall B",
    "Faber & Collings",
    "Loyola Hall",
    "Hughes Hall",
    "Water Fall",
    "Cunniffee Hall",
    "Dealy Hall",
    "Duane & Larking side",
    "Larking Hall",
    "Library",
    "Gate",
    "Campbell Hall",
    "Salice Hall",
    "Salice Hall Back",
    "Campbell Hall Back",
    "Conley Hall",
    "Conley Hall Back",
    "Conley Hall Side",
    "Martyrs' Court",
    "Collins Hall",
    "Martyrs' Court Back",
    "Queen's Court",
    "Collins Hall",
    "Alumni Court South",
    "Amazon Locker",
    "Tennis Court",
    "Bahoshy Field",
    "Field",
    "McGinley Center",
    "Bahoshy Softball Complex",
    "Rose Hill Gymnasium",
    "Jack Coffey Field",
    "Xavier Way",
    "Fordham Store || Bookstore",
    "O'Hare Hall",
    "Tierney Hall",
    "RAM Van",
    "Parking Regional Parking Facility",
    "Communication Department",
    "Canisius Hall",
    "Keating Hall",
    "Keating Hall",
    "Edward's Parade",
    "Edward's Parade",
    "McShane",
    "Lombardi Memorial Center",
    "Walsh Training Center",
  ];

  @override
  void initState() {
    super.initState();
    loadData();
    _startLocationUpdates();
    _getPolyline();

    // Start logging location every 3 seconds
    _locationLogTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _logCurrentLocation();
    });
  }

  // Future<void> loadData() async {
  //   for (int i = 0; i < _latLen.length; i++) {
  //     // Load marker icon
  //     final Uint8List markIcons = await getImages("assets/icons/1.png", 100);

  //     // Add marker with onTap callback
  //     _markers.add(Marker(
  //       markerId: MarkerId(i.toString()),
  //       icon: BitmapDescriptor.fromBytes(markIcons),
  //       position: _latLen[i],
  //       infoWindow: InfoWindow(
  //         title: '${marker_names[i]}',
  //       ),
  //       onTap: () {
  //         widget.selectedLocation(i);
  //         // _showLocationModal(i); // Show the modal when marker is clicked
  //       },
  //     ));

  //     setState(() {});
  //   }
  // }

  void _startLocationUpdates() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high, distanceFilter: 10),
    ).listen((Position position) {
      _checkAndNotifyLocationChange(position);
    });
  }

  void _checkAndNotifyLocationChange(Position position) {
    const double locationChangeThreshold = 30.48; // 100 feet in meters
    bool locationChanged = _lastKnownPosition == null ||
        Geolocator.distanceBetween(
              _lastKnownPosition!.latitude,
              _lastKnownPosition!.longitude,
              position.latitude,
              position.longitude,
            ) >
            locationChangeThreshold;

    if (locationChanged) {
      _lastKnownPosition = position;
      _checkProximityToLocations(position);
    }
  }

  void _checkProximityToLocations(Position userPosition) {
    const double proximityThreshold = 30.48; // 100 feet in meters
    bool isNearLocation = false;

    for (int i = 0; i < _latLen.length; i++) {
      double distanceInMeters = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        _latLen[i].latitude,
        _latLen[i].longitude,
      );

      if (distanceInMeters <= proximityThreshold) {
        widget.selectedLocation(i);
        isNearLocation = true;
        break;
      }
    }

    if (!isNearLocation) {
      widget.selectedLocation(-1);
    }
  }

  Future<void> loadData() async {
    for (int i = 0; i < _latLen.length; i++) {
      final Uint8List markIcons = await getImages("assets/icons/1.png", 100);

      _markers.add(Marker(
        markerId: MarkerId(i.toString()),
        icon: BitmapDescriptor.fromBytes(markIcons),
        position: _latLen[i],
        infoWindow: InfoWindow(
          title: '${marker_names[i]}',
        ),
        onTap: () {
          widget.selectedLocation(i); // Only trigger on tap
        },
      ));

      setState(() {});
    }
  }

  void _logCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      currentLatitude = position.latitude;
      currentLongitude = position.longitude;
    });
    // kDebugMode
    //     ? print("Current Location: ${position.latitude}, ${position.longitude}")
    //     : null;
  }


  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<String> getLocationName(int locationIndex) async {
    switch (locationIndex) {
      case 0:
        return 'Library';
      case 1:
        return 'Keating Hall';
      case 2:
        return 'Church';
      case 3:
        return 'University';
      case 4:
        return 'Food Delivery';
      default:
        return 'Location: $locationIndex';
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _locationLogTimer?.cancel(); // Cancel the timer
    super.dispose();
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
          initialCameraPosition: CameraPosition(target: _latLen[0], zoom: 17.5),
          markers: Set<Marker>.of(_markers),
          polylines: Set<Polyline>.of(polylines.values),
          myLocationButtonEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }

  Future<void> _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      for (PointLatLng point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      _addPolyLine();
    }
  }

  void _addPolyLine() {
    PolylineId id = PolylineId("route");
    Polyline polyline = Polyline(
      polylineId: id,
      color: const Color.fromARGB(255, 4, 89, 150),
      points: polylineCoordinates,
    );
    polylines[id] = polyline;
    setState(() {});
  }
}
