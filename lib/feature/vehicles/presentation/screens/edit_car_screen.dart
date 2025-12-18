import 'package:auto_asig/core/app/router.dart';
import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/assistants.dart';
import 'package:auto_asig/core/helpers/refresh_home_screen.dart';
import 'package:auto_asig/feature/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/widgets/auto_asig_appbar.dart';
import 'package:auto_asig/core/widgets/auto_asig_button_full.dart';
import 'package:auto_asig/feature/vehicles/presentation/cubit/edit_vehicle_reminder_cubit.dart';
import 'package:auto_asig/feature/vehicles/presentation/widgets/expiration_section.dart';
import 'package:go_router/go_router.dart';

class EditCarScreen extends StatelessWidget {
  const EditCarScreen({super.key});

  static const String path = 'editCarScreen';
  static const String absolutePath = '${HomeScreen.path}/$path';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditVehicleReminderCubit>();
    final state = context.watch<EditVehicleReminderCubit>().state;

    final vehicleReminder = state.vehicleReminder;

    return Scaffold(
      appBar: AlliatAppBar(),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Editează Vehicul',
                    style: TextStyle(
                      fontSize: 25,
                      color: buttonBlue,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'Editează datele vehiculului și expirările aferente:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Număr de înmatriculare: ${vehicleReminder!.registrationNumber.toUpperCase()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Model Vehicul: ${vehicleReminder.carModel}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ITP Section
              ExpirationSection(
                label: "ITP",
                type: VehicleNotificationType.ITP,
                selectedDate: vehicleReminder.expirationDateITP,
                updateDate: (date) => cubit.updateExpirationDateITP(date),
                clearDate: () => cubit.updateExpirationDateITP(null),
                notifications: vehicleReminder.notificationsITP ?? [],
                updateNotificationPeriods:
                    (index, monthBefore, weekBefore, dayBefore, email, push) {
                  cubit.updateNotificationPeriods(
                    VehicleNotificationType.ITP,
                    index,
                    monthBefore,
                    weekBefore,
                    dayBefore,
                    email,
                    push,
                  );
                },
                removeNotification: (index) => cubit.removeNotification(
                  VehicleNotificationType.ITP,
                  index,
                ),
              ),

              const SizedBox(height: 20),

              // RCA Section
              ExpirationSection(
                label: "RCA",
                type: VehicleNotificationType.RCA,
                selectedDate: vehicleReminder.expirationDateRCA,
                updateDate: (date) => cubit.updateExpirationDateRCA(date),
                clearDate: () => cubit.updateExpirationDateRCA(null),
                notifications: vehicleReminder.notificationsRCA ?? [],
                updateNotificationPeriods:
                    (index, monthBefore, weekBefore, dayBefore, email, push) {
                  cubit.updateNotificationPeriods(
                    VehicleNotificationType.RCA,
                    index,
                    monthBefore,
                    weekBefore,
                    dayBefore,
                    email,
                    push,
                  );
                },
                removeNotification: (index) => cubit.removeNotification(
                  VehicleNotificationType.RCA,
                  index,
                ),
              ),

              const SizedBox(height: 20),

              // Rovinieta Section
              ExpirationSection(
                label: "Rovinieta",
                type: VehicleNotificationType.Rovinieta,
                selectedDate: vehicleReminder.expirationDateRovinieta,
                updateDate: (date) => cubit.updateExpirationDateRovinieta(date),
                clearDate: () => cubit.updateExpirationDateRovinieta(null),
                notifications: vehicleReminder.notificationsRovinieta ?? [],
                updateNotificationPeriods:
                    (index, monthBefore, weekBefore, dayBefore, email, push) {
                  cubit.updateNotificationPeriods(
                    VehicleNotificationType.Rovinieta,
                    index,
                    monthBefore,
                    weekBefore,
                    dayBefore,
                    email,
                    push,
                  );
                },
                removeNotification: (index) => cubit.removeNotification(
                  VehicleNotificationType.Rovinieta,
                  index,
                ),
              ),

              const SizedBox(height: 20),

              // CASCO Section
              ExpirationSection(
                label: "CASCO",
                type: VehicleNotificationType.CASCO,
                selectedDate: vehicleReminder.expirationDateCASCO,
                updateDate: (date) => cubit.updateExpirationDateCASCO(date),
                clearDate: () => cubit.updateExpirationDateCASCO(null),
                notifications: vehicleReminder.notificationsCASCO ?? [],
                updateNotificationPeriods:
                    (index, monthBefore, weekBefore, dayBefore, email, push) {
                  cubit.updateNotificationPeriods(
                    VehicleNotificationType.CASCO,
                    index,
                    monthBefore,
                    weekBefore,
                    dayBefore,
                    email,
                    push,
                  );
                },
                removeNotification: (index) => cubit.removeNotification(
                  VehicleNotificationType.CASCO,
                  index,
                ),
              ),

              const SizedBox(height: 20),

              // Tahograf Section
              ExpirationSection(
                label: "Tahograf",
                type: VehicleNotificationType.Tahograf,
                selectedDate: vehicleReminder.expirationDateTahograf,
                updateDate: (date) => cubit.updateExpirationDateTahograf(date),
                clearDate: () => cubit.updateExpirationDateTahograf(null),
                notifications: vehicleReminder.notificationsTahograf ?? [],
                updateNotificationPeriods:
                    (index, monthBefore, weekBefore, dayBefore, email, push) {
                  cubit.updateNotificationPeriods(
                    VehicleNotificationType.Tahograf,
                    index,
                    monthBefore,
                    weekBefore,
                    dayBefore,
                    email,
                    push,
                  );
                },
                removeNotification: (index) => cubit.removeNotification(
                  VehicleNotificationType.Tahograf,
                  index,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: AutoAsigButton(
          onPressed: () async {
            // Show loading dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );

            try {
              String userId = context.read<UserDataCubit>().state.member.id;

              await cubit.saveChanges(userId);

              // Close loading dialog
              Navigator.of(context).pop();

              showSuccessSnackbar(
                  context, 'Vehiculul a fost actualizat cu succes.');

              // Refresh home screen data
              await refreshHomeScreenData(context);

              // Navigate back to home
              context.go(HomeScreen.path);
            } catch (e) {
              print('Error saving vehicle changes: $e');
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Eroare la actualizarea vehiculului.'),
                ),
              );
            }
          },
          text: 'SALVEAZĂ MODIFICĂRILE',
        ),
      ),
    );
  }
}
