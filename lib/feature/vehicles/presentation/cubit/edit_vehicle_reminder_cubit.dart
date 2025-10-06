import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/data/http_data.dart';
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
  void updateExpirationDate({
    required VehicleNotificationType type,
    DateTime? date,
  }) {
    if (state.vehicleReminder == null) return;

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
    );

    emit(state.copyWith(vehicleReminder: updatedReminder));
  }

  /// Type-specific methods for updating expiration dates
  void updateExpirationDateITP(DateTime? date) =>
      updateExpirationDate(type: VehicleNotificationType.ITP, date: date);

  void updateExpirationDateRCA(DateTime? date) =>
      updateExpirationDate(type: VehicleNotificationType.RCA, date: date);

  void updateExpirationDateCASCO(DateTime? date) =>
      updateExpirationDate(type: VehicleNotificationType.CASCO, date: date);

  void updateExpirationDateRovinieta(DateTime? date) =>
      updateExpirationDate(type: VehicleNotificationType.Rovinieta, date: date);

  void updateExpirationDateTahograf(DateTime? date) =>
      updateExpirationDate(type: VehicleNotificationType.Tahograf, date: date);

  /// Adds a notification for a specific type
  void addNotification(
    VehicleNotificationType type,
    DateTime date,
    bool sms,
    bool email,
    bool push,
    int notificationId,
  ) {
    if (state.vehicleReminder == null) return;

    final notification = NotificationModel(
      date: date,
      sms: sms,
      email: email,
      push: push,
      notificationId: notificationId,
    );

    final updatedNotifications = _getNotificationsByType(type)
      ..add(notification);

    _updateNotifications(type, updatedNotifications);
  }

  /// Removes a notification by index for a specific type
  void removeNotification(VehicleNotificationType type, int index) {
    if (state.vehicleReminder == null) return;

    final updatedNotifications = List<NotificationModel>.from(
      _getNotificationsByType(type),
    )..removeAt(index);

    _updateNotifications(type, updatedNotifications);
  }

  /// Generates a unique notification ID
  Future<int> generateUniqueNotificationId() async {
    // Simulate unique ID generation
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// Saves the updated vehicle reminder (implement your save logic here)
  Future<void> saveChanges(String userId) async {
    // print the updated vehicle reminder
    print('Saving vehicle reminder: ${state.vehicleReminder}');

    updateVehicleReminder(
      userId,
      state.vehicleReminder!.id,
      state.vehicleReminder!,
    );
  }

  /// Helper: Updates notifications for a specific type
  void _updateNotifications(
      VehicleNotificationType type, List<NotificationModel> notifications) {
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
  List<NotificationModel> _getNotificationsByType(
      VehicleNotificationType type) {
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
}
