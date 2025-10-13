import 'dart:io';

import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/data/http_app_data.dart';
import 'package:auto_asig/core/data/http_data.dart';
import 'package:auto_asig/core/data/http_user_data.dart';
import 'package:auto_asig/core/helpers/notification_helper.dart';
import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/core/models/reminder.dart';
import 'package:auto_asig/feature/authentication/presentation/screens/login_screen.dart';
import 'package:auto_asig/feature/authentication/presentation/screens/onboarding_screen.dart';
import 'package:auto_asig/feature/home/presentation/screens/home_screen.dart';
import 'package:auto_asig/feature/intro/presentation/screens/maintenance_screen.dart';
import 'package:auto_asig/feature/intro/presentation/screens/no_internet_screen.dart';
import 'package:auto_asig/feature/intro/presentation/screens/old_version_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const path = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initializeSplashScreen();
  }

  Future<void> _initializeSplashScreen() async {
    // Step 1: Check Internet Access
    bool hasInternet = await hasInternetAccess();
    if (!hasInternet) {
      _navigateTo(NoInternetScreen.path);
      return;
    }

    // _navigateTo(NoInternetScreen.path);

    // Step 2: Fetch App Data (Check for Maintenance or Version Issues)
    Map<String, bool>? appData = await getAppData();

    bool isMaintenance = appData['isMaintenance'] ?? false;
    bool isUpToDate = appData['isUpToDate'] ?? false;

    if (isMaintenance) {
      _navigateTo(MaintenanceScreen.path);
      return;
    } else if (!isUpToDate) {
      _navigateTo(OldVersionScreen.path);
      return;
    }

    // Step 3: Check User Authentication and Load Members
    await Future.delayed(const Duration(milliseconds: 500));
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId = user.uid;

      print('Current User ID: $currentUserId');

      final userModel = await loadUserData(
        user,
        () => _navigateTo(LoginScreen.absolutePath),
      );

      if (userModel == null) {
        _navigateTo(OnboardingScreen.path);
        return;
      }

      context.read<UserDataCubit>().setMember(userModel);

      // Fetch reminders and navigate to HomeScreen with data
      final reminders = await getRemindersFromDB(userModel.id);
      final vehicleReminders = await getVehicleRemindersFromDB(userModel.id);

      Map<String, List<NotificationModel>> allNotifications = {};

      for (var reminder in reminders) {
        allNotifications[reminder.title] = reminder.notificationDates;
      }

      for (var reminder in vehicleReminders) {
        allNotifications[
                'CASCO - ${reminder.registrationNumber}(${reminder.carModel})'] =
            reminder.notificationsCASCO;
        allNotifications[
                'RCA - ${reminder.registrationNumber}(${reminder.carModel})'] =
            reminder.notificationsRCA;
        allNotifications[
                'ITP - ${reminder.registrationNumber}(${reminder.carModel})'] =
            reminder.notificationsITP;
        allNotifications[
                'Rovinieta - ${reminder.registrationNumber}(${reminder.carModel})'] =
            reminder.notificationsRovinieta;
        allNotifications[
                'Tahograf - ${reminder.registrationNumber}(${reminder.carModel})'] =
            reminder.notificationsTahograf;
      }

      // for (var reminder in reminders) {
      //   allNotifications.addAll(reminder.notificationDates);
      // }

      // for (var reminder in vehicleReminders) {
      //   allNotifications.addAll(reminder.notificationsCASCO);
      //   allNotifications.addAll(reminder.notificationsRCA);
      //   allNotifications.addAll(reminder.notificationsITP);
      //   allNotifications.addAll(reminder.notificationsRovinieta);
      //   allNotifications.addAll(reminder.notificationsTahograf);
      // }

      // clear all notifications for the app
      await NotificationHelper.cancelAllNotifications();
      // schedule notifications
      NotificationHelper.scheduleNotifications(allNotifications);

      _navigateTo(HomeScreen.path, reminders: reminders);
    } else {
      _navigateTo(OnboardingScreen.path);
    }
  }

  Future<bool> hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  // Update the `_navigateTo` method to accept arguments for flexibility
  void _navigateTo(String route, {List<Reminder>? reminders}) {
    if (_hasNavigated) return;
    _hasNavigated = true;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    context.go(route, extra: reminders);
    // });
  }

  @override
  Widget build(BuildContext context) {
    // if (screenHeight == null) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    // }

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add a logo here
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 40), // Adjusted padding for more space
              child: Image.asset(
                'assets/images/simple_logo.png',
                fit: BoxFit.contain,
                height: screenHeight! *
                    0.1, // Adjust the 0.2 factor as needed for logo size
              ),
            ),
            const Text(
              'alliat',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: logoBlue,
              ),
            ),
            const SizedBox(height: 25),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.blue),
                SizedBox(width: 16),
                Text(
                  'Se încarcă...',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
