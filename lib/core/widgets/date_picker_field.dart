import 'package:auto_asig/core/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlliatDatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const AlliatDatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Old implementation
      // onTap: () async {
      //   final DateTime? pickedDate = await showDatePicker(
      //     context: context,
      //     initialDate: selectedDate ?? DateTime.now(),
      //     firstDate: DateTime.now(),
      //     lastDate: DateTime(2101),
      //   );
      //   if (pickedDate != null) {
      //     onDateSelected(pickedDate); // Pass the selected date
      //   }
      // },
      onTap: () async {
        DateTime now = DateTime.now();
        DateTime firstDate = now;

        // Use today as the default initial date if selectedDate is null
        DateTime initialDate =
            (selectedDate != null && selectedDate!.isAfter(firstDate))
                ? selectedDate!
                : firstDate;

        DateTime lastDate = DateTime(9999);

        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate, // Use adjusted initialDate
          firstDate: firstDate, // Set today as the minimum selectable date
          lastDate: lastDate,
        );

        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          // color: Colors.grey.shade100,
          color: textFieldGrey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              selectedDate != null
                  ? DateFormat('dd.MM.yyyy').format(selectedDate!)
                  : 'Adaugă',
              style: const TextStyle(
                // fontSize: 16,
                color: buttonBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
