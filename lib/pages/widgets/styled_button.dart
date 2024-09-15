
import 'package:flutter/material.dart';
import 'package:flutter_realtime_detection/pages/widgets/frosted_glass.dart'; // Adjust the import path as necessary


class RainbowButton extends StatefulWidget {
  const RainbowButton({Key? key, required this.label}) : super(key: key);
  final String label;

  @override
  _RainbowButtonState createState() => _RainbowButtonState();
}

class _RainbowButtonState extends State<RainbowButton>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  // ScrollController s = ScrollController();

  List<Color> rainbowColor = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(seconds: 1),
      value: 0,
      lowerBound: 0,
      upperBound: 80,
    )
    // ..addListener(
    //   () async {
    //     s.jumpTo((_controller?.value ?? 1) * 5);
    //   },
    // )
      ..repeat(); // Start and repeat the animation
  }

  @override
  Widget build(BuildContext context) {
    return _buildRainbowButton(context);
  }

  Stack _buildRainbowButton(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        FrostedGlassBox(
          // theWidth is the width of the frostedglass
          theWidth: 300.0,
          // theHeight is the height of the frostedglass
          theHeight: 300.0,
          // theChild is the child of the frostedglass
          label: widget.label,
        ),
        // Container(
        //   decoration: const BoxDecoration(
        //     color: Colors.black,
        //     borderRadius: BorderRadius.all(Radius.circular(10)),
        //   ),
        //   width: 280,
        //   height: 40,
        //   child: Center(
        //     child: Text(
        //       widget.label,
        //       style: GoogleFonts.kalam(
        //         fontWeight: FontWeight.bold,
        //         fontSize: 30,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
