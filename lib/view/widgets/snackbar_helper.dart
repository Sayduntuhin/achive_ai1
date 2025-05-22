import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SnackbarHelper {
  static void showSuccessSnackbar(String message) {
    Get.closeAllSnackbars(); // Close existing snackbars to prevent conflicts
    Get.snackbar(
      "Success",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withAlpha(50), // Use solid color instead of gradient
      colorText: Colors.white,
      icon: Icon(Icons.check_circle, color: Colors.white),
      duration: Duration(seconds: 3), // Increase duration for stability
      margin: EdgeInsets.all(20.w),
      borderRadius: 10.r,
      borderColor: Colors.green,
      borderWidth: 2,
      isDismissible: true,
      animationDuration: Duration(milliseconds: 300), // Explicit animation duration
      forwardAnimationCurve: Curves.easeOut,
      reverseAnimationCurve: Curves.easeIn,
    );
  }

  static void showErrorSnackbar(String message) {
    Get.closeAllSnackbars();
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withAlpha(50),
      colorText: Colors.white,
      icon: Icon(Icons.error, color: Colors.white),
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(20.w),
      borderRadius: 10.r,
      borderColor: Colors.red,
      borderWidth: 2,
      isDismissible: true,
      animationDuration: Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOut,
      reverseAnimationCurve: Curves.easeIn,
    );
  }

  static void showInfoSnackbar(String message) {
    Get.closeAllSnackbars();
    Get.snackbar(
      "Info",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue.withAlpha(50),
      colorText: Colors.white,
      icon: Icon(Icons.info, color: Colors.white),
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(20.w),
      borderRadius: 10.r,
      borderColor: Colors.blue,
      borderWidth: 2,
      isDismissible: true,
      animationDuration: Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOut,
      reverseAnimationCurve: Curves.easeIn,
    );
  }
}