import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../themes/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final Color? borderColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
            side: borderColor != null ? BorderSide(color: borderColor!) : BorderSide.none,

          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "Philosopher",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: borderColor  != null ? Color(0xff1C4A5A) : secondaryTextColor,
          ),
        ),
      ),
    );
  }
}
