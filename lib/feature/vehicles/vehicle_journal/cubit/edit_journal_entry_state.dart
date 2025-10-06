import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/models/vehicle_jorunal_model.dart';
import 'package:equatable/equatable.dart';

class EditJournalEntryState extends Equatable {
  final JournalEntry entry;
  final bool isSaving;
  final String vehicleId;
  final JournalEntryType type;

  const EditJournalEntryState({
    required this.entry,
    required this.vehicleId,
    this.isSaving = false,
    this.type = JournalEntryType.other,
  });

  EditJournalEntryState copyWith({
    JournalEntry? entry,
    bool? isSaving,
    String? vehicleId,
    JournalEntryType? type,
  }) {
    return EditJournalEntryState(
      entry: entry ?? this.entry,
      isSaving: isSaving ?? this.isSaving,
      vehicleId: vehicleId ?? this.vehicleId,
      type: type ?? this.type,
    );
  }

  @override
  List<Object> get props => [
        entry,
        isSaving,
        vehicleId,
        type,
      ];
}
