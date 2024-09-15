// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_realtime_detection/pages/widgets/widgets.dart';




class ServiceDetailTab extends StatelessWidget {
  const ServiceDetailTab({
    required this.id,
    required this.service,
    required this.color,
    this.backgroundImage,
    this.content,
    super.key,
  });

  final int id;
  final String service;
  final Color color;
  final String? content;
  final String? backgroundImage;

  Widget _buildBody(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Hero(
                tag: id,
                child: HeroAnimatingServiceCard(
                  serice: service,
                  color: color,
                  backgroundImage: backgroundImage,
                  heroAnimation: const AlwaysStoppedAnimation(1),
                ),
                // This app uses a flightShuttleBuilder to specify the exact widget
                // to build while the hero transition is mid-flight.
                //
                flightShuttleBuilder: (context, animation, flightDirection,
                    fromHeroContext, toHeroContext) {
                  return HeroAnimatingServiceCard(
                    serice: service,
                    color: color,
                    backgroundImage: backgroundImage,
                    heroAnimation: animation,
                  );
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ServicePlaceholderTile(content: content,),
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // Non-shared code below because we're using different scaffolds.
  // ===========================================================================

  Widget _buildAndroid(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: isDark ? Colors.black : Colors.white,
          title: Text(service)),
      body: _buildBody(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CupertinoPageScaffold(
      backgroundColor: Colors.black,
      navigationBar: CupertinoNavigationBar(
        border: null,
        backgroundColor: isDark ? Colors.black : Colors.white,
        middle: Text(service),
        previousPageTitle: 'Services',
      ),
      child: _buildBody(context),
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}