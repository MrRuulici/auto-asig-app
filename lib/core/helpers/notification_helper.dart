import 'dart:math';

import 'package:auto_asig/core/models/notification_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize notifications
  static Future<void> initialize() async {
    // Initialize TimeZone database
    tz.initializeTimeZones();

    // Define settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Define settings for iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    // Define settings for iOS (optional)
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS); // Add iOS settings here

    // Initialize the plugin
    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    // Ensure the scheduled date is in the future
    if (dateTime.isBefore(DateTime.now())) {
      print('Scheduled date must be in the future.');
      return;
    }
    // Request exact alarm permission if needed
    if (await _requestExactAlarmPermission()) {
      // Android-specific details
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'alliat_asig', // Channel ID
        'Alliat', // Channel Name
        channelDescription: 'This channel is for Alliat notifications',
        importance: Importance.high,
        priority: Priority.high,
      );

      // Notification details
      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidDetails);

      // Schedule the notification
      await _notificationsPlugin.zonedSchedule(
        id, // Unique ID for the notification
        title, // Notification title
        body, // Notification body
        tz.TZDateTime.from(dateTime, tz.local), // Scheduled time
        notificationDetails, // Notification details
        androidScheduleMode:
            AndroidScheduleMode.exactAllowWhileIdle, // Add this line
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } else {
      print('Exact alarms are not permitted.');
    }
  }

  static Future<bool> _requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isGranted) {
      return true;
    } else {
      final status = await Permission.scheduleExactAlarm.request();
      return status.isGranted;
    }
  }

  static void scheduleNotifications(
    Map<String, List<NotificationModel>> notifications,
  ) {
    notifications.forEach((key, value) {
      for (int i = 0; i < value.length; i++) {
        final notification = value[i];

        if (notification.push && notification.date.isAfter(DateTime.now())) {
          NotificationHelper.scheduleNotification(
            id: notification.notificationId, // Unique ID for each notification
            title: 'Notificare - ${key} - ${notification.date}',
            body: 'În data de ${notification.date} expiră documentul: $key.',
            dateTime: notification.date,
          );
        }
      }
    });
  }

  static Future<int> generateUniqueNotificationId() async {
    final List<PendingNotificationRequest> pendingNotifications =
        await _notificationsPlugin.pendingNotificationRequests();

    // random generate an int between 0 and 10000

    int i = _generateRandomInt(0, 10000);
    bool idExists;

    do {
      idExists = false;
      for (var notification in pendingNotifications) {
        if (notification.id == i) {
          idExists = true;
          i++;
          break;
        }
      }
    } while (idExists);

    return i;
  }

  // static void scheduleNotificationFromModel(NotificationModel notification) {
  //   if (notification.push && notification.date.isAfter(DateTime.now())) {
  //     NotificationHelper.scheduleNotification(
  //       id: notification.id, // Unique ID for each notification
  //       title: 'Reminder',
  //       body: 'Your notification is scheduled for ${notification.date}.',
  //       dateTime: notification.date,
  //     );
  //   }
  // }

  // update the notification
  static Future<void> updateNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    // Ensure the scheduled date is in the future
    if (dateTime.isBefore(DateTime.now())) {
      print('Scheduled date must be in the future.');
      return;
    }
    // Android-specific details
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'alliat_asig', // Channel ID
      'Alliat', // Channel Name
      channelDescription: 'This channel is for Alliat notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    // Notification details
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    // Schedule the notification
    await _notificationsPlugin.zonedSchedule(
      id, // Unique ID for the notification
      title, // Notification title
      body, // Notification body
      tz.TZDateTime.from(dateTime, tz.local), // Scheduled time
      notificationDetails, // Notification details
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle, // Add this line
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  static int _generateRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min + 1);
  }

  static clearAllNotifications() {
    _notificationsPlugin.cancelAll();
  }
}
