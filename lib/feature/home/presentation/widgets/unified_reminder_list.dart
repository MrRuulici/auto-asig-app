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

        // Count documents and vehicles
        final int documentCount = reminders?.length ?? 0;
        final int vehicleCount = vehicleReminders?.length ?? 0;

        return ListView(
          children: [
            // Documente Section
            ExpansionTile(
              title: Text(
                'Documente ($documentCount)',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

            // Vehicule Section
            ExpansionTile(
              title: Text(
                'Vehicule ($vehicleCount)',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      // Build the cards for this vehicle
                      final List<Widget> vehicleCards = [];
                      
                      if (vehicleReminder.expirationDateITP != null) {
                        final remainingTime = vehicleReminder.expirationDateITP!
                            .difference(DateTime.now())
                            .inDays;
                        vehicleCards.add(
                          VehicleReminderCards(
                            reminderId: '${vehicleReminder.id}-ITP',
                            title: 'ITP',
                            subtitle:
                                '${vehicleReminder.registrationNumber} - ${vehicleReminder.carModel}',
                            progressValue: remainingTime.abs(),
                            actionText: 'Detalii',
                            notifications: vehicleReminder.notificationsITP,
                            isExpired: vehicleReminder.expirationDateITP!
                                .isBefore(DateTime.now()),
                          ),
                        );
                      }

                      if (vehicleReminder.expirationDateRCA != null) {
                        final remainingTime = vehicleReminder.expirationDateRCA!
                            .difference(DateTime.now())
                            .inDays;
                        vehicleCards.add(
                          VehicleReminderCards(
                            reminderId: '${vehicleReminder.id}-RCA',
                            title: 'RCA',
                            subtitle:
                                '${vehicleReminder.registrationNumber} - ${vehicleReminder.carModel}',
                            progressValue: remainingTime.abs(),
                            actionText: 'Detalii',
                            notifications: vehicleReminder.notificationsRCA,
                            isExpired: vehicleReminder.expirationDateRCA!
                                .isBefore(DateTime.now()),
                          ),
                        );
                      }

                      if (vehicleReminder.expirationDateCASCO != null) {
                        final remainingTime = vehicleReminder.expirationDateCASCO!
                            .difference(DateTime.now())
                            .inDays;
                        vehicleCards.add(
                          VehicleReminderCards(
                            reminderId: '${vehicleReminder.id}-CASCO',
                            title: 'CASCO',
                            subtitle:
                                '${vehicleReminder.registrationNumber} - ${vehicleReminder.carModel}',
                            progressValue: remainingTime.abs(),
                            actionText: 'Detalii',
                            notifications: vehicleReminder.notificationsCASCO,
                            isExpired: vehicleReminder.expirationDateCASCO!
                                .isBefore(DateTime.now()),
                          ),
                        );
                      }

                      if (vehicleReminder.expirationDateRovinieta != null) {
                        final remainingTime = vehicleReminder.expirationDateRovinieta!
                            .difference(DateTime.now())
                            .inDays;
                        vehicleCards.add(
                          VehicleReminderCards(
                            reminderId: '${vehicleReminder.id}-Rovinieta',
                            title: 'Rovinieta',
                            subtitle:
                                '${vehicleReminder.registrationNumber} - ${vehicleReminder.carModel}',
                            progressValue: remainingTime.abs(),
                            actionText: 'Detalii',
                            notifications: vehicleReminder.notificationsRovinieta,
                            isExpired: vehicleReminder.expirationDateRovinieta!
                                .isBefore(DateTime.now()),
                          ),
                        );
                      }

                      if (vehicleReminder.expirationDateTahograf != null) {
                        final remainingTime = vehicleReminder.expirationDateTahograf!
                            .difference(DateTime.now())
                            .inDays;
                        vehicleCards.add(
                          VehicleReminderCards(
                            reminderId: '${vehicleReminder.id}-Tahograf',
                            title: 'Tahograf',
                            subtitle:
                                '${vehicleReminder.registrationNumber} - ${vehicleReminder.carModel}',
                            progressValue: remainingTime.abs(),
                            actionText: 'Detalii',
                            notifications: vehicleReminder.notificationsTahograf,
                            isExpired: vehicleReminder.expirationDateTahograf!
                                .isBefore(DateTime.now()),
                          ),
                        );
                      }

                      // Wrap all cards for this vehicle in a Column with a header
                      return [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.directions_car,
                                color: Colors.blue,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${vehicleReminder.registrationNumber.toUpperCase()} - ${vehicleReminder.carModel.toUpperCase()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...vehicleCards,
                        const SizedBox(height: 8),
                      ];
                    }).toList(),
            ),
            const SizedBox(height: 40),
          ],
        );
      },
    );
  }
}