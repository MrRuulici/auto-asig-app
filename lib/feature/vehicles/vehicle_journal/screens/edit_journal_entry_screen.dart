import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/widgets/auto_asig_button_full.dart';
import 'package:auto_asig/feature/vehicles/vehicle_journal/cubit/edit_journal_entry_cubit.dart';
import 'package:auto_asig/feature/vehicles/vehicle_journal/screens/vehicle_journal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditJournalEntryScreen extends StatelessWidget {
  const EditJournalEntryScreen({super.key});

  static const path = 'editJournalEntryScreen';
  static const absolutePath = '${VehicleJournalScreen.absolutePath}/$path';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditJournalEntryCubit>();
    final state = context.watch<EditJournalEntryCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.entry.entryId != ''
              ? 'Editează Înregistrare'
              : 'Adaugă Înregistrare',
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
                        decoration:
                            const InputDecoration(labelText: 'Kilometri'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: TextEditingController(
                          text: state.entry.date.toString().split(' ')[0],
                        ),
                        decoration: const InputDecoration(labelText: 'Date'),
                        readOnly: true,
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: state.entry.date,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            cubit.updateDate(pickedDate);
                          }
                        },
                      ),
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

                  final userId = context.read<UserDataCubit>().state.member.id;

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
    );
  }
}
