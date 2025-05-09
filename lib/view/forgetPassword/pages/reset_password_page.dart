import 'package:achive_ai/themes/colors.dart';
import 'package:achive_ai/view/widgets/app_logo.dart';
import 'package:achive_ai/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../controller/reset_pass_controller.dart';
import '../widgets/custom_textfield.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ResetPasswordController controller = Get.put(ResetPasswordController());
    final Logger logger = Logger();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// *** Back Button ***
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: secondaryColor, width: 1),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: IconButton(
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Icon(Icons.arrow_back_ios, color: secondaryColor, size: 20.sp),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 0.015.sh),
                /// *** App Logo ***
                AppLogo(),
                SizedBox(height: 0.03.sh),
                /// *** Create New Password Title ***
                Text(
                  "Create New Password",
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
                  "Your new password must be unique from those previously used.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: secondaryTextColor.withAlpha(100),
                  ),
                ),
                SizedBox(height: 20.h),
                /// *** Error Message ***
                Obx(() => controller.errorMessage.isNotEmpty
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
                /// *** New Password Input Field ***
                Obx(() => CustomTextField(
                  hintText: "New Password",
                  controller: controller.newPasswordController,
                  isPassword: true,
                  enabled: !controller.isLoading.value,
                  hasError: controller.isNewPasswordError.value,
                  onChanged: (value) {
                    logger.d('New password changed: value=$value');
                    controller.errorMessage.value = '';
                    controller.isNewPasswordError.value = false;
                    controller.update();
                  },
                )),
                SizedBox(height: 20.h),
                /// *** Confirm Password Input Field ***
                Obx(() => CustomTextField(
                  hintText: "Confirm Password",
                  controller: controller.confirmPasswordController,
                  isPassword: true,
                  enabled: !controller.isLoading.value,
                  hasError: controller.isConfirmPasswordError.value,
                  onChanged: (value) {
                    logger.d('Confirm password changed: value=$value');
                    controller.errorMessage.value = '';
                    controller.isConfirmPasswordError.value = false;
                    controller.update();
                  },
                )),
                SizedBox(height: 30.h),
                /// *** Reset Password Button ***
                Obx(() => CustomButton(
                  text: controller.isLoading.value ? "Resetting..." : "Reset Password",
                  backgroundColor: buttonColor,
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                    logger.d('Reset Password pressed: email=${controller.email}, otp=${controller.otp}');
                    controller.resetPassword();
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}