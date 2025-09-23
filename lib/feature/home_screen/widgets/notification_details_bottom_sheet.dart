import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/assistants.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/widgets/auto_asig_button_full.dart';
import 'package:auto_asig/core/widgets/progress_colored_bar.dart';
import 'package:auto_asig/feature/home_screen/cubit/bottom_sheet_details_cubit.dart';
import 'package:auto_asig/feature/home_screen/widgets/bottom_sheet_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_asig/core/models/notification_model.dart';
import 'package:intl/intl.dart';

class NotificationDetailsBottomSheet extends StatelessWidget {
  const NotificationDetailsBottomSheet({
    super.key,
    required this.title,
    required this.progressValue,
    required this.initialNotifications,
    required this.onEditCallback,
    required this.isExpired,
    required this.reminderId,
    required this.notificationType,
    this.onDeleteCallback,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final int progressValue;
  final bool isExpired;
  final List<NotificationModel> initialNotifications;
  final void Function(List<NotificationModel>) onEditCallback;
  final void Function()? onDeleteCallback;
  final String reminderId;
  final String notificationType;

  @override
  Widget build(BuildContext context) {
    // get the User id
    final userId = context.read<UserDataCubit>().state.member.id;

    final bool isZero = progressValue == 0;

    // Determine the color for the progress bar
    Color progressColor =
        !isExpired ? getProgressColor(progressValue) : Colors.red;

    // Calculate remaining years, months, and days
    final int absDays = progressValue.abs();
    final int years = absDays ~/ 365;
    final int months = (absDays % 365) ~/ 30;
    final int remainingDays = absDays % 30;

    // Build the time remaining text dynamically, showing only non-zero values
    List<String> timeComponents = [];
    if (years > 0) timeComponents.add('$years ani');
    if (months > 0) timeComponents.add('$months luni');
    if (remainingDays > 0) timeComponents.add('$remainingDays zile');

    // Join the components with a space and separator
    final String timeRemainingText = timeComponents.join(' ');

    DateTime expirationDate = isExpired
        ? DateTime.now().subtract(Duration(days: progressValue))
        : DateTime.now().add(Duration(days: progressValue + 1));

    String formattedDate = DateFormat('dd.MM.yyyy').format(expirationDate);

    // Build the combined expiration text based on whether the reminder is expired
    final String expirationText = isZero
        ? 'Documentul expiră astăzi'
        : isExpired
            ? 'Expirat de: $formattedDate | $timeRemainingText'
            : 'Expiră în: $formattedDate | $timeRemainingText';

    return BlocProvider(
      create: (_) => BottomSheetDetailsCubit(
        initialNotifications,
        userId: userId,
        reminderId: reminderId,
        notificationType: notificationType,
      ),
      child: BlocConsumer<BottomSheetDetailsCubit, BottomSheetDetailsState>(
        listener: (context, state) {
          // Listen for errorMessage and show a SnackBar if it exists
          if (state.errorMessage != null) {
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );

            // Clear the error message in the cubit after showing the SnackBar
            context.read<BottomSheetDetailsCubit>().clearErrorMessage();
          }
        },
        builder: (context, state) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                subtitle != null
                    ? Text(
                        subtitle!,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      )
                    : const Divider(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    expirationText,
                    style: TextStyle(
                      fontSize: 16,
                      color: progressColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ProgressColoredBar(
                  progressValue: progressValue,
                  progressColor: progressColor,
                  isExpired: isExpired,
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildNotificationList(context, state.notifications),
                        const SizedBox(height: 16),
                        AutoAsigButton(
                          text: 'Editează Detalii',
                          onPressed: () {
                            onEditCallback(state.notifications);
                            Navigator.pop(context);
                          },
                        ),
                        if (onDeleteCallback != null)
                          AutoAsigButton(
                            activeBackgroundColor: primaryRed,
                            text: 'Șterge Document',
                            onPressed: () {
                              onDeleteCallback!();
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Notification list builder
  Widget _buildNotificationList(
      BuildContext context, List<NotificationModel> notifications) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return BottomSheetNotification(
          index: index,
          notification: notification,
          nrOfNotifications: notifications.length,
        );
      },
    );
  }
}
