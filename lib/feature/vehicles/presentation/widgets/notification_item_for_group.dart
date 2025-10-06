import 'package:auto_asig/core/models/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatefulWidget {
  final NotificationModel notification;
  final ValueChanged<NotificationModel> onUpdate;
  final VoidCallback onDelete;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  late DateTime selectedDate;
  late bool sms;
  late bool push;
  late bool email;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.notification.date;
    sms = widget.notification.sms;
    push = widget.notification.push;
    email = widget.notification.email;
  }

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
      widget.onUpdate(
        widget.notification.copyWith(date: selectedDate),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('Data: ${selectedDate.toString().split(' ')[0]}'),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _pickDate,
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: sms,
                  onChanged: (value) {
                    setState(() {
                      sms = value ?? false;
                    });
                    widget.onUpdate(
                      widget.notification.copyWith(sms: sms),
                    );
                  },
                ),
                const Text('SMS'),
                Checkbox(
                  value: push,
                  onChanged: (value) {
                    setState(() {
                      push = value ?? false;
                    });
                    widget.onUpdate(
                      widget.notification.copyWith(push: push),
                    );
                  },
                ),
                const Text('Push'),
                Checkbox(
                  value: email,
                  onChanged: (value) {
                    setState(() {
                      email = value ?? false;
                    });
                    widget.onUpdate(
                      widget.notification.copyWith(email: email),
                    );
                  },
                ),
                const Text('Email'),
              ],
            ),
            ElevatedButton(
              onPressed: widget.onDelete,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Șterge Notificare'),
            ),
          ],
        ),
      ),
    );
  }
}
