import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../../../controller/buttom_navigation_controller.dart';
import 'package:achive_ai/themes/colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final BottomNavController navController;

  const CustomBottomNavBar({super.key, required this.navController});

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
              items: [
                _buildNavItem(
                  controller,
                  index: 0,
                  icon: Icons.home_outlined,
                  label: "Home",
                  svgPath: null,
                ),
                _buildNavItem(
                  controller,
                  index: 1,
                  svgPath: "assets/svg/task.svg",
                  label: "Tasks",
                ),
                _buildNavItem(
                  controller,
                  index: 2,
                  svgPath: "assets/svg/ai.svg",
                  label: "AI",
                ),
                _buildNavItem(
                  controller,
                  index: 3,
                  icon: Icons.settings_sharp,
                  label: "Settings",
                  svgPath: null,
                ),
              ],
              selectedItemColor: buttonColor,
              unselectedItemColor: Colors.white70,
              backgroundColor: const Color(0xFF1C4A5A), // ✅ Ensure background color matches
              elevation: 0, // ✅ Remove default shadow
              type: BottomNavigationBarType.fixed,

              // ✅ Hide Extra Label Space
              showSelectedLabels: false,
              showUnselectedLabels: false,
            ),
          ),
        );
      },
    );
  }

  /// ✅ Custom Bottom Navigation Item with Icon & Label Inside Box
  BottomNavigationBarItem _buildNavItem(
      BottomNavController controller, {
        required int index,
        IconData? icon,
        String? svgPath,
        required String label,
      }) {
    bool isSelected = controller.selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Container(
        width: 66.w,
        height: 65.h,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10), // Adjust padding
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffED840F).withAlpha(50) : Colors.transparent,
          borderRadius: BorderRadius.circular(10), // ✅ Rounded Box
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ✅ Prevent extra space
          children: [
            svgPath != null
                ? SvgPicture.asset(
              svgPath,
              width: 26, // Adjust SVG size
              height: 26,
              colorFilter: ColorFilter.mode(
                isSelected ? buttonColor : Colors.white70,
                BlendMode.srcIn,
              ),
            )
                : Icon(icon, size: 24.w, color: isSelected ? buttonColor : Colors.white70),
            const SizedBox(height: 4), // Space between icon & label
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                fontFamily: "Philosopher",
                color: isSelected ? buttonColor : Colors.white70,
              ),
            ),
          ],
        ),
      ),
      label: "", // ✅ Hide label text to remove extra space
    );
  }
}
