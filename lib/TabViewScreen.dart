import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/ProfilePage.dart';
import 'package:untitled/SettingsPage.dart';
import 'package:untitled/login_register/LoginPage.dart';
import 'AdManager.dart';
import 'Charity.dart';
import 'CharityPage.dart';
import 'Task.dart';
import 'TaskListScreen.dart';
import 'controllers/CharityController.dart';
import 'controllers/TaskController.dart';
import 'controllers/ValuesController.dart';

class TabViewScreen extends StatefulWidget {
  @override
  _TabViewScreenState createState() => _TabViewScreenState();
}

class _TabViewScreenState extends State<TabViewScreen> {
  final taskController = Get.put(TaskController());
  final charityController = Get.put(CharityController());
  final valuesController = Get.put(ValuesController());

  late AdManager _adManager;
  var pages = [TaskListScreen(), CharityPage(), ProfilePage(), SettingsPage()];

  @override
  void initState() {
    super.initState();
    _adManager = AdManager();
    _adManager.initApplovin();
    _adManager.initializeInterstitialAds();
    _adManager.initializeRewardedAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: MdiIcons.handHeart,
                  text: 'Görevler',
                ),
                GButton(
                  icon: MdiIcons.charity,
                  text: 'Bağışla',
                ),
                GButton(
                  icon: MdiIcons.account,
                  text: 'Profil',
                ),
                GButton(
                  icon: MdiIcons.cogOutline,
                  text: 'Ayarlar',
                ),
              ],
              onTabChange: (index) {
                valuesController.currentPageIndex.value = index;
              },
            ),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: (){
              logout();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.exit_to_app_rounded, color: Colors.white,),
            ),
          )
        ],
        backgroundColor: Colors.black87,
        title: Text('Demo App',style: TextStyle(color: Colors.white),),
        // bottom: TabBar(
        //   tabs: [
        //     Tab(child: Text('Task',style: TextStyle(color: Colors.black),),),
        //     Tab(child: Text('Charities',style: TextStyle(color: Colors.black),),),
        //   ],
        // ),
      ),
      body: Obx(() =>pages[valuesController.currentPageIndex.value]),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (valuesController.currentTabNumber.value == 0) {
            _showAddTaskDialog(context);
          } else if (valuesController.currentTabNumber.value == 1) {
            _showAddCharityDialog(context);
          }
        },
        child: Icon(Icons.add),
      ),




    );
  }


  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController _taskNameController = TextEditingController();
    final TextEditingController _taskDescController = TextEditingController();
    final TextEditingController _taskPointsController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(controller: _taskNameController, decoration: InputDecoration(labelText: 'Task Name')),
                TextFormField(controller: _taskDescController, decoration: InputDecoration(labelText: 'Description')),
                TextFormField(controller: _taskPointsController, decoration: InputDecoration(labelText: 'Points')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final String name = _taskNameController.text;
                final String desc = _taskDescController.text;
                final int points = int.tryParse(_taskPointsController.text) ?? 0;
                if (name.isNotEmpty && desc.isNotEmpty && points > 0) {
                  final task = Task(id: DateTime.now().toString(), name: name, description: desc, points: points);
                  //Get.find<TaskController>().addTask(task);
                  taskController.addTask(task);
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddCharityDialog(BuildContext context) {
    final TextEditingController _charityNameController = TextEditingController();
    final TextEditingController _charityDescController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Charity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: _charityNameController, decoration: InputDecoration(labelText: 'Charity Name')),
              TextFormField(controller: _charityDescController, decoration: InputDecoration(labelText: 'Description')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final String name = _charityNameController.text;
                final String desc = _charityDescController.text;
                if (name.isNotEmpty && desc.isNotEmpty) {
                  final charity = Charity(id: DateTime.now().toString(), name: name, description: desc);
                  charityController.addCharity(charity);
                  //Get.find<CharityController>().addCharity(charity);
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void logout() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("userData", []);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
  }


}

