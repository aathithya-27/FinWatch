import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import '../config/app_config.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    await _initLocalNotifications();
    await _initFirebaseMessaging();
    await _requestPermissions();
  }

  static Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  static Future<void> _createNotificationChannels() async {
    const List<AndroidNotificationChannel> channels = [
      AndroidNotificationChannel(
        AppConfig.transactionChannelId,
        'Transaction Notifications',
        description: 'Notifications for new transactions',
        importance: Importance.high,
        sound: RawResourceAndroidNotificationSound('notification_sound'),
      ),
      AndroidNotificationChannel(
        AppConfig.budgetChannelId,
        'Budget Notifications',
        description: 'Notifications for budget alerts',
        importance: Importance.high,
        sound: RawResourceAndroidNotificationSound('notification_sound'),
      ),
      AndroidNotificationChannel(
        AppConfig.reminderChannelId,
        'Reminder Notifications',
        description: 'Reminder notifications',
        importance: Importance.defaultImportance,
      ),
    ];

    for (final channel in channels) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  static Future<void> _initFirebaseMessaging() async {
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Handle notification tap when app is terminated
    final RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  static Future<void> _requestPermissions() async {
    // Request notification permissions
    final NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (kDebugMode) {
      print('Notification permission status: ${settings.authorizationStatus}');
    }

    // Request SMS permission for Android
    if (Platform.isAndroid) {
      await Permission.sms.request();
      await Permission.notification.request();
    }
  }

  // Local notification methods
  static Future<void> showTransactionNotification({
    required String title,
    required String body,
    required String transactionId,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      AppConfig.transactionChannelId,
      'Transaction Notifications',
      channelDescription: 'Notifications for new transactions',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF6C63FF),
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: 'transaction:$transactionId',
    );
  }

  static Future<void> showBudgetAlert({
    required String title,
    required String body,
    required String category,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      AppConfig.budgetChannelId,
      'Budget Notifications',
      channelDescription: 'Notifications for budget alerts',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFFFF9800),
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: 'budget:$category',
    );
  }

  static Future<void> showReminder({
    required String title,
    required String body,
    DateTime? scheduledDate,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      AppConfig.reminderChannelId,
      'Reminder Notifications',
      channelDescription: 'Reminder notifications',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    if (scheduledDate != null) {
      await _localNotifications.zonedSchedule(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } else {
      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        details,
      );
    }
  }

  // Firebase messaging methods
  static Future<String?> getFirebaseToken() async {
    return await _firebaseMessaging.getToken();
  }

  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  // Event handlers
  static void _onNotificationTapped(NotificationResponse response) {
    final String? payload = response.payload;
    if (payload != null) {
      _handlePayload(payload);
    }
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print('Received foreground message: ${message.messageId}');
    }

    // Show local notification for foreground messages
    if (message.notification != null) {
      await showTransactionNotification(
        title: message.notification!.title ?? 'FinWatch',
        body: message.notification!.body ?? 'New notification',
        transactionId: message.data['transactionId'] ?? '',
      );
    }
  }

  static void _handleNotificationTap(RemoteMessage message) {
    if (kDebugMode) {
      print('Notification tapped: ${message.messageId}');
    }
    
    // Handle navigation based on message data
    final String? type = message.data['type'];
    final String? id = message.data['id'];
    
    if (type != null && id != null) {
      _handlePayload('$type:$id');
    }
  }

  static void _handlePayload(String payload) {
    final List<String> parts = payload.split(':');
    if (parts.length == 2) {
      final String type = parts[0];
      final String id = parts[1];
      
      // Handle navigation based on payload
      switch (type) {
        case 'transaction':
          // Navigate to transaction details
          break;
        case 'budget':
          // Navigate to budget page
          break;
        default:
          // Navigate to home
          break;
      }
    }
  }

  // Cancel notifications
  static Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }
}

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Handling background message: ${message.messageId}');
  }
}