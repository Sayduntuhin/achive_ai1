import 'package:achive_ai/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Background color
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// *** App Logo ***
              SvgPicture.asset(
                'assets/svg/logo.svg', // Replace with your logo
                width: 0.12.sw,
                height: 0.12.sh,
              ),

              SizedBox(height: 20.h),
              /// *** Title ***
              Text(
                "Welcome To\nMyPerfectLife Ai",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Philosopher",
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                  color: titleColor, // Orange text color
                ),
              ),

              SizedBox(height: 40.h),

              /// *** Log In Button ***

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
                      side: BorderSide(color: buttonColor)
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

              /// *** Sign Up Button ***
              CustomButton(
                text: "Sign up",
                backgroundColor: buttonColor, // Pass any color
                onPressed: () {
                  Get.toNamed('/signUp');
                },
              ),


              SizedBox(height: 30.h),

              /// *** Divider with Text ***
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

              /// *** Google Button ***
              GestureDetector(
                onTap: () {
                  // TODO: Handle Google Login
                },
                child: Center(
                  child: Image.asset(
                    'assets/images/buttons.png', // Replace with Google icon
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
