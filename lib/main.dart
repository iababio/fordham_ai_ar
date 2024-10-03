import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:camera/camera.dart';

import 'home_page.dart';

late List<CameraDescription> cameras;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  initializeDateFormatting().then((_) => runApp(ProviderScope(child: MyApp())));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fordham AR',
      themeMode: ThemeMode.system,
      theme: ThemeData.light(), // standard light theme
      darkTheme: ThemeData.dark(), // standard dark theme
      home: Home(cameras: cameras),
      // home: SplashScreen(),
    );
  }
}

