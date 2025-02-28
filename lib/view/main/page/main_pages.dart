import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../controller/buttom_navigation_controller.dart';
import '../../home/page/home_page.dart';

class MainScreen extends StatelessWidget {
  final BottomNavController navController = Get.put(BottomNavController());

  final List<Widget> pages = [
    DailyTasksScreen(),    DailyTasksScreen(),    DailyTasksScreen(),    DailyTasksScreen(),
 /*   TaskPage(),
    SettingsPage(),*/
  ];

   MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[navController.selectedIndex.value]),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          currentIndex: navController.selectedIndex.value,
          onTap: (index) => navController.changeTab(index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tasks"),
            BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tasks"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          ],
          selectedItemColor: Colors.orangeAccent,
          unselectedItemColor: Colors.white70,
          backgroundColor: Color(0xFF123B4E),
        ),
      ),
    );
  }
}
