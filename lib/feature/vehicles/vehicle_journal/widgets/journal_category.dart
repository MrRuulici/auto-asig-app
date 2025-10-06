import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/data/http_data.dart';
import 'package:auto_asig/core/models/vehicle_jorunal_model.dart';
import 'package:auto_asig/feature/vehicles/vehicle_journal/cubit/edit_journal_entry_cubit.dart';
import 'package:auto_asig/feature/vehicles/vehicle_journal/screens/edit_journal_entry_screen.dart';
import 'package:auto_asig/feature/vehicles/vehicle_journal/widgets/journal_entry_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class JournalCategory extends StatefulWidget {
  final String vehicleId;
  final List<JournalEntry> entries;
  final JournalEntryType type;

  const JournalCategory({
    Key? key,
    required this.vehicleId,
    required this.entries,
    required this.type,
  }) : super(key: key);

  @override
  State<JournalCategory> createState() => _JournalCategoryState();
}

class _JournalCategoryState extends State<JournalCategory> {
  late List<JournalEntry> _entries;

  @override
  void initState() {
    super.initState();
    _entries = List.from(widget.entries); // Clone the entries list
  }

  void _addEntry(JournalEntry newEntry) {
    setState(() {
      _entries.add(newEntry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        _getJournalTypeName(widget.type),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        ..._entries.map((entry) {
          return JournalEntryItem(
            entry: entry,
            vehicleId: widget.vehicleId,
            onEdit: () {},
            onDelete: () {
              setState(() {
                _entries.remove(entry);
              });
            },
          );
        }).toList(),
        ListTile(
          title: const Text('Adaugă Înregistrare'),
          leading: const Icon(Icons.add),
          onTap: () async {
            JournalEntry entry = JournalEntry(
              entryId: '',
              name: '',
              createdAt: Timestamp.now(),
              editedAt: Timestamp.now(),
              type: widget.type,
              date: DateTime.now(),
              kms: 0,
            );

            context.read<EditJournalEntryCubit>().initializeEntry(
                  entry,
                  widget.vehicleId,
                );

            final result = await context.push<JournalEntry>(
              EditJournalEntryScreen.absolutePath,
              extra: entry,
            );

            if (result != null) {
              _addEntry(result);
            }
          },
        ),
      ],
    );
  }

  String _getJournalTypeName(JournalEntryType type) {
    switch (type) {
      case JournalEntryType.breaks:
        return 'Jurnal Frâne';
      case JournalEntryType.distribution:
        return 'Jurnal Distribuție';
      case JournalEntryType.service:
        return 'Jurnal Service';
      case JournalEntryType.other:
        return 'Alte Jurnale';
      default:
        return 'Jurnal';
    }
  }
}


// class JournalCategory extends StatelessWidget {
//   const JournalCategory({
//     super.key,
//     required this.type,
//     required this.entries,
//     required this.vehicleId,
//   });

//   final JournalEntryType type;
//   final List<JournalEntry> entries;
//   final String vehicleId;

//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       title: Text(
//         _getJournalTypeName(type),
//         style: const TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       children: [
//         // Add Entry Button as the first child
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           child: ElevatedButton.icon(
//             onPressed: () async {
//               // Create a new JournalEntry with default values
//               final newEntry = JournalEntry(
//                 entryId: '', // Firestore can auto-generate this later
//                 name: '',
//                 createdAt: Timestamp.now(),
//                 editedAt: Timestamp.now(),
//                 type: type,
//                 date: DateTime.now(),
//                 kms: 0,
//               );

//               // Initialize the cubit with the new entry
//               context
//                   .read<EditJournalEntryCubit>()
//                   .initializeEntry(newEntry, vehicleId);

//               // Navigate to the EditJournalEntryScreen
//               final result = await context.push<JournalEntry>(
//                 EditJournalEntryScreen.absolutePath,
//                 extra: newEntry,
//               );

//               // Handle the result if a new entry is added
//               if (result != null) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                       content: Text('Intrarea a fost adăugată cu succes.')),
//                 );

//                 // Add the result to the entries list dynamically
//                 entries.add(result);
//               }
//             },
//             icon: const Icon(Icons.add, size: 16),
//             label: const Text('Adaugă Intrare'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ),
//         // Existing entries
//         ...entries.map((entry) {
//           return JournalEntryItem(
//             entry: entry,
//             onEdit: () async {
//               // Initialize the cubit with the selected entry
//               context
//                   .read<EditJournalEntryCubit>()
//                   .initializeEntry(entry, vehicleId);

//               // Navigate to the EditJournalEntryScreen for editing the entry
//               final result =
//                   await context.push(EditJournalEntryScreen.absolutePath);

//               if (result is JournalEntry) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Intrarea a fost editată cu succes.'),
//                   ),
//                 );
//                 // Optionally, trigger a UI update here by refreshing the list
//               }
//             },
//             onDelete: () async {
//               final userId = context.read<UserDataCubit>().state.member.id;

//               // Display loading indicator
//               await showDialog(
//                 context: context,
//                 builder: (context) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 },
//               );

//               bool res = await deleteJournalEntry(
//                 userId: userId,
//                 vehicleId: vehicleId,
//                 entry: entry,
//               );

//               context.pop();

//               if (res) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Intrarea a fost ștearsă.'),
//                   ),
//                 );
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Eroare la ștergerea intrării.'),
//                   ),
//                 );
//               }
//             },
//             vehicleId: vehicleId,
//           );
//         }).toList(),
//       ],
//     );
//   }

//   // Function to get journal type name
//   String _getJournalTypeName(JournalEntryType type) {
//     switch (type) {
//       case JournalEntryType.breaks:
//         return 'Jurnal Frâne';
//       case JournalEntryType.distribution:
//         return 'Jurnal Distribuție';
//       case JournalEntryType.service:
//         return 'Jurnal Service';
//       case JournalEntryType.other:
//         return 'Alte Jurnale';
//       default:
//         return 'Jurnal';
//     }
//   }
// }
