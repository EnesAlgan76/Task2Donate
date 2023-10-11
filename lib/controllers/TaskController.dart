
import 'package:applovin_max/applovin_max.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/TaskListScreen.dart';

import '../FirebaseService.dart';
import '../Task.dart';
import '../main.dart';

class TaskController extends GetxController {
  var tasks = [].obs;
  var taskCards = <Widget>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void addTask(Task task) {
    tasks.add(task);
    FirebaseService().addTask(task);
    update();
  }

  void fetchTasks(BuildContext context) async {
    List<Widget> childrens = [];
    try {
      printWarning("Görevler çekildi");
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('tasks').get();
      tasks.value = querySnapshot.docs.map((doc) => Task.fromSnapshot(doc)).toList();

      for(int index = 0; index <tasks.length; index++){
        printWarning(index.toString());
        childrens.add(TaskListScreen().buildTaskCard(context, tasks[index]));
      }

      childrens.add(Container(
        height: 100,
        child: MaxAdView(
            adUnitId: "98df4e96e8da390a",
            adFormat: AdFormat.mrec,
            listener: AdViewAdListener(onAdLoadedCallback: (ad) {
              printWarning('MREC widget ad loaded from ${ad.networkName}');
            }, onAdLoadFailedCallback: (adUnitId, error) {
              printWarning('MREC widget ad failed to load with error code ${error.code} and message: ${error.message}');
            }, onAdClickedCallback: (ad) {
              printWarning('MREC widget ad clicked');
            }, onAdExpandedCallback: (ad) {
              printWarning('MREC widget ad expanded');
            }, onAdCollapsedCallback: (ad) {
              printWarning('MREC widget ad collapsed');
            }, onAdRevenuePaidCallback: (ad) {
              printWarning('MREC widget ad revenue paid: ${ad.revenue}');
            })),
      ),);

      taskCards.value = childrens;


     // tasks.addAll(querySnapshot.docs.map((doc) => Task.fromSnapshot(doc)).toList());
    } catch (e) {
      printWarning('Error fetching tasks: $e');
    }
  }




}

