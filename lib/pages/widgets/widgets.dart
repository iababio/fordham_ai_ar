// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/blocks/leaf/code_block.dart';
import 'package:markdown_widget/widget/blocks/leaf/link.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';

import 'code_wrapper.dart';


/// A simple widget that builds different things on different platforms.
class PlatformWidget extends StatelessWidget {
  const PlatformWidget({
    super.key,
    required this.androidBuilder,
    required this.iosBuilder,
  });

  final WidgetBuilder androidBuilder;
  final WidgetBuilder iosBuilder;

  @override
  Widget build(context) {
    assert(
    defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS,
    'Unexpected platform $defaultTargetPlatform');
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => androidBuilder(context),
      TargetPlatform.iOS => iosBuilder(context),
      _ => const SizedBox.shrink()
    };
  }
}

/// A platform-agnostic card with a high elevation that reacts when tapped.
///
/// This is an example of a custom widget that an app developer might create for
/// use on both iOS and Android as part of their brand's unique design.
class PressableCard extends StatefulWidget {
  const PressableCard({
    this.onPressed,
    required this.color,
    this.backgroundImage,
    required this.flattenAnimation,
    this.child,
    super.key,
  });

  final VoidCallback? onPressed;
  final Color color;
  final String? backgroundImage;
  final Animation<double> flattenAnimation;
  final Widget? child;

