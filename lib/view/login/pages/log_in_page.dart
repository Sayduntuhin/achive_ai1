import 'package:achive_ai/themes/colors.dart';
import 'package:achive_ai/view/widgets/app_logo.dart';
import 'package:achive_ai/view/widgets/custom_button.dart';
import 'package:achive_ai/view/widgets/custom_loading_indicator.dart';
import 'package:achive_ai/view/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/login_in_controller.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

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
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
                  decoration: BoxDecoration(
                    color: backgroundColor2,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// *** LogIn Title ***
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
                      buildTextField(
                        "Enter Your E-mail",
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        enabled: !controller.isLoading.value,
                        hasError: controller.isEmailError.value,
                        onChanged: (value) => controller.errorMessage.value = '',
                      ),
                      SizedBox(height: 10.h),
                      /// *** Password Field ***
                      buildTextField(
                        "Password",
                        controller: controller.passwordController,
                        isPassword: true,
                        enabled: !controller.isLoading.value,
                        hasError: controller.isPasswordError.value,
                        onChanged: (value) => controller.errorMessage.value = '',
                      ),
                      Row(
                        children: [
                          Spacer(),
                          TextButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : () {
                              Get.toNamed('/forgetPassword');
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              alignment: Alignment.centerLeft,
                            ),
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: subTextColor,
                                fontFamily: "Poppins",
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.03.sh),
                      /// *** LogIn Button ***
                      Obx(() => CustomButton(
                        text: controller.isLoading.value
                            ? "Logging In..."
                            : "Log In",
                        backgroundColor: buttonColor,
                        onPressed: controller.isLoading.value ||
                            !controller.isNetworkAvailable.value
                            ? null
                            : () async {
                          FocusScope.of(context).unfocus();
                          // Show loading dialog
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                child: CustomLoadingIndicator(),
                              );
                            },
                          );
                          try {
                            await controller.login();
                          } finally {
                            // Close dialog regardless of success or failure
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          }
                        },
                      )),
                      SizedBox(height: 15.h),
                      /// *** Don't have an account? Sign Up ***
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
                                  onTap: controller.isLoading.value
                                      ? null
                                      : () {
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
                      ),
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