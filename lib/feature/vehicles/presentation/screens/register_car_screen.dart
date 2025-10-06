import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/assistants.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/data/no_space_input_formatter.dart';
import 'package:auto_asig/core/helpers/notification_helper.dart';
import 'package:auto_asig/core/widgets/auto_asig_appbar.dart';
import 'package:auto_asig/core/widgets/auto_asig_button_full.dart';
import 'package:auto_asig/feature/vehicles/presentation/cubit/car_info_cubit.dart';
import 'package:auto_asig/feature/vehicles/presentation/widgets/expiration_section.dart';
import 'package:auto_asig/feature/vehicles/presentation/widgets/journal_section.dart';
import 'package:auto_asig/feature/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCarScreen extends StatelessWidget {
  const RegisterCarScreen({super.key});

  static const path = 'register_car';
  static const absolutePath = '${HomeScreen.path}/$path';

  @override
  Widget build(BuildContext context) {
    TextEditingController nrCar = TextEditingController();
    TextEditingController vehicleModelController = TextEditingController();

    return Scaffold(
      appBar: AlliatAppBar(),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: BlocBuilder<CarInfoCubit, CarInfoState>(
            builder: (context, carInfo) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Înregistrează vehicul',
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
                    'Te rugăm să introduci datele vehiculului pentru a-l înregistra:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                      'Introdu numărul de înmatriculare vehiculului (ex: BV10ABC):'),
                ),
                const SizedBox(height: 20),
                TextField(
                  textCapitalization: TextCapitalization.characters,
                  controller: nrCar,
                  decoration: InputDecoration(
                    labelText: 'Număr de înmatriculare',
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    fillColor: textFieldGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    context.read<CarInfoCubit>().updateCarNumber(value);
                  },
                  inputFormatters: [
                    NoSpaceInputFormatter(),
                  ],
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                      'Introdu marca și modelul vehiculului (ex: Dacia Logan):'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: vehicleModelController,
                  decoration: InputDecoration(
                    labelText: 'Marcă și model vehicul',
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    // fillColor: Colors.grey.shade100,
                    fillColor: textFieldGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  // const InputDecoration(
                  //   labelText: 'Model vehicul',
                  //   labelStyle: TextStyle(
                  //     fontSize: 14,
                  //     color: Colors.black,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  //   filled: true,
                  //   // fillColor: Colors.grey.shade100,
                  //   fillColor: textFieldGrey,
                  //   // border: OutlineInputBorder(
                  //   //   borderRadius: BorderRadius.circular(15),
                  //   //   borderSide: BorderSide.none,
                  //   // ),
                  // ),
                  onChanged: (value) {
                    context.read<CarInfoCubit>().updateVehicleModel(value);
                  },
                ),
                const SizedBox(height: 20),
                // RegisterCarScreen.dart
                ExpirationSection(
                  label: "ITP",
                  type: VehicleNotificationType.ITP,
                  selectedDate: carInfo.expirationDateITP,
                  updateDate: (date) => context
                      .read<CarInfoCubit>()
                      .updateExpirationDateITP(date),
                  clearDate: () => context
                      .read<CarInfoCubit>()
                      .clearSelectedDate(VehicleNotificationType.ITP),
                  notifications: carInfo.notificationsITP,
                  addNotification: (date, sms, email, push) async {
                    int notificationId =
                        await NotificationHelper.generateUniqueNotificationId();

                    context.read<CarInfoCubit>().addNotification(
                        VehicleNotificationType.ITP,
                        date,
                        sms,
                        email,
                        push,
                        notificationId);
                  },
                  removeNotification: (index) =>
                      context.read<CarInfoCubit>().removeNotification(
                            VehicleNotificationType.ITP,
                            index,
                          ),
                ),
                // Repeat ExpirationSection widgets for RCA, CASCO, etc., updating clearDate accordingly
                const SizedBox(height: 20),
                ExpirationSection(
                  label: "RCA",
                  type: VehicleNotificationType.RCA,
                  selectedDate: carInfo.expirationDateRCA,
                  updateDate: (date) => context
                      .read<CarInfoCubit>()
                      .updateExpirationDateRCA(date),
                  clearDate: () => context
                      .read<CarInfoCubit>()
                      .clearSelectedDate(VehicleNotificationType.RCA),
                  notifications: carInfo.notificationsRCA,
                  addNotification: (date, sms, email, push) async {
                    int notificationId =
                        await NotificationHelper.generateUniqueNotificationId();

                    context.read<CarInfoCubit>().addNotification(
                          VehicleNotificationType.RCA,
                          date,
                          sms,
                          email,
                          push,
                          notificationId,
                        );
                  },
                  removeNotification: (index) =>
                      context.read<CarInfoCubit>().removeNotification(
                            VehicleNotificationType.RCA,
                            index,
                          ),
                ),
                const SizedBox(height: 20),
                ExpirationSection(
                  label: "CASCO",
                  type: VehicleNotificationType.CASCO,
                  selectedDate: carInfo.expirationDateCASCO,
                  updateDate: (date) => context
                      .read<CarInfoCubit>()
                      .updateExpirationDateCASCO(date),
                  clearDate: () => context
                      .read<CarInfoCubit>()
                      .clearSelectedDate(VehicleNotificationType.CASCO),
                  notifications: carInfo.notificationsCASCO,
                  addNotification: (date, sms, email, push) async {
                    int notificationId =
                        await NotificationHelper.generateUniqueNotificationId();

                    context.read<CarInfoCubit>().addNotification(
                          VehicleNotificationType.CASCO,
                          date,
                          sms,
                          email,
                          push,
                          notificationId,
                        );
                  },
                  removeNotification: (index) =>
                      context.read<CarInfoCubit>().removeNotification(
                            VehicleNotificationType.CASCO,
                            index,
                          ),
                ),
                const SizedBox(height: 20),
                ExpirationSection(
                  label: "Rovinieta",
                  type: VehicleNotificationType.Rovinieta,
                  selectedDate: carInfo.expirationDateRovinieta,
                  updateDate: (date) => context
                      .read<CarInfoCubit>()
                      .updateExpirationDateRovinieta(date),
                  clearDate: () => context
                      .read<CarInfoCubit>()
                      .clearSelectedDate(VehicleNotificationType.Rovinieta),
                  notifications: carInfo.notificationsRovinieta,
                  addNotification: (date, sms, email, push) async {
                    int notificationId =
                        await NotificationHelper.generateUniqueNotificationId();

                    context.read<CarInfoCubit>().addNotification(
                          VehicleNotificationType.Rovinieta,
                          date,
                          sms,
                          email,
                          push,
                          notificationId,
                        );
                  },
                  removeNotification: (index) =>
                      context.read<CarInfoCubit>().removeNotification(
                            VehicleNotificationType.Rovinieta,
                            index,
                          ),
                ),
                const SizedBox(height: 20),
                ExpirationSection(
                  label: "Tahograf",
                  type: VehicleNotificationType.Tahograf,
                  selectedDate: carInfo.expirationDateTahograf,
                  updateDate: (date) => context
                      .read<CarInfoCubit>()
                      .updateExpirationDateTahograf(date),
                  clearDate: () => context
                      .read<CarInfoCubit>()
                      .clearSelectedDate(VehicleNotificationType.Tahograf),
                  notifications: carInfo.notificationsTahograf,
                  addNotification: (date, sms, email, push) async {
                    int notificationId =
                        await NotificationHelper.generateUniqueNotificationId();

                    context.read<CarInfoCubit>().addNotification(
                          VehicleNotificationType.Tahograf,
                          date,
                          sms,
                          email,
                          push,
                          notificationId,
                        );
                  },
                  removeNotification: (index) =>
                      context.read<CarInfoCubit>().removeNotification(
                            VehicleNotificationType.Tahograf,
                            index,
                          ),
                ),
                const Divider(),
                const SizedBox(height: 20),
                const SizedBox(
                  width: double.maxFinite,
                  child: Text(
                    'Jurnal (Marca Model)',
                    style: TextStyle(
                      fontSize: 20,
                      color: logoBlue,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 20),
                JournalSection(
                  label: 'Service',
                  selectedDate: DateTime.now(),
                  clearDate: () {},
                  notifications: [],
                  removeNotification: (index) {
                    // remove notification
                  },
                  addLog: () async {
                    JournalEntryType type = JournalEntryType.service;
                  },
                ),

                const SizedBox(height: 20),
                JournalSection(
                  label: 'Plăcuțe frână',
                  selectedDate: DateTime.now(),
                  clearDate: () {},
                  notifications: [],
                  removeNotification: (index) {
                    // remove notification
                  },
                  addLog: () async {
                    JournalEntryType type = JournalEntryType.breaks;
                  },
                ),
                const SizedBox(height: 20),
                JournalSection(
                  label: 'Transmisie',
                  selectedDate: DateTime.now(),
                  clearDate: () {},
                  notifications: [],
                  removeNotification: (index) {
                    // remove notification
                  },
                  addLog: () async {
                    JournalEntryType type = JournalEntryType.distribution;
                  },
                ),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: AutoAsigButton(
          onPressed: () async {
            // show loading dialog
            showDialog(
              context: context,
              builder: (context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );

            if (nrCar.text.isEmpty) {
              Navigator.of(context).pop();
              showSnackbar(
                  context, 'Te rugăm să introduci numărul de înmatriculare.');
              return;
            } else if (vehicleModelController.text.isEmpty) {
              Navigator.of(context).pop();
              showSnackbar(
                  context, 'Te rugăm să introduci modelul vehiculului.');
              return;
            }

            try {
              final userData = context.read<UserDataCubit>();
              bool res = await context
                  .read<CarInfoCubit>()
                  .addCar(userData.state.member.id);

              Navigator.of(context).pop();

              if (!res) {
                showSnackbar(context,
                    'Te rugăm să introduci cel puțin o dată de expirare.');
              } else {
                Navigator.of(context).pop();
                showSnackbar(
                    context, 'Vehiculul a fost înregistrat cu succes.');
              }
            } catch (e) {
              print(e);

              Navigator.of(context).pop();
              showSnackbar(
                  context, 'A apărut o eroare. Te rugăm să încerci din nou.');
            }
          },
          text: 'ÎNREGISTREAZĂ VEHICUL',
        ),
      ),
    );
  }
}
