import 'package:achive_ai/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildTextField(
    String hintText, {
      bool isPassword = false,
      TextEditingController? controller,
      TextInputType? keyboardType,
      bool enabled = true,
      bool hasError = false,
      ValueChanged<String>? onChanged,
    }) {
  bool obscureText = isPassword;
  return StatefulBuilder(
    builder: (context, setState) {
      return TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        enabled: enabled,
        onChanged: onChanged,
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: const Color(0xFFD1D5DB), fontSize: 14.sp),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: hasError ? Colors.red : Colors.white38,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: hasError ? Colors.red : borderColor,
              width: 1.5,
            ),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xFFD1D5DB),
              size: 20.sp,
            ),
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
          )
              : null,
          semanticCounterText: hintText,
        ),
      );
    },
  );
}