import 'package:auto_asig/core/data/assistants.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/core/widgets/progress_colored_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VehicleReminderItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String actionText;
  final int progressValue;
  final bool isExpired;
  final List<NotificationModel> notifications;
  final String reminderId;
  final EdgeInsets? padding;

  const VehicleReminderItem({
    super.key,
    required this.title,
    required this.actionText,
    required this.progressValue,
    required this.notifications,
    required this.isExpired,
    required this.reminderId,
    this.subtitle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the progress bar color based on remaining time
    Color progressColor = getProgressColor(progressValue);
    final int absDays = progressValue.abs();

    final bool isZero = progressValue == 0;

    // Format expiration date (example: using DateFormat from intl package)
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
    late final String expirationDate;

    // DateTime expirationDate = isExpired
    //     ? DateTime.now().subtract(Duration(days: progressValue))
    //     : DateTime.now().add(Duration(days: progressValue + 1));

    if (isExpired) {
      expirationDate = dateFormatter.format(
        DateTime.now().subtract(Duration(days: absDays)),
      );
    } else {
      expirationDate = dateFormatter.format(
        DateTime.now().add(Duration(days: progressValue)),
      );
    }

    // Calculate remaining years, months, and days
    final int years = absDays ~/ 365;
    final int months = (absDays % 365) ~/ 30;
    final int remainingDays = absDays % 30;

    // Build the time remaining text dynamically, showing only non-zero values
    List<String> timeComponents = [];
    if (years > 0) timeComponents.add('$years ani');
    if (months > 0) timeComponents.add('$months luni');
    if (remainingDays > 0) timeComponents.add('$remainingDays zile');

    // Join the components with a separator
    final String timeRemainingText = timeComponents.join(' ');

    // Build the combined expiration text based on whether the reminder is expired
    final String expirationText = isZero
        ? 'Documentul expiră astăzi'
        : isExpired
            ? 'Expirat de: $expirationDate  |  $timeRemainingText'
            : 'Expiră în: $expirationDate  |  $timeRemainingText';

    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
      child: Card(
        // color: Colors.white,
        color: isExpired || isZero ? lightRedColor : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.40),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            // fontWeight: FontWeight.w500,
                            fontWeight: FontWeight.bold,
                            color: logoBlue,
                            fontSize: 17,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print('Reminder ID: $reminderId');
                            print('Notification Type: $title');

                            showDetailsBottomSheet(
                              context: context,
                              progressValue: progressValue,
                              title: title,
                              isExpired: isExpired,
                              initialNotifications: notifications,
                              reminderId: reminderId,
                              notificationType: title,
                              onEditCallback: (updatedNotifications) {
                                // Todo - Load the Edit Info Screen.
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                actionText,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: logoBlue,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle ?? expirationText,
                      style: TextStyle(
                        fontSize: 14,
                        // color: progressColor,
                        color: isZero || isExpired ? Colors.red : logoBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ProgressColoredBar(
                      progressValue: progressValue,
                      progressColor: progressColor,
                      isExpired: isExpired,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
