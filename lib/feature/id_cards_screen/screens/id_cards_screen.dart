import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/assistants.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/helpers/notification_helper.dart';
import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/core/models/reminder.dart';
import 'package:auto_asig/core/widgets/auto_asig_appbar.dart';
import 'package:auto_asig/core/widgets/auto_asig_button_full.dart';
import 'package:auto_asig/core/widgets/date_picker_field.dart';
import 'package:auto_asig/feature/home_screen/screens/home_screen.dart';
import 'package:auto_asig/feature/id_cards_screen/cubit/id_cards_cubit.dart';
import 'package:auto_asig/feature/id_cards_screen/cubit/id_cards_state.dart';
import 'package:auto_asig/core/widgets/notification_item.dart';
import 'package:auto_asig/feature/home_screen/cubit/reminder_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({
    super.key,
    this.reminder, // Optional parameter for edit mode
    required this.type, // Required reminder type for context
  });

  static const path = 'reminder_screen';
  static const absolutePath = '${HomeScreen.path}/$path';

  final Reminder? reminder; // The reminder to edit, if in edit mode
  final ReminderType type;

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController(
      text: reminder?.title ?? '', // Prepopulate if editing
    );
    final idCardsCubit = context.read<IdCardsCubit>();
    bool isEditing = false;

    // Initialize state for edit mode
    if (reminder != null) {
      isEditing = true;

      idCardsCubit.initializeForEdit(reminder!);
    }

    // Determine dynamic title and label based on ReminderType
    final String titleText;
    final String labelName;
    switch (type) {
      case ReminderType.idCard:
        titleText = 'Carte de identitate';
        labelName = 'Nume Carte de identitate';
        break;
      case ReminderType.drivingLicense:
        titleText = 'Permis';
        labelName = 'Nume Permis';
        break;
      case ReminderType.passport:
        titleText = 'Pașaport';
        labelName = 'Nume Pașaport';
        break;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AlliatAppBar(),
      // AppBar(
      //   title: Text(reminder == null
      //       ? 'Inregistrare $titleText'
      //       : 'Editare $titleText'),
      //   centerTitle: true,
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   titleTextStyle: const TextStyle(
      //     color: Colors.black,
      //     fontSize: 24,
      //     fontWeight: FontWeight.w600,
      //   ),
      //   iconTheme: const IconThemeData(color: Colors.black),
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<IdCardsCubit, IdCardsState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  titleText,
                  style: const TextStyle(
                    fontSize: 25,
                    color: logoBlue,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Setează un nume pentru $titleText, data de expirare și când dorești să fii notificat',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  textCapitalization: TextCapitalization.characters,
                  controller: titleController,
                  style: const TextStyle(fontSize: 16),
                  inputFormatters: [
                    UpperCaseTextFormatter(), // Ensure all text is uppercase
                  ],
                  decoration: InputDecoration(
                    labelText: '     $labelName',
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
                    idCardsCubit.updateName(value
                        .toUpperCase()); // Optional: Ensure uppercase in the Cubit
                  },
                ),

                const SizedBox(height: 20),

                // Expiration Date Field
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    // color: Colors.grey.shade100,
                    color: textFieldGrey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: AlliatDatePickerField(
                    label: "Data Expirării",
                    selectedDate: state.expirationDate,
                    onDateSelected: (date) {
                      idCardsCubit.updateExpirationDate(date);
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Notification Section
                // const Text(
                //   'Notificări',
                //   style: TextStyle(
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.black,
                //   ),
                // ),
                // const SizedBox(height: 10),

                // Display Notification Pickers using NotificationItem
                for (int i = 0; i < state.notificationDates.length; i++)
                  NotificationItem(
                    index: i,
                    selectedDate: state.notificationDates[i].date,
                    sms: state.notificationDates[i].sms,
                    email: state.notificationDates[i].email,
                    push: state.notificationDates[i].push,
                    onNotificationRemove: () =>
                        idCardsCubit.removeNotification(context, i),
                    onNotificationUpdate: (date, sms, email, push) {
                      idCardsCubit.updateNotification(
                        i,
                        NotificationModel(
                          date: date,
                          sms: sms,
                          email: email,
                          push: push,
                          notificationId:
                              state.notificationDates[i].notificationId,
                        ),
                      );
                    },
                  ),

                // Add Notification Button
                TextButton.icon(
                  onPressed: () async {
                    if (state.notificationDates.length >=
                        maxNrOfNotifications) {
                      showSnackbar(context,
                          'Numărul maxim de notificări a fost atins. Poți șterge notificări existente pentru a adaugă altele noi');
                      return;
                    }

                    // @todo: vezi de ce nu cere permisiuni la notificari
                    await FirebaseMessaging.instance.requestPermission();

                    // aici generam token fcm
                    final fcmToken = await FirebaseMessaging.instance.getToken();
                    if (fcmToken != null) {
                      print('FCM Token: $fcmToken');

                      // Salvează token-ul în Firestore-ul emulat
                      // Asigură-te că ai un utilizator autentificat prin FirebaseAuth emulator
                      // if (FirebaseAuth.instance.currentUser != null) {
                      //   await FirebaseFirestore.instance
                      //       .collection('users')
                      //       .doc(FirebaseAuth.instance.currentUser!.uid)
                      //       .set({'fcmToken': fcmToken}, SetOptions(merge: true));
                      //   print('FCM Token salvat în Firestore emulator.');
                      // }
                    }

                    int notifId =
                        await NotificationHelper.generateUniqueNotificationId();

                    idCardsCubit.addNotification(NotificationModel(
                      date: state.expirationDate
                          .subtract(const Duration(days: 1)),
                      sms: false,
                      email: false,
                      push: true,
                      notificationId: notifId,
                    ));
                  },
                  icon: const Icon(
                    Icons.add,
                    color: logoBlue,
                  ),
                  label: const Text(
                    'Adaugă notificare',
                    style: TextStyle(
                      color: logoBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: AutoAsigButton(
          onPressed: () async {
            if (titleController.text.isEmpty) {
              showSnackbar(context, 'Numele nu poate fi gol');
              return;
            }

            if (!checkIfDateIsInFuture(idCardsCubit.state.expirationDate)) {
              showSnackbar(context, 'Data expirarii trebuie sa fie in viitor');
              return;
            }

            // show loading dialog
            showLoadingDialog(context);

            final userId = context.read<UserDataCubit>().state.member.id;

            try {
              if (reminder == null) {
                // Save new reminder to database
                await idCardsCubit.save(userId, type);
                showSnackbar(context, 'Reminder salvat cu succes');
              } else {
                // Update existing reminder
                await idCardsCubit.update(userId, reminder!.id, type);
                showSnackbar(context, 'Reminder actualizat cu succes');
                Navigator.of(context).pop();
              }

              Navigator.of(context).pop();

              // Update the reminders list
              context.read<ReminderCubit>().addOrUpdateReminder(
                    idCardsCubit.state.name,
                    idCardsCubit.state.expirationDate,
                    idCardsCubit.state.notificationDates,
                    type,
                    isEditing, // Pass isEditing flag
                    reminder?.id ?? '', // Pass ID if updating
                  );

              idCardsCubit.reset();
            } catch (e) {
              Navigator.of(context).pop();
              print('Error at creating/updating reminder: $e');
              showSnackbar(context,
                  'Eroare la salvarea datelor. Te rugam sa incerci mai tarziu');
            }
          },
          text: reminder == null ? 'SALVEAZĂ' : 'ACTUALIZEAZĂ',
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
