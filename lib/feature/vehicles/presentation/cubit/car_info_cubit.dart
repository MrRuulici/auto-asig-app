import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/data/http_data.dart';
import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/core/models/vehicle_jorunal_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'car_info_state.dart';

class CarInfoCubit extends Cubit<CarInfoState> {
  CarInfoCubit() : super(const CarInfoState(carNr: '', vehicleModel: ''));

  // Update expiration date methods
  void updateExpirationDateRCA(DateTime? date) {
    emit(state.copyWith(expirationDateRCA: date));
  }

  void updateExpirationDateITP(DateTime? date) {
    emit(state.copyWith(expirationDateITP: date));
  }

  void updateExpirationDateCASCO(DateTime? date) {
    emit(state.copyWith(expirationDateCASCO: date));
  }

  void updateExpirationDateRovinieta(DateTime? date) {
    emit(state.copyWith(expirationDateRovinieta: date));
  }

  void updateExpirationDateTahograf(DateTime? date) {
    emit(state.copyWith(expirationDateTahograf: date));
  }

  // Update car number
  void updateCarNumber(String value) {
    emit(state.copyWith(carNr: value));
  }

  // Update vehicle model
  void updateVehicleModel(String value) {
    emit(state.copyWith(vehicleModel: value));
  }

  // Add Notification
  void addNotification(
    VehicleNotificationType type,
    DateTime date,
    bool sms,
    bool email,
    bool push,
    int notificationId,
  ) {
    final updatedNotifications =
        List<NotificationModel>.from(_getNotificationsList(type))
          ..add(NotificationModel(
            date: date,
            sms: sms,
            email: email,
            push: push,
            notificationId: notificationId,
          ));
    _updateNotificationsList(type, updatedNotifications);

    // Print the updated list to verify addition
    print('Updated Notifications List for $type: $updatedNotifications');
  }

  void updateNotification(
    VehicleNotificationType type,
    int index,
    DateTime date,
    bool sms,
    bool email,
    bool push,
    int notificationId,
  ) {
    final updatedNotifications =
        List<NotificationModel>.from(_getNotificationsList(type));

    if (index < 0 || index >= updatedNotifications.length) {
      print("Error: Attempted to update notification at invalid index $index.");
      return;
    }

    updatedNotifications[index] = NotificationModel(
        date: date,
        sms: sms,
        email: email,
        push: push,
        notificationId: notificationId);
    _updateNotificationsList(type, updatedNotifications);

    // Print to verify the updated state of the list
    print(
        'Updated Notifications List after modification: $updatedNotifications');
  }

  // Remove Notification
  void removeNotification(VehicleNotificationType type, int index) {
    final updatedNotifications =
        List<NotificationModel>.from(_getNotificationsList(type))
          ..removeAt(index);
    _updateNotificationsList(type, updatedNotifications);
  }

  void clearSelectedDate(VehicleNotificationType type) {
    switch (type) {
      case VehicleNotificationType.ITP:
        // emit(state.copyWith(expirationDateITP: null, notificationsITP: []));
        emit(state.clearSelectedExpirationDates(clearITP: true));
        break;
      case VehicleNotificationType.RCA:
        emit(state.clearSelectedExpirationDates(clearRCA: true));
        break;
      case VehicleNotificationType.CASCO:
        emit(state.clearSelectedExpirationDates(clearCASCO: true));
        break;
      case VehicleNotificationType.Rovinieta:
        emit(state.clearSelectedExpirationDates(clearRovinieta: true));
        break;
      case VehicleNotificationType.Tahograf:
        emit(state.clearSelectedExpirationDates(clearTahograf: true));
        break;
    }
  }

  // Helper to get the list of notifications based on type
  List<NotificationModel> _getNotificationsList(VehicleNotificationType type) {
    switch (type) {
      case VehicleNotificationType.ITP:
        return state.notificationsITP;
      case VehicleNotificationType.RCA:
        return state.notificationsRCA;
      case VehicleNotificationType.CASCO:
        return state.notificationsCASCO;
      case VehicleNotificationType.Rovinieta:
        return state.notificationsRovinieta;
      case VehicleNotificationType.Tahograf:
        return state.notificationsTahograf;
    }
  }

  // Helper to update state with the modified list of notifications
  void _updateNotificationsList(VehicleNotificationType type,
      List<NotificationModel> updatedNotifications) {
    switch (type) {
      case VehicleNotificationType.ITP:
        emit(state.copyWith(notificationsITP: updatedNotifications));
        break;
      case VehicleNotificationType.RCA:
        emit(state.copyWith(notificationsRCA: updatedNotifications));
        break;
      case VehicleNotificationType.CASCO:
        emit(state.copyWith(notificationsCASCO: updatedNotifications));
        break;
      case VehicleNotificationType.Rovinieta:
        emit(state.copyWith(notificationsRovinieta: updatedNotifications));
        break;
      case VehicleNotificationType.Tahograf:
        emit(state.copyWith(notificationsTahograf: updatedNotifications));
        break;
    }
  }

