import 'package:achive_ai/themes/colors.dart';
import 'package:achive_ai/view/widgets/app_logo.dart';
import 'package:achive_ai/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../controller/forget_pass_controller.dart';
import '../widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordController controller = Get.put(ForgotPasswordController());
    final Logger logger = Logger();
    final FocusNode emailFocusNode = FocusNode();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.13.sh),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// *** App Logo ***
              AppLogo(),
              SizedBox(height: 0.03.sh),
              /// *** Forgot Password Title ***
              Text(
                "Forgot Password?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Philosopher",
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w700,
                  color: secondaryTextColor,
                ),
              ),
              SizedBox(height: 10.h),
              /// *** Instruction Text ***
              Text(
                "Don't worry! It occurs. Please enter the email\naddress linked with your account.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: secondaryTextColor.withAlpha(100),
                ),
              ),
              SizedBox(height: 20.h),
              /// *** Network Status ***
              Obx(() => !controller.isNetworkAvailable.value
                  ? Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Text(
                  'No internet connection',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.sp,
                    fontFamily: "Poppins",
                  ),
                ),
              )
                  : const SizedBox.shrink()),
              /// *** Error Message ***
              Obx(() => controller.errorMessage.isNotEmpty &&
                  controller.isNetworkAvailable.value
                  ? Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Text(
                  controller.errorMessage.value,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.sp,
                    fontFamily: "Poppins",
                  ),
                ),
              )
                  : const SizedBox.shrink()),
              /// *** Email Input Field ***
              Obx(() => GestureDetector(
                onTap: () {
                  logger.d('Text field tapped: isLoading=${controller.isLoading.value}, enabled=${!controller.isLoading.value}');
                  if (!controller.isLoading.value) {
                    emailFocusNode.requestFocus();
                  }
                },
                child: CustomTextField(
                  hintText: "Enter Your E-mail",
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !controller.isLoading.value,
                  hasError: controller.isEmailError.value,
                  focusNode: emailFocusNode,
                  onChanged: (value) {
                    logger.d('Text field changed: value=$value, isEmailError=${controller.isEmailError.value}');
                    controller.errorMessage.value = '';
                    controller.isEmailError.value = false;
                    controller.update();
                  },
                ),
              )),
              SizedBox(height: 20.h),
              /// *** Send Email Button ***
              Obx(() => CustomButton(
                text: controller.isLoading.value ? "Sending..." : "Send Email",
                backgroundColor: buttonColor,
                onPressed: controller.isLoading.value ||
                    !controller.isNetworkAvailable.value
                    ? null
                    : () {
                  logger.d(
                      'Send Email pressed: isLoading=${controller.isLoading.value}, isNetworkAvailable=${controller.isNetworkAvailable.value}, email=${controller.emailController.text}');
                  FocusScope.of(context).unfocus();
                  controller.requestPasswordReset().then((_) {
                    logger.d(
                        'After requestPasswordReset: isLoading=${controller.isLoading.value}, isEmailError=${controller.isEmailError.value}');
                    Future.delayed(Duration(milliseconds: 100), () {
                      if (!controller.isLoading.value) {
                        emailFocusNode.requestFocus();
                      }
                    });
                  });
                },
              )),
              SizedBox(height: 20.h),
              /// *** Remember Password? Login ***
              Obx(() => Text.rich(
                TextSpan(
                  text: "Remember Password? ",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: secondaryTextColor,
                    fontSize: 10.sp,
                  ),
                  children: [
                    WidgetSpan(
                      child: InkWell(
                        onTap: controller.isLoading.value
                            ? null
                            : () {
                          logger.d(
                              'Login link tapped: isLoading=${controller.isLoading.value}');
                          Get.back();
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: subTextColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}