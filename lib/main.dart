// ignore_for_file: unused_import

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './pages/splashscreen.dart';


GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future <void>main()  async {
  
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);       
  runApp(
      MaterialApp(
        builder: FToastBuilder(),
        home: const SplashScreen(),
        navigatorKey: navigatorKey,
      ),
    );
}


