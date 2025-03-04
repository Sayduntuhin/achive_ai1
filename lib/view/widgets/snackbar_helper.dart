import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {

  // Success Snackbar
  static void showSuccessSnackbar(String message) {
    Get.snackbar(
      "Success",  // Title
      message,    // Message
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: Icon(Icons.check_circle, color: Colors.white),
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(10),
      borderRadius: 10,
    );
  }

  // Error Snackbar
  static void showErrorSnackbar(String message) {
    Get.snackbar(
      "Error",    // Title
      message,    // Message
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      icon: Icon(Icons.error, color: Colors.white),
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(10),
      borderRadius: 10,
    );
  }

  // Info Snackbar
  static void showInfoSnackbar(String message) {
    Get.snackbar(
      "Info",     // Title
      message,    // Message
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      icon: Icon(Icons.info, color: Colors.white),
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(10),
      borderRadius: 10,
    );
  }
}
