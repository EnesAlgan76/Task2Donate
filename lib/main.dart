import 'dart:math';

import 'package:applovin_max/applovin_max.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled/PageB.dart';
import 'package:untitled/TabViewScreen.dart';
import 'package:untitled/login_register/CheckAuthPage.dart';
import 'AdManager.dart';

void printWarning(String text) {
  print('\x1B[33m$text\x1B[0m');
}



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //MobileAds.instance.initialize();

  runApp(MaterialApp(
    home: CheckAuthPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}