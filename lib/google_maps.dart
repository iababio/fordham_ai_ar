import 'dart:async';
import 'dart:ui' as ui;
<<<<<<< Updated upstream

=======
import 'package:FordhamAR/utils/cardInfo.dart';
import 'package:flutter/foundation.dart';
>>>>>>> Stashed changes
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  State<GoogleMaps> createState() => MapSampleState();
}

class MapSampleState extends State<GoogleMaps> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: sourceLocation,
    zoom: 13.5,
  );

  static const LatLng sourceLocation = LatLng(37.42796133580664, -122.085749655962);
  static const LatLng destination = LatLng(37.43296265331129, -122.08832357078792);

  late GoogleMapController mapController;
  final double _originLatitude = 37.42796133580664, _originLongitude = -122.085749655962;
  final double _destLatitude = 37.43296265331129, _destLongitude = -122.08832357078792;

  final Map<MarkerId, Marker> markers = {};
  final Map<PolylineId, Polyline> polylines = {};
  final List<LatLng> polylineCoordinates = [];
  final PolylinePoints polylinePoints = PolylinePoints();
  final String googleAPiKey = "AIzaSyAyVUkgZp4NvCF24vi1sd8LTXe1rHJUg4s";



  // created controller for displaying Google Maps
  // Completer<GoogleMapController> _controller = Completer();

  // given camera position
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(40.861396722773854, -73.88536423152142),
    zoom: 15.5,
  );

  Uint8List? marketimages;
  List<String> images = ['assets/images/library.png','assets/images/keating hall.webp', 'assets/images/Church.png', 'assets/images/university.png', 'assets/images/food-delivery.png'];

<<<<<<< Updated upstream
  // created empty list of markers
  final List<Marker> _markers = <Marker>[];

  // created list of coordinates of various locations
  final List<LatLng> _latLen = <LatLng>[

    LatLng(40.86117492258277, -73.88944787082634),
    LatLng(40.86078552154204, -73.8881060421306),
    LatLng(40.86365859205002, -73.886326597286),
    LatLng(40.860471313883764, -73.8869579727068),
    LatLng(40.86155669342214, -73.88498655632648),
    LatLng(40.862316402404765, -73.88333235584133),
    LatLng(40.863750254530146, -73.88599860589126),
  ];

  // declared method to get Images
  Future<Uint8List> getImages(String path, int width) async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return(await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();

  }
