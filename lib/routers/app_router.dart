import 'package:achive_ai/view/forgetPassword/pages/forget_password.dart';
import 'package:achive_ai/view/forgetPassword/pages/otp_verification_page.dart';
import 'package:achive_ai/view/forgetPassword/pages/pass_change_success_page.dart';
import 'package:achive_ai/view/forgetPassword/pages/reset_password_page.dart';
import 'package:achive_ai/view/login/pages/log_in_page.dart';
import 'package:achive_ai/view/main/page/main_pages.dart';
import 'package:achive_ai/view/missed_task/page/missed_task.dart';
import 'package:achive_ai/view/notification/page/notification_page.dart';
import 'package:achive_ai/view/setting/pages/help_&_support.dart';
import 'package:achive_ai/view/setting/pages/manage_sub_page.dart';
import 'package:achive_ai/view/setting/pages/privacy_policy.dart';
import 'package:achive_ai/view/setting/pages/terms_&_conditions.dart';
import 'package:achive_ai/view/signUp/pages/sign_up_page.dart';
import 'package:achive_ai/view/welcome/pages/welcome_page.dart';
import 'package:get/get.dart';
import '../view/aiboost/page/aiboost_page.dart';
import '../view/goal/page/view_task_page.dart';
import '../view/setting/pages/personal_page.dart';
import '../view/subcriptions/pages/upgrade_page.dart';

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
  static const String manageSubscription = "/manageSubscription";
  static const String personalInfo = "/personalInfo";
  static const String helpSupport = "/helpSupport";
  static const String termsConditions = "/termsConditions";
  static const String privacyPolicy = "/privacyPolicy";
  static const String upgradePlan = "/upgradePlan";
  static const String missedTask = "/missedTask";
  static const String viewTask = "/viewTask";
  static const String notification = "/notification";

}

class AppPages {
  static final routes = [
    //>>>>>>>>>>>>>>>>Welcome>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    GetPage(name: Routes.initial, page: () => AiBoostScreen(), transition: Transition.zoom),
    GetPage(name: Routes.welcome, page: () => WelcomeScreen(), transition: Transition.rightToLeftWithFade),
    //>>>>>>>>>>>>>>>>Login>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    GetPage(name: Routes.logIn, page: () => LogInScreen(), transition: Transition.size),
    GetPage(name: Routes.forgetPassword, page: () => ForgotPasswordScreen(), transition: Transition.rightToLeft),
    GetPage(name: Routes.otpVerification, page: () => OtpVerificationScreen(), transition: Transition.cupertinoDialog),
    GetPage(name: Routes.resetPassword , page: () => ResetPasswordScreen(), transition: Transition.size),
    GetPage(name: Routes.successResetPassword , page: () => PasswordChangedScreen(), transition: Transition.fadeIn),
   //>>>>>>>>>>>>>>>>SignUp>>>>>>>>>>>>>>>>>>>>>>>>>>      >>>>>
    GetPage(name: Routes.signUP, page: () => SignUpScreen(), transition: Transition.size),
    //>>>>>>>>>>>>>>>>MainPage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    GetPage(name: Routes.mainPage, page: () => MainScreen(), transition: Transition.fadeIn),
    GetPage(name: Routes.missedTask, page: () => MissedTaskPage(), transition: Transition.fadeIn),
    GetPage(name: Routes.viewTask, page: () => ViewTaskPage(), transition: Transition.fadeIn),
    GetPage(name: Routes.notification, page: () => NotificationPage(), transition: Transition.fadeIn),
    //>>>>>>>>>>>>>>>>SettingPage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    GetPage(name: Routes.manageSubscription, page: () => ManageSubscriptionScreen(), transition: Transition.fadeIn),
    GetPage(name: Routes.personalInfo, page: () => PersonalInformationScreen(), transition: Transition.fadeIn),
    GetPage(name: Routes.helpSupport, page: () => HelpAndSupportScreen(), transition: Transition.fadeIn),
    GetPage(name: Routes.termsConditions, page: () => TermsAndConditionsScreen(), transition: Transition.fadeIn),
    GetPage(name: Routes.privacyPolicy, page: () => PrivacyPolicy(), transition: Transition.fadeIn),
    //>>>>>>>>>>>>>>>>Subscriptions Page>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    GetPage(name: Routes.upgradePlan, page: () => UpgradePlanScreen(), transition: Transition.fadeIn),
  ];
}