  @override
  State<StatefulWidget> createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard>
    with SingleTickerProviderStateMixin {
  bool pressed = false;
  late final AnimationController controller;
  late final Animation<double> elevationAnimation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 40),
    );
    elevationAnimation =
        controller.drive(CurveTween(curve: Curves.easeInOutCubic));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double get flatten => 1 - widget.flattenAnimation.value;

  @override
  Widget build(context) {
    return Listener(
      onPointerDown: (details) {
        if (widget.onPressed != null) {
          controller.forward();
        }
      },
      onPointerUp: (details) {
        controller.reverse();
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          widget.onPressed?.call();
        },
        

        child: AnimatedBuilder(
          animation:
          Listenable.merge([elevationAnimation, widget.flattenAnimation]),
          child: widget.child,
          builder: (context, child) {
            return Transform.scale(
              

              scale: 1 - elevationAnimation.value * 0.03,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16) *
                    flatten,
                child: PhysicalModel(
                  elevation:
                  ((1 - elevationAnimation.value) * 10 + 10) * flatten,
                  borderRadius: BorderRadius.circular(12 * flatten),
                  clipBehavior: Clip.antiAlias,
                  color: widget.color,
                  child: child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


class HeroAnimatingServiceCard extends StatelessWidget {
  const HeroAnimatingServiceCard({
    required this.serice,
    required this.color,
    this.backgroundImage,
    required this.heroAnimation,
    this.onPressed,
    super.key,
  });

  final String serice;
  final Color color;
  final String? backgroundImage;
  final Animation<double> heroAnimation;
  final VoidCallback? onPressed;

  double get playButtonSize => 50 + 50 * heroAnimation.value;

  @override
  Widget build(context) {
    

    return AnimatedBuilder(
      animation: heroAnimation,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return PressableCard(
          onPressed: heroAnimation.value == 0 ? onPressed : null,
          color: backgroundImage != null ? Color.fromARGB(112, 1, 1, 1) : color,
          flattenAnimation: heroAnimation,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/$backgroundImage' ?? ''),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            
            height: 250,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // The song title banner slides off in the hero animation.
                Positioned(
                  bottom: -80 * heroAnimation.value,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    color: Colors.black38,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      serice,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                      ),
                      
                    ),
                  ),
                ),
                // The play button grows in the hero animation.
                Padding(
                  padding: const EdgeInsets.only(bottom: 45) *
                      (1 - heroAnimation.value),
                  child: Container(
                    height: playButtonSize,
                    width: playButtonSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black12,
                    ),
                    alignment: Alignment.center,
                    // child: Icon(Icons.ads_click_rounded,
                    //     size: playButtonSize, color: Colors.black38),
                    child: null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



/// A loading song tile's silhouette.
///
/// This is an example of a custom widget that an app developer might create for
/// use on both iOS and Android as part of their brand's unique design.
class ServicePlaceholderTile extends StatefulWidget {
  const ServicePlaceholderTile({super.key, this.content});

  final String? content;

  @override
  State<ServicePlaceholderTile> createState() => _ServicePlaceholderTileState();
}

class _ServicePlaceholderTileState extends State<ServicePlaceholderTile> {
  bool waiting = true;

  // create async function that delays for 10 seconds
  Future<void> delay() async {
    await Future.delayed(const Duration(milliseconds: 1));
    setState(() {
      waiting = false;
    });
  }

  @override
  Widget build(BuildContext context)  {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config =
    isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;

    Widget codeWrapper(child, text, language) =>
        CodeWrapperWidget(child, text, language);
    delay();
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: waiting ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Row(
            children: [
              Container(
                color: Colors.grey[300],
                width: 130,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 60),
                      color: Colors.grey[300],
                    ),
                    Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 50, top: 8),
                      color: Colors.grey[300],
                    ),Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 20, top: 8),
                      color: Colors.grey[300],
                    ),
                    Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 40, top: 8),
                      color: Colors.grey[300],
                    ),
                    Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 80, top: 8),
                      color: Colors.grey[300],
                    ),
                    Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 50, top: 8),
                      color: Colors.grey[300],
                    ),
                    Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 50, top: 8),
                      color: Colors.grey[300],
                    ),
                    Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 20, top: 8),
                      color: Colors.grey[300],
                    ),
                    Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 40, top: 8),
                      color: Colors.grey[300],
                    ),
                    Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 80, top: 8),
                      color: Colors.grey[300],
                    ),
                    Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 50, top: 8),
                      color: Colors.grey[300],
                    ),Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 50, top: 8),
                      color: Colors.grey[300],
                    ),
                    Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 20, top: 8),
                      color: Colors.grey[300],
                    ),
                    Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 40, top: 8),
                      color: Colors.grey[300],
                    ),
                    Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 80, top: 8),
                      color: Colors.grey[300],
                    ),
                    Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 50, top: 8),
                      color: Colors.grey[300],
                    ),Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 80, top: 8),
                      color: Colors.grey[300],
                    ),
                    Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 50, top: 8),
                      color: Colors.grey[300],
                    ),Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 50, top: 8),
                      color: Colors.grey[300],
                    ),
                    Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 20, top: 8),
                      color: Colors.grey[300],
                    ),
                    Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 40, top: 8),
                      color: Colors.grey[300],
                    ),
                    Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 80, top: 8),
                      color: Colors.grey[300],
                    ),
                    Container(
                      height: 9,
                      margin: const EdgeInsets.only(right: 50, top: 8),
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ):
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Container(
            color: isDark ? Colors.black : Colors.white,
            child:  MarkdownWidget(
              data: widget.content ?? '',
              selectable: true,
              config: config.copy(
                configs: [
                  isDark
                      ? PreConfig.darkConfig.copy(wrapper: codeWrapper)
                      : const PreConfig(theme: a11yLightTheme)
                      .copy(wrapper: codeWrapper),
                  LinkConfig(
                    style: TextStyle(
                      color: Colors.red,
                      decoration: TextDecoration.underline,
                    ),
                    onTap: (url) {
                      // Handle link tap action here
                    },
                  ),
                ],
              ),
              shrinkWrap: true,
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// Non-shared code below because different interfaces are shown to prompt
// for a multiple-choice answer.
//
// This is a design choice and you may want to do something different in your
// app.
// ===========================================================================
/// This uses a platform-appropriate mechanism to show users multiple choices.
///
/// On Android, it uses a dialog with radio buttons. On iOS, it uses a picker.
void showChoices(BuildContext context, List<String> choices) {
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      showDialog<void>(
        context: context,
        builder: (context) {
          int? selectedRadio = 1;
          return AlertDialog(
            contentPadding: const EdgeInsets.only(top: 12),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List<Widget>.generate(choices.length, (index) {
                    return RadioListTile<int?>(
                      title: Text(choices[index]),
                      value: index,
                      groupValue: selectedRadio,
                      onChanged: (value) {
                        setState(() => selectedRadio = value);
                      },
                    );
                  }),
                );
              },
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      return;
    case TargetPlatform.iOS:
      showCupertinoModalPopup<void>(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 250,
            child: CupertinoPicker(
              backgroundColor: Theme.of(context).canvasColor,
              useMagnifier: true,
              magnification: 1.1,
              itemExtent: 40,
              scrollController: FixedExtentScrollController(initialItem: 1),
              children: List<Widget>.generate(choices.length, (index) {
                return Center(
                  child: Text(
                    choices[index],
                    style: const TextStyle(
                      fontSize: 21,
                    ),
                  ),
                );
              }),
              onSelectedItemChanged: (value) {},
            ),
          );
        },
      );
      return;
    default:
      assert(false, 'Unexpected platform $defaultTargetPlatform');
  }
}