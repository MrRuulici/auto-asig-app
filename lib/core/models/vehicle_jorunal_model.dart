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
}
