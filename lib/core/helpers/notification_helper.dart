import 'dart:math';
import 'dart:io' show Platform;

import 'package:auto_asig/core/models/notification_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize notifications with proper permissions and settings
  static Future<void> initialize() async {
    await _configureLocalTimeZone();

    // Define settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Define settings for iOS/macOS
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combined initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    // Initialize the plugin with callback for notification taps
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
    );

    // Request permissions
    await _requestPermissions();
  }

  /// Configure local timezone
  static Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    
    // Get TimezoneInfo and extract the name property
    final TimezoneInfo timeZoneInfo = await FlutterTimezone.getLocalTimezone();
    final String timeZoneName = timeZoneInfo.identifier;
    
    tz.setLocalLocation(tz.getLocation(timeZoneName));
}


  /// Handle notification tap (foreground)
  static void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ID=${response.id}, Payload=${response.payload}');
    // Handle navigation or other actions here
    // You can use a navigation service or global key to navigate
  }

  /// Handle notification tap (background/terminated)
  @pragma('vm:entry-point')
  static void _notificationTapBackground(NotificationResponse response) {
    print('Background notification tapped: ID=${response.id}');
  }

  /// Request all necessary permissions
  static Future<bool> _requestPermissions() async {
    bool granted = true;

    if (Platform.isAndroid) {
      // Check notification permission (Android 13+)
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
      granted = grantedNotificationPermission ?? false;

      // Request exact alarm permission
      if (granted) {
        granted = granted && await _requestExactAlarmPermission();
      }
    }

    // iOS/macOS permissions are requested during initialization
    if (Platform.isIOS || Platform.isMacOS) {
      final result = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      granted = result ?? false;
    }

    return granted;
  }

  /// Request exact alarm permission for Android 12+
  static Future<bool> _requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.scheduleExactAlarm.isGranted) {
        return true;
      } else {
        final status = await Permission.scheduleExactAlarm.request();
        return status.isGranted;
      }
    }
    return true;
  }

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final bool? enabled = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();
      return enabled ?? false;
    }
    return true; // iOS handles this differently
  }

  /// Schedule a single notification
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    String? payload,
  }) async {
    // Ensure the scheduled date is in the future
    if (dateTime.isBefore(DateTime.now())) {
      print('Scheduled date must be in the future: $dateTime');
      return;
    }

    try {
      // Android-specific details
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'alliat_asig', // Channel ID
        'Alliat', // Channel Name
        channelDescription: 'This channel is for Alliat notifications',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
      );

      // iOS/macOS-specific details
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      // Notification details
      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
        macOS: iosDetails,
      );

      // Convert DateTime to TZDateTime
      final tz.TZDateTime scheduledDate = tz.TZDateTime.from(dateTime, tz.local);

      // Schedule the notification
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );

      print('✅ Notification scheduled: ID=$id at $scheduledDate');
    } catch (e) {
      print('❌ Error scheduling notification: $e');
    }
  }

  /// Schedule notifications from collapsed format (with flags)
  static Future<void> scheduleNotificationsFromCollapsed({
    required String documentType,
    required String documentInfo,
    required DateTime expirationDate,
    required List<NotificationModel> notifications,
  }) async {
    for (var notification in notifications) {
      // Only schedule if push is enabled
      if (!notification.push) continue;

      // Schedule for month before if flag is set
      if (notification.monthBefore ?? false) {
        final monthBeforeDate = DateTime(
          expirationDate.year,
          expirationDate.month - 1,
          expirationDate.day,
          9, // Schedule at 9 AM
          0,
        );
        
        if (monthBeforeDate.isAfter(DateTime.now())) {
          await scheduleNotification(
            id: await generateUniqueNotificationId(),
            title: '$documentType expiră în 1 lună',
            body: '$documentInfo - $documentType expiră pe ${_formatDate(expirationDate)}',
            dateTime: monthBeforeDate,
            payload: 'month_before|$documentType|$documentInfo',
          );
        }
      }

      // Schedule for week before if flag is set
      if (notification.weekBefore ?? false) {
        final weekBeforeDate = expirationDate.subtract(const Duration(days: 7));
        final scheduledTime = DateTime(
          weekBeforeDate.year,
          weekBeforeDate.month,
          weekBeforeDate.day,
          9, // Schedule at 9 AM
          0,
        );
        
        if (scheduledTime.isAfter(DateTime.now())) {
          await scheduleNotification(
            id: await generateUniqueNotificationId(),
            title: '$documentType expiră în 1 săptămână',
            body: '$documentInfo - $documentType expiră pe ${_formatDate(expirationDate)}',
            dateTime: scheduledTime,
            payload: 'week_before|$documentType|$documentInfo',
          );
        }
      }

      // Schedule for day before if flag is set
      if (notification.dayBefore ?? false) {
        final dayBeforeDate = expirationDate.subtract(const Duration(days: 1));
        final scheduledTime = DateTime(
          dayBeforeDate.year,
          dayBeforeDate.month,
          dayBeforeDate.day,
          9, // Schedule at 9 AM
          0,
        );
        
        if (scheduledTime.isAfter(DateTime.now())) {
          await scheduleNotification(
            id: await generateUniqueNotificationId(),
            title: '$documentType expiră mâine!',
            body: '$documentInfo - $documentType expiră pe ${_formatDate(expirationDate)}',
            dateTime: scheduledTime,
            payload: 'day_before|$documentType|$documentInfo',
          );
        }
      }
    }
  }

  /// Schedule notifications from a map
  static Future<void> scheduleNotifications(
    Map<String, List<NotificationModel>> notifications,
  ) async {
    for (var entry in notifications.entries) {
      final key = entry.key;
      final notificationList = entry.value;

      for (var notification in notificationList) {
        if (notification.push && notification.date.isAfter(DateTime.now())) {
          await scheduleNotification(
            id: notification.notificationId,
            title: 'Notificare - $key',
            body: 'În data de ${_formatDate(notification.date)} expiră documentul: $key.',
            dateTime: notification.date,
            payload: 'document|$key',
          );
        }
      }
    }
  }

  /// Generate a unique notification ID
  static Future<int> generateUniqueNotificationId() async {
    final List<PendingNotificationRequest> pendingNotifications =
        await _notificationsPlugin.pendingNotificationRequests();

    int id = _generateRandomInt(1000, 999999);
    
    final existingIds = pendingNotifications.map((n) => n.id).toSet();
    
    while (existingIds.contains(id)) {
      id = _generateRandomInt(1000, 999999);
    }

    return id;
  }

  /// Update an existing notification (essentially reschedule it)
  static Future<void> updateNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    String? payload,
  }) async {
    // Cancel the old notification
    await cancelNotification(id);
    
    // Schedule the new one
    await scheduleNotification(
      id: id,
      title: title,
      body: body,
      dateTime: dateTime,
      payload: payload,
    );
  }

  /// Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
    print('🗑️ Notification cancelled: ID=$id');
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
    print('🗑️ All notifications cancelled');
  }

  /// Cancel notifications for a collapsed model
  static Future<void> cancelNotificationsForCollapsed(
    List<NotificationModel> notifications,
  ) async {
    for (var notification in notifications) {
      await cancelNotification(notification.notificationId);
    }
  }

  /// Get all pending notifications
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  /// Get all active notifications (Android 6.0+, iOS 10.0+)
  static Future<List<ActiveNotification>?> getActiveNotifications() async {
    return await _notificationsPlugin.getActiveNotifications();
  }

  /// Show an immediate notification (not scheduled)
  static Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'alliat_asig',
      'Alliat',
      channelDescription: 'This channel is for Alliat notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Helper methods
  static int _generateRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min + 1);
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  /// Clear all notifications (alias for cancelAllNotifications)
  static Future<void> clearAllNotifications() async {
    await cancelAllNotifications();
  }
}