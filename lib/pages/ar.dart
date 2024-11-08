import 'dart:async';
import 'dart:math' as math;

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:FordhamAR/detect_page.dart';
import 'package:FordhamAR/google_maps.dart';
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
<<<<<<< Updated upstream
=======
  int location = 0;
  String locationName = '';
>>>>>>> Stashed changes

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

<<<<<<< Updated upstream
=======
Future<void> onARKitViewCreated(ARKitController controller) async {
    arkitController = controller;
    arkitController?.addCoachingOverlay(CoachingOverlayGoal.horizontalPlane);
    arkitController?.addCoachingOverlay(CoachingOverlayGoal.verticalPlane);
    arkitController?.addCoachingOverlay(CoachingOverlayGoal.anyPlane);

    updateARContent();
  }

  void updateARContent() {
    arkitController?.remove("container");
    arkitController?.remove("image");
    arkitController?.remove("title");
    arkitController?.remove("subText");
    arkitController?.remove("list1");
    arkitController?.remove("list2");
    arkitController?.remove("list3");
    arkitController?.remove("list4");
    arkitController?.remove("status");

    for (int i = 0; i < 5; i++) {
      arkitController?.remove("star$i");
    }

    for (int i = 1; i < 5; i++) {
      arkitController?.remove("bottomImage$i");
    }

    // Create and add the container background
    final containerNode = _createContainerBackground();
    arkitController?.add(containerNode);

    // Create and add text nodes separately
    arkitController?.add(AddImage());
    arkitController?.add(_createTitleText());
    arkitController?.add(_createSubText());
    arkitController?.add(_createList1Text());
    arkitController?.add(_createList2Text());
    arkitController?.add(_createList3Text());
    arkitController?.add(_createList4Text());
    arkitController?.add(_createStatusText());

    // Add stars
    for (int i = 0; i < 5; i++) {
      arkitController?.add(_createStarNode(i));
    }
    // Add Bottom Image
    for (int i = 1; i < 5; i++) {
      arkitController?.add(AddBottomImage(i));
    }
  }

  void selectedLocation(int index, String name) {
    kDebugMode ? print('Selected location: $index and $name') : null;
    setState(() {
      location = index;
      locationName = name;
      if (arkitController != null) {
        updateARContent();
      }
    });
  }


>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
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
=======
    return WillPopScope(
      onWillPop: () async {
        _cleanupResources();
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xFF26292C),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: buildCircularMenu(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (_isCameraInitialized && _showARKitView)
              ARKitSceneView(
                onARKitViewCreated: onARKitViewCreated,
              )
            else if (!_showARKitView)
              PanoramaPage(
                arkitController: arkitController!,
                panaoramaImage: cardInfo[location]["panoramaImage"] as String,
              ),
            buildBackButton(isDark),
            if (showMap) buildMapSheet(),
            buildARToggleButton(isDark),
          ],
        ),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
          diffuse: ARKitMaterialProperty.color(Colors.blue),
        )
=======
          // diffuse: ARKitMaterialProperty.color(Colors.white),
          diffuse: ARKitMaterialProperty.image(
              cardInfo[location]['image'] as String),
          doubleSided: true,
        ),
>>>>>>> Stashed changes
      ],
    );
    return ARKitNode(
      geometry: text,
      position: vector.Vector3(-0.3, 0.3, -1.4),
      scale: vector.Vector3(0.02, 0.02, 0.02),
    );
  }

<<<<<<< Updated upstream
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
=======
// Title text adjustment
  ARKitNode _createTitleText() {
    final titleText = ARKitText(
      text: locationName,
      extrusionDepth: 0.01, // Better extrusion for visibility
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty.color(Colors.black87),
        ),
      ],
    );

    return ARKitNode(
      name: "title",
      geometry: titleText,
      position: vector.Vector3(-0.08, 0.25, -1.19),
      // Adjusted position to be inside the container
      scale: vector.Vector3(
          0.003, 0.003, 0.003), // Increased scale for better readability
    );
  }

  // Address text adjustment
  ARKitNode _createSubText() {
    final addressText = ARKitText(
      text: cardInfo[location]['subText'] as String,
      extrusionDepth: 0.01,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty.color(Colors.black54),
        ),
      ],
    );

    return ARKitNode(
      name: "subText",
      geometry: addressText,
      position: vector.Vector3(-0.08, 0.20, -1.19),
      // Positioned below the title
      //   -0.23, 0.1, -1.19
      scale:
          vector.Vector3(0.002, 0.002, 0.002), // Adjusted scale for readability
    );
  }

// List Item 1 text adjustment
  ARKitNode _createList1Text() {
    final addressText = ARKitText(
      text: cardInfo[location]['list1'] as String,
      extrusionDepth: 0.01,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty.color(Colors.black54),
        ),
      ],
    );

    return ARKitNode(
      name: "list1",
      geometry: addressText,
      position: vector.Vector3(-0.33, 0.08, -1.19),
      // Positioned below the title
      //   -0.23, 0.1, -1.19
      scale:
          vector.Vector3(0.002, 0.002, 0.002), // Adjusted scale for readability
    );
  }

