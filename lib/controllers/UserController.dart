import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:untitled/login_register/LoginPage.dart';

class UserController extends GetxController {
  final users = <QueryDocumentSnapshot>[].obs;
  final isLoading = true.obs; // Add an isLoading state

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      final querySnapshot =
      await FirebaseFirestore.instance.collection('users').get();
      final userList = querySnapshot.docs.toList();

      userList.sort((a, b) {
        final watchedAdsA = a['watched_ads'];
        final watchedAdsB = b['watched_ads'];

        if (watchedAdsA is int && watchedAdsB is int) {
          return watchedAdsB.compareTo(watchedAdsA);
        }
        else {
          return watchedAdsB.toString().compareTo(watchedAdsA.toString());
        }
      });

      users.value = userList;
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
      isLoading.value = false; // Hide the progress indicator
    }
  }


  Future<void> deleteUser(int index) async {
    final userRef = users[index].reference;
    await userRef.delete();
    users.removeAt(index);
    //users.refresh();
  }

}
