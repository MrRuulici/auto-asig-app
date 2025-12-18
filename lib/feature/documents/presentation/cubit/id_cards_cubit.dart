import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/data/http_data.dart';
import 'package:auto_asig/core/helpers/notification_helper.dart';
import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/core/models/reminder.dart';
import 'package:auto_asig/feature/documents/presentation/cubit/id_cards_state.dart';
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

    // Only create default notification if there are no notifications yet
    List<NotificationModel> notificationsToUse;
    
    if (state.notificationDates.isEmpty) {
      // First time setting expiration date - create default notification
      int notifId = await NotificationHelper.generateUniqueNotificationId();
      notificationsToUse = [
        NotificationModel(
          date: expirationDate.subtract(const Duration(days: 1)),
          sms: false,
          email: false,
          push: true,
          notificationId: notifId,
          monthBefore: false,
          weekBefore: false,
          dayBefore: true,
        )
      ];
    } else {
      // Already have notifications - adjust them to be before the new expiration date
      notificationsToUse = state.notificationDates
          .where((notification) => notification.date.isBefore(expirationDate))
          .toList();
      
      // If all notifications got filtered out, add a default one
      if (notificationsToUse.isEmpty) {
        int notifId = await NotificationHelper.generateUniqueNotificationId();
        notificationsToUse = [
          NotificationModel(
            date: expirationDate.subtract(const Duration(days: 1)),
            sms: false,
            email: false,
            push: true,
            notificationId: notifId,
            monthBefore: false,
            weekBefore: false,
            dayBefore: true,
          )
        ];
      }
    }

    print('Notifications to use: $notificationsToUse'); // Debug print

    emit(state.copyWith(
      expirationDate: expirationDate,
      notificationDates: notificationsToUse,
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

  Future<void> updateNotificationPeriods(
    int index,
    bool monthBefore,
    bool weekBefore,
    bool dayBefore,
    bool email,
    bool push,
  ) async {
    // Simply update the flags on the existing notification
    final updatedNotifications = List<NotificationModel>.from(state.notificationDates);
    
    // Just update the single notification with the selected flags
    updatedNotifications[index] = NotificationModel(
      date: state.expirationDate.subtract(const Duration(days: 1)), // Keep a reference date
      sms: false,
      email: email,
      push: push,
      notificationId: updatedNotifications[index].notificationId,
      monthBefore: monthBefore,
      weekBefore: weekBefore,
      dayBefore: dayBefore,
    );
    
    emit(state.copyWith(notificationDates: updatedNotifications));
  }

  void removeNotification(BuildContext context, int index) {
    final isEditing = state.notificationDates.length > 1;
    final updatedNotifications =
        List<NotificationModel>.from(state.notificationDates)..removeAt(index);

    if (isEditing || updatedNotifications.isNotEmpty) {
      emit(state.copyWith(notificationDates: updatedNotifications));
    } else {
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

    // DON'T expand - keep collapsed format
    // Convert to map format for Firestore
    List<Map<String, dynamic>> notificationsData = state.notificationDates
        .map((notification) => notification.toMap())
        .toList();

    Map<String, dynamic> ids = {
      'name': state.name,
      'exp': state.expirationDate,
      'notifications': notificationsData,
      'timestamp': FieldValue.serverTimestamp(),
    };

    id = await addReminderForUser(userId, ids, type);
    emit(state.copyWith(id: id));

    // Schedule local notifications based on flags
    await NotificationHelper.scheduleNotificationsFromCollapsed(
      documentType: _getReminderTypeName(type),
      documentInfo: state.name,
      expirationDate: state.expirationDate,
      notifications: state.notificationDates,
    );
  }

  void initializeForEdit(Reminder reminder) {
    emit(state.copyWith(
      name: reminder.title,
      expirationDate: reminder.expirationDate,
      notificationDates:
          List<NotificationModel>.from(reminder.notificationDates),
    ));
  }

  Future<void> update(String userId, String documentId, ReminderType type) async {
    // DON'T expand - keep collapsed format
    // Convert to map format for Firestore
    List<Map<String, dynamic>> notificationsData = state.notificationDates
        .map((notification) => notification.toMap())
        .toList();

    // Prepare data for updating
    Map<String, dynamic> updatedData = {
      'name': state.name,
      'exp': state.expirationDate,
      'notifications': notificationsData,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await updateTheReminderForUser(userId, documentId, updatedData, type);
    emit(state.copyWith(id: documentId));

    // Schedule local notifications based on flags
    await NotificationHelper.scheduleNotificationsFromCollapsed(
      documentType: _getReminderTypeName(type),
      documentInfo: state.name,
      expirationDate: state.expirationDate,
      notifications: state.notificationDates,
    );
  }

  void clearReminderData() {
    emit(state.copyWith(
      name: '',
      expirationDate: DateTime.now(),
      notificationDates: [],
    ));
  }

  String _getReminderTypeName(ReminderType type) {
    switch (type) {
      case ReminderType.idCard:
        return 'Carte de identitate';
      case ReminderType.drivingLicense:
        return 'Permis';
      case ReminderType.passport:
        return 'Pașaport';
    }
  }
}