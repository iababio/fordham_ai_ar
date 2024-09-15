import 'dart:async';
import 'dart:ui' as ui;

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
          // onMapCreated: _onMapCreated,
          // markers: Set<Marker>.of(markers.values),
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

