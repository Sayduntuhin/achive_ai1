/*import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPress;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPress,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.grey,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.only(left: 15, top: 10, bottom: 5),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Icon(Icons.arrow_back_ios, color: borderColor, size: 20.sp),
            ),
            onPressed: onBackPress ?? () => Get.back(), // ✅ Default action: Go back
          ),
        ),
      ),
      title: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
            fontFamily: "Philosopher",
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}*/
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../themes/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPress;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;


  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPress,
    required this.backgroundColor,
    this.borderColor = Colors.grey,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        color: backgroundColor, // Custom background color for AppBar
        padding: EdgeInsets.only(top: 20.h), // Padding at the top for alignment
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Leading Icon (Back Button)
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor, width: 1),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: IconButton(
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(Icons.arrow_back_ios, color: borderColor, size: 20.sp),
                      ),
                      onPressed: onBackPress ?? () => Get.back(), // ✅ Default action: Go back
                    ),
                  ),
                ),
                Spacer(),
                // Title Section
                Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      fontFamily: "Philosopher",
                    ),
                  ),
                ),
                Spacer(flex: 2,)
              ],
            ),
            SizedBox(height: 10.h),
            // Divider below the title
            Divider(
              color: dividerColor, // Divider color
              thickness: 1, // Thickness of the divider
              height: 1, // The height of the divider
              indent: 10, // No indentation on the left
              endIndent: 10, // No indentation on the right
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Default height of the AppBar
}
