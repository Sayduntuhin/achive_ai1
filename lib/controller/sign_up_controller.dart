import 'package:achive_ai/api/api_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../view/widgets/snackbar_helper.dart';

class SignupController extends GetxController {
  final ApiService _apiService = ApiService();
  final Logger _logger = Logger();

  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // State variables
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isNetworkAvailable = true.obs;
  var isNameError = false.obs;
  var isEmailError = false.obs;
  var isPasswordError = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkNetworkStatus();
    // Monitor network changes
    Connectivity().onConnectivityChanged.listen((result) {
      isNetworkAvailable.value = result != ConnectivityResult.none;
      if (!isNetworkAvailable.value) {
        errorMessage.value = 'No internet connection';
        isNameError.value = false;
        isEmailError.value = false;
        isPasswordError.value = false;
        SnackbarHelper.showErrorSnackbar('Please check your internet connection');
      }
    });
    // Clear errors when user starts typing
    nameController.addListener(() {
      if (isNameError.value) {
        isNameError.value = false;
        errorMessage.value = '';
      }
    });
    emailController.addListener(() {
      if (isEmailError.value) {
        isEmailError.value = false;
        errorMessage.value = '';
      }
    });
    passwordController.addListener(() {
      if (isPasswordError.value) {
        isPasswordError.value = false;
        errorMessage.value = '';
      }
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Check network status
  Future<void> _checkNetworkStatus() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    isNetworkAvailable.value = connectivityResult != ConnectivityResult.none;
  }

  // Validate inputs
  bool _validateInputs() {
    isNameError.value = nameController.text.trim().isEmpty;
    if (isNameError.value) {
      errorMessage.value = 'Please enter your full name';
      return false;
    }
    isEmailError.value = !GetUtils.isEmail(emailController.text.trim());
    if (isEmailError.value) {
      errorMessage.value = 'Please enter a valid email';
      return false;
    }
    isPasswordError.value = passwordController.text.length < 8 ||
        !RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$')
            .hasMatch(passwordController.text);
    if (isPasswordError.value) {
      errorMessage.value = passwordController.text.length < 8
          ? 'Password must be at least 8 characters'
          : 'Password must contain letters and numbers';
      return false;
    }
    return true;
  }

  // Handle signup
  Future<void> signUp() async {
    errorMessage.value = '';
    isNameError.value = false;
    isEmailError.value = false;
    isPasswordError.value = false;

    if (!isNetworkAvailable.value) {
      errorMessage.value = 'No internet connection';
      SnackbarHelper.showErrorSnackbar('Please check your internet connection');
      return;
    }

    if (!_validateInputs()) {
      SnackbarHelper.showErrorSnackbar(errorMessage.value);
      return;
    }

    isLoading.value = true;

    final response = await _apiService.signUp(
      email: emailController.text.trim(),
      name: nameController.text.trim(),
      password: passwordController.text.trim(),
    );

    isLoading.value = false;

    if (response['success']) {
      _logger.i('Signup successful: ${response['data']}');
      SnackbarHelper.showSuccessSnackbar(
          response['data']['message'] ?? 'User created successfully');
      // Clear form
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      // Navigate to login screen
      if (Get.context != null) {
        Navigator.pushReplacementNamed(Get.context!, '/logIn');
      } else {
        _logger.w('Navigation context is null, fallback to GetX navigation');
        Get.offNamed('/logIn');
      }
    } else {
      _logger.w('Signup failed: ${response['message']}');
      errorMessage.value = response['message'];
      // Set specific error flags based on message content
      if (response['message'].toLowerCase().contains('email')) {
        isEmailError.value = true;
      } else if (response['message'].toLowerCase().contains('password')) {
        isPasswordError.value = true;
      } else if (response['message'].toLowerCase().contains('name')) {
        isNameError.value = true;
      }
      SnackbarHelper.showErrorSnackbar(response['message']);
    }
  }
}