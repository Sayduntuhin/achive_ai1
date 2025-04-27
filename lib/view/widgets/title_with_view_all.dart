import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../themes/colors.dart';

class TitleWithViewAll extends StatelessWidget {
  final String title;
  final double titleFontSize; // Font size for the title
  final bool showViewAll; // Controls whether the "View All" section should be shown
  final String viewAllText; // Custom text for "View All" button

  const TitleWithViewAll({
    super.key,
    required this.title,
    this.titleFontSize = 24, // Default font size for the title
    this.showViewAll = true, // Default is true, so View All is shown
    this.viewAllText = "View All", // Default "View All" text
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Title Text
        Text(
          title,
          style: TextStyle(
            fontSize: titleFontSize.sp,
            color: titleColor, // You can replace with your `titleColor`
            fontWeight: FontWeight.w700,
            fontFamily: 'Philosopher',
          ),
        ),
        Spacer(),
        // View All Section (Only shown if showViewAll is true)
        if (showViewAll)
          GestureDetector(
            onTap: () {
              Get.toNamed('/missedTask');            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
              decoration: BoxDecoration(
                color:flortingButtonColor,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Text(
                viewAllText, // Use custom text here
                style: TextStyle(
                  color: Color(0xff1C2A45),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
