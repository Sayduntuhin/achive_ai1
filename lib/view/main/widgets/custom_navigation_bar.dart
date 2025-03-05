import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
          height: 85.h, // Adjust height
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color(0xFF1C4A5A), // Background Color
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0), // Rounded Corners
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.0,
                spreadRadius: 2.0,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(controller, index: 0, icon: Icons.home_outlined, label: "Home"),
              _buildNavItem(controller, index: 1, svgPath: "assets/svg/task.svg", label: "Tasks"),
              _buildNavItem(controller, index: 2, svgPath: "assets/svg/ai.svg", label: "AI"),
              _buildNavItem(controller, index: 3, icon: Icons.settings_sharp, label: "Settings"),
            ],
          ),
        );
      },
    );
  }

  /// ✅ Custom Navigation Item inside Row
  Widget _buildNavItem(
      BottomNavController controller, {
        required int index,
        IconData? icon,
        String? svgPath,
        required String label,
      }) {
    bool isSelected = controller.selectedIndex == index;

    return GestureDetector(
      onTap: () => controller.changeTab(index), // Handle tap
      child: Container(
        width: 70.w, // Adjust width
        height: 65.h, // Adjust height
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffED840F).withAlpha(50) : Colors.transparent,
          borderRadius: BorderRadius.circular(10), // Rounded Box
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            svgPath != null
                ? SvgPicture.asset(
              svgPath,
              width: 25.w, // Adjust SVG size
              height: 25.h,
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
    );
  }
}
