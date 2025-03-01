import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/buttom_navigation_controller.dart';
import '../../home/page/home_page.dart';
import '../widgets/custom_navigation_bar.dart';


class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final BottomNavController navController = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /// ✅ Wrap `Scaffold` in GetBuilder to ensure updates
      body: GetBuilder<BottomNavController>(
        builder: (controller) {
          return _getPage(controller.selectedIndex);
        },
      ),

      /// ✅ Custom Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavBar(navController: navController),
    );
  }

  /// ✅ Function to Return the Correct Page
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return HomePage();
      case 2:
        return HomePage(); // Replace with Profile Page
      case 3:
        return HomePage();
      default:
        return HomePage();
    }
  }
}
