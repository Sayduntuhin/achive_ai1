import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../controller/buttom_navigation_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  final BottomNavController navController;

  const CustomBottomNavBar({Key? key, required this.navController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavController>(
      builder: (controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1C4A5A), // ✅ Custom Color
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), // ✅ Rounded Corners
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.0,
                spreadRadius: 2.0,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0), // ✅ Clip to make it rounded
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              currentIndex: controller.selectedIndex,
              onTap: (index) => controller.changeTab(index),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tasks"),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
              ],
              selectedItemColor: Colors.orangeAccent,
              unselectedItemColor: Colors.white70,
              backgroundColor: Color(0xFF1C4A5A), // ✅ Ensure background color matches
              elevation: 0, // ✅ Remove default shadow
              type: BottomNavigationBarType.fixed,
            ),
          ),
        );
      },
    );
  }
}
