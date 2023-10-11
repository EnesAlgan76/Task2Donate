import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/controllers/ValuesController.dart';

import 'Charity.dart';
import 'Task.dart';
import 'login_register/Kullanici.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var valueController = Get.put(ValuesController());
  Future<void> addTask(Task task) async {
    try {
      await _firestore.collection('tasks').add({
        'name': task.name,
        'description': task.description,
        'points': task.points,
      });
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  Future<void> addCharity(Charity charity) async {
    try {
      await _firestore.collection('charities').add({
        'name': charity.name,
        'description': charity.description,
      });
    } catch (e) {
      print('Error adding charity: $e');
    }
  }


  Future<bool> loginAsUser(Kullanici kullanici) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('tel' , isEqualTo: kullanici.tel)
        .where('password' , isEqualTo: kullanici.password)
        .get();

    if(snapshot.docs.isNotEmpty){
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String documentId = snapshot.docs[0].id;
      valueController.currentUserId.value = documentId;
      await prefs.setStringList('userData', <String>[kullanici.tel, kullanici.password]);
      return true;
    }else{
      return false;
    }
  }

// Implement methods to fetch tasks and charities if needed
}
