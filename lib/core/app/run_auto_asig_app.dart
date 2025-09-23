import 'dart:async';
import 'package:auto_asig/core/app/app_data.dart';
import 'package:auto_asig/core/app/auto-asig.dart';
import 'package:auto_asig/core/dependency_injection/dependencies_provider.dart';
import 'package:auto_asig/core/helpers/notification_helper.dart';
import 'package:auto_asig/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> runAutoAsigApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  _lockOrientation();
  _setSystemOverlayStyle();

  // Check if Firebase is already initialized
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        name: 'alliatAsig', // Set your custom app name here
        options: DefaultFirebaseOptions.currentPlatform,
      );
      //
      // const kDebugMode = true;
      //
      // // if (kDebugMode) {
      //   try {
      //     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      //     await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      //   } catch (e) {
      //     // ignore: avoid_print
      //     print(e);
      //   }
      // // }
      print('Firebase initialized successfully with custom name.');
    } else {
      print('Firebase is already initialized.');
    }
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
      print('Firebase app already exists.');
    } else {
      print('Error initializing Firebase: $e');
    }
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  // Initialize notifications
  await NotificationHelper.initialize();

  const fatalError = true;
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    }
    // else {
    //   FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    // }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
    //  else {
    //   FirebaseCrashlytics.instance.recordError(error, stack);
    // }
    return true;
  };

  db = FirebaseFirestore.instance;

  userCollection = FirebaseFirestore.instance.collection('users');
  // userDataCollection = FirebaseFirestore.instance.collection('user_data');
  appDataCollection = FirebaseFirestore.instance.collection('app_data');

  // vehicleDocument = userDataCollection!.doc('vehicles');
  // driversLicenseDocument = userDataCollection!.doc('drv_license');
  // passportDocument = userDataCollection!.doc('passports');
  // idCardDocument = userDataCollection!.doc('id_cards');
  // otherDocument = userDataCollection!.doc('other_docs');

  // driversLicenseCollection =
  //     FirebaseFirestore.instance.collection('drv_license');
  // passportCollection = FirebaseFirestore.instance.collection('passports');
  // idCardCollection = FirebaseFirestore.instance.collection('id_cards');
  // vehicleCollection = FirebaseFirestore.instance.collection('vehicles');
  secureStorage = const FlutterSecureStorage();

  // messaging = FirebaseMessaging.instance;

  // await initNotification();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://94199d009d562d6ba64c8c136991fbc8@o4505488006512640.ingest.us.sentry.io/4508052539179008';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      const DependenciesProvider(
        child: AutoAsig(),
      ),
    ),
  );
}

void _lockOrientation() {
  SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[DeviceOrientation.portraitUp],
  );
}

void _setSystemOverlayStyle() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}

// // Initialize the FlutterLocalNotificationsPlugin
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

  // Future<void> initNotification() async {
//   // Initialize local notifications
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/launcher_icon');

//   const InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//   );

//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//   // if (Platform.isIOS) {
//   //   // Request permission for iOS devices
//     await FirebaseMessaging.instance.requestPermission();
//   // }

//   // // Get the FCM token (works for both iOS and Android)
//     final fCMToken = FirebaseMessaging.instance.getToken();

    // print('FCM Token: $fCMToken');

//   // // Subscribe the device to the 'messages' topic
//   // await FirebaseMessaging.instance.subscribeToTopic('messages').then((_) {
//   //   print('Subscribed to topic: messages');
//   // });

//   // // Handle foreground messages
//   // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   //   // Extract the senderId from the data payload
//   //   String senderId = message.data['senderId'] ?? '';
//   //   // Check if the message sender is not the current user
//   //   if (currentUserId.isNotEmpty && senderId != currentUserId) {
//   //     // Only show the notification if the message sender is not the current user
//   //     _showNotification(
//   //       message.notification!.title,
//   //       message.notification!.body,
//   //     );
//   //   } else {
//   //     print('Message from self, no notification displayed.');
//   //   }
//   // });

//   initPushNotifications();
// }

// Future<void> initPushNotifications() async {
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );

//   FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
// }

// Function to display local notifications when the app is in the foreground
// Future<void> _showNotification(String? title, String? body) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'high_importance_channel', // ID of the notification channel
//     'High Importance Notifications', // Name of the notification channel
//     importance: Importance.max,
//     priority: Priority.high,
//   );

//   const NotificationDetails platformChannelSpecifics = NotificationDetails(
//     android: androidPlatformChannelSpecifics,
//   );

//   await flutterLocalNotificationsPlugin.show(
//     0, // Notification ID
//     title, // Notification Title
//     body, // Notification Body
//     platformChannelSpecifics,
//   );
// }

// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   print('Title: ${message.notification!.title}');
//   print('Body: ${message.notification!.body}');
//   print('Payload: ${message.data}');
// }
