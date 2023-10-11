import 'package:get/get.dart';

class ValuesController extends GetxController{
  var currentTabNumber = 0.obs;
  var isVisible = true.obs;
  var errorMessage = "".obs;
  var currentUserId ="".obs;
  var reklamBekleniyorMu =false.obs;
  var currentPageIndex = 0.obs;
}