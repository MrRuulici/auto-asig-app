import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/assistants.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/helpers/notification_helper.dart';
import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/core/models/reminder.dart';
import 'package:auto_asig/core/widgets/auto_asig_appbar.dart';
import 'package:auto_asig/core/widgets/auto_asig_button_full.dart';
import 'package:auto_asig/core/widgets/date_picker_field.dart';
import 'package:auto_asig/feature/home/presentation/screens/home_screen.dart';
import 'package:auto_asig/feature/documents/presentation/cubit/id_cards_cubit.dart';
import 'package:auto_asig/feature/documents/presentation/cubit/id_cards_state.dart';
import 'package:auto_asig/core/widgets/notification_item.dart';
import 'package:auto_asig/feature/home/presentation/cubit/reminder_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({
    super.key,
    this.reminder,
    required this.type,
  });

  static const path = 'reminder_screen';
  static const absolutePath = '${HomeScreen.path}/$path';

  final Reminder? reminder;
  final ReminderType type;

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  late final TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    
    final idCardsCubit = context.read<IdCardsCubit>();
    
    // Reset or initialize based on mode
    if (widget.reminder != null) {
      // Edit mode: initialize with existing data
      idCardsCubit.initializeForEdit(widget.reminder!);
      titleController = TextEditingController(text: widget.reminder!.title);
    } else {
      // Add mode: reset to initial state
      idCardsCubit.reset();
      titleController = TextEditingController();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine dynamic title and label based on ReminderType
    final String titleText;
    final String labelName;
    switch (widget.type) {
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
                    UpperCaseTextFormatter(),
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
                    context.read<IdCardsCubit>().updateName(value.toUpperCase());
                  },
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: textFieldGrey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: AlliatDatePickerField(
                    label: "Data Expirării",
                    selectedDate: state.expirationDate,
                    onDateSelected: (date) {
                      context.read<IdCardsCubit>().updateExpirationDate(date);
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Notification Section - Only show if notifications exist
                if (state.notificationDates.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
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
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Selectează o dată de expirare pentru a configura notificările',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Notificări',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: logoBlue,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 10),
                      for (int i = 0; i < state.notificationDates.length; i++)
                        NotificationItem(
                          index: i,
                          expirationDate: state.expirationDate,
                          monthBefore: state.notificationDates[i].monthBefore ?? false,
                          weekBefore: state.notificationDates[i].weekBefore ?? false,
                          dayBefore: state.notificationDates[i].dayBefore ?? false,
                          email: state.notificationDates[i].email,
                          push: state.notificationDates[i].push,
                          onNotificationRemove: () =>
                              context.read<IdCardsCubit>().removeNotification(context, i),
                          onNotificationUpdate: (monthBefore, weekBefore, dayBefore, email, push) {
                            context.read<IdCardsCubit>().updateNotificationPeriods(
                              i,
                              monthBefore,
                              weekBefore,
                              dayBefore,
                              email,
                              push,
                            );
                          },
                        ),
                    ],
                  ),
                
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: AutoAsigButton(
          onPressed: () async {
            if (titleController.text.isEmpty) {
              showErrorSnackbar(context, 'Numele nu poate fi gol');
              return;
            }

            if (!checkIfDateIsInFuture(context.read<IdCardsCubit>().state.expirationDate)) {
              showErrorSnackbar(context, 'Data expirarii trebuie sa fie in viitor');
              return;
            }

            // Validate that at least one notification exists
            if (context.read<IdCardsCubit>().state.notificationDates.isEmpty) {
              showErrorSnackbar(context, 'Selectează o dată de expirare validă');
              return;
            }

            showLoadingDialog(context);

            final userId = context.read<UserDataCubit>().state.member.id;

            try {
              if (widget.reminder == null) {
                await context.read<IdCardsCubit>().save(userId, widget.type);
                showSuccessSnackbar(context, 'Reminder salvat cu succes');
              } else {
                await context.read<IdCardsCubit>().update(userId, widget.reminder!.id, widget.type);
                showSuccessSnackbar(context, 'Reminder actualizat cu succes');
              }

              Navigator.of(context).pop();
              context.go(HomeScreen.path);
            } catch (e) {
              Navigator.of(context).pop();
              print('Error at creating/updating reminder: $e');
              showErrorSnackbar(context, 'Eroare la salvarea datelor. Te rugam sa incerci mai tarziu');
            }
          },
          text: widget.reminder == null ? 'SALVEAZĂ' : 'ACTUALIZEAZĂ',
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