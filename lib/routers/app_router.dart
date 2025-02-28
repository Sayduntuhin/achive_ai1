import 'package:achive_ai/view/forgetPassword/pages/forget_password.dart';
import 'package:achive_ai/view/forgetPassword/pages/otp_verification_page.dart';
import 'package:achive_ai/view/forgetPassword/pages/pass_change_success_page.dart';
import 'package:achive_ai/view/forgetPassword/pages/reset_password_page.dart';
import 'package:achive_ai/view/login/pages/log_in_page.dart';
import 'package:achive_ai/view/main/page/main_pages.dart';
import 'package:achive_ai/view/signUp/pages/sign_up_page.dart';
import 'package:achive_ai/view/welcome/pages/welcome_page.dart';
import 'package:get/get.dart';
import '../view/aiboost/page/aiboost_page.dart';

class Routes {
  static const String initial = "/";
  static const String welcome = "/welcome";
  static const String logIn = "/logIn";
  static const String forgetPassword = "/forgetPassword";
  static const String otpVerification = "/otpVerification";
  static const String resetPassword = "/resetPassword";
  static const String successResetPassword = "/successResetPassword";
  static const String signUP = "/signUp";
  static const String mainPage = "/mainPage";
}

class AppPages {
  static final routes = [
    //>>>>>>>>>>>>>>>>Welcome>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    GetPage(name: Routes.initial, page: () => AiBoostScreen(), transition: Transition.zoom),
    GetPage(name: Routes.welcome, page: () => WelcomeScreen(), transition: Transition.rightToLeftWithFade),
    //>>>>>>>>>>>>>>>>Login>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    GetPage(name: Routes.logIn, page: () => LogInScreen(), transition: Transition.size),
    GetPage(name: Routes.forgetPassword, page: () => ForgotPasswordScreen(), transition: Transition.size),
    GetPage(name: Routes.otpVerification, page: () => OtpVerificationScreen(), transition: Transition.size),
    GetPage(name: Routes.resetPassword , page: () => ResetPasswordScreen(), transition: Transition.size),
    GetPage(name: Routes.successResetPassword , page: () => PasswordChangedScreen(), transition: Transition.size),
   //>>>>>>>>>>>>>>>>SignUp>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    GetPage(name: Routes.signUP, page: () => SignUpScreen(), transition: Transition.size),
    //>>>>>>>>>>>>>>>>MainPage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    GetPage(name: Routes.mainPage, page: () => MainScreen(), transition: Transition.size),
  ];
}
