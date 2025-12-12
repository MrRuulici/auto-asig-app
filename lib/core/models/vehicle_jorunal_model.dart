import 'package:auto_asig/core/data/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JournalEntry {
  final String entryId;
  final Timestamp createdAt;
  final Timestamp editedAt;
  final JournalEntryType type;
  DateTime date;
  int kms;
  String name;

  JournalEntry({
    required this.entryId,
    required this.name,
    required this.createdAt,
    required this.editedAt,
    required this.type,
    required this.date,
    required this.kms,
  });
  
  JournalEntry copyWith({
    String? entryId,
    Timestamp? createdAt,
    Timestamp? editedAt,
    JournalEntryType? type,
    DateTime? date,
    int? kms,
    String? name,
  }) {
    return JournalEntry(
      entryId: entryId ?? this.entryId,
      createdAt: createdAt ?? this.createdAt,
      editedAt: editedAt ?? this.editedAt,
      type: type ?? this.type,
      date: date ?? this.date,
      kms: kms ?? this.kms,
      name: name ?? this.name,
    );
  }

  // Add toMap method
  Map<String, dynamic> toMap() {
    return {
      'entryId': entryId,
      'name': name,
      'createdAt': createdAt,
      'editedAt': editedAt,
      'type': type.toString(), // Convert enum to string
      'date': Timestamp.fromDate(date),
      'kms': kms,
    };
  }

  // Add fromMap method
  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      entryId: map['entryId'] ?? '',
      name: map['name'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      editedAt: map['editedAt'] ?? Timestamp.now(),
      type: _journalEntryTypeFromString(map['type']),
      date: (map['date'] as Timestamp).toDate(),
      kms: map['kms'] ?? 0,
    );
  }

  // Helper method to convert string back to enum
  static JournalEntryType _journalEntryTypeFromString(String? typeString) {
    if (typeString == null) return JournalEntryType.values.first;
    
    return JournalEntryType.values.firstWhere(
      (e) => e.toString() == typeString,
      orElse: () => JournalEntryType.values.first,
    );
  }
}