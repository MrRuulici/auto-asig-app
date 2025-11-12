import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/data/http_data.dart';
import 'package:auto_asig/core/helpers/notification_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_asig/core/models/vehicle_reminder.dart';
import 'package:auto_asig/core/models/notification_model.dart';
import 'edit_vehicle_reminder_state.dart';

class EditVehicleReminderCubit extends Cubit<EditVehicleReminderState> {
  EditVehicleReminderCubit()
      : super(const EditVehicleReminderState(vehicleReminder: null));

  /// Initialize the vehicle reminder
  void initializeReminder(VehicleReminder reminder) {
    emit(state.copyWith(vehicleReminder: reminder));
  }

  /// Updates the expiration date for a specific type
  Future<void> updateExpirationDate({
    required VehicleNotificationType type,
    DateTime? date,
  }) async {
    if (state.vehicleReminder == null) return;
    
    // Get current notifications for this type
    List<NotificationModel> currentNotifications = _getNotificationsByType(type);
    DateTime? currentExpirationDate = _getExpirationDateByType(type);
    
    // Determine notifications to use
    List<NotificationModel> notificationsToUse;
    
    if (date == null) {
      // Clearing the date - clear notifications too
      notificationsToUse = [];
    } else if (date == currentExpirationDate) {
      // No change in date
      return;
    } else if (currentNotifications.isEmpty) {
      // First time setting expiration date - create default notification
      int notifId = await NotificationHelper.generateUniqueNotificationId();
      notificationsToUse = [
        NotificationModel(
          date: date.subtract(const Duration(days: 1)),
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
      notificationsToUse = currentNotifications
          .where((notification) => notification.date.isBefore(date))
          .toList();
      
      if (notificationsToUse.isEmpty) {
        int notifId = await NotificationHelper.generateUniqueNotificationId();
        notificationsToUse = [
          NotificationModel(
            date: date.subtract(const Duration(days: 1)),
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

    final updatedReminder = state.vehicleReminder!.copyWith(
      expirationDateITP: type == VehicleNotificationType.ITP
          ? date
          : state.vehicleReminder!.expirationDateITP,
      expirationDateRCA: type == VehicleNotificationType.RCA
          ? date
          : state.vehicleReminder!.expirationDateRCA,
      expirationDateCASCO: type == VehicleNotificationType.CASCO
          ? date
          : state.vehicleReminder!.expirationDateCASCO,
      expirationDateRovinieta: type == VehicleNotificationType.Rovinieta
          ? date
          : state.vehicleReminder!.expirationDateRovinieta,
      expirationDateTahograf: type == VehicleNotificationType.Tahograf
          ? date
          : state.vehicleReminder!.expirationDateTahograf,
      notificationsITP: type == VehicleNotificationType.ITP
          ? notificationsToUse
          : state.vehicleReminder!.notificationsITP,
      notificationsRCA: type == VehicleNotificationType.RCA
          ? notificationsToUse
          : state.vehicleReminder!.notificationsRCA,
      notificationsCASCO: type == VehicleNotificationType.CASCO
          ? notificationsToUse
          : state.vehicleReminder!.notificationsCASCO,
      notificationsRovinieta: type == VehicleNotificationType.Rovinieta
          ? notificationsToUse
          : state.vehicleReminder!.notificationsRovinieta,
      notificationsTahograf: type == VehicleNotificationType.Tahograf
          ? notificationsToUse
          : state.vehicleReminder!.notificationsTahograf,
    );

    emit(state.copyWith(vehicleReminder: updatedReminder));
  }

  /// Type-specific methods for updating expiration dates
  Future<void> updateExpirationDateITP(DateTime? date) =>
      updateExpirationDate(type: VehicleNotificationType.ITP, date: date);

  Future<void> updateExpirationDateRCA(DateTime? date) =>
      updateExpirationDate(type: VehicleNotificationType.RCA, date: date);

  Future<void> updateExpirationDateCASCO(DateTime? date) =>
      updateExpirationDate(type: VehicleNotificationType.CASCO, date: date);

  Future<void> updateExpirationDateRovinieta(DateTime? date) =>
      updateExpirationDate(type: VehicleNotificationType.Rovinieta, date: date);

  Future<void> updateExpirationDateTahograf(DateTime? date) =>
      updateExpirationDate(type: VehicleNotificationType.Tahograf, date: date);

  /// Simplified notification update - just updates flags, doesn't create multiple notifications
  void updateNotificationPeriods(
    VehicleNotificationType type,
    int index,
    bool monthBefore,
    bool weekBefore,
    bool dayBefore,
    bool email,
    bool push,
  ) {
    if (state.vehicleReminder == null) return;

    List<NotificationModel> notifications = List<NotificationModel>.from(_getNotificationsByType(type));
    DateTime? expirationDate = _getExpirationDateByType(type);
    
    if (expirationDate == null || index >= notifications.length) return;
    
    // Simply update the flags on the existing notification
    notifications[index] = NotificationModel(
      date: expirationDate.subtract(const Duration(days: 1)), // Keep a reference date
      sms: false,
      email: email,
      push: push,
      notificationId: notifications[index].notificationId,
      monthBefore: monthBefore,
      weekBefore: weekBefore,
      dayBefore: dayBefore,
    );
    
    _updateNotifications(type, notifications);
  }

  /// Removes a notification by index for a specific type
  void removeNotification(VehicleNotificationType type, int index) {
    if (state.vehicleReminder == null) return;

    final updatedNotifications = List<NotificationModel>.from(
      _getNotificationsByType(type),
    )..removeAt(index);

    _updateNotifications(type, updatedNotifications);
  }

  /// Helper method to expand notifications based on flags
  Future<List<Map<String, dynamic>>> _expandNotifications(
    List<NotificationModel> notifications,
    DateTime? expirationDate,
  ) async {
    if (expirationDate == null) return [];
    
    List<NotificationModel> expandedNotifications = [];
    
    for (var notification in notifications) {
      if (notification.monthBefore ?? false) {
        final monthBeforeDate = expirationDate.subtract(const Duration(days: 30));
        if (monthBeforeDate.isAfter(DateTime.now())) {
          expandedNotifications.add(
            NotificationModel(
              date: monthBeforeDate,
              sms: false,
              email: notification.email,
              push: notification.push,
              notificationId: await NotificationHelper.generateUniqueNotificationId(),
              monthBefore: true,
              weekBefore: false,
              dayBefore: false,
            ),
          );
        }
      }
      
      if (notification.weekBefore ?? false) {
        final weekBeforeDate = expirationDate.subtract(const Duration(days: 7));
        if (weekBeforeDate.isAfter(DateTime.now())) {
          expandedNotifications.add(
            NotificationModel(
              date: weekBeforeDate,
              sms: false,
              email: notification.email,
              push: notification.push,
              notificationId: await NotificationHelper.generateUniqueNotificationId(),
              monthBefore: false,
              weekBefore: true,
              dayBefore: false,
            ),
          );
        }
      }
      
      if (notification.dayBefore ?? false) {
        final dayBeforeDate = expirationDate.subtract(const Duration(days: 1));
        if (dayBeforeDate.isAfter(DateTime.now())) {
          expandedNotifications.add(
            NotificationModel(
              date: dayBeforeDate,
              sms: false,
              email: notification.email,
              push: notification.push,
              notificationId: await NotificationHelper.generateUniqueNotificationId(),
              monthBefore: false,
              weekBefore: false,
              dayBefore: true,
            ),
          );
        }
      }
    }

    return expandedNotifications.map((n) => n.toMap()).toList();
  }

  /// Saves the updated vehicle reminder with expanded notifications
  Future<void> saveChanges(String userId) async {
    if (state.vehicleReminder == null) return;

    print('Saving vehicle reminder: ${state.vehicleReminder}');

    // Expand notifications for each type before saving
    final expandedITP = await _expandNotifications(
      state.vehicleReminder!.notificationsITP ?? [],
      state.vehicleReminder!.expirationDateITP,
    );
    final expandedRCA = await _expandNotifications(
      state.vehicleReminder!.notificationsRCA ?? [],
      state.vehicleReminder!.expirationDateRCA,
    );
    final expandedCASCO = await _expandNotifications(
      state.vehicleReminder!.notificationsCASCO ?? [],
      state.vehicleReminder!.expirationDateCASCO,
    );
    final expandedRovinieta = await _expandNotifications(
      state.vehicleReminder!.notificationsRovinieta ?? [],
      state.vehicleReminder!.expirationDateRovinieta,
    );
    final expandedTahograf = await _expandNotifications(
      state.vehicleReminder!.notificationsTahograf ?? [],
      state.vehicleReminder!.expirationDateTahograf,
    );

    // Create a copy with expanded notifications for saving
    final reminderToSave = state.vehicleReminder!.copyWith(
      notificationsITP: expandedITP.map((n) => NotificationModel.fromMap(n)).toList(),
      notificationsRCA: expandedRCA.map((n) => NotificationModel.fromMap(n)).toList(),
      notificationsCASCO: expandedCASCO.map((n) => NotificationModel.fromMap(n)).toList(),
      notificationsRovinieta: expandedRovinieta.map((n) => NotificationModel.fromMap(n)).toList(),
      notificationsTahograf: expandedTahograf.map((n) => NotificationModel.fromMap(n)).toList(),
    );

    await updateVehicleReminder(
      userId,
      reminderToSave.id,
      reminderToSave,
    );
  }

  /// Helper: Updates notifications for a specific type
  void _updateNotifications(
    VehicleNotificationType type,
    List<NotificationModel> notifications,
  ) {
    if (state.vehicleReminder == null) return;

    final updatedReminder = state.vehicleReminder!.copyWith(
      notificationsITP: type == VehicleNotificationType.ITP
          ? notifications
          : state.vehicleReminder!.notificationsITP,
      notificationsRCA: type == VehicleNotificationType.RCA
          ? notifications
          : state.vehicleReminder!.notificationsRCA,
      notificationsCASCO: type == VehicleNotificationType.CASCO
          ? notifications
          : state.vehicleReminder!.notificationsCASCO,
      notificationsRovinieta: type == VehicleNotificationType.Rovinieta
          ? notifications
          : state.vehicleReminder!.notificationsRovinieta,
      notificationsTahograf: type == VehicleNotificationType.Tahograf
          ? notifications
          : state.vehicleReminder!.notificationsTahograf,
    );

    emit(state.copyWith(vehicleReminder: updatedReminder));
  }

  /// Helper: Retrieves notifications for a specific type
  List<NotificationModel> _getNotificationsByType(VehicleNotificationType type) {
    switch (type) {
      case VehicleNotificationType.ITP:
        return state.vehicleReminder?.notificationsITP ?? [];
      case VehicleNotificationType.RCA:
        return state.vehicleReminder?.notificationsRCA ?? [];
      case VehicleNotificationType.CASCO:
        return state.vehicleReminder?.notificationsCASCO ?? [];
      case VehicleNotificationType.Rovinieta:
        return state.vehicleReminder?.notificationsRovinieta ?? [];
      case VehicleNotificationType.Tahograf:
        return state.vehicleReminder?.notificationsTahograf ?? [];
    }
  }

  /// Helper: Retrieves expiration date for a specific type
  DateTime? _getExpirationDateByType(VehicleNotificationType type) {
    switch (type) {
      case VehicleNotificationType.ITP:
        return state.vehicleReminder?.expirationDateITP;
      case VehicleNotificationType.RCA:
        return state.vehicleReminder?.expirationDateRCA;
      case VehicleNotificationType.CASCO:
        return state.vehicleReminder?.expirationDateCASCO;
      case VehicleNotificationType.Rovinieta:
        return state.vehicleReminder?.expirationDateRovinieta;
      case VehicleNotificationType.Tahograf:
        return state.vehicleReminder?.expirationDateTahograf;
    }
  }
}