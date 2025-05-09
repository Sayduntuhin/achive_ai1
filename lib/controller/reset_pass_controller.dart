import 'package:achive_ai/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../view/widgets/snackbar_helper.dart';

class ResetPasswordController extends GetxController {
  final ApiService _apiService = ApiService();
  final Logger _logger = Logger();

  // Form controllers
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // State variables
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isNewPasswordError = false.obs;
  var isConfirmPasswordError = false.obs;
  late String email;
  late String otp;

  @override
  void onInit() {
    super.onInit();
    // Retrieve email and otp from arguments
    email = Get.arguments?['email'] ?? '';
    otp = Get.arguments?['otp'] ?? '';
    if (email.isEmpty || otp.isEmpty) {
      _logger.e('No email or OTP received in ResetPasswordController');
      errorMessage.value = 'Error: Invalid email or OTP';
      SnackbarHelper.showErrorSnackbar('Error: Invalid email or OTP');
      Get.back();
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Validate passwords
  bool _validatePasswords() {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty) {
      errorMessage.value = 'Please enter a new password';
      isNewPasswordError.value = true;
      update();
      return false;
    }

    if (newPassword.length < 8) {
      errorMessage.value = 'Password must be at least 8 characters';
      isNewPasswordError.value = true;
      update();
      return false;
    }

    if (confirmPassword.isEmpty) {
      errorMessage.value = 'Please confirm your password';
      isConfirmPasswordError.value = true;
      update();
      return false;
    }

    if (newPassword != confirmPassword) {
      errorMessage.value = 'Passwords do not match';
      isNewPasswordError.value = true;
      isConfirmPasswordError.value = true;
      update();
      return false;
    }

    return true;
  }

  // Handle password reset
  Future<void> resetPassword() async {
    errorMessage.value = '';
    isNewPasswordError.value = false;
    isConfirmPasswordError.value = false;
    update();

    if (!_validatePasswords()) {
      SnackbarHelper.showErrorSnackbar(errorMessage.value);
      update();
      return;
    }

    isLoading.value = true;
    update();

    try {
      final response = await _apiService.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPasswordController.text.trim(),
      );

      isLoading.value = false;

      if (response['success']) {
        _logger.i('Password reset successful: ${response['message']}');
        SnackbarHelper.showSuccessSnackbar(response['message']);
        // Clear form
        newPasswordController.clear();
        confirmPasswordController.clear();
        // Navigate to success screen
        Get.offAllNamed('/successResetPassword');
      } else {
        _logger.w('Password reset failed: ${response['error']}');
        errorMessage.value = response['error'];
        isNewPasswordError.value = true;
        SnackbarHelper.showErrorSnackbar(response['error']);
      }
    } catch (e) {
      _logger.e('Unexpected error: $e');
      isLoading.value = false;
      errorMessage.value = 'An unexpected error occurred';
      isNewPasswordError.value = true;
      SnackbarHelper.showErrorSnackbar('An unexpected error occurred');
    } finally {
      update();
    }
  }
}