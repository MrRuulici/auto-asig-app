import 'package:auto_asig/core/data/assistants.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/core/widgets/date_picker_field.dart';
import 'package:auto_asig/core/widgets/notification_item.dart';
import 'package:auto_asig/core/widgets/progress_colored_bar.dart';
import 'package:auto_asig/feature/cars_reg/cubit/car_info_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpirationSection extends StatelessWidget {
  final String label;
  final VehicleNotificationType type;
  final DateTime? selectedDate;
  final void Function(DateTime) updateDate;
  final void Function() clearDate;
  final List<NotificationModel> notifications;
  final void Function(DateTime, bool, bool, bool) addNotification;
  final void Function(int) removeNotification;

  const ExpirationSection({
    super.key,
    required this.label,
    required this.type,
    required this.selectedDate,
    required this.updateDate,
    required this.clearDate,
    required this.notifications,
    required this.addNotification,
    required this.removeNotification,
  });

  // Calculate remaining days
  int _getRemainingDays() {
    if (selectedDate == null) return 0;
    return selectedDate!.difference(DateTime.now()).inDays;
  }

  int _calculateProgress() {
    if (selectedDate == null) return 0;
    const daysTotal = 60; // Full progress for 60 days
    final daysRemaining = selectedDate!.difference(DateTime.now()).inDays;
    final progress =
        (daysRemaining > daysTotal ? daysTotal : daysRemaining) / daysTotal;
    return (progress * 100)
        .toInt(); // Scale to percentage (0-100) and convert to int
  }

  @override
  Widget build(BuildContext context) {
    final int remainingDays = _getRemainingDays();
    final int progressValue = _calculateProgress();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AlliatDatePickerField(
          label: label,
          selectedDate: selectedDate,
          onDateSelected: updateDate,
        ),
        const SizedBox(height: 8),
        if (selectedDate != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  remainingDays > 0
                      ? 'Timp rămas: $remainingDays zile'
                      : 'Expirat',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed:
                      clearDate, // Clear the selected date and notifications
                  child: const Text(
                    'Șterge',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          ProgressColoredBar(
            progressValue: progressValue,
            progressColor: getProgressColor(progressValue),
            isExpired: remainingDays <= 0,
          ),
          const SizedBox(height: 8),
        ],

        // Notifications list and add button
        for (int i = 0; i < notifications.length; i++)
          NotificationItem(
            index: i,
            selectedDate: notifications[i].date,
            sms: notifications[i].sms,
            email: notifications[i].email,
            push: notifications[i].push,
            onNotificationUpdate: (date, sms, email, push) {
              context.read<CarInfoCubit>().updateNotification(
                    type,
                    i,
                    date,
                    sms,
                    email,
                    push,
                    notifications[i].notificationId,
                  );
            },
            onNotificationRemove: () => removeNotification(i),
          ),
        if (selectedDate != null)
          // Row(
          //   children: [
          TextButton.icon(
            onPressed: () {
              if (selectedDate != null) {
                addNotification(
                  selectedDate!.subtract(const Duration(days: 1)),
                  false,
                  false,
                  true,
                );
              }
            },
            icon: const Icon(
              Icons.add,
              // color: Colors.indigoAccent,
              // color: logoBlue,
              color: Colors.indigoAccent,
            ),
            label: const Text(
              'Adaugă notificare',
              style: TextStyle(
                color: Colors.indigoAccent,
                // color: logoBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        // const Spacer(),
        // TextButton(
        //   onPressed:
        //       clearDate, // Clear the selected date and notifications
        //   child: const Text(
        //     'Șterge',
        //     style: TextStyle(color: Colors.red),
        //   ),
        // ),
        //   ],
        // ),
        const SizedBox(height: 20),
      ],
    );
  }
}
