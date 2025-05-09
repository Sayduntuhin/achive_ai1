import 'package:achive_ai/api/api_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../api/auth_service.dart';
import '../view/widgets/snackbar_helper.dart';

class LoginController extends GetxController {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  final Logger _logger = Logger();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // State variables
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isNetworkAvailable = true.obs;
  var isEmailError = false.obs;
  var isPasswordError = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkNetworkStatus();
    Connectivity().onConnectivityChanged.listen((result) {
      isNetworkAvailable.value = result != ConnectivityResult.none;
      if (!isNetworkAvailable.value) {
        errorMessage.value = 'No internet connection';
        SnackbarHelper.showErrorSnackbar('Please check your internet connection');
        update();
      }
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Check network status
  Future<void> _checkNetworkStatus() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    isNetworkAvailable.value = connectivityResult != ConnectivityResult.none;
    update();
  }

  // Validate inputs
  bool _validateInputs() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    isEmailError.value = !GetUtils.isEmail(email);
    isPasswordError.value = password.isEmpty;

    if (isEmailError.value) {
      errorMessage.value = 'Please enter a valid email';
    } else if (isPasswordError.value) {
      errorMessage.value = 'Please enter a password';
    }

    update();
    return !isEmailError.value && !isPasswordError.value;
  }

  // Handle login
  Future<void> login() async {
    errorMessage.value = '';
    isEmailError.value = false;
    isPasswordError.value = false;
    update();

    if (!isNetworkAvailable.value) {
      errorMessage.value = 'No internet connection';
      SnackbarHelper.showErrorSnackbar('Please check your internet connection');
      update();
      return;
    }

    if (!_validateInputs()) {
      SnackbarHelper.showErrorSnackbar(errorMessage.value);
      update();
      return;
    }

    isLoading.value = true;
    update();

    try {
      final response = await _apiService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      _logger.d('Login response: $response');

      isLoading.value = false;

      if (response['success']) {
        if (response['tokens'] == null) {
          _logger.e('Tokens not found in response: $response');
          errorMessage.value = 'Invalid response from server';
          isEmailError.value = true;
          isPasswordError.value = true;
          SnackbarHelper.showErrorSnackbar(errorMessage.value);
          update();
          return;
        }

        _logger.i('Login successful: ${response['tokens']}');
        // Store tokens
        await _authService.storeTokens(
          access: response['tokens']['access'],
          refresh: response['tokens']['refresh'],
        );
        // Clear form
        emailController.clear();
        passwordController.clear();
        // Navigate to main page
        Get.offAllNamed('/mainPage');
      } else {
        _logger.w('Login failed: ${response['message']}');
        errorMessage.value = response['message'] ?? 'Login failed';
        isEmailError.value = true;
        isPasswordError.value = true;
        SnackbarHelper.showErrorSnackbar(errorMessage.value);
      }
    } catch (e) {
      _logger.e('Unexpected error in login: $e');
      isLoading.value = false;
      errorMessage.value = 'An unexpected error occurred';
      isEmailError.value = true;
      isPasswordError.value = true;
      SnackbarHelper.showErrorSnackbar(errorMessage.value);
    } finally {
      update();
    }
  }
}