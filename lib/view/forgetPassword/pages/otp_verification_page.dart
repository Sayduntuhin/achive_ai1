import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:get/get.dart';
import '../../../themes/colors.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late TextEditingController otpController;

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
  }

/*
  @override
  void dispose() {
    otpController.dispose(); // ✅ Safe disposal
    super.dispose();
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false, // ✅ Prevent UI jump on keyboard
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
            child: Column(
              children: [
                /// *** Back Button ***
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
                        Get.back();
                      },
                    ),
                  ),
                ),

                /// *** App Logo & Title ***
                AppLogo(),

                SizedBox(height: 30.h),

                /// *** OTP Verification Title ***
                Text(
                  "OTP Verification",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Philosopher",
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 10.h),

                /// *** Instruction Text ***
                Text(
                  "Enter the verification code we just sent on\nyour email address.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14.sp,
                    color: Colors.white70,
                  ),
                ),

                SizedBox(height: 20.h),

                /// *** OTP Input Fields ***
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    controller: otpController,
                    textStyle: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10.r),
                      fieldHeight: 50.h,
                      fieldWidth: 50.w,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      activeColor: borderColor,
                      inactiveColor: Colors.white70,
                      selectedColor: borderColor,
                    ),
                    enableActiveFill: true,
                    onChanged: (value) {
                      debugPrint("OTP Entered: $value");
                    },
                  ),
                ),

                SizedBox(height: 20.h),

                /// *** Verify OTP Button ***
                CustomButton(
                  text: "Otp Verified",
                  backgroundColor: buttonColor,
                  onPressed: () {
                    Navigator.pushNamed(context, "/resetPassword");
                  },
                ),

                SizedBox(height: 20.h),

                /// *** Resend OTP Link ***
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: "Didn't receive a code? ",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white70,
                        fontSize: 12.sp,
                      ),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Handle Resend OTP
                            },
                            child: Text(
                              "Resend",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: buttonColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
