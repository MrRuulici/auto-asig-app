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
import 'package:go_router/go_router.dart';

class RegisterCarScreen extends StatefulWidget {
  const RegisterCarScreen({super.key});

  static const path = 'register_car';
  static const absolutePath = '${HomeScreen.path}/$path';

  @override
  State<RegisterCarScreen> createState() => _RegisterCarScreenState();
}

class _RegisterCarScreenState extends State<RegisterCarScreen> {
  late final TextEditingController nrCar;
  late final TextEditingController vehicleModelController;

  @override
  void initState() {
    super.initState();
    nrCar = TextEditingController();
    vehicleModelController = TextEditingController();

    // Reset the cubit when entering the screen
    context.read<CarInfoCubit>().reset();
  }

  @override
  void dispose() {
    nrCar.dispose();
    vehicleModelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    'Introdu numărul de înmatriculare vehiculului (ex: BV10ABC):',
                  ),
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
                  ]
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    'Introdu marca și modelul vehiculului (ex: Dacia Logan):',
                  ),
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
                    fillColor: textFieldGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    context.read<CarInfoCubit>().updateVehicleModel(value);
                  },
                ),
                const SizedBox(height: 20),

                // ITP Section
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
                  updateNotificationPeriods:
                      (index, monthBefore, weekBefore, dayBefore, email, push) {
                    context.read<CarInfoCubit>().updateNotificationPeriods(
                          VehicleNotificationType.ITP,
                          index,
                          monthBefore,
                          weekBefore,
                          dayBefore,
                          email,
                          push,
                        );
                  },
                  removeNotification: (index) =>
                      context.read<CarInfoCubit>().removeNotification(
                            VehicleNotificationType.ITP,
                            index,
                          ),
                ),

                const SizedBox(height: 20),

                // RCA Section
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
                  updateNotificationPeriods:
                      (index, monthBefore, weekBefore, dayBefore, email, push) {
                    context.read<CarInfoCubit>().updateNotificationPeriods(
                          VehicleNotificationType.RCA,
                          index,
                          monthBefore,
                          weekBefore,
                          dayBefore,
                          email,
                          push,
                        );
                  },
                  removeNotification: (index) =>
                      context.read<CarInfoCubit>().removeNotification(
                            VehicleNotificationType.RCA,
                            index,
                          ),
                ),

                const SizedBox(height: 20),

                // CASCO Section
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
                  updateNotificationPeriods:
                      (index, monthBefore, weekBefore, dayBefore, email, push) {
                    context.read<CarInfoCubit>().updateNotificationPeriods(
                          VehicleNotificationType.CASCO,
                          index,
                          monthBefore,
                          weekBefore,
                          dayBefore,
                          email,
                          push,
                        );
                  },
                  removeNotification: (index) =>
                      context.read<CarInfoCubit>().removeNotification(
                            VehicleNotificationType.CASCO,
                            index,
                          ),
                ),

                const SizedBox(height: 20),

                // Rovinieta Section
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
                  updateNotificationPeriods:
                      (index, monthBefore, weekBefore, dayBefore, email, push) {
                    context.read<CarInfoCubit>().updateNotificationPeriods(
                          VehicleNotificationType.Rovinieta,
                          index,
                          monthBefore,
                          weekBefore,
                          dayBefore,
                          email,
                          push,
                        );
                  },
                  removeNotification: (index) =>
                      context.read<CarInfoCubit>().removeNotification(
                            VehicleNotificationType.Rovinieta,
                            index,
                          ),
                ),

                const SizedBox(height: 20),

                // Tahograf Section
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
                  updateNotificationPeriods:
                      (index, monthBefore, weekBefore, dayBefore, email, push) {
                    context.read<CarInfoCubit>().updateNotificationPeriods(
                          VehicleNotificationType.Tahograf,
                          index,
                          monthBefore,
                          weekBefore,
                          dayBefore,
                          email,
                          push,
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
                  type: JournalEntryType.service,
                  entries: carInfo.journalEntriesService,
                  onAddEntry: (type, date, km) {
                    context
                        .read<CarInfoCubit>()
                        .addTemporaryJournalEntry(type, date, km);
                  },
                  onRemoveEntry: (type, entryId) {
                    context
                        .read<CarInfoCubit>()
                        .removeTemporaryJournalEntry(type, entryId);
                  },
                ),

                const SizedBox(height: 20),

                JournalSection(
                  label: 'Plăcuțe frână',
                  type: JournalEntryType.breaks,
                  entries: carInfo.journalEntriesBreaks,
                  onAddEntry: (type, date, km) {
                    context
                        .read<CarInfoCubit>()
                        .addTemporaryJournalEntry(type, date, km);
                  },
                  onRemoveEntry: (type, entryId) {
                    context
                        .read<CarInfoCubit>()
                        .removeTemporaryJournalEntry(type, entryId);
                  },
                ),

                const SizedBox(height: 20),

                JournalSection(
                  label: 'Transmisie',
                  type: JournalEntryType.distribution,
                  entries: carInfo.journalEntriesDistribution,
                  onAddEntry: (type, date, km) {
                    context
                        .read<CarInfoCubit>()
                        .addTemporaryJournalEntry(type, date, km);
                  },
                  onRemoveEntry: (type, entryId) {
                    context
                        .read<CarInfoCubit>()
                        .removeTemporaryJournalEntry(type, entryId);
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: AutoAsigButton(
          onPressed: () async {
            // Validate inputs
            if (nrCar.text.isEmpty) {
              showErrorSnackbar(
                  context, 'Te rugăm să introduci numărul de înmatriculare.');
              return;
            } else if (vehicleModelController.text.isEmpty) {
              showErrorSnackbar(
                  context, 'Te rugăm să introduci modelul vehiculului.');
              return;
            }

            // Show loading dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            );

            try {
              final userData = context.read<UserDataCubit>();
              final res = await context
                  .read<CarInfoCubit>()
                  .addCar(userData.state.member.id);

              // Close loading dialog
              Navigator.of(context).pop();

              if (!res) {
                showErrorSnackbar(context,
                    'Te rugăm să introduci cel puțin o dată de expirare.');
                return;
              }

              showSuccessSnackbar(
                  context, 'Vehiculul a fost înregistrat cu succes.');

              // Navigate to home
              context.go(HomeScreen.path);
            } catch (e) {
              // Close loading dialog if shown
              Navigator.of(context).pop();
              print('Error adding car: $e');
              showErrorSnackbar(
                  context, 'A apărut o eroare. Te rugăm să încerci din nou.');
            }
          },
          text: 'ÎNREGISTREAZĂ VEHICUL',
        ),
      ),
    );
  }
}
