import 'package:auto_asig/core/data/assistants.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/core/widgets/date_picker_field.dart';
import 'package:auto_asig/core/widgets/notification_item.dart';
import 'package:auto_asig/core/widgets/progress_colored_bar.dart';
import 'package:auto_asig/feature/vehicles/presentation/cubit/car_info_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpirationSection extends StatelessWidget {
  final String label;
  final VehicleNotificationType type;
  final DateTime? selectedDate;
  final void Function(DateTime) updateDate;
  final void Function() clearDate;
  final List<NotificationModel> notifications;
  final void Function(int index, bool monthBefore, bool weekBefore, bool dayBefore, bool email, bool push) updateNotificationPeriods;
  final void Function(int) removeNotification;

  const ExpirationSection({
    super.key,
    required this.label,
    required this.type,
    required this.selectedDate,
    required this.updateDate,
    required this.clearDate,
    required this.notifications,
    required this.updateNotificationPeriods,
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
                  onPressed: clearDate,
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

        // Show info message when no notifications exist
        if (notifications.isEmpty && selectedDate != null)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Notificare configurată implicit pentru o zi înainte',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Notifications list
        if (notifications.isNotEmpty)
          for (int i = 0; i < notifications.length; i++)
            NotificationItem(
              index: i,
              expirationDate: selectedDate ?? DateTime.now(),
              monthBefore: notifications[i].monthBefore ?? false,
              weekBefore: notifications[i].weekBefore ?? false,
              dayBefore: notifications[i].dayBefore ?? false,
              email: notifications[i].email,
              push: notifications[i].push,
              onNotificationUpdate: (monthBefore, weekBefore, dayBefore, email, push) {
                updateNotificationPeriods(
                  i,
                  monthBefore,
                  weekBefore,
                  dayBefore,
                  email,
                  push,
                );
              },
              onNotificationRemove: () => removeNotification(i),
            ),

        const SizedBox(height: 20),
      ],
    );
  }
}