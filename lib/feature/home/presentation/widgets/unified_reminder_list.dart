import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/core/models/vehicle_reminder.dart';
import 'package:auto_asig/core/widgets/vehicle_notification_cards.dart';
import 'package:auto_asig/feature/home/presentation/cubit/unified_cubit.dart';
import 'package:auto_asig/feature/home/presentation/cubit/unified_state.dart';
import 'package:auto_asig/feature/home/presentation/widgets/no_elements.dart';
import 'package:auto_asig/feature/home/presentation/widgets/no_vehicles.dart';
import 'package:auto_asig/feature/home/presentation/widgets/notif_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class UnifiedReminderList extends StatelessWidget {
  const UnifiedReminderList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnifiedCubit, UnifiedState>(
      builder: (context, state) {
        final reminders = state.reminders;
        final List<VehicleReminder>? vehicleReminders = state.vehicleReminders;

        if ((reminders == null || reminders.isEmpty) &&
            (vehicleReminders == null || vehicleReminders.isEmpty)) {
          return const NoElements();
        }

        // sort all reminders by expiration date, descending
        reminders?.sort((a, b) => a.expirationDate.compareTo(b.expirationDate));

        final DateFormat dateFormatter = DateFormat('dd.MM.yyyy');
        final DateFormat timeFormatter = DateFormat('HH:mm');

        return ListView(
          children: [
            // Documente Section
            ExpansionTile(
              title: const Text(
                'Documente',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              initiallyExpanded: state.showDocuments,
              onExpansionChanged: (_) =>
                  context.read<UnifiedCubit>().toggleDocuments(),
              shape: const Border(),
              children: reminders == null || reminders.isEmpty
                  ? [
                      const NoElements(
                        topPadding: 10,
                      )
                    ]
                  : reminders.asMap().entries.map((entry) {
                      final index = entry.key;
                      final reminder = entry.value;

                      final remainingTime = reminder.expirationDate
                          .difference(DateTime.now())
                          .inDays;
                      final bool isExpired = remainingTime < 0;
                      final int days = remainingTime.abs();

                      final notifItem = NotifItem(
                        reminder: reminder,
                        isExpired: isExpired,
                        days: days,
                        dateFormatter: dateFormatter,
                        timeFormatter: timeFormatter,
                        remainingTime: remainingTime,
                      );

                      // Add padding for the last item
                      if (index == reminders.length - 1) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: notifItem,
                        );
                      }

                      return notifItem;
                    }).toList(),
            ),

            // TODO - To implement the vehicle reminders section
            // Vehicule Section
            ExpansionTile(
              title: const Text(
                'Vehicule',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              initiallyExpanded: state.showVehicles,
              onExpansionChanged: (_) =>
                  context.read<UnifiedCubit>().toggleVehicles(),
              shape: const Border(),
              children: vehicleReminders == null || vehicleReminders.isEmpty
                  ? [
                      const NoVehicles(
                        topPadding: 10,
                      )
                    ]
                  : vehicleReminders.expand<Widget>((vehicleReminder) {
                      // Combine all notifications into one list with their types
                      final List<Map<String, dynamic>> notificationsWithType = [
                        {
                          'type': 'ITP',
                          'notifications': vehicleReminder.notificationsITP,
                          'expirationDate': vehicleReminder.expirationDateITP,
                        },
                        {
                          'type': 'RCA',
                          'notifications': vehicleReminder.notificationsRCA,
                          'expirationDate': vehicleReminder.expirationDateRCA,
                        },
                        {
                          'type': 'CASCO',
                          'notifications': vehicleReminder.notificationsCASCO,
                          'expirationDate': vehicleReminder.expirationDateCASCO,
                        },
                        {
                          'type': 'Rovinieta',
                          'notifications':
                              vehicleReminder.notificationsRovinieta,
                          'expirationDate':
                              vehicleReminder.expirationDateRovinieta,
                        },
                        {
                          'type': 'Tahograf',
                          'notifications':
                              vehicleReminder.notificationsTahograf,
                          'expirationDate':
                              vehicleReminder.expirationDateTahograf,
                        },
                      ];

                      // Generate a list of VehicleReminderCards for each type
                      return notificationsWithType.expand<Widget>((entry) {
                        final type = entry['type'];
                        final notifications =
                            entry['notifications'] as List<NotificationModel>;
                        final expirationDate =
                            entry['expirationDate'] as DateTime?;

                        return notifications.map<Widget>((notification) {
                          final remainingTime = expirationDate != null
                              ? expirationDate.difference(DateTime.now()).inDays
                              : 0;

                          return VehicleReminderCards(
                            reminderId: '${vehicleReminder.id}-$type',
                            title: type,
                            subtitle:
                                '${vehicleReminder.registrationNumber} - ${vehicleReminder.carModel}',
                            progressValue: remainingTime.abs(),
                            actionText: 'Detalii',
                            notifications: [notification],
                            isExpired: expirationDate != null
                                ? expirationDate.isBefore(DateTime.now())
                                : false,
                          );
                        }).toList();
                      }).toList();
                    }).toList()
                // Sort widgets by expiration date
                ..sort((a, b) {
                  final aExpirationDate =
                      (a as VehicleReminderCards).notifications[0].date;
                  final bExpirationDate =
                      (b as VehicleReminderCards).notifications[0].date;

                  if (aExpirationDate == null && bExpirationDate == null) {
                    return 0;
                  }

                  return aExpirationDate.compareTo(bExpirationDate);
                }),
            ),
            const SizedBox(height: 40),
          ],
        );
      },
    );
  }
}
