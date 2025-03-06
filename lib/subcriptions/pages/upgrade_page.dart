import 'package:achive_ai/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../themes/colors.dart';
import '../../view/setting/widgets/custom_app_bar.dart';

class UpgradePlanScreen extends StatefulWidget {
  const UpgradePlanScreen({super.key});

  @override
  State<UpgradePlanScreen> createState() => _UpgradePlanScreenState();
}

class _UpgradePlanScreenState extends State<UpgradePlanScreen> {
  bool isMonthly = true; // true for Monthly, false for Yearly

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorMain,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.1.sh),
        child: CustomAppBar(
          backgroundColor: backgroundColorMain,
          title: "Upgrade Plan",
          borderColor: secondaryBorderColor,
          textColor: textColor,
          onBackPress: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            /// Plan Selector (Monthly/Yearly Toggle)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPlanToggleButton("Monthly", isMonthly),
                SizedBox(width: 10.w),
                _buildPlanToggleButton("Yearly", !isMonthly),
              ],
            ),
            SizedBox(height: 20.h),

            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.white),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  children: [
                    /// Pricing Section
                    Text(
                      "Achieve Ai",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        fontFamily: "Philosopher",
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      isMonthly ? "\$4.99 / month" : "\$49.99 / year",
                      // Price change based on selection
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor2,
                        fontFamily: "Philosopher",
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Divider(
                      color: dividerColor,
                    ),
                    SizedBox(height: 10.h),

                    /// Features List
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(6, (index) {
                        return _buildFeatureItem("Some features goes here");
                      }),
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
            Spacer(flex: 2),
            /// Continue Button
            CustomButton(
              text: "Continue - \$${isMonthly ? '4.99' : '49.99'}",
              backgroundColor: buttonColor,
              onPressed: () {},
            ),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  /// Plan Toggle Button (Monthly / Yearly)
  Widget _buildPlanToggleButton(String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isMonthly = label == "Monthly"; // Update isMonthly based on selected plan
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isActive ? buttonColor : Colors.white, // Use buttonColor when active, white when inactive
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: buttonColor), // Border color remains buttonColor
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : buttonColor, // Text color is white when active, buttonColor when inactive
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }

  /// Feature Item Widget (with Checkmark)
  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/svg/check_mark.svg",
            width: 28.w,
            height: 28.h,
          ),
          SizedBox(width: 10.w),
          Text(
            feature,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: textColor2,
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    );
  }
}
