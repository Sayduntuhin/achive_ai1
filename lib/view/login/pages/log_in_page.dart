import 'package:achive_ai/themes/colors.dart';
import 'package:achive_ai/view/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_loading_indicator.dart';
import '../../widgets/snackbar_helper.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30.h),
            child: Column(
              children: [
                /// *** App Logo ***
                SizedBox(height: 0.05.sh),
                AppLogo(),
                SizedBox(height: 0.1.sh),
                /// *** LogIn Card ***
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
                  decoration: BoxDecoration(
                    color: backgroundColor2,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// *** Sign-Up Title ***
                      Text(
                        "Log In",
                        style: TextStyle(
                          fontFamily: "Philosopher",
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      /// *** Email Field ***
                      buildTextField("E-mail or Mobile Number"),
                      SizedBox(height: 10.h),
                      /// *** Password Field ***
                      buildTextField("Password", isPassword: true),
                      Row(
                        children: [
                          Spacer(),
                          TextButton(
                              onPressed: () {
                                Get.toNamed('/forgetPassword');
                              },
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(50, 30),
                                  tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                                  alignment: Alignment.centerLeft),
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: subTextColor,
                                  fontFamily: "Poppins",
                                  fontSize: 11.sp,
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 0.03.sh,
                      ),
                      /// *** Sign-Up Button ***
                      CustomButton(
                        text: "Log In",
                        backgroundColor: buttonColor,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                child: CustomLoadingIndicator(),
                              );
                            },
                          );
                          // Simulate a login process
                          Future.delayed(Duration(seconds: 2), () {
                            Get.back();
                            SnackbarHelper.showSuccessSnackbar('Login Successful');
                            Get.offAllNamed('/mainPage');
                          });
                        },
                      ),
                      SizedBox(height: 15.h),
                      /// *** Already have an account? Sign In ***
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: "Didn't Join yet? ",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white70,
                              fontSize: 11.sp,
                            ),
                            children: [
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.offAllNamed('/signUp');
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: subTextColor,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
