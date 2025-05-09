import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../api/api_service.dart';
import '../../../themes/colors.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/snackbar_helper.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  final Logger logger = Logger();
  late String email;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Retrieve email from arguments
    email = Get.arguments?['email'] ?? '';
    if (email.isEmpty) {
      logger.e('No email received in OtpVerificationScreen');
      SnackbarHelper.showErrorSnackbar('Error: No email provided');
      // Defer navigation to after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed('/forgotPassword');
      });
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  // Resend OTP
  Future<void> _resendOtp() async {
    try {
      final response = await ApiService().requestPasswordReset(email: email);
      logger.d('Resend OTP response: status=${response['success']}, message=${response['message']}');
      if (response['success']) {
        SnackbarHelper.showSuccessSnackbar('OTP resent to $email');
      } else {
        String displayMessage = response['message'];
        if (displayMessage.contains('No PerfectUser matches')) {
          displayMessage = 'No account found with this email';
        }
        SnackbarHelper.showErrorSnackbar(displayMessage);
      }
    } catch (e) {
      logger.e('Error resending OTP: $e');
      SnackbarHelper.showErrorSnackbar('Failed to resend OTP');
    }
  }
  Future<void> _verifyOtp() async {
    if (otpController.text.length != 4) {
      SnackbarHelper.showErrorSnackbar('Please enter a 4-digit OTP');
      return;
    }

    try {
      final response = await _apiService.verifyOtp(
        email: email,
        otp: otpController.text,
      );
      logger.d('Verify OTP response: $response');

      if (response['success'] == true && response['message'].toLowerCase() == 'otp is correct') {
        logger.d('OTP verification successful, navigating to /resetPassword');
        SnackbarHelper.showSuccessSnackbar('OTP verified successfully');
        Get.toNamed('/resetPassword', arguments: {
          'email': email,
          'otp': otpController.text,
        });
      } else {
        logger.w('OTP verification failed: ${response['error'] ?? 'Unknown error'}');
        SnackbarHelper.showErrorSnackbar(response['error'] ?? 'Failed to verify OTP');
      }
    } catch (e) {
      logger.e('Error verifying OTP: $e');
      SnackbarHelper.showErrorSnackbar('Failed to verify OTP');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
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
                      border: Border.all(color: secondaryColor, width: 1),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: IconButton(
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Icon(Icons.arrow_back_ios, color: secondaryColor, size: 20.sp),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 0.015.sh),
                /// *** App Logo ***
                AppLogo(),
                SizedBox(height: 0.03.sh),
                /// *** OTP Verification Title ***
                Text(
                  "OTP Verification",
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
                  "Enter the verification code sent to\n$email",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: secondaryTextColor.withAlpha(100),
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
                      activeFillColor: secondaryColor,
                      inactiveFillColor: secondaryColor,
                      selectedFillColor: secondaryColor,
                      activeColor: borderColor,
                      inactiveColor: Colors.white70,
                      selectedColor: borderColor,
                    ),
                    enableActiveFill: true,
                    onChanged: (value) {
                      logger.d("OTP Entered: $value");
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                /// *** Verify OTP Button ***
                CustomButton(
                  text: "Verify OTP",
                  backgroundColor: buttonColor,
                  onPressed: _verifyOtp,
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
                            onTap: _resendOtp,
                            child: Text(
                              "Resend",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: subTextColor,
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