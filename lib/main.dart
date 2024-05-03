// ignore_for_file: unused_import

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './pages/splashscreen.dart';


GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future <void>main()  async {
  
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Store data
  await prefs.setString('password', 'SairamX');
  // Hide the other tabs :)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  // Set the device to portrait mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);       
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: FToastBuilder(),
        home: const SplashScreen(),
        navigatorKey: navigatorKey,
      ),
    );
}


