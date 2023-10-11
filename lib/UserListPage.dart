import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'controllers/UserController.dart';
class UserListPage extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User List')),
      body: GetBuilder<UserController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              final userData = controller.users[index].data()as Map<String, dynamic>;

              final infoField = userData['info'] as String?;
              final nameParts = infoField?.split('<>') ?? ['Unknown', 'User'];

              return ListTile(
                title: Text('${nameParts[0]} ${nameParts[1]}'),
                subtitle: Text('Watched Ads: ${userData['watched _ ads']}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    controller.deleteUser(index);
                  },
                ),
              );

            },
          );
        },
      ),
    );
  }
}
