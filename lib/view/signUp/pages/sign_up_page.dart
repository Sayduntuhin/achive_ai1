import 'package:achive_ai/themes/colors.dart';
import 'package:achive_ai/view/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Background color
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
                  decoration: BoxDecoration(
                    color:backgroundColor2, // Card background color
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
                      buildTextField("Full Name"),
                      SizedBox(height: 10.h),

                      /// *** Email Field ***
                      buildTextField("E-mail or Mobile Number"),
                      SizedBox(height: 10.h),

                      /// *** Password Field ***
                      buildTextField("Password", isPassword: true),
                      SizedBox(height: 15.h),

                      /// *** Terms & Conditions ***
                      Text.rich(
                        TextSpan(
                          text: "By signing up, you're agree to our ",
                          style:
                              TextStyle(fontFamily: "Poppins", color: Colors.white70, fontSize: 10.sp),
                          children: [
                            TextSpan(
                              text: "Terms & Conditions",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color:subTextColor,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            TextSpan(
                              text: " and ",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white70, fontSize: 10.sp),
                            ),
                            TextSpan(
                              text: "Privacy Policy",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: subTextColor,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 0.03.sh,
                      ),

                      /// *** Sign-Up Button ***
                      CustomButton(
                        text: "Sign up",
                        backgroundColor: buttonColor, // Pass any color
                        onPressed: () {
                          Navigator.pushNamed(context, '/signUp');
                        },
                      ),

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
                                  onTap: () {
                                    Navigator.pushReplacementNamed(context, '/logIn'); // ✅ Navigate to sign-up page
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