=======
  final List<Map<String, dynamic>> locations = cardInfo;

  // [
  //   {"name": "John Mulcahy Hall", "location": LatLng(40.8598444, -73.8847904)},
  //   {"name": "Mulcahy - Keating", "location": LatLng(40.8602013, -73.8844390)},
  //   {"name": "Keating Back", "location": LatLng(40.8601683, -73.8836578)},
  //   {"name": "Keating Front 1", "location": LatLng(40.8606841, -73.8832300)},
  //   {"name": "O’Hare Hall", "location": LatLng(40.8598103, -73.8824994)},
  //   {"name": "Parking Area", "location": LatLng(40.8603633, -73.8817890)},
  //   {"name": "Moglia Stadium", "location": LatLng(40.8611839, -73.8837628)},
  //   {"name": "Moglia Way", "location": LatLng(40.8618342, -73.8842409)},
  //   {"name": "Tennis Court", "location": LatLng(40.8633417, -73.8855467)},
  //   {"name": "Cemetery", "location": LatLng(40.8634756, -73.8858471)},
  //   {"name": "Fordham Prep sch", "location": LatLng(40.8640126, -73.8862444)},
  //   {"name": "Loschert Hall", "location": LatLng(40.8638970, -73.8868402)},
  //   {"name": "Loschert Hall", "location": LatLng(40.86382521262713, -73.8863784953219)},
  //   {"name": "St John and Tueds", "location": LatLng(40.8636748, -73.8866543)},
  //   {"name": "Church and Brownson", "location": LatLng(40.8632446, -73.8867571)},
  //   {"name": "Church and Crusifix", "location": LatLng(40.8632266, -73.8865345)},
  //   {"name": "Collings Hall", "location": LatLng(40.8630526, -73.8862518)},
  //   {"name": "Faber & Collings", "location": LatLng(40.8629180, -73.8860446)},
  //   {"name": "Loyola Hall", "location": LatLng(40.8625944, -73.8858394)},
  //   {"name": "Hughes Hall S", "location": LatLng(40.8622184, -73.8856285)},
  //   {"name": "Water Fall", "location": LatLng(40.8617097, -73.8858097)},
  //   {"name": "Cunniffee Hall", "location": LatLng(40.8619213, -73.8862813)},
  //   {"name": "Dealy Hall", "location": LatLng(40.8616210, -73.8864332)},
  //   {"name": "Duane", "location": LatLng(40.8614574, -73.8872238)},
  //   {"name": "Larking Hall", "location": LatLng(40.8609952, -73.8882417)},
  //   {"name": "Library", "location": LatLng(40.86150607299467, -73.88896543957128)},
  //   {"name": "Gate", "location": LatLng(40.861226150882246, -73.89011879668851)},
  //   {"name": "Campbell Hall", "location": LatLng(40.86236402896374, -73.88907875259216)},
  //   {"name": "Salice Hall", "location": LatLng(40.86278368807378, -73.88868700273055)},
  //   {"name": "Salice Hall Back", "location": LatLng(40.86287763850865, -73.88902861442958)},
  //   {"name": "Campbell Hall Back", "location": LatLng(40.86253238516355, -73.88934538736315)},
  //   {"name": "Conley Hall", "location": LatLng(40.862966842701056, -73.88851991385981)},
  //   {"name": "Conley Hall Back", "location": LatLng(40.86327172596001, -73.8885502213916)},
  //   {"name": "Conley Hall Side", "location": LatLng(40.86325109170988, -73.88815617581797)},
  //   {"name": "Martyrs' Court", "location": LatLng(40.862467046668414, -73.88849062920174)},
  //   {"name": "Collins Hall", "location": LatLng(40.862849310672054, -73.88704789021529)},
  //   {"name": "Martyrs' Court Back", "location": LatLng(40.86319213127064, -73.88784099212826)},
  //   {"name": "Queen's Court", "location": LatLng(40.863002991029404, -73.88729173101204)},
  //   {"name": "Collins Hall", "location": LatLng(40.862467028278516, -73.88645353154206)},
  //   {"name": "Alumni Court South", "location": LatLng(40.86359834230361, -73.8875415131169)},
  //   {"name": "Amazon Locker", "location": LatLng(40.86381962609719, -73.88730816541958)},
  //   {"name": "Tennis Court", "location": LatLng(40.86393423956953, -73.8850119381504)},
  //   {"name": "Bahoshy Field", "location": LatLng(40.86334881121144, -73.88466008803972)},
  //   {"name": "Field", "location": LatLng(40.863883811300056, -73.88431932331652)},
  //   {"name": "McGinley Center", "location": LatLng(40.86266254185804, -73.8840971040944)},
  //   {"name": "Bahoshy Softball Complex", "location": LatLng(40.86304908748162, -73.88356374252838)},
  //   {"name": "Rose Hill Gymnasium", "location": LatLng(40.86192025165094, -73.88440081502361)},
  //   {"name": "Jack Coffey Field", "location": LatLng(40.86147765821646, -73.88261187068268)},
  //   {"name": "Xavier Way", "location": LatLng(40.86077176290269, -73.88184148720234)},
  //   {"name": "Fordham Store || Bookstore", "location": LatLng(40.85959805899672, -73.88272298718134)},
  //   {"name": "O'Hare Hall", "location": LatLng(40.859256309232265, -73.88277484476826)},
  //   {"name": "Tierney Hall", "location": LatLng(40.85928992605681, -73.88348968026257)},
  //   {"name": "RAM Van", "location": LatLng(40.8590798306726, -73.88227853215828)},
  //   {"name": "Parking Regional Parking Facility", "location": LatLng(40.85874927585338, -73.88180815161397)},
  //   {"name": "Communication Department", "location": LatLng(40.85841032410379, -73.88259706112997)},
  //   {"name": "Canisius Hall", "location": LatLng(40.8586204225088, -73.88274521203577)},
  //   {"name": "Keating Hall", "location": LatLng(40.860569492650555, -73.88353242172421)},
  //   {"name": "Keating Hall", "location": LatLng(40.86084401197889, -73.88397688062106)},
  //   {"name": "Edward's Parade", "location": LatLng(40.86098966739332, -73.88524730060098)},
  //   {"name": "Edward's Parade", "location": LatLng(40.86135943400756, -73.88456579661496)},
  //   {"name": "McShane Back", "location": LatLng(40.86284963153381, -73.88385094998279)},
  //   {"name": "Lombardi Memorial Center", "location": LatLng(40.862900051308, -73.88366946285079)},
  //   {"name": "Walsh Training Center", "location": LatLng(40.86228100228768, -73.88272499491018)},
  // ];

  final List<Marker> _markers = <Marker>[];
  // final List<LatLng> _latLen = <LatLng>[
  //   LatLng(40.8598444, -73.8847904), //John Mulcahy Hall
  //   LatLng(
  //       40.8602013, -73.8844390), //Mulcahy - Keating: (40.8602013, -73.8844390)
  //   LatLng(40.8601683, -73.8836578), //Keating Back: (40.8601683, -73.8836578)
  //   LatLng(
  //       40.8606841, -73.8832300), //Keating Front 1: (40.8606841, -73.8832300)
  //   LatLng(40.8598103, -73.8824994), //O’Hare Hall: (40.8598103, -73.8824994)
  //   LatLng(40.8603633, -73.8817890), //Parking Area: (40.8603633, -73.8817890)
  //   LatLng(40.8611839, -73.8837628), //Moglia Stadium: (40.8611839, -73.8837628)
  //   LatLng(40.8618342, -73.8842409), //Moglia Way: (40.8618342, -73.8842409)
  //
  //
  //   LatLng(40.8633417, -73.8855467), //Tennis Court: (40.8633417, -73.8855467)
  //   LatLng(40.8634756, -73.8858471), //Cemetery: (40.8634756, -73.8858471)
  //   LatLng(
  //       40.8640126, -73.8862444), //Fordham Prep sch: (40.8640126, -73.8862444)
  //   LatLng(40.8638970, -73.8868402), //Loschert Hall: (40.8638970, -73.8868402)
  //   LatLng(40.86382521262713, -73.8863784953219), //Loschert Hall
  //   LatLng(
  //       40.8636748, -73.8866543), //St John and Tueds: (40.8636748, -73.8866543)
  //   LatLng(40.8632446,
  //       -73.8867571), //Church and Brownson: (40.8632446, -73.8867571)
  //
  //   LatLng(40.8632266,
  //       -73.8865345), //Church and Crusifix: (40.8632266, -73.8865345)
  //   LatLng(40.8630526, -73.8862518), //Collings Hall: (40.8630526, -73.8862518)
  //   LatLng(
  //       40.8629180, -73.8860446), //Faber & Collings: (40.8629180, -73.8860446)
  //   LatLng(40.8625944, -73.8858394), //Loyola Hall: (40.8625944, -73.8858394)
  //   LatLng(40.8622184, -73.8856285), //Hughes Hall S: (40.8622184, -73.8856285)
  //   LatLng(40.8617097, -73.8858097), //Water Fall: (40.8617097, -73.8858097)
  //   LatLng(40.8619213, -73.8862813), //Cunniffee Hall: (40.8619213, -73.8862813)
  //   LatLng(40.8616210, -73.8864332), //Dealy Hall: (40.8616210, -73.8864332)
  //   LatLng(40.8614574, -73.8872238), //Duane: (40.8614574, -73.8872238)
  //   LatLng(40.8609952, -73.8882417), //Larking Hall: (40.8609952, -73.8882417)
  //   LatLng(40.86150607299467, -73.88896543957128), //Library
  //   LatLng(40.861226150882246, -73.89011879668851), //Gate
  //   LatLng(40.86236402896374, -73.88907875259216), //Campbell Hall
  //   LatLng(40.86278368807378, -73.88868700273055), //Salice Hall
  //   LatLng(40.86287763850865, -73.88902861442958), // Salice Hall Back
  //   LatLng(40.86253238516355, -73.88934538736315), //Campbell Hall Back
  //   LatLng(40.862966842701056, -73.88851991385981), //Conley Hall
  //   LatLng(40.86327172596001, -73.8885502213916), //Conley Hall Back
  //   LatLng(40.86325109170988, -73.88815617581797), //Conley Hall Side
  //   LatLng(40.862467046668414, -73.88849062920174), //Martyrs' Court
  //   LatLng(40.862849310672054, -73.88704789021529), //Collins Hall
  //   LatLng(40.86319213127064, -73.88784099212826), //Martyrs' Court Back
  //   LatLng(40.863002991029404, -73.88729173101204), //Queen's Court
  //   LatLng(40.862467028278516, -73.88645353154206), //Collins Hall
  //   LatLng(40.86359834230361, -73.8875415131169), //Alumni Court South
  //   LatLng(40.86381962609719, -73.88730816541958), //Amazon Locker
  //   LatLng(40.86393423956953, -73.8850119381504), //Tennis Court
  //   LatLng(40.86334881121144, -73.88466008803972), //Bahoshy Field
  //   LatLng(40.863883811300056, -73.88431932331652), //Field
  //   LatLng(40.86266254185804, -73.8840971040944), //McGinley Center
  //   LatLng(40.86304908748162, -73.88356374252838), //Bahoshy Softball Complex
  //   LatLng(40.86192025165094, -73.88440081502361), //Rose Hill Gymnasium
  //   LatLng(40.86147765821646, -73.88261187068268), //Jack Coffey Field
  //   LatLng(40.86077176290269, -73.88184148720234), //Xavier Way
  //   LatLng(40.85959805899672, -73.88272298718134), //Fordham Store || Bookstore
  //   LatLng(40.859256309232265, -73.88277484476826), //O'Hare Hall
  //   LatLng(40.85928992605681, -73.88348968026257), //Tierney Hall
  //   LatLng(40.8590798306726, -73.88227853215828), //RAM Van
  //   LatLng(40.85874927585338,
  //       -73.88180815161397), //Parking Regional Parking Facility
  //   LatLng(40.85841032410379, -73.88259706112997), // Communication Department
  //   LatLng(40.8586204225088, -73.88274521203577), // Canisius Hall
  //   LatLng(40.860569492650555, -73.88353242172421), // Keating Hall
  //   LatLng(40.86084401197889, -73.88397688062106), // Keating Hall
  //   LatLng(40.86098966739332, -73.88524730060098), // Edward's Parade
  //   LatLng(40.86135943400756, -73.88456579661496), // Edward's Parade
  //   LatLng(40.86284963153381, -73.88385094998279), // McShane Back
  //   LatLng(40.862900051308, -73.88366946285079), // Lombardi Memorial Center
  //   LatLng(40.86228100228768, -73.88272499491018), // Walsh Training Center
  // ];
  //
  // final List marker_names = [
  //   "John Mulcahy Hall",
  //   "Mulcahy - Keating",
  //   "Keating Front",
  //   "O’Hare Hall",
  //   "Parking Area",
  //   "Moglia Stadium",
  //   "Moglia Way",
  //   "Mc Shane",
  //   "Tennis Court",
  //   "Cemetery",
  //   "Fordham Prep sch",
  //   "Loschert Hall",
  //   "Loschert Hall",
  //   "St John and Tueds",
  //   "Church and Brownson",
  //   "Church and Crusifix",
  //   "Collings Hall B",
  //   "Faber & Collings",
  //   "Loyola Hall",
  //   "Hughes Hall",
  //   "Water Fall",
  //   "Cunniffee Hall",
  //   "Dealy Hall",
  //   "Duane & Larking side",
  //   "Larking Hall",
  //   "Library",
  //   "Gate",
  //   "Campbell Hall",
  //   "Salice Hall",
  //   "Salice Hall Back",
  //   "Campbell Hall Back",
  //   "Conley Hall",
  //   "Conley Hall Back",
  //   "Conley Hall Side",
  //   "Martyrs' Court",
  //   "Collins Hall",
  //   "Martyrs' Court Back",
  //   "Queen's Court",
  //   "Collins Hall",
  //   "Alumni Court South",
  //   "Amazon Locker",
  //   "Tennis Court",
  //   "Bahoshy Field",
  //   "Field",
  //   "McGinley Center",
  //   "Bahoshy Softball Complex",
  //   "Rose Hill Gymnasium",
  //   "Jack Coffey Field",
  //   "Xavier Way",
  //   "Fordham Store || Bookstore",
  //   "O'Hare Hall",
  //   "Tierney Hall",
  //   "RAM Van",
  //   "Parking Regional Parking Facility",
  //   "Communication Department",
  //   "Canisius Hall",
  //   "Keating Hall",
  //   "Keating Hall",
  //   "Edward's Parade",
  //   "Edward's Parade",
  //   "McShane",
  //   "Lombardi Memorial Center",
  //   "Walsh Training Center",
  // ];
