import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/FirebaseService.dart';
import 'package:untitled/TabViewScreen.dart';
import 'package:untitled/controllers/ValuesController.dart';
import 'Kullanici.dart';
import 'RegisterPage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final valuesController = Get.put(ValuesController());
  TextEditingController _textPasswordlController = TextEditingController();
  TextEditingController _textTelController = TextEditingController();
  FirebaseService firebaseService = FirebaseService();
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print('Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: $visible');
      if(visible){
        valuesController.isVisible.value=false;
      }else{
        valuesController.isVisible.value = true;
      }
    });
  }

  @override
  void dispose() {
    _textPasswordlController.dispose();
    _textTelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Obx(() => valuesController.isVisible.value?SizedBox(height: 150):SizedBox(height: 50,)),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.elliptical(100, 50),
                      topLeft: Radius.elliptical(40, 10),
                    ),
                    //color: Color(0xff0d7fa8),
                  ),
                  child: Column(
                    children: [
                      Obx(() => Visibility(
                        visible: valuesController.isVisible.value,
                        child: Text("Giriş Yap",
                          style: TextStyle(fontSize: 40, color: Color(0xffffde59), fontFamily: "Quicksand", fontWeight: FontWeight.bold,),
                        ),
                      ),
                      ),
                      Obx(() => Visibility(visible: valuesController.isVisible.value,child: SizedBox(height: 40),),),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 10),

                            buildCustomTextField( hintText: "05XXXXXXXX", label: "Telefon",
                              icon: Icon(Icons.phone, color: Colors.black87, size: 25,),
                              controller: _textTelController,
                            ),
                            SizedBox(height: 10),

                            buildCustomTextField(hintText: "Şifre", label: "Şifre",
                              icon: Icon(Icons.lock, color: Colors.black87, size: 25,),
                              controller: _textPasswordlController,
                            ),
                            SizedBox(height: 10),
                            Obx(() => Text(valuesController.errorMessage.value,
                              style: TextStyle(color: Colors.red, fontSize: 15),
                            ),
                            ),
                            buildForgotPasswordLink(),
                            SizedBox(height: 100),
                            buildLoginButton(),
                            SizedBox(height: 15),
                            buildRegisterLink(),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }







  Widget buildCustomTextField({
    required String hintText,
    required String label,
    required Widget icon,
    required TextEditingController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          label: Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
          prefixIcon: icon,
          border: InputBorder.none,
          hintText: hintText,
          contentPadding: EdgeInsets.only(left: icon == null ? 15 : 0,right: 15,top: 15, bottom: 15, ),
        ),
        onTap: () {
        },
      ),
    );
  }



  Widget buildForgotPasswordLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            valuesController.errorMessage.value = "";
          },
          child: Text("Şifremi Unuttum ?"),
        ),
      ],
    );
  }



  Widget buildLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        if (areAllFieldsFilled()) {
          Kullanici kullanici = Kullanici(
            userId: "null",
            firstName: "null",
            lastName: "null",
            tel: _textTelController.text.trim(),
            password: _textPasswordlController.text.trim(),
            registrationDate: "null",
          );

          if(isValidPhoneNumber(_textTelController.text.trim())){
            printWarning("User olarak deneniyor...");
            bool user = await firebaseService.loginAsUser(kullanici);
            if (user) {
              valuesController.errorMessage.value ="";
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TabViewScreen()),
              );
            } else {
              valuesController.errorMessage.value ="Kullanıcı bulunamadı. Lütfen doğru bilgileri girdiğinizden emin olunuz.";
            }
          }else{
            valuesController.errorMessage.value = "Geçerli bir telefon numarası girin: 05xxxxxxxxx.";
          }

          // Do something with the user object

        } else {
          valuesController.errorMessage.value = "Boş Alanları Doldurunuz";
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        minimumSize: Size(200, 50),
        backgroundColor: Colors.black87,
      ),
      child: Text(
        'GİRİŞ',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }



  Widget buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Hesabın yok mu ?   ", style: TextStyle(fontSize: 15)),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
          },
          child: Text(
            "Yeni hesap oluştur",
            style: TextStyle(color: Color(0xffe5e709), fontSize: 15),
          ),
        ),
      ],
    );
  }

  bool areAllFieldsFilled() {
    String phoneNumber = _textTelController.text.trim();
    String password = _textPasswordlController.text.trim();

    return phoneNumber.isNotEmpty && password.isNotEmpty;
  }

  bool isValidPhoneNumber(String phoneNumber) {
    RegExp regex = RegExp(r'^05\d{9}$');
    return regex.hasMatch(phoneNumber);
  }


}



void printWarning(String text) {
  print('\x1B[33m$text\x1B[0m');
}
