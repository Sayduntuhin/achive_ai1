import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../themes/colors.dart';

class CustomTextFieldForSetting extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final bool isReadOnly;
  final String? suffixIconPath;  // Update to hold path for SVG
  final VoidCallback? onSuffixTap;
  final bool isEditable;

  const CustomTextFieldForSetting({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.isPassword = false,
    this.isReadOnly = false,
    this.suffixIconPath,  // Used SVG path here
    this.onSuffixTap,
    this.isEditable = false,  // Add isEditable to control whether it's editable
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label for the text field
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 6.h),
        // Text Field
        TextField(
          controller: controller,
          obscureText: isPassword,
          readOnly: !isEditable, // Handle non-editable state
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade500),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: secondaryBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color:borderColor, width: 1.5),
            ),
            // If a suffixIconPath is provided, show the SVG as a button
            suffixIcon: suffixIconPath != null
                ? IconButton(
              icon: SvgPicture.asset(
                suffixIconPath!,
                width: 20.w,
                height: 20.h,
              ),
              onPressed: onSuffixTap, // Action when icon is pressed
            )
                : null,
          ),
        ),
      ],
    );
  }
}
