import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/TabViewScreen.dart';

import '../FirebaseService.dart';
import 'Kullanici.dart';
import 'LoginPage.dart';

class CheckAuthPage extends StatefulWidget {
  const CheckAuthPage({Key? key}) : super(key: key);

  @override
  _CheckAuthPageState createState() => _CheckAuthPageState();
}

class _CheckAuthPageState extends State<CheckAuthPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseService firebaseService = FirebaseService();
  @override
  void initState()  {
    super.initState();
    initializeSharedPreferences();
  }






  void printWarning(String text) {
    print('\x1B[33m$text\x1B[0m');
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void initializeSharedPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList('userData');
    if (items != null && items.length == 2) {
      String tel = items[0];
      String password = items[1];
      bool loggedIn = await firebaseService.loginAsUser(Kullanici(userId: "",firstName: "",lastName: "",tel: tel,password: password,registrationDate: ""));
      if (loggedIn) {
        print('User logged in before');
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TabViewScreen()));
        });
      } else {
        // User data in SharedPreferences is invalid, navigate to login page
        navigateToLoginPage();
      }
    } else {
      // User data in SharedPreferences is missing, navigate to login page
      navigateToLoginPage();
    }
  }

  void navigateToLoginPage() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }


}