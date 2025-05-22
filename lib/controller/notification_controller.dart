import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api_service.dart';
import '../model/notification_model.dart';
import '../view/widgets/snackbar_helper.dart';

class NotificationController extends GetxController {
  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final unreadCount = 0.obs;
  final Logger _logger = Logger();
  final ApiService _apiService = Get.find<ApiService>();
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const String _storageKey = 'notifications';
  static const int _maxStorageRetries = 3;

  @override
  void onInit() {
    super.onInit();
    _initializeLocalNotifications();
    fetchNotifications();
    setupFCMListeners();
  }

  Future<void> _initializeLocalNotifications() async {
    try {
      const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const InitializationSettings initializationSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          _logger.i('Notification tapped: ${response.payload}');
          Get.toNamed('/notification');
        },
      );

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      final androidPlugin = _localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(channel);
      _logger.i('Notification channel created: high_importance_channel');

      final androidPermission = await androidPlugin?.requestNotificationsPermission();
      _logger.i('Android notification permission: $androidPermission');
    } catch (e) {
      _logger.e('Error initializing local notifications: $e');
    }
  }

  Future<void> showLocalNotification(String title, String body, String id) async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        showWhen: true,
        channelShowBadge: true,
      );
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotificationsPlugin.show(
        id.hashCode,
        title,
        body,
        platformDetails,
        payload: id,
      );
      _logger.i('Local notification shown: id=$id, title=$title, body=$body');
    } catch (e) {
      _logger.e('Error showing local notification: $e');
    }
  }

  Future<void> submitDeviceToken(String deviceToken) async {
    try {
      final response = await _apiService.submitDeviceToken(deviceToken);
      if (response['success']) {
        _logger.i('Device token submitted successfully: $deviceToken');
      } else {
        _logger.w('Failed to submit device token: ${response['message']}');
      }
    } catch (e) {
      _logger.e('Error submitting device token: $e');
    }
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedNotifications = prefs.getString(_storageKey);
      if (storedNotifications != null) {
        try {
          final List<dynamic> jsonList = jsonDecode(storedNotifications);
          notifications.assignAll(jsonList.map((json) => NotificationModel.fromJson(json)).toList());
          unreadCount.value = notifications.where((n) => !n.isRead).length;
          _logger.i('Fetched ${notifications.length} notifications from local storage');
        } catch (e) {
          _logger.e('Error decoding stored notifications: $e, stored data: $storedNotifications');
          await prefs.remove(_storageKey);
        }
      }
    } catch (e) {
      _logger.e('Error accessing SharedPreferences: $e');
    }

    try {
      final response = await _apiService.getNotifications();
      _logger.d('Notifications API response: ${response.toString()}');
      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        notifications.clear();
        notifications.assignAll(data.map((json) => NotificationModel.fromJson(json)).toList());
        unreadCount.value = notifications.where((n) => !n.isRead).length;
        await _saveToStorage();
        _logger.i('Fetched ${notifications.length} notifications from API');
      } else {
        errorMessage.value = response['message'] ?? 'Failed to load notifications';
        _logger.w('API error: ${errorMessage.value}');
        SnackbarHelper.showErrorSnackbar(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Error loading notifications: $e';
      _logger.e('Error fetching notifications from API: $e');
      SnackbarHelper.showErrorSnackbar(errorMessage.value);
    } finally {
      isLoading.value = false;
      if (notifications.isEmpty && errorMessage.value.isNotEmpty) {
        _logger.w('No notifications loaded, error: ${errorMessage.value}');
      }
    }
  }

  Future<void> addNotificationFromFCM(NotificationModel notification) async {
    notifications.insert(0, notification);
    unreadCount.value = notifications.where((n) => !n.isRead).length;
    await _saveToStorage();
    notifications.refresh();
    _logger.i('Added FCM notification: ${notification.title}');
    await showLocalNotification(
      notification.title,
      notification.description,
      notification.id,
    );
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index == -1) {
        _logger.w('Notification not found: $notificationId');
        SnackbarHelper.showErrorSnackbar('Notification not found');
        return;
      }

      // Update local state
      final originalNotification = notifications[index];
      notifications[index] = NotificationModel(
        id: originalNotification.id,
        title: originalNotification.title,
        description: originalNotification.description,
        createdAt: originalNotification.createdAt,
        isRead: true,
      );
      unreadCount.value = notifications.where((n) => !n.isRead).length;
      notifications.refresh();
      _logger.i('Marked notification $notificationId as read locally');

      // Sync with backend
      final response = await _apiService.markNotificationAsRead(notificationId);
      if (!response['success']) {
        _logger.w('Failed to mark notification $notificationId as read on backend: ${response['message']}');
        SnackbarHelper.showErrorSnackbar('Failed to mark notification as read: ${response['message']}');
        // Revert local change
        notifications[index] = originalNotification;
        unreadCount.value = notifications.where((n) => !n.isRead).length;
        notifications.refresh();
        return;
      }

      // Save to storage
      await _saveToStorage();
      _logger.i('Saved notification $notificationId read status to storage');
    } catch (e) {
      _logger.e('Error marking notification as read: $e');
      SnackbarHelper.showErrorSnackbar('Error marking notification as read');
      // Revert local state by refetching
      await fetchNotifications();
    }
  }

  Future<void> _saveToStorage() async {
    int attempt = 0;
    while (attempt < _maxStorageRetries) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final jsonList = notifications.map((n) => n.toJson()).toList();
        await prefs.setString(_storageKey, jsonEncode(jsonList));
        _logger.i('Saved ${notifications.length} notifications to storage');
        return;
      } catch (e) {
        attempt++;
        _logger.e('Error saving notifications to storage (attempt $attempt): $e');
        if (attempt >= _maxStorageRetries) {
          _logger.e('Max retries reached for saving to storage');
          SnackbarHelper.showErrorSnackbar('Failed to save notifications');
          break;
        }
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  void setupFCMListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _logger.i('Received foreground FCM message: ${message.toMap()}');
      String title = 'New Notification';
      String description = 'You have a new notification';
      String id = DateTime.now().millisecondsSinceEpoch.toString();

      if (message.notification != null) {
        title = message.notification!.title ?? title;
        description = message.notification!.body ?? description;
        id = message.messageId ?? id;
      } else if (message.data.isNotEmpty) {
        title = message.data['title'] ?? message.data['text'] ?? title;
        description = message.data['text'] ?? message.data['user_email'] ?? description;
        id = message.data['id'] ?? id;
      }

      final notification = NotificationModel(
        id: id,
        title: title,
        description: description,
        createdAt: DateTime.now(),
        isRead: false,
      );
      addNotificationFromFCM(notification);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _logger.i('FCM message opened app: ${message.toMap()}');
      String title = 'New Notification';
      String description = 'You have a new notification';
      String id = DateTime.now().millisecondsSinceEpoch.toString();

      if (message.notification != null) {
        title = message.notification!.title ?? title;
        description = message.notification!.body ?? description;
        id = message.messageId ?? id;
      } else if (message.data.isNotEmpty) {
        title = message.data['title'] ?? message.data['text'] ?? title;
        description = message.data['text'] ?? message.data['user_email'] ?? description;
        id = message.data['id'] ?? id;
      }

      final notification = NotificationModel(
        id: id,
        title: title,
        description: description,
        createdAt: DateTime.now(),
        isRead: false,
      );
      addNotificationFromFCM(notification);
      Get.toNamed('/notification');
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _logger.i('App opened from terminated state with FCM message: ${message.toMap()}');
        String title = 'New Notification';
        String description = 'You have a new notification';
        String id = DateTime.now().millisecondsSinceEpoch.toString();

        if (message.notification != null) {
          title = message.notification!.title ?? title;
          description = message.notification!.body ?? description;
          id = message.messageId ?? id;
        } else if (message.data.isNotEmpty) {
          title = message.data['title'] ?? message.data['text'] ?? title;
          description = message.data['text'] ?? message.data['user_email'] ?? description;
          id = message.data['id'] ?? id;
        }

        final notification = NotificationModel(
          id: id,
          title: title,
          description: description,
          createdAt: DateTime.now(),
          isRead: false,
        );
        addNotificationFromFCM(notification);
        Get.toNamed('/notification');
      }
    });
  }
}