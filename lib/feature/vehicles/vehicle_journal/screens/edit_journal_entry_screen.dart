import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/widgets/auto_asig_button_full.dart';
import 'package:auto_asig/feature/vehicles/vehicle_journal/cubit/edit_journal_entry_cubit.dart';
import 'package:auto_asig/feature/vehicles/vehicle_journal/screens/vehicle_journal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EditJournalEntryScreen extends StatelessWidget {
  const EditJournalEntryScreen({super.key});

  static const path = 'editJournalEntryScreen';
  static const absolutePath = '${VehicleJournalScreen.absolutePath}/$path';

  String _getJournalTypeName(JournalEntryType type) {
    switch (type) {
      case JournalEntryType.service:
        return 'Jurnal Service';
      case JournalEntryType.breaks:
        return 'Jurnal Frâne';
      case JournalEntryType.distribution:
        return 'Jurnal Distribuție';
      case JournalEntryType.other:
        return 'Jurnal Altele';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditJournalEntryCubit>();
    final state = context.watch<EditJournalEntryCubit>().state;

    return GestureDetector(
      onTap: () {
        // Unfocus any text field when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                state.entry.entryId != ''
                    ? 'Editează Înregistrare'
                    : 'Adaugă Înregistrare',
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                _getJournalTypeName(state.entry.type),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: padding, vertical: 16),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: cubit.nameController,
                          decoration: const InputDecoration(labelText: 'Nume'),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: cubit.kmsController,
                          decoration: const InputDecoration(
                            labelText: 'Kilometri',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                              // Prevent starting with 0
                              if (newValue.text.startsWith('0')) {
                                return oldValue;
                              }
                              return newValue;
                            }),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: TextEditingController(
                            text: DateFormat('dd.MM.yyyy')
                                .format(state.entry.date),
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Data',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: state.entry.date,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                              locale: const Locale('ro', 'RO'),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: buttonBlue,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: buttonBlue,
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedDate != null) {
                              cubit.updateDate(pickedDate);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AutoAsigButton(
                  text: 'Salvează Modificările',
                  onPressed: () async {
                    // validate the fields before saving
                    if (!cubit.validateFields()) {
                      // show an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Câmpurile nu sunt completate corect!'),
                        ),
                      );
                      return;
                    }

                    final userId =
                        context.read<UserDataCubit>().state.member.id;

                    // display loading overlay

                    await cubit.saveChanges(userId);
                    // Navigator.pop(context, true);
                    context.pop(state.entry);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}