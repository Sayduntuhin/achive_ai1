import 'package:achive_ai/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import '../../../api/auth_service.dart';
import '../../widgets/snackbar_helper.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    final Logger _logger = Logger();
    final AuthService authService = AuthService();
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

    try {
      // Sign out previous user to ensure fresh login
      await googleSignIn.signOut();
      _logger.d('Initiating Google Sign-In');

      // Start Google Sign-In
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        _logger.w('Google Sign-In canceled by user');
        SnackbarHelper.showErrorSnackbar('Google Sign-In canceled');
        return;
      }
      final name = googleUser.displayName ?? 'No Name';
      final email = googleUser.email;
      _logger.d('Google Sign-In successful, email: $email');

      // Call social sign-in API
      final response = await authService.socialSignIn(
        name: name,
        email: email,
        timeZone: 'Asia/Dhaka',
      );

      if (response['success']) {
        _logger.i('Social sign-in successful, navigating to HomePage');
        await authService.storeTokens(
          access: response['tokens']['access'],
          refresh: response['tokens']['refresh'],
        );
        Get.offNamed('/mainPage'); // Navigate to HomePage
      } else {
        _logger.w('Social sign-in failed: ${response['message']}');
        SnackbarHelper.showErrorSnackbar(response['message'] ?? 'Social sign-in failed');
      }
    } catch (e) {
      _logger.e('Error during Google Sign-In: $e');
      SnackbarHelper.showErrorSnackbar('An unexpected error occurred during Google Sign-In');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/logo.svg',
                width: 0.12.sw,
                height: 0.12.sh,
              ),
              SizedBox(height: 20.h),
              Text(
                "Welcome To\nMyPerfectLife Ai",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Philosopher",
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              SizedBox(height: 40.h),
              SizedBox(
                width: double.infinity,
                height: 60.h,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/logIn');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonInnerColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      side: BorderSide(color: buttonColor),
                    ),
                  ),
                  child: Text(
                    "Log in",
                    style: TextStyle(
                      fontFamily: "Philosopher",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              SizedBox(
                width: double.infinity,
                height: 60.h,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/signUp');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      fontFamily: "Philosopher",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[600],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      "Or continue with",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14.sp,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              GestureDetector(
                onTap: () => _handleGoogleSignIn(context),
                child: Center(
                  child: Image.asset(
                    'assets/images/buttons.png',
                    width: 60.w,
                    height: 60.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}