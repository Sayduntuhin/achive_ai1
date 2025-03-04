import 'package:achive_ai/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  ResetPasswordScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Background color
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: IconButton(
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                /// *** App Logo ***
                AppLogo(),
                SizedBox(height: 30.h),
        
                /// *** Forgot Password Title ***
                Text(
                  "Create New Password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Philosopher",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
        
                SizedBox(height: 10.h),
        
                /// *** Instruction Text ***
                Text(
                  "Your new password must be unique from those previously used.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
        
                SizedBox(height: 20.h),
        
                /// *** Email Input Field ***
                CustomTextField(
                  hintText: "New Password",
                  controller: newPasswordController,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  hintText: "Confirm Password",
                  controller: confirmPasswordController,
                ),
        
                SizedBox(height: 30.h),
        
                /// *** Reset Password  Button ***
                CustomButton(
                  text: "Reset Password",
                  backgroundColor: buttonColor,
                  onPressed: () {
                 /*   Navigator.pushNamedAndRemoveUntil(
                      context,
                      "/successResetPassword", // ✅ Navigate to login screen
                          (route) => false, // ✅ Removes all previous routes
                    );*/
                    Get.offAllNamed('/successResetPassword');
                  },
        
        
        
                ),
        
              ],
            ),
          ),
        ),
      ),
    );
  }
}
