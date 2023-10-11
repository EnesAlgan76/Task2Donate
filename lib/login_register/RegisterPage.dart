import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:untitled/controllers/ValuesController.dart';
import 'Kullanici.dart';
import 'LoginPage.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final valuesController = Get.put(ValuesController());

  late StreamSubscription<bool> keyboardSubscription;
  TextEditingController _textFirstNameController = TextEditingController();
  TextEditingController _textLastNameController = TextEditingController();
  TextEditingController _textTelController = TextEditingController();
  TextEditingController _textPasswordlController = TextEditingController();
  TextEditingController _textPasswordAgainlController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isButtonDisabled = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      if(visible) {
        valuesController.isVisible.value=false;
      } else {
        valuesController.isVisible.value=true;
      }
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    _textFirstNameController.dispose();
    _textPasswordAgainlController.dispose();
    _textPasswordlController.dispose();
    _textTelController.dispose();
    _textLastNameController.dispose();
    valuesController.errorMessage.value="";
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent, // Set the background color to transparent
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 100,),
              Obx(() =>
                  Visibility(
                      visible: valuesController.isVisible.value,
                      child: Text("Kayıt Ol", style: TextStyle( fontSize: 50, color: Colors.black87, fontFamily: "Quicksand",fontWeight: FontWeight.bold ),)),),
              Obx(() =>
                  Visibility(
                    visible: valuesController.isVisible.value,
                    child: SizedBox(height: 100),),),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Row(
                      children: [
                        Expanded(child: eTextField2("Adı",Icon(Icons.account_circle_rounded,color: Colors.black87, size: 20,),_textFirstNameController)),
                        SizedBox(width: 10,),
                        Expanded(child: eTextField2("Soyadı",null,_textLastNameController)),
                      ],
                    ),

                    SizedBox(height: 10,),

                    eTextField2("05XXXXXXXX",Icon(Icons.phone,color: Colors.black87, size: 20,),_textTelController),
                    SizedBox(height: 10,),

                    eTextField2("Şifre",Icon(Icons.lock,color: Colors.black87, size: 23,),_textPasswordlController),
                    SizedBox(height: 10,),

                    eTextField2("Şifre Tekrar",Icon(Icons.lock,color: Colors.black87, size: 23,),_textPasswordAgainlController),
                    SizedBox(height: 10,),

                    Obx(() => Text(valuesController.errorMessage.value,style: TextStyle(color: Colors.red,fontSize: 15),)),
                    SizedBox(height: 100,),



                    ElevatedButton(
                      onPressed: () async {
                        await handleLoginPress();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        minimumSize: Size(200, 50),
                        backgroundColor:  Color(0xffe5e709), // Set the desired color here
                      ),
                      child: Text('Kayıt Ol',style: TextStyle(color: Colors.black87, fontSize: 18),),
                    ),

                  ],
                ),

              ),



            ],
          ),
        ),
      ),
    );
  }



  bool isValidPhoneNumber(String phoneNumber) {
    RegExp regex = RegExp(r'^05\d{9}$');
    return regex.hasMatch(phoneNumber);
  }


  bool areAllFieldsFilled() {
    String phoneNumber = _textTelController.text.trim();
    String firstName = _textFirstNameController.text.trim();
    String lastName = _textLastNameController.text.trim();
    String password = _textPasswordlController.text.trim();
    String passwordAgain = _textPasswordAgainlController.text.trim();

    return phoneNumber.isNotEmpty &&
        firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        password.isNotEmpty &&
        passwordAgain.isNotEmpty;
  }


  void clearTextFields() {
    _textFirstNameController.clear();
    _textLastNameController.clear();
    _textTelController.clear();
    _textPasswordlController.clear();
    _textPasswordAgainlController.clear();
  }


  Widget eTextField2(String hintText, Widget? image, TextEditingController controller) {
    return
      Container(
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  prefixIcon: image,
                  border: InputBorder.none,
                  hintText: hintText,
                  contentPadding: EdgeInsets.only(left: image==null?10:0, right: 15, top: 15, bottom: 15),
                ),
                onTap: (){
                },
              ),
            ),
          ],
        ),
      );
  }




  Future<void> createUser({required Kullanici kullanici}) async {
   try{
     final FirebaseFirestore _firestore = FirebaseFirestore.instance;

     QuerySnapshot snapshot = await _firestore
         .collection('users')
         .where('tel', isEqualTo: kullanici.tel)
         .get();

     if (snapshot.docs.isNotEmpty){
       valuesController.errorMessage.value ="Bu telefon numarası zaten kayıtlı.";
     }else{
       valuesController.errorMessage.value ="";
       Map<String,dynamic> kullaniciMap = {
         "info":kullanici.getInfo(),
         "password":kullanici.password,
         "tel":kullanici.tel,
         "watched_ads":0
       };

       DocumentReference docRef = await _firestore.collection('users').add(kullaniciMap);

       String userId = docRef.id;
       await docRef.update({'userId': userId}).then((value){
         showDialog(
           context: context,
           builder: (context) {
             return AlertDialog(
               title: Text('Kayıt Başarılı'),
               content: Text("Giriş yapabilirsiniz"),
               actions: [
                 TextButton(
                   onPressed: () {
                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                      clearTextFields();
                   },
                   child: Text('OK'),
                 ),
               ],
             );
           },
         );
       });
     }

   }catch(e){
     showDialog(
       context: context,
       builder: (context) {
         return AlertDialog(
           title: Text('Kayıt Hatası'),
           content: Text("İnternet'e bağlı olduğunuzdan emin olun"),
           actions: [
             TextButton(
               onPressed: () {
                 Navigator.of(context).pop();
               },
               child: Text('OK'),
             ),
           ],
         );
       },
     );
   }
  }


  Future<void> handleLoginPress() async {
    if (areAllFieldsFilled()) {
      if (!isValidPhoneNumber(_textTelController.text)) {
        valuesController.errorMessage.value =
        "Geçerli bir telefon numarası girin: 05xxxxxxxxx.";
      } else if (_textPasswordlController.text.length < 6) {
        valuesController.errorMessage.value =
        "Şifre minimum 6 haneli olmalıdır";
      } else if (_textPasswordlController.text !=
          _textPasswordAgainlController.text) {
        valuesController.errorMessage.value = "Şifreler eşleşmiyor";
      } else {
        Kullanici kullanci = Kullanici(
          userId: "null",
          firstName: _textFirstNameController.text,
          lastName: _textLastNameController.text,
          tel: _textTelController.text.trim(),
          password: _textPasswordlController.text,
          registrationDate: "formattedDateTime",
        );
        printWarning("Kayıt butonuna tıklandı");
        await createUser(kullanici: kullanci).then((value) => isButtonDisabled = false);
      }
    } else {
      valuesController.errorMessage.value = "Boş Alanları Doldurunuz";
    }
  }


  void printWarning(String text) {
    print('\x1B[33m$text\x1B[0m');
  }















}
