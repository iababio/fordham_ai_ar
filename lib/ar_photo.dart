import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class PanoramaPage extends StatefulWidget {
  PanoramaPage({Key? key, required this.arkitController, required this.panaoramaImage}) : super(key: key);
  final String panaoramaImage;

  ARKitController arkitController;
  @override
  _PanoramaPageState createState() => _PanoramaPageState();
}

class _PanoramaPageState extends State<PanoramaPage> {
  @override
  void dispose() {
    widget.arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        // Remove the AppBar by setting it to null
        body: Container(
          // Ensure the ARKitSceneView takes the entire screen
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ARKitSceneView(
            planeDetection: ARPlaneDetection.horizontal,
            onARKitViewCreated: onARKitViewCreated,
          ),
        ),
      );

  void onARKitViewCreated(ARKitController arkitController) {
    this.widget.arkitController = arkitController;
    final material = ARKitMaterial(
      diffuse: ARKitMaterialProperty.image('assets/panorama/' +
          widget.panaoramaImage), // Change the image path to the panorama image
      doubleSided: true,
    );
    final sphere = ARKitSphere(
      materials: [material],
      radius: 20,
    );

    final node = ARKitNode(
      geometry: sphere,
      position: Vector3.zero(),
      eulerAngles: Vector3.zero(),
    );
    widget.arkitController.add(node);
  }
}
