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
        color: backgroundColor,
        padding: EdgeInsets.only(top: 20.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                      onPressed: onBackPress ?? () => Get.back(),
                    ),
                  ),
                ),
                Spacer(),
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
            Divider(
              color: dividerColor,
              thickness: 1,
              height: 1,
              indent: 10,
              endIndent: 10,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
