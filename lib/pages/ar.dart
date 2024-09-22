import 'dart:async';
import 'dart:math' as math;

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_realtime_detection/detect_page.dart';
import 'package:flutter_realtime_detection/google_maps.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import 'widgets/info_dialog.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';


class ArVrPage extends StatefulWidget {
  const ArVrPage({Key? key, required this.camera}) : super(key: key);

  final List<CameraDescription> camera;

  @override
  _ArVrPageState createState() => _ArVrPageState();
}

class _ArVrPageState extends State<ArVrPage>
    with SingleTickerProviderStateMixin {
  ARKitController? arkitController; // Nullable ARKitController
  Timer? timer;
  bool anchorWasFound = false;
  bool showMap = false;
  bool _showARKitView = false;
  String imageDetected = '';
  CameraController? cameraController;

  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    getCam();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );

    // Start the animation
    _animationController!.forward();
  }

  void getCam() async {
    cameraController =
        CameraController(widget.camera[0], ResolutionPreset.high);
    await cameraController?.initialize();
    setState(() {});
  }

  void toggleARKitView(dynamic label) {
    setState(() {
      _showARKitView = !_showARKitView;
      imageDetected = label;
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    cameraController?.dispose(); // Dispose of the camera controller
    timer?.cancel();

    // Safely dispose the ARKit controller if it is initialized
    arkitController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ignore: unused_local_variable
    String _colorName = 'No';

    return Scaffold(
      backgroundColor: Color(0xFF26292C),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CircularMenu(
        toggleButtonSize: 30,
        alignment: Alignment.bottomCenter,
        toggleButtonColor: Color(0xFFB22002),
        items: [
          CircularMenuItem(
              icon: Icons.home,
              color: Colors.green,
              iconSize: 20,
              onTap: () {
                Navigator.of(context).pop();
                setState(() {
                  _colorName = 'Green';
                });
              }),
          CircularMenuItem(
              icon: Icons.castle,
              color: Colors.blue,
              iconSize: 20,
              onTap: () {
                setState(() {
                  showMap = !showMap;
                });
              }),
          CircularMenuItem(
              icon: Icons.map_outlined,
              color: Colors.red,
              iconSize: 20,
              onTap: () {
                setState(() {
                  showMap = !showMap;
                });
              }),
          CircularMenuItem(
              icon: Icons.info,
              color: Colors.brown,
              iconSize: 20,
              onTap: () {
                dialogBuilder(context);
                setState(() {
                  _colorName = 'Brown';
                });
              }),
          CircularMenuItem(
              icon: Icons.swap_calls,
              color: Colors.orange,
              iconSize: 20,
              onTap: () {
                setState(() {
                  _showARKitView = !_showARKitView;
                });
              }),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _showARKitView
              ? ARKitSceneView(
                  onARKitViewCreated: onARKitViewCreated,
                )
              : DetectObj(
                  cameras: widget.camera, toddleARKitView: toggleARKitView),
          Positioned(
            top: 60,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? Colors.white : Colors.black,
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
          if (showMap)
            DraggableScrollableSheet(
              initialChildSize: 0.35,
              minChildSize: 0.25,
              maxChildSize: 0.75,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: GoogleMaps(),
                  ),
                );
              },
            ),
          _showARKitView
              ? Align(
                  alignment: Alignment.topRight,
                  child: FadeTransition(
                    opacity: _animation!,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1 + 400,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.view_in_ar,
                          size: 50,
                          color: isDark ? Colors.black : Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _showARKitView = !_showARKitView;
                          });
                        },
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  void onARKitViewCreated(ARKitController controller) {
    // Initialize arkitController here
    arkitController = controller;

    // ARKit objects creation logic...
    arkitController?.add(_createSphere());
    arkitController?.add(_createPlane());
    arkitController?.add(_createText());
    arkitController?.add(_createBox());
    arkitController?.add(_createCylinder());
    arkitController?.add(_createCone());
    arkitController?.add(_createPyramid());
    arkitController?.add(_createTube());
    arkitController?.add(_createTorus());
    arkitController?.add(_createCapsule());
  }

  ARKitNode _createSphere() => ARKitNode(
        geometry:
            ARKitSphere(materials: _createRandomColorMaterial(), radius: 0.04),
        position: vector.Vector3(-0.1, -0.1, -0.5),
      );

  ARKitNode _createPlane() {
    final plane = ARKitPlane(
      width: 1,
      height: 1,
      materials: [
        ARKitMaterial(
          transparency: 0.5,
          diffuse: ARKitMaterialProperty.color(Colors.white),
        )
      ],
    );
    return ARKitNode(
      geometry: plane,
      position: vector.Vector3(0, 0, -1.5),
    );
  }

  ARKitNode _createText() {
    final text = ARKitText(
      text: imageDetected == ''
          ? 'Detect Objects on Fordham Campus '
          : imageDetected,
      extrusionDepth: 1,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty.color(Colors.blue),
        )
      ],
    );
    return ARKitNode(
      geometry: text,
      position: vector.Vector3(-0.3, 0.3, -1.4),
      scale: vector.Vector3(0.02, 0.02, 0.02),
    );
  }

  ARKitNode _createBox() => ARKitNode(
        geometry: ARKitBox(
            width: 0.06,
            height: 0.06,
            length: 0.06,
            chamferRadius: 0.01,
            materials: _createRandomColorMaterial()),
        position: vector.Vector3(-0.1, 0, -0.5),
      );

  ARKitNode _createCylinder() => ARKitNode(
        geometry: ARKitCylinder(
            radius: 0.05,
            height: 0.09,
            materials: _createRandomColorMaterial()),
        position: vector.Vector3(-0.1, 0.1, -0.5),
      );

  ARKitNode _createCone() => ARKitNode(
        geometry: ARKitCone(
            topRadius: 0,
            bottomRadius: 0.05,
            height: 0.09,
            materials: _createRandomColorMaterial()),
        position: vector.Vector3(0, -0.2, -0.5),
      );

  ARKitNode _createPyramid() => ARKitNode(
        geometry: ARKitPyramid(
            width: 0.06,
            height: 0.06,
            length: 0.06,
            materials: _createRandomColorMaterial()),
        position: vector.Vector3(-0.2, -0.2, -0.5),
      );

  ARKitNode _createTube() => ARKitNode(
        geometry: ARKitTube(
            innerRadius: 0.03,
            outerRadius: 0.05,
            height: 0.2,
            materials: _createRandomColorMaterial()),
        position: vector.Vector3(0.2, -0.2, -0.5),
      );

  ARKitNode _createTorus() => ARKitNode(
        geometry: ARKitTorus(
            ringRadius: 0.05,
            pipeRadius: 0.02,
            materials: _createRandomColorMaterial()),
        position: vector.Vector3(0.1, 0, -0.5),
      );

  ARKitNode _createCapsule() => ARKitNode(
        geometry: ARKitCapsule(
            capRadius: 0.03,
            height: 0.1,
            materials: _createRandomColorMaterial()),
        position: vector.Vector3(0.2, 0.1, -0.5),
      );

  List<ARKitMaterial> _createRandomColorMaterial() {
    final random = math.Random();
    final color = Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
    return [
      ARKitMaterial(
        diffuse: ARKitMaterialProperty.color(color),
      )
    ];
  }
}
