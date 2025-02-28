import 'package:achive_ai/routers/app_router.dart';
import 'package:achive_ai/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 800),
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
          ),
          initialRoute: Routes.initial, // ✅ Use class-based route names
          getPages: AppPages.routes, // ✅ Cleaner route structure
        );
      },
    );
  }
}
