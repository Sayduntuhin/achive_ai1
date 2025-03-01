import 'package:get/get.dart';

class BottomNavController extends GetxController {
  int selectedIndex = 0; // ✅ Change from Rx<int> to normal int

  void changeTab(int index) {
    selectedIndex = index;
    update(); // ✅ Use `update()` instead of `.value`
  }
}
