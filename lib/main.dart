import 'package:achive_ai/routers/app_router.dart';
import 'package:achive_ai/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'api/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AuthService authService = AuthService();
  final String initialRoute = await authService.isAuthenticated() ? Routes.mainPage : Routes.initial;
  final Logger logger = Logger();
  logger.d('Initial route: $initialRoute');

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Achieve AI',
          theme: ThemeData(
            primaryColor: primaryColor,
            scaffoldBackgroundColor: backgroundColor,
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              scrolledUnderElevation: 0,
            ),
          ),
          initialRoute: initialRoute,
          getPages: AppPages.routes,
        );
      },
    );
  }
}