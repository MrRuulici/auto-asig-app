import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/assistants.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/core/models/vehicle_reminder.dart';
import 'package:auto_asig/core/widgets/auto_asig_button_full.dart';
import 'package:auto_asig/feature/vehicles/presentation/cubit/edit_vehicle_reminder_cubit.dart';
import 'package:auto_asig/feature/vehicles/presentation/screens/edit_car_screen.dart';
import 'package:auto_asig/feature/home/presentation/cubit/reminder_cubit.dart';
import 'package:auto_asig/feature/home/presentation/cubit/reminder_state.dart';
import 'package:auto_asig/feature/home/presentation/widgets/no_elements.dart';
import 'package:auto_asig/feature/home/presentation/widgets/vehicle_notif_item.dart';
import 'package:auto_asig/feature/vehicles/vehicle_journal/cubit/vehicle_journals_cubit.dart';
import 'package:auto_asig/feature/vehicles/vehicle_journal/screens/vehicle_journal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class VehicleReminderList extends StatelessWidget {
  const VehicleReminderList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderCubit, ReminderState>(
      builder: (context, state) {
        if (state is ReminderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReminderError) {
          return Center(child: Text(state.message));
        } else if (state is ReminderLoaded) {
          final vehicleReminders = state.vehicleReminders;

          if (vehicleReminders == null || vehicleReminders.isEmpty) {
            return const NoElements();
          }

          return ListView.builder(
            itemCount: vehicleReminders.length,
            itemBuilder: (context, index) {
              final vehicleReminder = vehicleReminders[index];
              final List<Widget> expirationItems = _buildExpirationItems(
                vehicleReminder,
                vehicleReminder.id,
              );
              final hasAlmostExpired = _hasAlmostExpiredItems(vehicleReminder);
              
              return ExpansionTile(
                title: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [logoBlue, logoBlue.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.car,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${vehicleReminder.registrationNumber.toUpperCase()} - ${vehicleReminder.carModel.toUpperCase()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      if (hasAlmostExpired)
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                children: [
                  Divider(
                    thickness: 1.5,
                    color: Colors.grey.shade300,
                    indent: 16,
                    endIndent: 16,
                  ),
                  ...expirationItems,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      children: [
                        AutoAsigButton(
                          textStyle: const TextStyle(
                            fontSize: 16,
                          ),
                          onPressed: () async {
                            final cubit = context.read<VehicleJournalsCubit>();
                            final userId =
                                context.read<UserDataCubit>().state.member.id;

                            // Show loading dialog
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                            try {
                              // Wait for the fetch to complete
                              await cubit.fetchAllJournalsForVehicle(
                                userId: userId,
                                vehicleId: vehicleReminder.id,
                                carModel: vehicleReminder.carModel,
                                carLicense: vehicleReminder.registrationNumber,
                              );

                              // Close loading dialog
                              if (context.mounted) {
                                Navigator.of(context).pop();

                                // Navigate to the journal screen
                                context.push(VehicleJournalScreen.absolutePath);
                              }
                            } catch (e) {
                              // Close loading dialog
                              if (context.mounted) {
                                Navigator.of(context).pop();

                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Eroare la încărcarea jurnalului: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          text: 'Vezi Jurnal',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: AutoAsigButton(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                ),
                                onPressed: () {
                                  context
                                      .read<EditVehicleReminderCubit>()
                                      .initializeReminder(vehicleReminder);

                                  // Code for editing the vehicle
                                  context.push(
                                    EditCarScreen.absolutePath,
                                    extra: vehicleReminder,
                                  );
                                },
                                text: 'Editează Vehicul',
                              ),
                            ),
                            Expanded(
                              child: AutoAsigButton(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                ),
                                activeBackgroundColor: Colors.red[600],
                                onPressed: () {
                                  final userId = context
                                      .read<UserDataCubit>()
                                      .state
                                      .member
                                      .id;
                                  _deleteVehicle(
                                      context, vehicleReminder, userId);
                                },
                                text: 'Șterge Vehicul',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          return const Center(child: Text('Eroare necunoscută.'));
        }
      },
    );
  }

  // Check if vehicle has any items expiring within 30 days or already expired
  bool _hasAlmostExpiredItems(VehicleReminder vehicleReminder) {
    const int warningDays = 30;
    final now = DateTime.now();

    bool isAlmostExpired(DateTime? expirationDate) {
      if (expirationDate == null) return false;
      final difference = expirationDate.difference(now).inDays;
      return difference <= warningDays;
    }

    return isAlmostExpired(vehicleReminder.expirationDateITP) ||
        isAlmostExpired(vehicleReminder.expirationDateRCA) ||
        isAlmostExpired(vehicleReminder.expirationDateCASCO) ||
        isAlmostExpired(vehicleReminder.expirationDateRovinieta) ||
        isAlmostExpired(vehicleReminder.expirationDateTahograf);
  }

  List<Widget> _buildExpirationItems(
      VehicleReminder vehicleReminder, String id) {
    List<Widget> items = [];

    void addItem(String title, DateTime expirationDate) {
      final remainingTime = expirationDate.difference(DateTime.now()).inDays;
      final days = remainingTime.abs();

      List<NotificationModel> notifications = [];

      if (title == 'ITP') {
        notifications = vehicleReminder.notificationsITP;
      } else if (title == 'RCA') {
        notifications = vehicleReminder.notificationsRCA;
      } else if (title == 'CASCO') {
        notifications = vehicleReminder.notificationsCASCO;
      } else if (title == 'Rovinieta') {
        notifications = vehicleReminder.notificationsRovinieta;
      } else if (title == 'Tahograf') {
        notifications = vehicleReminder.notificationsTahograf;
      }

      items.add(
        VehicleReminderItem(
          reminderId: id,
          title: title,
          progressValue: days,
          actionText: 'Detalii',
          notifications: notifications,
          isExpired: remainingTime < 0,
          vehicleReminder: vehicleReminder,
        ),
      );
    }

    if (vehicleReminder.expirationDateITP != null) {
      addItem('ITP', vehicleReminder.expirationDateITP!);
    }
    if (vehicleReminder.expirationDateRCA != null) {
      addItem('RCA', vehicleReminder.expirationDateRCA!);
    }
    if (vehicleReminder.expirationDateCASCO != null) {
      addItem('CASCO', vehicleReminder.expirationDateCASCO!);
    }
    if (vehicleReminder.expirationDateRovinieta != null) {
      addItem('Rovinieta', vehicleReminder.expirationDateRovinieta!);
    }
    if (vehicleReminder.expirationDateTahograf != null) {
      addItem('Tahograf', vehicleReminder.expirationDateTahograf!);
    }

    return items;
  }

  // Method to delete a vehicle reminder
  void _deleteVehicle(
    BuildContext context,
    VehicleReminder vehicleReminder,
    String userId,
  ) {
    // show a confirmation dialog
    showDeletionConfirmation(
      context,
      title: 'Ștergere Vehicul',
      content:
          'Ești sigur că dorești să ștergi vehiculul înregistrat? Această acțiune este ireversibilă.',
      onConfirm: () {
        context
            .read<ReminderCubit>()
            .deleteVehicleReminder(userId, vehicleReminder);
      },
    );
  }
}