import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'AdManager.dart';
import 'Charity.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'controllers/CharityController.dart';
import 'controllers/ValuesController.dart';

class CharityPage extends StatelessWidget {
  final charityController = Get.put(CharityController());
  final valuesController = Get.put(ValuesController());
  AdManager applovinManager = AdManager();

  @override
  Widget build(BuildContext context) {
    valuesController.currentTabNumber.value = 1;
    return Scaffold(
      body: GetBuilder<CharityController>(
        init: CharityController(),
        builder: (controller) {
          return StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            itemCount: controller.charities.length,
            itemBuilder: (context, index) {
              final charity = controller.charities[index];
              return Card(
                elevation: 3,
                color: Colors.orange[200],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  onTap: () {
                    // Add your onTap logic here
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon(Icons.heart_broken),
                        // SizedBox(height: 8),
                        Text(
                          charity.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(charity.description),
                        SizedBox(height: 12), // Add spacing between text and button
                        Container(
                          width: double.infinity, // Make button take full width
                          child: ElevatedButton(
                            onPressed: () {
                              // Add your button's onTap logic here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black, // Adjust button color as needed
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Puan Aktar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );


            },
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          );
        },
      ),
    );
  }
}
