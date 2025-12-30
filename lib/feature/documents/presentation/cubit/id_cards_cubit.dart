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

    print('📅 New expiration date: $expirationDate');

    List<NotificationModel> notificationsToUse;
    
    if (state.notificationDates.isEmpty) {
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
      print('🔔 Created default notification with ID: $notifId');
    } else {
      notificationsToUse = state.notificationDates;
      print('🔔 Keeping existing notifications');
    }

    emit(state.copyWith(
      expirationDate: expirationDate,
      notificationDates: notificationsToUse,
    ));
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

    print('✏️ Notification at index $index updated');
  }

  void addNotification(NotificationModel notification) {
    if (notification.date.isBefore(DateTime.now()) ||
        notification.date.isAfter(state.expirationDate)) {
      return;
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
    final updatedNotifications = List<NotificationModel>.from(state.notificationDates);
    
    updatedNotifications[index] = NotificationModel(
      date: state.expirationDate,
      sms: false,
      email: email,
      push: push,
      notificationId: updatedNotifications[index].notificationId,
      monthBefore: monthBefore,
      weekBefore: weekBefore,
      dayBefore: dayBefore,
    );
    
    print('🔔 Updated notification - Month: $monthBefore, Week: $weekBefore, Day: $dayBefore, Push: $push, Email: $email');
    
    emit(state.copyWith(notificationDates: updatedNotifications));
  }

  void removeNotification(BuildContext context, int index) {
    final isEditing = state.notificationDates.length > 1;
    final updatedNotifications =
        List<NotificationModel>.from(state.notificationDates)..removeAt(index);

    if (isEditing || updatedNotifications.isNotEmpty) {
      emit(state.copyWith(notificationDates: updatedNotifications));
      print('🗑️ Removed notification at index $index');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trebuie să ai cel puțin o notificare adăugată'),
        ),
      );
    }
  }

  void reset() {
    emit(IdCardsInitial());
    print('🔄 State reset');
  }

  Future<void> save(
    String userId, 
    ReminderType type, {
    String? userEmail,
    String? userName,
  }) async {
    print('💾 Saving reminder...');
    
    String id = '';

    List<Map<String, dynamic>> notificationsData = state.notificationDates
        .map((notification) => notification.toMap())
        .toList();

    Map<String, dynamic> reminderData = {
      'name': state.name,
      'exp': state.expirationDate,
      'notifications': notificationsData,
      'timestamp': FieldValue.serverTimestamp(),
    };

    id = await addReminderForUser(userId, reminderData, type);
    emit(state.copyWith(id: id));
    print('✅ Reminder saved with ID: $id');

    // Schedule notifications (both push and email)
    try {
      await NotificationHelper.scheduleNotificationsFromCollapsed(
        documentType: _getReminderTypeName(type),
        documentInfo: state.name,
        expirationDate: state.expirationDate,
        notifications: state.notificationDates,
        userEmail: userEmail,
        userName: userName,
      );
      print('✅ Notifications scheduled successfully');
      
      final pending = await NotificationHelper.getPendingNotifications();
      print('📱 Total pending notifications: ${pending.length}');
    } catch (e) {
      print('❌ Error scheduling notifications: $e');
    }
  }

  void initializeForEdit(Reminder reminder) {
    print('✏️ Initializing for edit: ${reminder.title}');
    emit(state.copyWith(
      id: reminder.id,
      name: reminder.title,
      expirationDate: reminder.expirationDate,
      notificationDates:
          List<NotificationModel>.from(reminder.notificationDates),
    ));
  }

  Future<void> update(
    String userId, 
    String documentId, 
    ReminderType type, {
    String? userEmail,
    String? userName,
  }) async {
    print('💾 Updating reminder: $documentId');
    
    // Cancel old notifications
    try {
      for (var notification in state.notificationDates) {
        await NotificationHelper.cancelNotification(notification.notificationId);
      }
      print('🗑️ Cancelled old notifications');
    } catch (e) {
      print('⚠️ Error cancelling old notifications: $e');
    }

    List<Map<String, dynamic>> notificationsData = state.notificationDates
        .map((notification) => notification.toMap())
        .toList();

    Map<String, dynamic> updatedData = {
      'name': state.name,
      'exp': state.expirationDate,
      'notifications': notificationsData,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await updateTheReminderForUser(userId, documentId, updatedData, type);
    emit(state.copyWith(id: documentId));
    print('✅ Reminder updated in Firestore');

    // Schedule new notifications (both push and email)
    try {
      await NotificationHelper.scheduleNotificationsFromCollapsed(
        documentType: _getReminderTypeName(type),
        documentInfo: state.name,
        expirationDate: state.expirationDate,
        notifications: state.notificationDates,
        userEmail: userEmail,
        userName: userName,
      );
      print('✅ New notifications scheduled');
      
      final pending = await NotificationHelper.getPendingNotifications();
      print('📱 Total pending notifications: ${pending.length}');
    } catch (e) {
      print('❌ Error scheduling notifications: $e');
    }
  }

  Future<void> deleteReminder(
    String userId, 
    String documentId, 
    ReminderType type,
  ) async {
    print('🗑️ Deleting reminder: $documentId');
    
    try {
      for (var notification in state.notificationDates) {
        await NotificationHelper.cancelNotification(notification.notificationId);
      }
      print('✅ Cancelled all notifications for this reminder');
    } catch (e) {
      print('⚠️ Error cancelling notifications: $e');
    }
    
    await deleteReminderForUser(userId, documentId, type);
    print('✅ Reminder deleted from Firestore');
    
    reset();
  }

  void clearReminderData() {
    emit(state.copyWith(
      name: '',
      expirationDate: DateTime.now(),
      notificationDates: [],
    ));
    print('🧹 Reminder data cleared');
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