  // Add Car logic
  Future<bool> addCar(String userId) async {
    print('Adding car info for user: $userId');
    print('Car number: ${state.carNr}');
    print('Vehicle model: ${state.vehicleModel}');
    print('RCA expiration date: ${state.expirationDateRCA}');
    print('ITP expiration date: ${state.expirationDateITP}');
    print('CASCO expiration date: ${state.expirationDateCASCO}');
    print('Rovinieta expiration date: ${state.expirationDateRovinieta}');
    print('Tahograf expiration date: ${state.expirationDateTahograf}');

    // Check if at least one expiration date is provided
    if (state.expirationDateRCA == null &&
        state.expirationDateITP == null &&
        state.expirationDateCASCO == null &&
        state.expirationDateRovinieta == null &&
        state.expirationDateTahograf == null) {
      return false;
    }

    // Build the structured data with expiration dates and notifications
    Map<String, dynamic> carInfo = {
      'carNr': state.carNr,
      'vehicleModel': state.vehicleModel,
      'expirationDates': {
        'RCA': {
          'date': state.expirationDateRCA,
          'notifications': state.notificationsRCA
              .map((notification) => {
                    'date': notification.date,
                    'sms': notification.sms,
                    'email': notification.email,
                    'push': notification.push,
                    'notifId': notification.notificationId,
                  })
              .toList(),
        },
        'ITP': {
          'date': state.expirationDateITP,
          'notifications': state.notificationsITP
              .map((notification) => {
                    'date': notification.date,
                    'sms': notification.sms,
                    'email': notification.email,
                    'push': notification.push,
                    'notifId': notification.notificationId,
                  })
              .toList(),
        },
        'CASCO': {
          'date': state.expirationDateCASCO,
          'notifications': state.notificationsCASCO
              .map((notification) => {
                    'date': notification.date,
                    'sms': notification.sms,
                    'email': notification.email,
                    'push': notification.push,
                    'notifId': notification.notificationId,
                  })
              .toList(),
        },
        'Rovinieta': {
          'date': state.expirationDateRovinieta,
          'notifications': state.notificationsRovinieta
              .map((notification) => {
                    'date': notification.date,
                    'sms': notification.sms,
                    'email': notification.email,
                    'push': notification.push,
                    'notifId': notification.notificationId,
                  })
              .toList(),
        },
        'Tahograf': {
          'date': state.expirationDateTahograf,
          'notifications': state.notificationsTahograf
              .map((notification) => {
                    'date': notification.date,
                    'sms': notification.sms,
                    'email': notification.email,
                    'push': notification.push,
                    'notifId': notification.notificationId,
                  })
              .toList(),
        },
      },
    };

    Map<String, dynamic> distributionJournal = {};
    Map<String, dynamic> breaksJournal = {};
    Map<String, dynamic> serviceJournal = {};

    if (state.distributionJournalEntry != null) {
      distributionJournal = {
        'entryId': '',
        'name': state.distributionJournalEntry!.name,
        'kms': state.distributionJournalEntry!.kms,
        'timestamp': DateTime.now() as Timestamp,
        'date': DateTime.now(),
        'type': JournalEntryType.distribution,
      };
    }

    if (state.breaksJournalEntry != null) {
      breaksJournal = {
        'entryId': '',
        'name': state.breaksJournalEntry!.name,
        'kms': state.breaksJournalEntry!.kms,
        'timestamp': DateTime.now() as Timestamp,
        'date': DateTime.now(),
        'type': JournalEntryType.breaks,
      };
    }

    if (state.serviceJournalEntry != null) {
      serviceJournal = {
        'entryId': '',
        'name': 'Service',
        'kms': 0,
        'timestamp': DateTime.now() as Timestamp,
        'date': DateTime.now(),
        'type': JournalEntryType.service,
      };
    }

    // Call the function to add vehicle data, passing structured carInfo
    await addVehicleDataForUser(
      userId: userId,
      carInfo: carInfo,
      distributionJournal: distributionJournal,
      breaksJournal: breaksJournal,
      serviceJournal: serviceJournal,
    );
    return true;
  }

  void clearCarInfo() {
    emit(state.clearSelectedExpirationDates(
      clearRCA: true,
      clearITP: true,
      clearCASCO: true,
      clearRovinieta: true,
      clearTahograf: true,
    ));
  }
}
