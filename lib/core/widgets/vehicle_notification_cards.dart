import 'package:auto_asig/core/data/assistants.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/core/models/vehicle_reminder.dart';
import 'package:auto_asig/core/widgets/progress_colored_bar.dart';
import 'package:auto_asig/feature/vehicles/presentation/cubit/edit_vehicle_reminder_cubit.dart';
import 'package:auto_asig/feature/vehicles/presentation/screens/edit_car_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class VehicleReminderCards extends StatelessWidget {
  final String title;
  final String? subtitle;

  final String actionText;
  final int progressValue;
  final bool isExpired;
  final List<NotificationModel> notifications;
  final String reminderId;
  final EdgeInsets? padding;
  final VehicleReminder vehicleReminder;

  const VehicleReminderCards({
    super.key,
    required this.title,
    required this.actionText,
    required this.progressValue,
    required this.notifications,
    required this.isExpired,
    required this.reminderId,
    required this.vehicleReminder,
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
    final DateFormat dateFormatter = DateFormat('dd.MM.yyyy');
    late String expirationDate = '';

    if (isExpired) {
      // progressValue is negative for expired items
      expirationDate = dateFormatter
          .format(DateTime.now().add(Duration(days: progressValue)));
    } else if (isZero) {
      expirationDate = dateFormatter.format(DateTime.now());
    } else {
      // progressValue is positive for future items
      expirationDate = dateFormatter
          .format(DateTime.now().add(Duration(days: progressValue)));
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
                                // Initialize the cubit with the vehicle data
                                context
                                    .read<EditVehicleReminderCubit>()
                                    .initializeReminder(vehicleReminder);

                                // Navigate to edit screen
                                context.push(
                                  EditCarScreen.absolutePath,
                                  extra: vehicleReminder,
                                );
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
                    // Text('')
                    const SizedBox(height: 4),
                    subtitle != null
                        ? Text(
                            subtitle!.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: logoBlue,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(height: 4),
                    Text(
                      expirationText,
                      style: TextStyle(
                        fontSize: 14,
                        // color: progressColor,
                        color: isZero || isExpired ? Colors.red : logoBlue,
                        fontWeight:
                            isZero || isExpired ? FontWeight.bold : null,
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
