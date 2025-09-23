import 'package:auto_asig/core/app/router.dart';
import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/feature/home_screen/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/widgets/auto_asig_appbar.dart';
import 'package:auto_asig/core/widgets/auto_asig_button_full.dart';
import 'package:auto_asig/feature/cars_reg/cubit/edit_vehicle_reminder_cubit.dart';
import 'package:auto_asig/feature/cars_reg/widgets/expiration_section.dart';
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
              ExpirationSection(
                label: "ITP",
                type: VehicleNotificationType.ITP,
                selectedDate: vehicleReminder?.expirationDateITP,
                updateDate: (date) => cubit.updateExpirationDateITP(date),
                clearDate: () => cubit.updateExpirationDateITP(null),
                notifications: vehicleReminder?.notificationsITP ?? [],
                addNotification: (date, sms, email, push) async {
                  int notificationId =
                      await cubit.generateUniqueNotificationId();
                  cubit.addNotification(
                    VehicleNotificationType.ITP,
                    date,
                    sms,
                    email,
                    push,
                    notificationId,
                  );
                },
                removeNotification: (index) => cubit.removeNotification(
                    VehicleNotificationType.ITP, index),
              ),
              const SizedBox(height: 20),
              ExpirationSection(
                label: "RCA",
                type: VehicleNotificationType.RCA,
                selectedDate: vehicleReminder?.expirationDateRCA,
                updateDate: (date) => cubit.updateExpirationDateRCA(date),
                clearDate: () => cubit.updateExpirationDateRCA(null),
                notifications: vehicleReminder?.notificationsRCA ?? [],
                addNotification: (date, sms, email, push) async {
                  int notificationId =
                      await cubit.generateUniqueNotificationId();
                  cubit.addNotification(
                    VehicleNotificationType.RCA,
                    date,
                    sms,
                    email,
                    push,
                    notificationId,
                  );
                },
                removeNotification: (index) => cubit.removeNotification(
                    VehicleNotificationType.RCA, index),
              ),
              const SizedBox(height: 20),
              ExpirationSection(
                label: "CASCO",
                type: VehicleNotificationType.CASCO,
                selectedDate: vehicleReminder?.expirationDateCASCO,
                updateDate: (date) => cubit.updateExpirationDateCASCO(date),
                clearDate: () => cubit.updateExpirationDateCASCO(null),
                notifications: vehicleReminder?.notificationsCASCO ?? [],
                addNotification: (date, sms, email, push) async {
                  int notificationId =
                      await cubit.generateUniqueNotificationId();
                  cubit.addNotification(
                    VehicleNotificationType.CASCO,
                    date,
                    sms,
                    email,
                    push,
                    notificationId,
                  );
                },
                removeNotification: (index) => cubit.removeNotification(
                    VehicleNotificationType.CASCO, index),
              ),
              const SizedBox(height: 20),
              ExpirationSection(
                label: "Rovinieta",
                type: VehicleNotificationType.Rovinieta,
                selectedDate: vehicleReminder?.expirationDateRovinieta,
                updateDate: (date) => cubit.updateExpirationDateRovinieta(date),
                clearDate: () => cubit.updateExpirationDateRovinieta(null),
                notifications: vehicleReminder?.notificationsRovinieta ?? [],
                addNotification: (date, sms, email, push) async {
                  int notificationId =
                      await cubit.generateUniqueNotificationId();
                  cubit.addNotification(
                    VehicleNotificationType.Rovinieta,
                    date,
                    sms,
                    email,
                    push,
                    notificationId,
                  );
                },
                removeNotification: (index) => cubit.removeNotification(
                    VehicleNotificationType.Rovinieta, index),
              ),
              const SizedBox(height: 20),
              ExpirationSection(
                label: "Tahograf",
                type: VehicleNotificationType.Tahograf,
                selectedDate: vehicleReminder?.expirationDateTahograf,
                updateDate: (date) => cubit.updateExpirationDateTahograf(date),
                clearDate: () => cubit.updateExpirationDateTahograf(null),
                notifications: vehicleReminder?.notificationsTahograf ?? [],
                addNotification: (date, sms, email, push) async {
                  int notificationId =
                      await cubit.generateUniqueNotificationId();
                  cubit.addNotification(
                    VehicleNotificationType.Tahograf,
                    date,
                    sms,
                    email,
                    push,
                    notificationId,
                  );
                },
                removeNotification: (index) => cubit.removeNotification(
                    VehicleNotificationType.Tahograf, index),
              ),
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
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );

            try {
              String userId = context.read<UserDataCubit>().state.member.id;

              await cubit.saveChanges(userId);

              context.pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vehiculul a fost actualizat cu succes.'),
                ),
              );
            } catch (e) {
              print(e);
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
