import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../themes/colors.dart';
import '../../widgets/custom_button.dart';
import '../widgets/custom_app_bar.dart';

class ManageSubscriptionScreen extends StatelessWidget {
  const ManageSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.1.sh),
        child: CustomAppBar(
          backgroundColor: Colors.white,
          title: "Manage Subscription",
          borderColor: secondaryBorderColor,
          textColor: textColor,
          onBackPress: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w,),
        child: Column(
          children: [
            /// ✅ Subscription Details Box
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow("Bill No", "123"),
                  _buildDetailRow("User Name", "Mira", isBold: true),
                  _buildDetailRow("Purchase date", "19 FEB, 2025", isBold: true),
                  _buildDetailRow("Subscription Type", "Standard", isBold: true),
                  _buildDetailRow("Subscription Amount", "\$40", isBold: true),
                  _buildDetailRow("Expire Date", "19 Sep, 2025", isBold: true),
                ],
              ),
            ),

            SizedBox(height: 0.1.sh),

            /// ✅ Update Button
           CustomButton(
              text: "Update Subscription",
              onPressed: () {
                Get.toNamed("/upgradePlan");
              },
             backgroundColor: buttonColor,
            ),

            SizedBox(height: 15.h),

            /// ✅ Cancel Button
            CustomButton(
              text: "Cancel",
              onPressed: () {},
              backgroundColor: Colors.white,
              borderColor: secondaryBorderColor
            ),

          ],
        ),
      ),
    );
  }

  /// ✅ Build Subscription Detail Row
  Widget _buildDetailRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: .015.sh, horizontal: 0.10.sw),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 15.sp, color: textColor2),
          children: [
            TextSpan(
              text: "$title : ",
              style: TextStyle(
                fontWeight:FontWeight.w600,
                color: textColor2,
                fontFamily: "Poppins",
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.w400 : FontWeight.normal,
                color: Color(0xff595C5E),
                fontFamily: "Poppins",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
