import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../themes/colors.dart';

class TitleWithViewAll extends StatelessWidget {
  final String title;
  final bool showViewAll; // Controls whether the "View All" section should be shown
  final String viewAllText; // Custom text for "View All" button

  const TitleWithViewAll({
    super.key,
    required this.title,
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
            fontSize: 24.sp,
            color: titleColor, // You can replace with your `titleColor`
            fontWeight: FontWeight.w700,
            fontFamily: 'Philosopher',
          ),
        ),
        Spacer(),
        // View All Section (Only shown if showViewAll is true)
        if (showViewAll)
          Row(
            children: [
              Text(
                viewAllText, // Use custom text here
                style: TextStyle(
                  fontSize: 10.sp,
                  color: subTextColor2, // You can replace with your `subTextColor2`
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              Icon(
                Icons.arrow_right_alt_rounded,
                color: subTextColor2, // You can replace with your `subTextColor2`
                size: 16.sp,
              ),
            ],
          ),
      ],
    );
  }
}
