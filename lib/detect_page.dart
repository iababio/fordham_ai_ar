
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:FordhamAR/pages/ai_detect/camera.dart';
import 'package:FordhamAR/pages/ai_detect/models.dart';
import 'package:FordhamAR/pages/ar.dart';
import 'package:FordhamAR/pages/widgets/styled_button.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import 'package:FordhamAR/pages/ai_detect/bndbox.dart';

class DetectObj extends StatefulWidget {
  const DetectObj({Key? key, required this.cameras, required this.toddleARKitView}) : super(key: key);

  final void Function(dynamic label) toddleARKitView;
  final List<CameraDescription> cameras;

  @override
  _DetectObjState createState() => _DetectObjState();
}

class _DetectObjState extends State<DetectObj> with TickerProviderStateMixin {
  // CameraController? _cameraController;
  // late List<CameraDescription> cameras;
  late List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "ssd";
  bool isCameraReady = false;
  Timer? _timer; // Timer to log every 3 seconds
  String _label = '';

  @override
  void initState() {
    super.initState();
    loadModel();
    startLoggingTimer(); // Start the logging timer


    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
  }

  void startLoggingTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      logRecognitions();
    });
  }

  void logRecognitions() {
    // Trigger the animation with a delay, checking if the widget is still mounted
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        _animationController?.forward();
      }
    });

    if (_recognitions.isNotEmpty) {
      for (var recognition in _recognitions) {
        String label = recognition['detectedClass'] ?? 'Unknown';
        double confidence = recognition['confidence'] ?? 0.0;
        print('Detected object: $label');
        setState(() {
          _label = label;
        });
      }
    }
  }


  AnimationController? _animationController;
  Animation<double>? _animation;


  loadModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt",
      );
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  runModelOnFrame(CameraImage img) async {
    try {
      var recognitions = await Tflite.detectObjectOnFrame(
        bytesList: img.planes.map((plane) => plane.bytes).toList(),
        model: "SSDMobileNet",
        imageHeight: img.height,
        imageWidth: img.width,
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.5,
        numResultsPerClass: 1,
      );

      setRecognitions(recognitions!, img.height, img.width);
    } catch (e) {
      print("Error running model on frame: $e");
    }
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Camera(
            widget.cameras,
            _model,
            setRecognitions,
          ),
          if (_label != 'unknown' && _label.isNotEmpty)
            Align(
              alignment: Alignment.topRight,
              child: FadeTransition(
                opacity: _animation!,
                child: InkWell(
                  onTap: () {
                    widget.toddleARKitView(_label);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 200),
                    child: RainbowButton(
                      label: _label,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


