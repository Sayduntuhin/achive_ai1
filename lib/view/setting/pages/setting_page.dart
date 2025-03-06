import 'package:achive_ai/view/widgets/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../themes/colors.dart';
import '../../widgets/custom_loading_indicator.dart';
import '../widgets/custom_switch.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: [
            SizedBox(height: 0.02.sh),
            Text(
              "Setting",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: textColor2,
                fontFamily: "Philosopher",
              ),
            ),
            Divider()
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            SizedBox(height: 0.05.sh),

            /// ✅ Notification Toggle
            _buildSwitchTile("Notification", 'assets/svg/notification.svg', true),

            /// ✅ Menu Items
            _buildMenuItem("Manage Subscription", 'assets/svg/manage_sub.svg',
                    () {
                    Get.toNamed('/manageSubscription');
                }),
            _buildMenuItem("Personal information", 'assets/svg/personal.svg',
                    () {
                  Get.toNamed('/personalInfo');
                }),
            _buildMenuItem("Help & Support", 'assets/svg/help.svg', () {
              Get.toNamed('/helpSupport');
            }),
            _buildMenuItem(
                "Terms & Condition", 'assets/svg/trams&conditions.svg', () {
              Get.toNamed('/termsConditions');
            }),
            _buildMenuItem("Privacy Policy", 'assets/svg/privacy.svg', () {
              Get.toNamed('/privacyPolicy');
            }),

            /// ✅ Delete Data Option
            _buildMenuItem(
                "Delete my Data", 'assets/svg/delete_data.svg', () {
              _showDeleteDataDialog();
            }, isDelete: true),

            /// ✅ Log Out Button
            SizedBox(height: 20.h),
            _buildLogout(),
          ],
        ),
      ),
    );
  }

  /// ✅ Switch Tile for Notification
  Widget _buildSwitchTile(String title, String svgPath, bool isActive) {
    return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: SvgPicture.asset(svgPath, width: 22.sp, height: 22.sp),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 18.sp,
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins"),
        ),
        trailing: CustomSwitch());
  }

  /// ✅ Menu Item with Arrow Icon
  Widget _buildMenuItem(String title, String svgPath, VoidCallback onTap,
      {bool isDelete = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: SvgPicture.asset(svgPath, width: 22.sp, height: 22.sp),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 18.sp,
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontFamily: "Poppins"),
      ),
      trailing: isDelete
          ? Icon(Icons.delete, color: Colors.red, size: 20.sp)
          : Icon(Icons.arrow_forward_ios, color: backgroundColor, size: 18.sp),
      onTap: onTap,
    );
  }

  /// ✅ Logout Button
  Widget _buildLogout() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          _showLogoutDialog();
        },
        child: Row(
          children: [
            Text(
              "Log Out",
              style: TextStyle(
                   fontSize: 18.sp,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
              ),
            ),
            Spacer(),
            Icon(Icons.logout_sharp, color: buttonColor, size: 20.sp),
          ],
        ),
      ),
    );
  }

  /// Delete Data Confirmation Dialog
  void _showDeleteDataDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Are you sure you want to delete all your data?",style: TextStyle(fontSize: 14.sp,fontFamily: "Poppins"),textAlign: TextAlign.center,),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red, // Orange color for "Yes"
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Text(
              "Yes",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
              side: BorderSide(color: secondaryBorderColor),
            ),
            child: Text(
              "No",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: textColor2,
              ),
            ),
          ),
          SizedBox(width: 2.w,)
        ],
      ),
      barrierDismissible: false, // Prevent closing by tapping outside
    );
  }

  /// Log Out Confirmation Dialog
  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "Do you really want to log out?",
          style: TextStyle(fontSize: 14.sp, fontFamily: "Poppins"),
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Show loading indicator before logging out
              Get.dialog(
                barrierDismissible: false,
                const CustomLoadingIndicator(),
              );
              // Simulate a delay before navigating to login
              Future.delayed(Duration(seconds: 2), () {
                SnackbarHelper.showInfoSnackbar("Log Out Successfully");
                Get.offAllNamed("/logIn"); // Navigate to login after delay
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Text(
              "Yes",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
              side: BorderSide(color: secondaryBorderColor),
            ),
            child: Text(
              "No",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: textColor2,
              ),
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      barrierDismissible: false, // Prevent closing by tapping outside
    );
  }
}
