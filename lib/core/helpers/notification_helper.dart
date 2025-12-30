import 'dart:math';
import 'dart:io' show Platform;

import 'package:auto_asig/core/data/email_data.dart';
import 'package:auto_asig/core/models/notification_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // EmailJS Configuration - Add your credentials
  static const String _emailServiceId = EmailData.serviceId;
  static const String _emailTemplateId = EmailData.notifTemplateId;
  static const String _emailPublicKey = EmailData.publicKey;

  /// Initialize notifications with proper permissions and settings
  static Future<void> initialize() async {
    await _configureLocalTimeZone();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
    );

    await _requestPermissions();
  }

  static Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final TimezoneInfo timeZoneInfo = await FlutterTimezone.getLocalTimezone();
    final String timeZoneName = timeZoneInfo.identifier;

    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  static void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ID=${response.id}, Payload=${response.payload}');
  }

  @pragma('vm:entry-point')
  static void _notificationTapBackground(NotificationResponse response) {
    print('Background notification tapped: ID=${response.id}');
  }

  static Future<bool> _requestPermissions() async {
    bool granted = true;

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
      granted = grantedNotificationPermission ?? false;

      if (granted) {
        granted = granted && await _requestExactAlarmPermission();
      }
    }

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

  static Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final bool? enabled = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();
      return enabled ?? false;
    }
    return true;
  }

  /// Schedule a single notification
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    String? payload,
  }) async {
    if (dateTime.isBefore(DateTime.now())) {
      print('Scheduled date must be in the future: $dateTime');
      return;
    }

    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'alliat_asig',
        'Alliat',
        channelDescription: 'This channel is for Alliat notifications',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
        macOS: iosDetails,
      );

      final tz.TZDateTime scheduledDate = tz.TZDateTime.from(dateTime, tz.local);

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

  /// Send email notification via EmailJS
  static Future<void> sendEmailNotification({
    required String userEmail,
    required String userName,
    required String documentType,
    required String documentInfo,
    required DateTime expirationDate,
    required String timePeriod,
  }) async {
    try {
      print('📧 Sending email notification to $userEmail...');
      
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      
      final data = {
        'service_id': _emailServiceId,
        'template_id': _emailTemplateId,
        'user_id': _emailPublicKey,
        'template_params': {
          'to_email': userEmail,
          'to_name': userName,
          'document_type': documentType,
          'document_info': documentInfo,
          'expiration_date': _formatDate(expirationDate),
          'time_period': timePeriod,
          'send_date': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
        }
      };

      print('Email request data: ${json.encode(data)}');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        print('✅ Email sent successfully via EmailJS');
      } else {
        print('❌ EmailJS error: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print('❌ EmailJS exception: $error');
    }
  }

  /// Schedule notifications from collapsed format (with flags)
  static Future<void> scheduleNotificationsFromCollapsed({
    required String documentType,
    required String documentInfo,
    required DateTime expirationDate,
    required List<NotificationModel> notifications,
    String? userEmail,
    String? userName,
  }) async {
    for (var notification in notifications) {
      // Only schedule if push or email is enabled
      if (!notification.push && !notification.email) continue;

      // Schedule for month before if flag is set
      if (notification.monthBefore ?? false) {
        final monthBeforeDate = DateTime(
          expirationDate.year,
          expirationDate.month - 1,
          expirationDate.day,
          9,
          0,
        );
        
        if (monthBeforeDate.isAfter(DateTime.now())) {
          // Push notification
          if (notification.push) {
            await scheduleNotification(
              id: await generateUniqueNotificationId(),
              title: '$documentType expiră în 1 lună',
              body: '$documentInfo - $documentType expiră pe ${_formatDate(expirationDate)}',
              dateTime: monthBeforeDate,
              payload: 'month_before|$documentType|$documentInfo',
            );
          }
          
          // Email notification
          if (notification.email && userEmail != null) {
            await sendEmailNotification(
              userEmail: userEmail,
              userName: userName ?? 'Utilizator',
              documentType: documentType,
              documentInfo: documentInfo,
              expirationDate: expirationDate,
              timePeriod: '1 lună',
            );
          }
        }
      }

      // Schedule for week before if flag is set
      if (notification.weekBefore ?? false) {
        final weekBeforeDate = expirationDate.subtract(const Duration(days: 7));
        final scheduledTime = DateTime(
          weekBeforeDate.year,
          weekBeforeDate.month,
          weekBeforeDate.day,
          9,
          0,
        );
        
        if (scheduledTime.isAfter(DateTime.now())) {
          // Push notification
          if (notification.push) {
            await scheduleNotification(
              id: await generateUniqueNotificationId(),
              title: '$documentType expiră în 1 săptămână',
              body: '$documentInfo - $documentType expiră pe ${_formatDate(expirationDate)}',
              dateTime: scheduledTime,
              payload: 'week_before|$documentType|$documentInfo',
            );
          }
          
          // Email notification (send immediately for testing, or schedule for later)
          if (notification.email && userEmail != null) {
            // For immediate testing:
            await sendEmailNotification(
              userEmail: userEmail,
              userName: userName ?? 'Utilizator',
              documentType: documentType,
              documentInfo: documentInfo,
              expirationDate: expirationDate,
              timePeriod: '1 săptămână',
            );
          }
        }
      }

      // Schedule for day before if flag is set
      if (notification.dayBefore ?? false) {
        final dayBeforeDate = expirationDate.subtract(const Duration(days: 1));
        final scheduledTime = DateTime(
          dayBeforeDate.year,
          dayBeforeDate.month,
          dayBeforeDate.day,
          9,
          0,
        );
        
        if (scheduledTime.isAfter(DateTime.now())) {
          // Push notification
          if (notification.push) {
            await scheduleNotification(
              id: await generateUniqueNotificationId(),
              title: '$documentType expiră mâine!',
              body: '$documentInfo - $documentType expiră pe ${_formatDate(expirationDate)}',
              dateTime: scheduledTime,
              payload: 'day_before|$documentType|$documentInfo',
            );
          }
          
          // Email notification
          if (notification.email && userEmail != null) {
            await sendEmailNotification(
              userEmail: userEmail,
              userName: userName ?? 'Utilizator',
              documentType: documentType,
              documentInfo: documentInfo,
              expirationDate: expirationDate,
              timePeriod: '1 zi',
            );
          }
        }
      }
    }
  }

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

  static Future<void> updateNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    String? payload,
  }) async {
    await cancelNotification(id);
    await scheduleNotification(
      id: id,
      title: title,
      body: body,
      dateTime: dateTime,
      payload: payload,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
    print('🗑️ Notification cancelled: ID=$id');
  }

  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
    print('🗑️ All notifications cancelled');
  }

  static Future<void> cancelNotificationsForCollapsed(
    List<NotificationModel> notifications,
  ) async {
    for (var notification in notifications) {
      await cancelNotification(notification.notificationId);
    }
  }

  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  static Future<List<ActiveNotification>?> getActiveNotifications() async {
    return await _notificationsPlugin.getActiveNotifications();
  }

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

  static int _generateRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min + 1);
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  static Future<void> clearAllNotifications() async {
    await cancelAllNotifications();
  }
}