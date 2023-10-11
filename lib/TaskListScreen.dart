import 'package:applovin_max/applovin_max.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:untitled/AdManager.dart';
import 'Task.dart';
import 'controllers/TaskController.dart';
import 'controllers/ValuesController.dart';
import 'login_register/LoginPage.dart';

class TaskListScreen extends StatelessWidget {
  var taskController = Get.put(TaskController());
  final valuesController = Get.put(ValuesController());
  AdManager applovinManager = AdManager();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    taskController.fetchTasks(context);

    valuesController.currentTabNumber.value = 0;

    return Scaffold(
      body: Obx(() => ListView.builder(
        itemCount: taskController.taskCards.length,
        itemBuilder: (context, index) {

          return taskController.taskCards[index];
        },
      ))


    );
  }

  void showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Obx(() {
          if(valuesController.reklamBekleniyorMu.value){
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16.0),
                    Text("Yükleniyor..."),
                  ],
                ),
              ),
            );
          }else{
            Navigator.pop(context);
            return Container();
          }
        }
        );
      },
    );
  }

   Widget buildTaskCard(BuildContext context, Task task) {
    return Card(
      color: Colors.green[200],
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          // Implement task completion logic and update points in Firebase
        },
        child: ListTile(
          onTap: (){
            valuesController.reklamBekleniyorMu.value=true;
            showProgressDialog(context);
            if(task.points>2000){
              applovinManager.showRewardedAd();
            }else{
              applovinManager.showInterstitialAd();
            }

          },
          leading: Icon(Icons.check_circle_outline),
          title: Text(task.name),
          subtitle: Text(task.description),
          trailing: Text('${task.points} Points', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );;
  }
}
