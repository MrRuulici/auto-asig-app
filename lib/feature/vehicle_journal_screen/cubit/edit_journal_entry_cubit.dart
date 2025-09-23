import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/data/http_data.dart';
import 'package:auto_asig/core/models/vehicle_jorunal_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_journal_entry_state.dart';

class EditJournalEntryCubit extends Cubit<EditJournalEntryState> {
  late final TextEditingController nameController;
  late final TextEditingController kmsController;

  EditJournalEntryCubit()
      : super(EditJournalEntryState(
          entry: JournalEntry(
            entryId: '',
            name: '',
            createdAt: Timestamp.now(),
            editedAt: Timestamp.now(),
            type: JournalEntryType.other,
            date: DateTime.now(),
            kms: 0,
          ),
          vehicleId: '',
        )) {
    // Initialize controllers
    nameController = TextEditingController(text: state.entry.name)
      ..addListener(() {
        updateName(nameController.text);
      });
    kmsController = TextEditingController(text: state.entry.kms.toString())
      ..addListener(() {
        updateKms(int.tryParse(kmsController.text) ?? 0);
      });
  }

  void initializeEntry(JournalEntry entry, String vehicleId) {
    emit(state.copyWith(entry: entry, vehicleId: vehicleId));
    nameController.text = entry.name;
    kmsController.text = entry.kms.toString();
  }

  void updateType(JournalEntryType type) {
    emit(state.copyWith(
      entry: state.entry.copyWith(type: type),
    ));
  }

  void updateName(String name) {
    emit(state.copyWith(
      entry: state.entry.copyWith(name: name),
    ));
  }

  void updateKms(int kms) {
    emit(state.copyWith(
      entry: state.entry.copyWith(kms: kms),
    ));
  }

  void updateDate(DateTime date) {
    emit(state.copyWith(
      entry: state.entry.copyWith(date: date),
    ));
  }

  Future<void> saveChanges(String userId) async {
    emit(state.copyWith(isSaving: true));

    if (state.entry.entryId.isEmpty) {
      // Save the new entry
      await addJournalEntry(
        userId: userId,
        vehicleId: state.vehicleId,
        newEntry: state.entry,
      );
    } else {
      // Save the updated entry
      await editJournalEntry(
        userId: userId,
        vehicleId: state.vehicleId,
        updatedEntry: state.entry,
      );
    }

    emit(state.copyWith(isSaving: false));
  }

  @override
  Future<void> close() {
    // Dispose controllers
    nameController.dispose();
    kmsController.dispose();
    return super.close();
  }

  bool validateFields() {
    if (state.entry.name.isEmpty) {
      return false;
    }

    if (state.entry.kms <= 0) {
      return false;
    }

    return true;
  }
}
