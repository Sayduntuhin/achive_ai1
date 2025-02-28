import 'package:achive_ai/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/custom_slide_button.dart';

class AiBoostScreen extends StatelessWidget {
  const AiBoostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: Column(
            children: [
              /// *** 3D Illustration ***
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/splash.png',
                    width: 2.sw,
                  ),
                ),
              ),

              /// *** Title and Description ***
              Text(
                "Boost Your Mind\nPower with AI",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Philosopher",
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w700,
                  color: titleColor, // Orange text color
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                "Chat with the smartest AI Future\nExperience power of AI with us",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xffD9D9D9),
                ),
              ),
              SizedBox(height: 30.h),

              /// *** SLIDABLE BUTTON ***
              Center(
                child: CustomSlideButton(
                  onSlideComplete: () {
                    /// Navigate to the next screen when slide is complete
                    Navigator.pushReplacementNamed(context, "/welcome");
                  },
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
