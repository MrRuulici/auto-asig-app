import 'package:auto_asig/core/data/assistants.dart';
import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/feature/home/presentation/cubit/bottom_sheet_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomSheetNotification extends StatelessWidget {
  const BottomSheetNotification({
    super.key,
    required this.index,
    required this.notification,
    required this.nrOfNotifications,
  });

  final int index;
  final NotificationModel notification;
  final int nrOfNotifications;

  Widget _buildStatusIcon(bool value) {
    return SizedBox(
      width: 24,
      height: 24,
      child: value
          ? Image.asset(
              'assets/images/checkmark.png',
              width: 16,
              height: 16,
            )
          : Image.asset(
              'assets/images/checkmark_unchecked.png',
              width: 16,
              height: 16,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and delete button
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notificare',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                // IconButton(
                //   icon: const Icon(Icons.close, color: Colors.red),
                //   onPressed: () {
                //     if (nrOfNotifications <= 1) {
                //       Navigator.pop(context);
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //           content: Text('Trebuie să păstrezi cel puțin o notificare.'),
                //         ),
                //       );
                //       return;
                //     }

                //     // Show confirmation dialog
                //     showDeletionConfirmation(
                //       context,
                //       title: 'Șterge Notificare',
                //       content: 'Ești sigur că dorești să ștergi această notificare? Această acțiune este ireversibilă.',
                //       onConfirm: () {
                //         // Remove the notification
                //         context.read<BottomSheetDetailsCubit>().removeNotification(index);
                //       },
                //     );
                //   },
                // ),
              ],
            ),
            
            const Divider(),
            const SizedBox(height: 8),

            // Notification channels (Email, Push)
            const Text(
              'Tip notificare:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildStatusIcon(notification.email),
                const SizedBox(width: 8),
                const Text('Email'),
                const SizedBox(width: 16),
                _buildStatusIcon(notification.push),
                const SizedBox(width: 8),
                const Text('Push'),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // Notification timing (read-only with icons)
            const Text(
              'Dată notificări:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),

            // Month Before
            Row(
              children: [
                _buildStatusIcon(notification.monthBefore),
                const SizedBox(width: 8),
                const Text('Cu o lună înainte'),
              ],
            ),
            const SizedBox(height: 10),

            // Week Before
            Row(
              children: [
                _buildStatusIcon(notification.weekBefore),
                const SizedBox(width: 8),
                const Text('Cu o săptămână înainte'),
              ],
            ),
            const SizedBox(height: 10),

            // Day Before
            Row(
              children: [
                _buildStatusIcon(notification.dayBefore),
                const SizedBox(width: 8),
                const Text('Cu o zi înainte'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}