// List Item 2 text adjustment
  ARKitNode _createList2Text() {
    final addressText = ARKitText(
      text: cardInfo[location]['list2'] as String,
      extrusionDepth: 0.01,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty.color(Colors.black54),
        ),
      ],
    );

    return ARKitNode(
      name: "list2",
      geometry: addressText,
      position: vector.Vector3(-0.33, 0.04, -1.19),
      // Positioned below the title
      //   -0.23, 0.1, -1.19
      scale:
          vector.Vector3(0.002, 0.002, 0.002), // Adjusted scale for readability
    );
  }

  // List Item 3 text adjustment
  ARKitNode _createList3Text() {
    final addressText = ARKitText(
      text: cardInfo[location]['list3'] as String,
      extrusionDepth: 0.01,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty.color(Colors.black54),
        ),
      ],
    );

    return ARKitNode(
      name: "list3",
      geometry: addressText,
      position: vector.Vector3(-0.33, 0.00, -1.19),
      // Positioned below the title
      //   -0.23, 0.1, -1.19
      scale:
          vector.Vector3(0.002, 0.002, 0.002), // Adjusted scale for readability
    );
  }

  // List Item 4 text adjustment
  ARKitNode _createList4Text() {
    final addressText = ARKitText(
      text: cardInfo[location]['list4'] as String,
      extrusionDepth: 0.01,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty.color(Colors.black54),
        ),
      ],
    );

    return ARKitNode(
      name: "list4",
      geometry: addressText,
      position: vector.Vector3(-0.33, -0.04, -1.19),
      // Positioned below the title
      //   -0.23, 0.1, -1.19
      scale:
          vector.Vector3(0.002, 0.002, 0.002), // Adjusted scale for readability
    );
  }

// Status text adjustment
  ARKitNode _createStatusText() {
    final statusText = ARKitText(
      text: cardInfo[location]['status'] as String,
      extrusionDepth: 0.01,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty.color(Colors.black54),
        ),
      ],
    );

    return ARKitNode(
      name: "status",
      geometry: statusText,
      position: vector.Vector3(-0.23, -0.14, -1.19),
      // Positioned near the bottom
      scale: vector.Vector3(
          0.002, 0.002, 0.002), // Consistent scale with the address
    );
  }

// Adjusted star node creation
  ARKitNode _createStarNode(int i) {
    final star = ARKitBox(
      width: 0.015, // Slightly increased size for visibility
      height: 0.015,
      length: 0.01,
      materials: [
        ARKitMaterial(
          diffuse: ARKitMaterialProperty.color(
            // Adjusted color for visibility from gray to red
            i.isEven
                ? Color.fromARGB(255, 92, 7, 1)
                : Color.fromARGB(255, 246, 158, 154),
          ),
        ),
      ],
    );

    return ARKitNode(
      geometry: star,
      position: vector.Vector3(
          -0.33 + i * 0.03, -0.24, -1.19), // Positioned horizontally
    );
  }

  ARKitNode AddBottomImage(int i) {
    final container = ARKitBox(
      width: 0.12, // Increased width
      height: 0.08, // Increased height
      length: 0.01, // Depth remains the same for a flat background
      materials: [
        ARKitMaterial(
          // diffuse: ARKitMaterialProperty.color(Colors.white),
          diffuse:
              ARKitMaterialProperty.image('assets/images/backgrounds/$i.png'),
          doubleSided: true,
        ),
      ],
    );

    return ARKitNode(
      name: "bottomImage$i",
      geometry: container,
      position: vector.Vector3(
          -0.2 + i * 0.13, -0.24, -1.19), // Adjusted position for centering
    );
  }
}

extension ARKitNodeExtension on ARKitNode {
  void addChildNode(ARKitNode child) {
    // Implement the method to add a child node
    this.addChildNode(child);
  }
}

ARKitNode _createContainerBackground() {
  final container = ARKitBox(
    width: 0.8,
    height: 0.70,
    length: 0.01,
    materials: [
      ARKitMaterial(
        diffuse:
            ARKitMaterialProperty.color(Color.fromARGB(172, 255, 255, 255)),
        doubleSided: true,
      ),
    ],
  );

  return ARKitNode(
    name: "container",
    geometry: container,
    position: vector.Vector3(0, 0, -1.2),
  );
}

ARKitNode AddImage(int i) {
  var location = i;
  final container = ARKitBox(
    width: 0.2,
    height: 0.12,
    length: 0.01,
    materials: [
      ARKitMaterial(
        diffuse:
            ARKitMaterialProperty.image(cardInfo[location]['image'] as String),
        doubleSided: true,
      ),
    ],
  );

  return ARKitNode(
    name: "image",
    geometry: container,
    position: vector.Vector3(-0.24, 0.25, -1.19),
  );
}

ARKitNode _createStarNode(int i) {
  final star = ARKitBox(
    width: 0.015,
    height: 0.015,
    length: 0.01,
    materials: [
      ARKitMaterial(
        diffuse: ARKitMaterialProperty.color(
          i.isEven
              ? Color.fromARGB(255, 92, 7, 1)
              : Color.fromARGB(255, 246, 158, 154),
        ),
      ),
    ],
  );

  return ARKitNode(
    name: "star$i",
    geometry: star,
    position: vector.Vector3(-0.33 + i * 0.03, -0.24, -1.19),
  );
  }

ARKitNode AddBottomImage(int i) {
  var location = i;
  final container = ARKitBox(
    width: 0.12,
    height: 0.08,
    length: 0.01,
    materials: [
      ARKitMaterial(
        diffuse:
            ARKitMaterialProperty.image('assets/images/backgrounds/$i.png'),
        doubleSided: true,
      ),
    ],
  );

  return ARKitNode(
    name: "bottomImage$i",
    geometry: container,
    position: vector.Vector3(-0.2 + i * 0.13, -0.24, -1.19),
  );
>>>>>>> Stashed changes
}
