import 'package:auto_asig/core/data/constants.dart';
import 'package:flutter/material.dart';

class JournalAddingWidget extends StatelessWidget {
  const JournalAddingWidget({
    super.key,
    required this.label,
    required this.onAdd,
  });

  final String label;
  final Function onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            // selectedDate != null
            //     ? DateFormat('dd.MM.yyyy').format(selectedDate!)
            //     :
            'Adaugă',
            style: const TextStyle(
              // fontSize: 16,
              color: buttonBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
