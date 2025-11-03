import 'package:auto_asig/core/data/constants.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:auto_asig/core/models/vehicle_jorunal_model.dart';
import 'package:auto_asig/core/data/http_data.dart';

part 'vehicle_journals_state.dart';

class VehicleJournalsCubit extends Cubit<VehicleJournalsState> {
  VehicleJournalsCubit() : super(VehicleJournalsInitial());

  Future<void> fetchAllJournalsForVehicle({
    required String userId,
    required String vehicleId,
    required String carModel,
    required String carLicense,
  }) async {
    try {
      // Placeholder for grouped journal entries
      final Map<JournalEntryType, List<JournalEntry>> allJournals = {};

      for (JournalEntryType journalType in JournalEntryType.values) {
        final journals = await getJournalsForVehicle(
          userId,
          vehicleId,
          journalType,
        );

        // Combine all entries for the current type
        allJournals[journalType] = journals
            .expand((journal) => journal.entries)
            .toList(); // Flatten the list of entries
      }

      // Emit the loaded state
      emit(VehicleJournalsLoaded(
        journals: allJournals,
        carModel: carModel,
        carLicense: carLicense,
      ));
    } catch (e) {
      emit(VehicleJournalsError(e.toString()));
    }
  }
}
