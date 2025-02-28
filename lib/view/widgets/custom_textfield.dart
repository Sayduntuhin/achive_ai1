import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildTextField(String hintText, {bool isPassword = false}) {
  return TextField(
    obscureText: isPassword,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white70, fontSize: 14.sp),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white38),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.orangeAccent, width: 1.5),
      ),
    ),
  );
}