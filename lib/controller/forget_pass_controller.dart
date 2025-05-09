import 'package:achive_ai/api/api_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../view/widgets/snackbar_helper.dart';

class ForgotPasswordController extends GetxController {
  final ApiService _apiService = ApiService();
  final Logger _logger = Logger();

  // Form controller
  final emailController = TextEditingController();

  // State variables
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isNetworkAvailable = true.obs;
  var isEmailError = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkNetworkStatus();
    Connectivity().onConnectivityChanged.listen((result) {
      isNetworkAvailable.value = result != ConnectivityResult.none;
      if (!isNetworkAvailable.value) {
        errorMessage.value = 'No internet connection';
        isEmailError.value = false;
        SnackbarHelper.showErrorSnackbar('Please check your internet connection');
        update();
      }
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  // Check network status
  Future<void> _checkNetworkStatus() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    isNetworkAvailable.value = connectivityResult != ConnectivityResult.none;
    update();
  }

  // Validate email
  bool _validateEmail() {
    final email = emailController.text.trim();
    isEmailError.value = !GetUtils.isEmail(email);
    if (isEmailError.value) {
      errorMessage.value = 'Please enter a valid email';
      update();
      return false;
    }
    return true;
  }

  // Handle password reset request
  Future<void> requestPasswordReset() async {
    errorMessage.value = '';
    isEmailError.value = false;
    update();

    if (!isNetworkAvailable.value) {
      errorMessage.value = 'No internet connection';
      SnackbarHelper.showErrorSnackbar('Please check your internet connection');
      update();
      return;
    }

    if (!_validateEmail()) {
      SnackbarHelper.showErrorSnackbar(errorMessage.value);
      update();
      return;
    }

    isLoading.value = true;
    update();

    try {
      final response = await _apiService.requestPasswordReset(
        email: emailController.text.trim(),
      );

      _logger.d('requestPasswordReset response: status=${response['success']}, message=${response['message']}');

      isLoading.value = false;

      if (response['success']) {
        _logger.i('Password reset request successful: ${response['message']}');
        SnackbarHelper.showSuccessSnackbar('An OTP has been sent to ${emailController.text.trim()}');
        // Navigate to OTP verification with email
        _logger.d('Navigating to /otpVerification with email: ${emailController.text.trim()}');
        Get.toNamed('/otpVerification', arguments: {'email': emailController.text.trim()});
        // Clear form after navigation
        emailController.clear();
      } else {
        _logger.w('Password reset request failed: ${response['message']}');
        // Make error message user-friendly
        String displayMessage = response['message'];
        if (displayMessage.contains('No PerfectUser matches')) {
          displayMessage = 'No account found with this email';
        }
        errorMessage.value = displayMessage;
        isEmailError.value = true;
        SnackbarHelper.showErrorSnackbar(displayMessage);
      }
    } catch (e) {
      _logger.e('Unexpected error in requestPasswordReset: $e');
      isLoading.value = false;
      errorMessage.value = 'An unexpected error occurred';
      isEmailError.value = true;
      SnackbarHelper.showErrorSnackbar('An unexpected error occurred');
    } finally {
      update();
    }
  }
}