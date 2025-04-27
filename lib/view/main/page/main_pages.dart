import 'package:achive_ai/view/ai/pages/ai_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/buttom_navigation_controller.dart';
import '../../../themes/colors.dart';
import '../../home/page/home_page.dart';
import '../../setting/pages/setting_page.dart';
import '../../task/page/task_page.dart';
import '../widgets/custom_navigation_bar.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final BottomNavController navController = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: controller.selectedIndex == 0 || controller.selectedIndex == 1
              ? backgroundColor
              : Colors.white,
          body: _getPage(controller.selectedIndex),
          bottomNavigationBar: CustomBottomNavBar(navController: navController),
        );
      },
    );
  }

  /// Function to Return the Correct Page
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return GoalsPage();
      case 2:
        return ChatBotScreen();
      case 3:
        return SettingsScreen();
      default:
        return HomePage();
    }
  }
}