import 'package:achive_ai/routers/app_router.dart';
import 'package:achive_ai/themes/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'api/api_service.dart';
import 'api/auth_service.dart';
import 'controller/notification_controller.dart';
import 'controller/profile_controller.dart';
import 'firebase_options.dart';
import 'model/notification_model.dart';

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final logger = Logger();
  logger.i('Handling background FCM message: ${message.toMap()}');

  try {
    final notificationController = Get.find<NotificationController>();
    String title = 'New Notification';
    String body = 'You have a new notification';
    String id = DateTime.now().millisecondsSinceEpoch.toString();

    if (message.notification != null) {
      title = message.notification!.title ?? title;
      body = message.notification!.body ?? body;
      id = message.messageId ?? id;
    } else if (message.data.isNotEmpty) {
      title = message.data['title'] ?? message.data['text'] ?? title;
      body = message.data['text'] ?? body;
      id = message.data['id'] ?? id;
    }

    final notification = NotificationModel(
      id: id,
      title: title,
      description: body,
      createdAt: DateTime.now(),
      isRead: false,
    );
    await notificationController.addNotificationFromFCM(notification);
    logger.i('Background notification added: $title');
  } catch (e) {
    logger.e('Error in background handler: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Logger logger = Logger();

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    logger.i('Firebase initialized successfully');
    Get.put(ApiService(), permanent: true);
    Get.put(ProfileController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
  } catch (e) {
    logger.e('Firebase initialization error: $e');
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final AuthService authService = AuthService();
  final String initialRoute = await authService.isAuthenticated() ? Routes.mainPage : Routes.initial;
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