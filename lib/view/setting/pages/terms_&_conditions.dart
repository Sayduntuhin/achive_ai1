import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../themes/colors.dart';
import '../widgets/custom_app_bar.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.1.sh),
        child: CustomAppBar(
          title: "Terms & Conditions",
          borderColor: secondaryBorderColor,
          textColor: textColor,
          onBackPress: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "By using the Business Coach Chatbot, you agree to the following terms:",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor2,
                  fontFamily: "Poppins"
                ),
              ),
              SizedBox(height: 20.h),
              _buildTermsItem(
                  "1. The chatbot provides general business guidance and advice but is not a substitute for professional consulting services."),
              _buildTermsItem(
                  "2. We offer both free and paid subscription plans. Paid plans are billed on a recurring basis unless canceled."),
              _buildTermsItem(
                  "3. User data is handled securely and in accordance with our Privacy Policy."),
              _buildTermsItem(
                  "4. We are not responsible for decisions made based on the chatbot's advice or any resulting outcomes."),
              _buildTermsItem(
                  "5. Misuse of the service or violation of these terms may result in termination of access."),
              SizedBox(height: 20.h),
              Text(
                "By continuing to use the chatbot, you accept these terms. For questions, contact our support team.",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
                color: textColor2,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
