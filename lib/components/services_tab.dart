// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:FordhamAR/pages/widgets/widgets.dart';
import 'package:FordhamAR/services/chat_api.dart';

import '../pages/chat_page.dart';
import 'sevices_detail_tab.dart';
import '../utils/utils.dart';

class ServicesTab extends StatefulWidget {
  static const title = 'Services';
  static const androidIcon = Icon(Icons.apps);
  static const iosIcon = Icon(Icons.apps);

  const ServicesTab({super.key, this.androidDrawer});

  final Widget? androidDrawer;

  @override
  State<ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends State<ServicesTab> {
  static const _itemsLength = 4;

  final _androidRefreshKey = GlobalKey<RefreshIndicatorState>();

  late List<MaterialColor> colors;
  late List<String> serviceNames;
  late List<String> backgroundImages;
  late List<String> content;

  @override
  void initState() {
    _setData();
    super.initState();
  }

  void _setData() {
    colors = getRandomColors(_itemsLength);
    serviceNames = getRandomNames(_itemsLength);
    backgroundImages = getImages(_itemsLength);
    content = getContent(_itemsLength);
  }

  Future<void> _refreshData() {
    return Future.delayed(
      // This is just an arbitrary delay that simulates some network activity.
      const Duration(seconds: 2),
      () => setState(() => _setData()),
    );
  }

  Widget _listBuilder(BuildContext context, int index) {
    if (index >= _itemsLength) return Container();

    final color = defaultTargetPlatform == TargetPlatform.iOS
        ? colors[index]
        : colors[index].shade400;

    return SafeArea(
      top: false,
      bottom: false,
      child: Hero(
        tag: index,
        child: HeroAnimatingServiceCard(
          serice: serviceNames[index],
          color: color,
          backgroundImage: backgroundImages[index],
          heroAnimation: const AlwaysStoppedAnimation(0),
          onPressed: () => Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (context) => ServiceDetailTab(
                id: index,
                service: serviceNames[index],
                color: color,
                content: content[index],
                backgroundImage: backgroundImages[index],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? Colors.black : Colors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  chatApi: ChatApi(),
                ),
              ),
            ),
            child: const Text('Chat with AI'),
          ),
          IconButton(
              padding: const EdgeInsets.only(right: 10),
              icon: const Icon(Icons.smart_button, size: 40),
              onPressed: () => {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(
                                  chatApi: ChatApi(),
                                ))),
                    HapticFeedback.mediumImpact()
                  }),
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: isDark ? Colors.black : Colors.white,
        onRefresh: _refreshData,
        child: ListView.builder(
          itemCount: _itemsLength,
          itemBuilder: _listBuilder,
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    return PlatformWidget(
      androidBuilder: _buildIos,
      iosBuilder: _buildIos,
    );
  }
}
