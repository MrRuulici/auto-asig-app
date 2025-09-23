import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/feature/cars_reg/widgets/notification_item_for_group.dart';
import 'package:flutter/material.dart';

class NotificationGroup extends StatefulWidget {
  final String title;
  final List<NotificationModel> notifications;
  final ValueChanged<List<NotificationModel>> onNotificationsChanged;

  const NotificationGroup({
    super.key,
    required this.title,
    required this.notifications,
    required this.onNotificationsChanged,
  });

  @override
  State<NotificationGroup> createState() => _NotificationGroupState();
}

class _NotificationGroupState extends State<NotificationGroup> {
  late List<NotificationModel> notifications;

  @override
  void initState() {
    super.initState();
    notifications = List.from(widget.notifications);
  }

  void _addNotification() {
    setState(() {
      final newNotification = NotificationModel(
        date: DateTime.now(),
        sms: false,
        email: false,
        push: false,
        notificationId: DateTime.now().millisecondsSinceEpoch,
      );
      notifications.add(newNotification);
      widget.onNotificationsChanged(notifications);
    });
  }

  void _updateNotification(int index, NotificationModel updatedNotification) {
    setState(() {
      notifications[index] = updatedNotification;
      widget.onNotificationsChanged(notifications);
    });
  }

  void _removeNotification(int index) {
    setState(() {
      notifications.removeAt(index);
      widget.onNotificationsChanged(notifications);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            notifications.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return NotificationItem(
                        notification: notifications[index],
                        onUpdate: (updatedNotification) =>
                            _updateNotification(index, updatedNotification),
                        onDelete: () => _removeNotification(index),
                      );
                    },
                  )
                : const Text(
                    'Nu există notificări. Adaugă una nouă.',
                    style: TextStyle(color: Colors.grey),
                  ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _addNotification,
              icon: const Icon(Icons.add),
              label: const Text('Adaugă Notificare'),
            ),
          ],
        ),
      ),
    );
  }
}
