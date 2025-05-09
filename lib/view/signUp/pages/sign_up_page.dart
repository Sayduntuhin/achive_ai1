import 'package:achive_ai/themes/colors.dart';
import 'package:achive_ai/view/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/sign_up_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  // Method to show bottom sheet with page content
  void _showBottomSheet(BuildContext context, String title, Widget content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Philosopher',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10.h),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: content,
                ),
              ),
              // Close button
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Close',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.sp,
                      color: subTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Extract content from TermsAndConditionsScreen
  Widget _getTermsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "By using the Business Coach Chatbot, you agree to the following terms:",
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: textColor3,
            fontFamily: "Poppins",
          ),
        ),
        SizedBox(height: 20.h),
        _buildTermsItem(
          "The chatbot provides general business guidance and advice but is not a substitute for professional consulting services.",
        ),
        _buildTermsItem(
          "We offer both free and paid subscription plans. Paid plans are billed on a recurring basis unless canceled.",
        ),
        _buildTermsItem(
          "User data is handled securely and in accordance with our Privacy Policy.",
        ),
        _buildTermsItem(
          "We are not responsible for decisions made based on the chatbot's advice or any resulting outcomes.",
        ),
        _buildTermsItem(
          "Misuse of the service or violation of these terms may result in termination of access.",
        ),
        SizedBox(height: 20.h),
        Text(
          "By continuing to use the chatbot, you accept these terms. For questions, contact our support team.",
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  // Extract content from PrivacyPolicy
  Widget _getPrivacyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "By using the Business Coach Chatbot, you agree to the following terms:",
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: textColor3,
            fontFamily: "Poppins",
          ),
        ),
        SizedBox(height: 20.h),
        _buildTermsItem(
          "The chatbot provides general business guidance and advice but is not a substitute for professional consulting services.",
        ),
        _buildTermsItem(
          "We offer both free and paid subscription plans. Paid plans are billed on a recurring basis unless canceled.",
        ),
        _buildTermsItem(
          "User data is handled securely and in accordance with our Privacy Policy.",
        ),
        _buildTermsItem(
          "We are not responsible for decisions made based on the chatbot's advice or any resulting outcomes.",
        ),
        _buildTermsItem(
          "Misuse of the service or violation of these terms may result in termination of access.",
        ),
        SizedBox(height: 20.h),
        Text(
          "By continuing to use the chatbot, you accept these terms. For questions, contact our support team.",
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  // Helper method to build terms item
  Widget _buildTermsItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: buttonColor, size: 15.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: textColor3,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30.h),
            child: Column(
              children: [
                SizedBox(height: 0.05.sh),
                /// *** App Logo ***
                AppLogo(),
                SizedBox(height: 0.1.sh),
                /// *** Sign-Up Card ***
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
                      /// *** Sign-Up Title ***
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          fontFamily: "Philosopher",
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      /// *** Full Name Field ***
                      buildTextField(
                        "Full Name",
                        controller: controller.nameController,
                        enabled: !controller.isLoading.value,
                        hasError: controller.isNameError.value,
                        onChanged: (value) => controller.errorMessage.value = '',
                      ),
                      SizedBox(height: 10.h),

                      /// *** Email Field ***
                      buildTextField(
                        "Enter your E-mail",
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
                        isPassword: true,
                        controller: controller.passwordController,
                        enabled: !controller.isLoading.value,
                        hasError: controller.isPasswordError.value,
                        onChanged: (value) => controller.errorMessage.value = '',
                      ),
                      SizedBox(height: 15.h),

                      /// *** Terms & Conditions ***
                      Text.rich(
                        TextSpan(
                          text: "By signing up, you're agree to our ",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.white70,
                            fontSize: 10.sp,
                          ),
                          children: [
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  _showBottomSheet(
                                    context,
                                    'Terms & Conditions',
                                    _getTermsContent(),
                                  );
                                },
                                child: Text(
                                  "Terms & Conditions",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: subTextColor,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            TextSpan(
                              text: " and ",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white70,
                                fontSize: 10.sp,
                              ),
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  _showBottomSheet(
                                    context,
                                    'Privacy Policy',
                                    _getPrivacyContent(),
                                  );
                                },
                                child: Text(
                                  "Privacy Policy",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: subTextColor,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 0.03.sh),

                      /// *** Sign-Up Button with Loading Indicator ***
                      Obx(() => Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomButton(
                            text: controller.isLoading.value
                                ? "Signing Up..."
                                : "Sign up",
                            backgroundColor: buttonColor,
                            onPressed: controller.isLoading.value ||
                                !controller.isNetworkAvailable.value
                                ? null
                                : () {
                              FocusScope.of(context).unfocus();
                              controller.signUp();
                            },
                          ),
                        ],
                      )),

                      SizedBox(height: 15.h),

                      /// *** Already have an account? Sign In ***
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: "Join us before? ",
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
                                    Navigator.pushReplacementNamed(
                                        context, '/logIn');
                                  },
                                  child: Text(
                                    "Log In",
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