import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../Charity.dart';
import '../FirebaseService.dart';

class CharityController extends GetxController {
  List<Charity> charities = [];

  @override
  void onInit() {
    super.onInit();
    fetchCharities();
  }

  void fetchCharities() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('charities').get();
      charities.assignAll(querySnapshot.docs.map((doc) => Charity.fromSnapshot(doc)).toList());
    } catch (e) {
      print('Error fetching charities: $e');
    }
  }

  void addCharity(Charity charity) {
    charities.add(charity);
    FirebaseService().addCharity(charity);
    update();
  }
}