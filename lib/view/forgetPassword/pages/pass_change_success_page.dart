import 'package:achive_ai/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PasswordChangedScreen extends StatefulWidget {
  const PasswordChangedScreen({super.key});

  @override
  State<PasswordChangedScreen> createState() => _PasswordChangedScreenState();
}

class _PasswordChangedScreenState extends State<PasswordChangedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // ✅ Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    // ✅ Scale Animation (For Checkmark Icon)
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    // ✅ Start animation after build
    Future.delayed(Duration(milliseconds: 200), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Background color
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// *** Animated Checkmark Icon ***
                ScaleTransition(
                  scale: _animation,
                  child: SvgPicture.asset("assets/svg/checkmark.svg")
                ),

                SizedBox(height: 30.h),

                /// *** Password Changed Text ***
                Text(
                  "Password Changed!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Philosopher",
                    fontSize: 35.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),

                SizedBox(height: 10.h),

                /// *** Success Message ***
                Text(
                  "Your password has been changed\nsuccessfully.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14.sp,
                    color: secondaryTextColor.withAlpha(150),
                  ),
                ),

                SizedBox(height: 40.h),

                /// *** Back to Login Button ***
                SizedBox(
                  width: double.infinity,
                  height: 55.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        "/logIn", // ✅ Navigate to Login & Remove History
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Text(
                      "Back To Login",
                      style: TextStyle(
                        fontFamily: "Philosopher",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: secondaryTextColor,
                      ),
                    ),
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
