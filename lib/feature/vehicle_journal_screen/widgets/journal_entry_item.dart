import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/data/http_data.dart';
import 'package:auto_asig/core/models/vehicle_jorunal_model.dart';
import 'package:auto_asig/feature/vehicle_journal_screen/cubit/edit_journal_entry_cubit.dart';
import 'package:auto_asig/feature/vehicle_journal_screen/screens/edit_journal_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class JournalEntryItem extends StatefulWidget {
  const JournalEntryItem({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onDelete,
    required this.vehicleId,
    this.type = JournalEntryType.other,
  });

  final JournalEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final JournalEntryType type;
  final String vehicleId;

  @override
  State<JournalEntryItem> createState() => _JournalEntryItemState();
}

class _JournalEntryItemState extends State<JournalEntryItem> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            widget.entry.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data execuției: ${widget.entry.date.toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Nr kilometri (la data execuției): ${widget.entry.kms}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          trailing: Icon(
            _isExpanded ? Icons.expand_less : Icons.expand_more,
            size: 20,
          ),
          onTap: _toggleExpanded,
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Initialize the cubit with the entry before navigation
                      context.read<EditJournalEntryCubit>().initializeEntry(
                            widget.entry,
                            widget.vehicleId,
                          );

                      // Navigate to the EditJournalEntryScreen
                      final editEntryCubit =
                          context.read<EditJournalEntryCubit>();
                      editEntryCubit.updateType(widget.entry.type);

                      final result = await context.push(
                        EditJournalEntryScreen.absolutePath,
                        extra: widget.entry,
                      );

                      // if (result == true) {
                      //   // Refresh or reload data if editing was successful
                      //   print('Intrarea a fost editată cu succes.');
                      // }

                      if (result != null && result is JournalEntry) {
                        setState(() {
                          widget.entry.name = result.name;
                          widget.entry.date = result.date;
                          widget.entry.kms = result.kms;
                        });
                      }
                    },
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Editează'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: logoBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Spacing between buttons
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Show the confirmation dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirmă Ștergerea'),
                          content: const Text(
                            'Ești sigur că vrei să ștergi această intrare? Această acțiune este ireversibilă.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: const Text('Anulează'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final userId = context
                                    .read<UserDataCubit>()
                                    .state
                                    .member
                                    .id;

                                deleteJournalEntry(
                                  userId: userId,
                                  vehicleId: widget.vehicleId,
                                  entry: widget.entry,
                                );

                                widget.onDelete(); // Call the delete function
                                Navigator.pop(context); // Close the dialog
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Da, Șterge'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('Șterge'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
