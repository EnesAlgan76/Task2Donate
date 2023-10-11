import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/UserController.dart';

class ProfilePage extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (userController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: userController.users.length,
          itemBuilder: (context, index) {
            final userData = userController.users[index].data() as Map<String, dynamic>;

            final infoField = userData['info'] as String?;
            final nameParts = infoField?.split('<>') ?? ['Unknown', 'User'];

            return ListTile(
              title: Text('${nameParts[0]} ${nameParts[1]}'),
              subtitle: Text('Watched Ads: ${userData['watched_ads']}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmationDialog(context, index);
                },
              ),
            );
          },
        );
      }),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                userController.deleteUser(index); // Use the controller to delete the user
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
