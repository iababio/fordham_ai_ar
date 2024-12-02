import 'dart:async';

import 'package:FordhamAR/utils/cardInfo.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:FordhamAR/google_maps.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../ar_photo.dart';
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
  ARKitController? arkitController;
  Timer? timer;
  bool anchorWasFound = false;
  bool showMap = false;
  bool _showARKitView = true;
  String imageDetected = '';
  CameraController? cameraController;
  final GlobalKey<CircularMenuState> _menuKey = GlobalKey<CircularMenuState>();
  bool _isCameraInitialized = false;

  AnimationController? _animationController;
  Animation<double>? _animation;
  int location = 0;
  String locationName = '';

  @override
  void initState() {
    super.initState();
    initializeCamera();
    _setupAnimation();
    _setOrientation();
  }

  Future<void> initializeCamera() async {
    try {
      cameraController = CameraController(
        widget.camera[0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController?.initialize();

      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );

    _animationController!.forward();
  }

  void _setOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

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

  void toggleARKitView(dynamic label) {
    setState(() {
      _showARKitView = !_showARKitView;
      imageDetected = label;

      if (!_showARKitView) {
        // Turn off ARKit view and dispose the camera
        arkitController?.dispose();
        arkitController = null;

        // Dispose of the camera controller
        if (cameraController != null) {
          cameraController?.dispose();
          cameraController = null;
        }
      } else {
        // Re-initialize ARKit view when toggling back
        initializeCamera();
      }
    });
  }

  bool _isDisposed = false;

  @override
  void dispose() {
    _cleanupResources();
    super.dispose();
  }

  void _cleanupResources() async {
    if (_isDisposed) return;

    // Dispose of the camera controller
    if (cameraController != null) {
      await cameraController?.dispose();
      cameraController = null;
    }

    // Dispose of the ARKit controller
    if (arkitController != null) {
      arkitController?.dispose();
      arkitController = null;
    }

    if (_animationController != null && _animationController!.isAnimating) {
      _animationController!.stop();
    }
    _animationController?.dispose();

    timer?.cancel();
    _isDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                panaoramaImage: cardInfo[location]["panoramaImage"]! as String,
              ),
            buildBackButton(isDark),
            if (showMap) buildMapSheet(),
            buildARToggleButton(isDark),
          ],
        ),
      ),
    );
  }

  Widget buildBackButton(bool isDark) {
    return Positioned(
      top: 60,
      left: 20,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.white : Colors.black,
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: isDark ? Colors.black : Colors.white,
          ),
          onPressed: () async {
            _cleanupResources();
            if (mounted) {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  Widget buildCircularMenu() {
    return CircularMenu(
      key: _menuKey,
      toggleButtonSize: 30,
      radius: 60,
      alignment: Alignment.bottomCenter,
      toggleButtonColor: Color(0xFFB22002),
      items: [
        CircularMenuItem(
          icon: Icons.home,
          color: Colors.green,
          iconSize: 20,
          onTap: () => Navigator.of(context).pop(),
        ),
        CircularMenuItem(
          icon: Icons.map_outlined,
          color: Colors.red,
          iconSize: 20,
          onTap: () => setState(() => showMap = !showMap),
        ),
        CircularMenuItem(
          icon: Icons.info,
          color: Colors.brown,
          iconSize: 20,
          onTap: () => dialogBuilder(context),
        ),
      ],
    );
  }

  Widget buildMapSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.25,
      maxChildSize: 0.75,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            child: GoogleMaps(selectedLocation: selectedLocation, arkitController: arkitController!),
          ),
        );
      },
    );
  }

  Widget buildARToggleButton(bool isDark) {
    return Align(
      alignment: Alignment.topRight,
      child: FadeTransition(
        opacity: _animation!,
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.1 + 400,
          ),
          child: Container(
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? Color.fromARGB(172, 255, 255, 255) : Colors.black,
            ),
            child: IconButton(
              icon: Icon(
                Icons.view_in_ar,
                size: 30,
                color: isDark ? Colors.black : Colors.white,
              ),
              onPressed: () => setState(() => _showARKitView = !_showARKitView),
            ),
          ),
        ),
      ),
    );
  }

// Rest of the methods remain the same, just updating the method names here for clarity

  ARKitNode _createContainerBackground() {
    final container = ARKitBox(
      width: 0.8, // Increased width
      height: 0.70, // Increased height
      length: 0.01, // Depth remains the same for a flat background
      materials: [
        ARKitMaterial(
          diffuse:
              ARKitMaterialProperty.color(Color.fromARGB(172, 255, 255, 255)),
          // diffuse: ARKitMaterialProperty.image('assets/images/pexels-pixabay-290595.jpg'),
          doubleSided: true,
        ),
      ],
    );

    return ARKitNode(
      name: "container",
      geometry: container,
      position: vector.Vector3(0, 0, -1.2), // Adjusted position for centering
    );
  }

  ARKitNode AddImage() {
    final container = ARKitBox(
      width: 0.2, // Increased width
      height: 0.12, // Increased height
      length: 0.01, // Depth remains the same for a flat background
      materials: [
        ARKitMaterial(
          // diffuse: ARKitMaterialProperty.color(Colors.white),
          diffuse: ARKitMaterialProperty.image(
              cardInfo[location]['image']! as String),
          doubleSided: true,
        ),
      ],
    );

    return ARKitNode(
      name: "image",
      geometry: container,
      position:
          vector.Vector3(-0.24, 0.25, -1.19), // Adjusted position for centering
    );
  }

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
      text: cardInfo[location]['subText']! as String,
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
      text: cardInfo[location]['list1']! as String,
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
      text: cardInfo[location]['list2']! as String,
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
      text: cardInfo[location]['list3']! as String,
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
      text: cardInfo[location]['list4']! as String,
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
      text: cardInfo[location]['status']! as String,
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
          diffuse: ARKitMaterialProperty.image(
              'assets/images/backgrounds/' +
                  i.toString() +
                  '.png'),
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

// Update other _create methods similarly, adding a name parameter to each ARKitNode
// For example:

ARKitNode _createTitleText(int i) {
  var location = i;
  final titleText = ARKitText(
    text: cardInfo[location]['title']! as String,
    extrusionDepth: 0.01,
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
    scale: vector.Vector3(0.003, 0.003, 0.003),
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
  final container = ARKitBox(
    width: 0.12,
    height: 0.08,
    length: 0.01,
    materials: [
      ARKitMaterial(
        diffuse: ARKitMaterialProperty.image(
            'assets/images/backgrounds/$i.png'),
        doubleSided: true,
      ),
    ],
  );

  return ARKitNode(
    name: "bottomImage$i",
    geometry: container,
    position: vector.Vector3(-0.2 + i * 0.13, -0.24, -1.19),
  );
}
