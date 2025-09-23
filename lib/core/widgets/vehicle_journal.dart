import 'package:auto_asig/core/models/vehicle_jorunal_model.dart';

class VehicleJournal {
  String journalId;
  String vehicleId;
  List<JournalEntry> entries;

  VehicleJournal({
    required this.journalId,
    required this.vehicleId,
    required this.entries,
  });

  static fromJson(Map<String, dynamic> data, String vehicleId) {
    return VehicleJournal(vehicleId: vehicleId, journalId: '', entries: []

        // TODO - IMPLEMENT!

        // entries: data['entries']
        //     .map<JournalEntry>((entry) => JournalEntry(
        //           entryId: entry['entryId'],
        //           timestamp: entry['timestamp'],
        //           type: entry['type'],
        //           date: entry['date'],
        //           kms: entry['kms'],
        //         ))
        //     .toList(),
        );
  }
}
