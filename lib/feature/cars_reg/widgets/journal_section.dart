import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/feature/cars_reg/widgets/journal_adding_widget.dart';
import 'package:flutter/material.dart';

class JournalSection extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final void Function() clearDate;
  final List<NotificationModel> notifications;
  final void Function(int) removeNotification;

  const JournalSection({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.clearDate,
    required this.notifications,
    required this.removeNotification,
    required Future<Null> Function() addLog,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController _nrKmController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JournalAddingWidget(
          label: label,
          onAdd: () {
            // DO SOMETHING
          },
        ),
        const SizedBox(height: 8),
        if (selectedDate != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                TextField(
                  controller: _nrKmController,
                  decoration: const InputDecoration(
                    labelText: 'Număr de kilometri',
                    hintText: 'Introduceți numărul de kilometri',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                // date picker
                const SizedBox(height: 8),
                Align(
                  alignment:
                      Alignment.centerLeft, // Align the button to the left
                  child: TextButton(
                    onPressed: clearDate,
                    child: const Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        Text(
                          'Șterge',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // add something else if needed
          // const SizedBox(height: 8),
        ],

        // Notifications list and add button
        for (int i = 0; i < notifications.length; i++)
          // NotificationItem(
          //   index: i,
          //   selectedDate: notifications[i].date,
          //   sms: notifications[i].sms,
          //   email: notifications[i].email,
          //   push: notifications[i].push,
          //   onNotificationUpdate: (date, sms, email, push) {
          //     context.read<CarInfoCubit>().updateNotification(
          //           type,
          //           i,
          //           date,
          //           sms,
          //           email,
          //           push,
          //           notifications[i].notificationId,
          //         );
          //   },
          //   onNotificationRemove: () => removeNotification(i),
          // ),
          if (selectedDate != null)
            TextButton.icon(
              onPressed: () {
                // if (selectedDate != null) {
                //   addNotification(
                //     selectedDate!.subtract(const Duration(days: 1)),
                //     false,
                //     false,
                //     true,
                //   );
                // }
              },
              icon: const Icon(
                Icons.add,
                color: Colors.indigoAccent,
              ),
              label: const Text(
                'Adaugă înregistrare',
                style: TextStyle(
                  color: Colors.indigoAccent,
                  // color: logoBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.add,
            // color: Colors.indigoAccent,
            // color: logoBlue,
            color: Colors.indigoAccent,
          ),
          label: const Text(
            'Adaugă înregistrare',
            style: TextStyle(
              color: Colors.indigoAccent,
              // color: logoBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
