import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/data/http_data.dart';
import 'package:auto_asig/core/helpers/notification_helper.dart';
import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/core/models/reminder.dart';
import 'package:auto_asig/feature/documents/cubit/id_cards_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IdCardsCubit extends Cubit<IdCardsState> {
  IdCardsCubit() : super(IdCardsInitial());

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  Future<void> updateExpirationDate(DateTime? expirationDate) async {
    if (expirationDate == null || expirationDate == state.expirationDate) {
      return;
    }

    print('New expiration date: $expirationDate'); // Debug print

    // Adjust notifications to ensure they are before the expiration date
    final adjustedNotifications = state.notificationDates
        .where((notification) => notification.date.isBefore(expirationDate))
        .toList();

    print(
        'Adjusted notifications: $adjustedNotifications with notificationId 000000'); // Debug print

    int notifId = await NotificationHelper.generateUniqueNotificationId();

    emit(state.copyWith(
      expirationDate: expirationDate,
      notificationDates: adjustedNotifications.isNotEmpty
          ? adjustedNotifications
          : [
              NotificationModel(
                date: expirationDate.subtract(const Duration(days: 1)),
                sms: false,
                email: false,
                push: true,
                notificationId: notifId,
              )
            ], // Default one day before expiration with push enabled
    ));

    print('New state emitted: ${state.expirationDate}'); // Debug print
  }

  void updateNotification(int index, NotificationModel updatedNotification) {
    if (updatedNotification.date.isBefore(DateTime.now()) ||
        updatedNotification.date.isAfter(state.expirationDate)) {
      return;
    }

    final updatedNotifications =
        List<NotificationModel>.from(state.notificationDates);
    updatedNotifications[index] = updatedNotification;
    emit(state.copyWith(notificationDates: updatedNotifications));

    print('Notification at index $index updated to: $updatedNotification');
  }

  void addNotification(NotificationModel notification) {
    if (notification.date.isBefore(DateTime.now()) ||
        notification.date.isAfter(state.expirationDate)) {
      return; // Ensure notifications are within valid range
    }

    emit(state.copyWith(
      notificationDates: List.from(state.notificationDates)..add(notification),
    ));
  }

  // void removeNotification(BuildContext context, int index) {
  //   if (state.notificationDates.length <= 1) {
  //     // Show snackbar if trying to remove the last notification
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Trebuie sa ai cel puțin o notificare adăugată'),
  //       ),
  //     );
  //     return;
  //   }

  //   final updatedNotifications =
  //       List<NotificationModel>.from(state.notificationDates)..removeAt(index);

  //   emit(state.copyWith(notificationDates: updatedNotifications));
  // }

  void removeNotification(BuildContext context, int index) {
    final isEditing = state.notificationDates.length >
        1; // Editing mode: more than one notification
    final updatedNotifications =
        List<NotificationModel>.from(state.notificationDates)..removeAt(index);

    // If editing mode or more than one notification exists, allow removal
    if (isEditing || updatedNotifications.isNotEmpty) {
      emit(state.copyWith(notificationDates: updatedNotifications));
    } else {
      // Show snackbar if trying to remove the last notification when adding a new reminder
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trebuie sa ai cel puțin o notificare adăugată'),
        ),
      );
    }
  }

  void reset() {
    emit(IdCardsInitial());
  }

  Future<void> save(String userId, ReminderType type) async {
    String id = '';

    // Convert List<NotificationModel> to a format compatible with Firestore
    List<Map<String, dynamic>> notificationsData = state.notificationDates
        .map((notification) => {
              'date': Timestamp.fromDate(notification.date),
              'sms': notification.sms,
              'email': notification.email,
              'push': notification.push,
              'notifId': notification.notificationId,
            })
        .toList();

    // Prepare data for saving
    Map<String, dynamic> ids = {
      'name': state.name,
      'exp': state.expirationDate,
      'notifications': notificationsData,
      'timestamp': FieldValue.serverTimestamp(),
    };

    id = await addReminderForUser(userId, ids, type);
    // update the reminder id
    emit(state.copyWith(id: id));
  }

  void initializeForEdit(Reminder reminder) {
    emit(state.copyWith(
      name: reminder.title,
      expirationDate: reminder.expirationDate,
      notificationDates:
          List<NotificationModel>.from(reminder.notificationDates),
    ));
  }

  Future<void> update(String userId, String documentId, type) async {
    // Convert List<NotificationModel> to a format compatible with Firestore
    List<Map<String, dynamic>> notificationsData = state.notificationDates
        .map((notification) => {
              'date': Timestamp.fromDate(notification.date),
              'sms': notification.sms,
              'email': notification.email,
              'push': notification.push,
              'notifId': notification.notificationId,
            })
        .toList();

    // Prepare data for updating
    Map<String, dynamic> updatedData = {
      'name': state.name,
      'exp': state.expirationDate,
      'notifications': notificationsData,
      'timestamp': FieldValue
          .serverTimestamp(), // Optional: Update timestamp to current time
    };

    // Use the update function to modify the document with the given ID
    await updateTheReminderForUser(userId, documentId, updatedData, type);

    // Optionally, emit a state if needed to reflect that the document was updated
    emit(state.copyWith(id: documentId));
  }

  void clearReminderData() {
    emit(state.copyWith(
      name: '',
      expirationDate: DateTime.now(),
      notificationDates: [],
    ));
  }
}
