import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DriverNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showOnlineNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'driver_channel',
      'Driver Status',
      channelDescription: 'Shows current driver status',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true, // ✅ Permanent बनाता है
      autoCancel: false, // ✅ Swipe से remove नहीं होगा
      visibility: NotificationVisibility.public,
      showWhen: false,
      playSound: false, // Optional: sound हटाने के लिए
      enableVibration: false, // Optional: vibration हटाने के लिए
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      100,
      'You Are Online',
      'Ready to accept rides',
      platformChannelSpecifics,
    );
  }

  static Future<void> showOfflineNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'driver_channel',
      'Driver Status',
      channelDescription: 'Shows current driver status',
      importance: Importance.low,
      ongoing: true, // ✅ Permanent बनाता है
      autoCancel: false, // ✅ Swipe से remove नहीं होगा
      visibility: NotificationVisibility.public,
      showWhen: false,
      playSound: false, // Optional: sound हटाने के लिए
      enableVibration: false, // Optional: vibration हटाने के लिए
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      100,
      'You Are Offline',
      'Not accepting rides',
      platformChannelSpecifics,
    );
  }

  static Future<void> clearNotification() async {
    await _notificationsPlugin.cancel(100);
  }
}