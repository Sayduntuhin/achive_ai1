import 'package:achive_ai/themes/colors.dart';
import 'package:achive_ai/view/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Background color
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
            child: Column(
              children: [
                /// *** App Logo ***
                SizedBox(height: 0.05.sh),
                AppLogo(),

                SizedBox(height: 0.1.sh),

                /// *** LogIN Card ***
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
                  decoration: BoxDecoration(
                    color: backgroundColor2, // Card background color
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
                                Navigator.pushReplacementNamed(
                                    context, '/forgetPassword');
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
                                  color: Color(0xffFF2929),
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
                        backgroundColor: buttonColor, // Pass any color
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, '/mainPage',(route) =>
                          false);
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
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/signUp',
                                        (route) =>
                                            false); // ✅ Navigate to sign-up page
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.orangeAccent,
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
