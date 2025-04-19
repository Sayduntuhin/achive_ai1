import 'package:achive_ai/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Background color
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
        
              /// *** Email Input Field ***
              CustomTextField(
                hintText: "Email.",
                controller: emailController,
              ),
        
              SizedBox(height: 20.h),
        
              /// *** Sign Up Button ***
              CustomButton(
                text: "Send Email",
                backgroundColor: buttonColor,
                onPressed: () {
             //    Navigator.pushNamed(context, "/otpVerification");
                 Get.toNamed('/otpVerification');

                },
              ),
        
              SizedBox(height: 20.h),
        
              /// *** Remember Password? Login ***
              Center(
                child: Text.rich(
                  TextSpan(
                    text: "Remember Password? ",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: secondaryTextColor,
                      fontSize: 10.sp,
                    ),
                    children: [
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "/logIn");
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
