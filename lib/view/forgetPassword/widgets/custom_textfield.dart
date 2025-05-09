import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../themes/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType? keyboardType;
  final bool enabled;
  final bool hasError;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.isPassword = false,
    this.keyboardType,
    this.enabled = true,
    this.hasError = false,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      enabled: enabled,
      onChanged: onChanged,
      focusNode: focusNode,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: const Color(0xFF727272), fontSize: 14.sp),
        filled: true,
        fillColor: secondaryTextColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(
            color: hasError ? Colors.red : Colors.white,
            width: 0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(
            color: hasError ? Colors.red : borderColor,
            width: 1.5,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(
            color: hasError ? Colors.red : Colors.grey,
            width: 0,
          ),
        ),
      ),
    );
  }
}