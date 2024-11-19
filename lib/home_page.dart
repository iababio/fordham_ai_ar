// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:FordhamAR/pages/ar.dart';
import 'package:FordhamAR/pages/webView.dart';
import 'package:FordhamAR/slider.dart';

class Home extends StatelessWidget {
  Home({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription> cameras;
  final songsTabKey = GlobalKey();

  Widget _buildIosHomePage(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
      ),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
            ),
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SliderImages(),
                WebView(
                    url: Uri.parse('https://fordhamlite.skedda.com/booking'),
                    showBackButton: false),
              ],
            ),
          ),
          bottomNavigationBar: TabBar(

            padding: EdgeInsets.only(bottom: 15.0),
            tabs: [
              Tab(
                  icon: Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.home_rounded, size: 35),
                  )),
              // Tab(
              //     icon: Container(
              //   margin: const EdgeInsets.only(right: 20.0),
              //   child: Icon(Icons.camera_alt, size: 30),
              // )),
              Tab(
                  icon: Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Icon(Icons.calendar_month, size: 30),
                  )),
              // Tab(
              //     icon: Container(
              //   margin: const EdgeInsets.only(left: 10.0),
              //   child: Icon(Icons.person_2_rounded, size: 30),
              // )),

            ],
            isScrollable: false,
            unselectedLabelColor: const Color.fromARGB(255, 89, 89, 89),
            labelColor: isDark ? Colors.white : Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(10.0),
            indicatorColor: Colors.transparent,
          ),
          //
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.transparent,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ArVrPage(camera: cameras)
                ),
              );
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 132, 1, 44),
                      Color.fromARGB(255, 63, 1, 1),
                    ],
                    transform: const GradientRotation(pi / 4),
                  )),
              child: Icon(
                Icons.threed_rotation,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildIosHomePage(context);
  }
}

