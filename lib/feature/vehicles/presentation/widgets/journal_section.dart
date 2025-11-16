import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/models/vehicle_jorunal_model.dart';
import 'package:auto_asig/feature/vehicles/presentation/widgets/journal_adding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class JournalSection extends StatelessWidget {
  final String label;
  final JournalEntryType type;
  final List<JournalEntry> entries;
  final Function(JournalEntryType, DateTime, int) onAddEntry;
  final Function(JournalEntryType, String) onRemoveEntry;

  const JournalSection({
    super.key,
    required this.label,
    required this.type,
    required this.entries,
    required this.onAddEntry,
    required this.onRemoveEntry,
  });

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: buttonBlue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && context.mounted) {
      _showKilometersDialog(context, pickedDate);
    }
  }

  Future<void> _showKilometersDialog(BuildContext context, DateTime date) async {
    final TextEditingController kmController = TextEditingController();
    
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Adaugă $label'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data: ${DateFormat('dd.MM.yyyy').format(date)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: kmController,
                decoration: InputDecoration(
                  labelText: 'Număr de kilometri',
                  hintText: 'Introduceți numărul de kilometri',
                  filled: true,
                  fillColor: textFieldGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                autofocus: false,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Anulează'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBlue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (kmController.text.isNotEmpty) {
                  final kilometers = int.parse(kmController.text);
                  onAddEntry(type, date, kilometers);
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Adaugă'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JournalAddingWidget(
          label: label,
          onAdd: () => _showDatePicker(context),
        ),
        const SizedBox(height: 8),
        
        // Display existing entries
        if (entries.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 8),
            child: Column(
              children: entries.map((entry) {
                return _JournalEntryItem(
                  entry: entry,
                  onDelete: () => onRemoveEntry(type, entry.entryId),
                );
              }).toList(),
            ),
          ),
        ],
        
        // Add entry button
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextButton.icon(
            onPressed: () => _showDatePicker(context),
            icon: const Icon(
              Icons.add,
              color: buttonBlue,
            ),
            label: const Text(
              'Adaugă înregistrare',
              style: TextStyle(
                color: buttonBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _JournalEntryItem extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onDelete;

  const _JournalEntryItem({
    required this.entry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: buttonBlue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('dd.MM.yyyy').format(entry.date),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.speed,
                        size: 16,
                        color: buttonBlue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${entry.kms} km',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 22,
              ),
              onPressed: onDelete,
              tooltip: 'Șterge',
            ),
          ],
        ),
      ),
    );
  }
}