>>>>>>> Stashed changes

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initialize loadData method
    loadData();

    /// origin marker
    _addMarker(LatLng(_originLatitude, _originLongitude), "origin", BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination", BitmapDescriptor.defaultMarkerWithHue(90));

    _getPolyline();
  }

<<<<<<< Updated upstream
  // created method for displaying custom markers according to index
  loadData() async{
    for(int i=0 ;i<images.length; i++){
      final Uint8List markIcons = await getImages(images[i], 100);
      // makers added according to index
      _markers.add(
          Marker(
            // given marker id
            markerId: MarkerId(i.toString()),
            // given marker icon
            icon: BitmapDescriptor.fromBytes(markIcons),
            // given position
            position: _latLen[i],
            infoWindow: InfoWindow(
              // given title for marker
              title: 'Location: '+i.toString(),
            ),
          )
      );
      setState(() {
      });
    }
  }

  getLocationName(int itermIndex) async{
    // get the location name from the lat and long
    // using geocoding
    if (itermIndex == 0){
      return 'Library';
    }else if (itermIndex == 1){
      return 'Keating Hall';
=======
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

    for (int i = 0; i < locations.length; i++) {
      double distanceInMeters = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        locations[i]["location"].latitude,
        locations[i]["location"].longitude,
      );

      if (distanceInMeters <= proximityThreshold) {
        widget.selectedLocation(i, locations[i]["name"]);
        isNearLocation = true;
        break;
      }
    }

    if (!isNearLocation) {
      widget.selectedLocation(0, locations[0]["name"]);
    }
  }

  Future<void> loadData() async {
    for (int i = 0; i < locations.length; i++) {
      final Uint8List markIcons = await getImages("assets/icons/1.png", 100);

      _markers.add(Marker(
        markerId: MarkerId(i.toString()),
        icon: BitmapDescriptor.fromBytes(markIcons),
        position: locations[i]["location"],
        infoWindow: InfoWindow(
          title: '${locations[i]["name"]}',
        ),
        onTap: () {
          widget.selectedLocation(i, locations[i]["name"]); // Only trigger on tap
        },
      ));

      setState(() {});
>>>>>>> Stashed changes
    }
    else if (itermIndex == 2){
      return 'Church';
    }
    else if (itermIndex == 3){
      return 'University';
    }
    else if (itermIndex == 4){
      return 'Food Delivery';
    }
    else{
      return 'Location: '+itermIndex.toString();
    }

  }

  // @override
  // void initState() {
  //   super.initState();
  //
  //
  // }

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
          // initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
<<<<<<< Updated upstream
          // onMapCreated: _onMapCreated,
          // markers: Set<Marker>.of(markers.values),
=======
          initialCameraPosition: CameraPosition(target: locations[0]["location"], zoom: 17.5),
          markers: Set<Marker>.of(_markers),
>>>>>>> Stashed changes
          polylines: Set<Polyline>.of(polylines.values),
          // given camera position
          initialCameraPosition: _kGoogle,
          // set markers on google map
          markers: Set<Marker>.of(_markers),
          // on below line we have given map type
          // on below line we have enabled location
          myLocationButtonEnabled: true,
          // on below line we have enabled compass
          // below line displays google map in our app
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  void _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      position: position,
    );
    markers[markerId] = marker;
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

  Future<void> _getPolyline() async {
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleAPiKey,
        request: PolylineRequest(
          origin: PointLatLng(_originLatitude, _originLongitude),
          destination: PointLatLng(_destLatitude, _destLongitude),
          mode: TravelMode.driving,
          wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
        ),
      );

      if (result.points.isNotEmpty) {
        for (PointLatLng point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      } else {
        print("No points found in result.");
      }
      _addPolyLine();
    } catch (e) {
      print("Error getting polyline: $e");
    }
  }
}

