import 'package:auto_asig/core/models/vehicle_jorunal_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    return VehicleJournal(
      vehicleId: vehicleId, 
      journalId: '', 
      entries: []
      // TODO - IMPLEMENT!
    );
  }

  // Add toMap method
  Map<String, dynamic> toMap() {
    return {
      'journalId': journalId,
      'vehicleId': vehicleId,
      'entries': entries.map((entry) => entry.toMap()).toList(),
    };
  }

  // Add fromMap method
  factory VehicleJournal.fromMap(Map<String, dynamic> map) {
    return VehicleJournal(
      journalId: map['journalId'] ?? '',
      vehicleId: map['vehicleId'] ?? '',
      entries: (map['entries'] as List?)
          ?.map((entry) => JournalEntry.fromMap(entry as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}