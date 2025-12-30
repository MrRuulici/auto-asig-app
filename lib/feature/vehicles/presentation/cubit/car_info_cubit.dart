import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/data/http_data.dart';
import 'package:auto_asig/core/helpers/notification_helper.dart';
import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/core/models/vehicle_jorunal_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'car_info_state.dart';

class CarInfoCubit extends Cubit<CarInfoState> {
  CarInfoCubit() : super(const CarInfoState(carNr: '', vehicleModel: ''));

  // Reset to initial state
  void reset() {
    emit(const CarInfoState(carNr: '', vehicleModel: ''));
  }

  // Update car number
  void updateCarNumber(String value) {
    emit(state.copyWith(carNr: value));
  }

  // Update vehicle model
  void updateVehicleModel(String value) {
    emit(state.copyWith(vehicleModel: value));
  }

  // Update expiration date methods with automatic notification creation
  Future<void> updateExpirationDateITP(DateTime? date) async {
    if (date == null || date == state.expirationDateITP) {
      return;
    }

    List<NotificationModel> notificationsToUse;

    if (state.notificationsITP.isEmpty) {
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
      notificationsToUse = state.notificationsITP
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

    emit(state.copyWith(
      expirationDateITP: date,
      notificationsITP: notificationsToUse,
    ));
  }

  Future<void> updateExpirationDateRCA(DateTime? date) async {
    if (date == null || date == state.expirationDateRCA) {
      return;
    }

    List<NotificationModel> notificationsToUse;

    if (state.notificationsRCA.isEmpty) {
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
      notificationsToUse = state.notificationsRCA
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

    emit(state.copyWith(
      expirationDateRCA: date,
      notificationsRCA: notificationsToUse,
    ));
  }

  Future<void> updateExpirationDateCASCO(DateTime? date) async {
    if (date == null || date == state.expirationDateCASCO) {
      return;
    }

    List<NotificationModel> notificationsToUse;

    if (state.notificationsCASCO.isEmpty) {
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
      notificationsToUse = state.notificationsCASCO
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

    emit(state.copyWith(
      expirationDateCASCO: date,
      notificationsCASCO: notificationsToUse,
    ));
  }

  Future<void> updateExpirationDateRovinieta(DateTime? date) async {
    if (date == null || date == state.expirationDateRovinieta) {
      return;
    }

    List<NotificationModel> notificationsToUse;

    if (state.notificationsRovinieta.isEmpty) {
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
      notificationsToUse = state.notificationsRovinieta
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

    emit(state.copyWith(
      expirationDateRovinieta: date,
      notificationsRovinieta: notificationsToUse,
    ));
  }

  Future<void> updateExpirationDateTahograf(DateTime? date) async {
    if (date == null || date == state.expirationDateTahograf) {
      return;
    }

    List<NotificationModel> notificationsToUse;

    if (state.notificationsTahograf.isEmpty) {
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
      notificationsToUse = state.notificationsTahograf
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

    emit(state.copyWith(
      expirationDateTahograf: date,
      notificationsTahograf: notificationsToUse,
    ));
  }

  // Simplified notification update - just updates flags, doesn't create multiple notifications
  void updateNotificationPeriods(
    VehicleNotificationType type,
    int index,
    bool monthBefore,
    bool weekBefore,
    bool dayBefore,
    bool email,
    bool push,
  ) {
    List<NotificationModel> notifications;
    DateTime? expirationDate;

    // Get the appropriate notification list and expiration date
    switch (type) {
      case VehicleNotificationType.ITP:
        notifications = List<NotificationModel>.from(state.notificationsITP);
        expirationDate = state.expirationDateITP;
        break;
      case VehicleNotificationType.RCA:
        notifications = List<NotificationModel>.from(state.notificationsRCA);
        expirationDate = state.expirationDateRCA;
        break;
      case VehicleNotificationType.CASCO:
        notifications = List<NotificationModel>.from(state.notificationsCASCO);
        expirationDate = state.expirationDateCASCO;
        break;
      case VehicleNotificationType.Rovinieta:
        notifications =
            List<NotificationModel>.from(state.notificationsRovinieta);
        expirationDate = state.expirationDateRovinieta;
        break;
      case VehicleNotificationType.Tahograf:
        notifications =
            List<NotificationModel>.from(state.notificationsTahograf);
        expirationDate = state.expirationDateTahograf;
        break;
    }

    if (expirationDate == null) return;

    // Simply update the flags on the existing notification
    notifications[index] = NotificationModel(
      date: expirationDate
          .subtract(const Duration(days: 1)), // Keep a reference date
      sms: false,
      email: email,
      push: push,
      notificationId: notifications[index].notificationId,
      monthBefore: monthBefore,
      weekBefore: weekBefore,
      dayBefore: dayBefore,
    );

    // Emit the updated state based on type
    switch (type) {
      case VehicleNotificationType.ITP:
        emit(state.copyWith(notificationsITP: notifications));
        break;
      case VehicleNotificationType.RCA:
        emit(state.copyWith(notificationsRCA: notifications));
        break;
      case VehicleNotificationType.CASCO:
        emit(state.copyWith(notificationsCASCO: notifications));
        break;
      case VehicleNotificationType.Rovinieta:
        emit(state.copyWith(notificationsRovinieta: notifications));
        break;
      case VehicleNotificationType.Tahograf:
        emit(state.copyWith(notificationsTahograf: notifications));
        break;
    }
  }

  // Remove Notification (kept for compatibility)
  void removeNotification(VehicleNotificationType type, int index) {
    final updatedNotifications =
        List<NotificationModel>.from(_getNotificationsList(type))
          ..removeAt(index);
    _updateNotificationsList(type, updatedNotifications);
  }

  void clearSelectedDate(VehicleNotificationType type) {
    switch (type) {
      case VehicleNotificationType.ITP:
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
  void _updateNotificationsList(
    VehicleNotificationType type,
    List<NotificationModel> updatedNotifications,
  ) {
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

  // // Helper method to expand notifications based on flags
  // Future<List<Map<String, dynamic>>> _expandNotifications(
  //   List<NotificationModel> notifications,
  //   DateTime? expirationDate,
  // ) async {
  //   if (expirationDate == null) return [];

  //   List<NotificationModel> expandedNotifications = [];

  //   for (var notification in notifications) {
  //     if (notification.monthBefore ?? false) {
  //       final monthBeforeDate =
  //           expirationDate.subtract(const Duration(days: 30));
  //       if (monthBeforeDate.isAfter(DateTime.now())) {
  //         expandedNotifications.add(
  //           NotificationModel(
  //             date: monthBeforeDate,
  //             sms: false,
  //             email: notification.email,
  //             push: notification.push,
  //             notificationId:
  //                 await NotificationHelper.generateUniqueNotificationId(),
  //             monthBefore: true,
  //             weekBefore: false,
  //             dayBefore: false,
  //           ),
  //         );
  //       }
  //     }

  //     if (notification.weekBefore ?? false) {
  //       final weekBeforeDate = expirationDate.subtract(const Duration(days: 7));
  //       if (weekBeforeDate.isAfter(DateTime.now())) {
  //         expandedNotifications.add(
  //           NotificationModel(
  //             date: weekBeforeDate,
  //             sms: false,
  //             email: notification.email,
  //             push: notification.push,
  //             notificationId:
  //                 await NotificationHelper.generateUniqueNotificationId(),
  //             monthBefore: false,
  //             weekBefore: true,
  //             dayBefore: false,
  //           ),
  //         );
  //       }
  //     }

  //     if (notification.dayBefore ?? false) {
  //       final dayBeforeDate = expirationDate.subtract(const Duration(days: 1));
  //       if (dayBeforeDate.isAfter(DateTime.now())) {
  //         expandedNotifications.add(
  //           NotificationModel(
  //             date: dayBeforeDate,
  //             sms: false,
  //             email: notification.email,
  //             push: notification.push,
  //             notificationId:
  //                 await NotificationHelper.generateUniqueNotificationId(),
  //             monthBefore: false,
  //             weekBefore: false,
  //             dayBefore: true,
  //           ),
  //         );
  //       }
  //     }
  //   }

  //   return expandedNotifications.map((n) => n.toMap()).toList();
  // }

  void addTemporaryJournalEntry(
      JournalEntryType type, DateTime date, int kilometers) {
    // Create a temporary entry with a placeholder ID
    final entry = JournalEntry(
      entryId: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _getJournalNameFromType(type),
      createdAt: Timestamp.now(),
      editedAt: Timestamp.now(),
      type: type,
      date: date,
      kms: kilometers,
    );

    List<JournalEntry> updatedEntries;

    switch (type) {
      case JournalEntryType.service:
        updatedEntries = [...state.journalEntriesService, entry];
        emit(state.copyWith(journalEntriesService: updatedEntries));
        break;
      case JournalEntryType.breaks:
        updatedEntries = [...state.journalEntriesBreaks, entry];
        emit(state.copyWith(journalEntriesBreaks: updatedEntries));
        break;
      case JournalEntryType.distribution:
        updatedEntries = [...state.journalEntriesDistribution, entry];
        emit(state.copyWith(journalEntriesDistribution: updatedEntries));
        break;
      case JournalEntryType.other:
        break;
    }
  }

  /// Remove a temporary journal entry (before car is saved)
  void removeTemporaryJournalEntry(JournalEntryType type, String entryId) {
    List<JournalEntry> updatedEntries;

    switch (type) {
      case JournalEntryType.service:
        updatedEntries = state.journalEntriesService
            .where((e) => e.entryId != entryId)
            .toList();
        emit(state.copyWith(journalEntriesService: updatedEntries));
        break;
      case JournalEntryType.breaks:
        updatedEntries = state.journalEntriesBreaks
            .where((e) => e.entryId != entryId)
            .toList();
        emit(state.copyWith(journalEntriesBreaks: updatedEntries));
        break;
      case JournalEntryType.distribution:
        updatedEntries = state.journalEntriesDistribution
            .where((e) => e.entryId != entryId)
            .toList();
        emit(state.copyWith(journalEntriesDistribution: updatedEntries));
        break;
      case JournalEntryType.other:
        break;
    }
  }

  String _getJournalNameFromType(JournalEntryType type) {
    switch (type) {
      case JournalEntryType.service:
        return 'Service';
      case JournalEntryType.breaks:
        return 'Plăcuțe frână';
      case JournalEntryType.distribution:
        return 'Transmisie';
      case JournalEntryType.other:
        return 'Altele';
    }
  }

  Future<bool> addCar(
    String userId, {
    String? userEmail,
    String? userName,
  }) async {
    print('💾 Adding car info for user: $userId');
    print('🚗 Car number: ${state.carNr}');
    print('🚗 Vehicle model: ${state.vehicleModel}');

    // Check if at least one expiration date has notifications
    bool hasAtLeastOneExpiration = state.notificationsITP.isNotEmpty ||
        state.notificationsRCA.isNotEmpty ||
        state.notificationsCASCO.isNotEmpty ||
        state.notificationsRovinieta.isNotEmpty ||
        state.notificationsTahograf.isNotEmpty;

    if (!hasAtLeastOneExpiration) {
      return false;
    }

    // Convert to map format (collapsed format)
    List<Map<String, dynamic>> notificationsITP =
        state.notificationsITP.map((n) => n.toMap()).toList();
    List<Map<String, dynamic>> notificationsRCA =
        state.notificationsRCA.map((n) => n.toMap()).toList();
    List<Map<String, dynamic>> notificationsCASCO =
        state.notificationsCASCO.map((n) => n.toMap()).toList();
    List<Map<String, dynamic>> notificationsRovinieta =
        state.notificationsRovinieta.map((n) => n.toMap()).toList();
    List<Map<String, dynamic>> notificationsTahograf =
        state.notificationsTahograf.map((n) => n.toMap()).toList();

    // Build the structured data with expiration dates and collapsed notifications
    Map<String, dynamic> carInfo = {
      'carNr': state.carNr,
      'vehicleModel': state.vehicleModel,
      'expirationDates': {
        'RCA': {
          'date': state.expirationDateRCA,
          'notifications': notificationsRCA,
        },
        'ITP': {
          'date': state.expirationDateITP,
          'notifications': notificationsITP,
        },
        'CASCO': {
          'date': state.expirationDateCASCO,
          'notifications': notificationsCASCO,
        },
        'Rovinieta': {
          'date': state.expirationDateRovinieta,
          'notifications': notificationsRovinieta,
        },
        'Tahograf': {
          'date': state.expirationDateTahograf,
          'notifications': notificationsTahograf,
        },
      },
    };

    // Prepare journal data
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

    // Save to Firestore
    await addVehicleDataForUser(
      userId: userId,
      carInfo: carInfo,
      distributionJournal: distributionJournal,
      breaksJournal: breaksJournal,
      serviceJournal: serviceJournal,
    );

    // Add journal entries
    String carName = state.vehicleModel.replaceAll(' ', '');
    String vehicleId = '${state.carNr}-$carName';

    for (var entry in state.journalEntriesService) {
      await addJournalEntry(
        userId: userId,
        vehicleId: vehicleId,
        newEntry: entry,
      );
    }

    for (var entry in state.journalEntriesBreaks) {
      await addJournalEntry(
        userId: userId,
        vehicleId: vehicleId,
        newEntry: entry,
      );
    }

    for (var entry in state.journalEntriesDistribution) {
      await addJournalEntry(
        userId: userId,
        vehicleId: vehicleId,
        newEntry: entry,
      );
    }

    print('✅ Vehicle saved to Firestore');

    // Schedule notifications with email support
    final vehicleInfo = '${state.carNr} - ${state.vehicleModel}';

    try {
      // Schedule ITP notifications
      if (state.expirationDateITP != null &&
          state.notificationsITP.isNotEmpty) {
        await NotificationHelper.scheduleNotificationsFromCollapsed(
          documentType: 'ITP',
          documentInfo: vehicleInfo,
          expirationDate: state.expirationDateITP!,
          notifications: state.notificationsITP,
          userEmail: userEmail,
          userName: userName,
        );
        print('✅ ITP notifications scheduled');
      }

      // Schedule RCA notifications
      if (state.expirationDateRCA != null &&
          state.notificationsRCA.isNotEmpty) {
        await NotificationHelper.scheduleNotificationsFromCollapsed(
          documentType: 'RCA',
          documentInfo: vehicleInfo,
          expirationDate: state.expirationDateRCA!,
          notifications: state.notificationsRCA,
          userEmail: userEmail,
          userName: userName,
        );
        print('✅ RCA notifications scheduled');
      }

      // Schedule CASCO notifications
      if (state.expirationDateCASCO != null &&
          state.notificationsCASCO.isNotEmpty) {
        await NotificationHelper.scheduleNotificationsFromCollapsed(
          documentType: 'CASCO',
          documentInfo: vehicleInfo,
          expirationDate: state.expirationDateCASCO!,
          notifications: state.notificationsCASCO,
          userEmail: userEmail,
          userName: userName,
        );
        print('✅ CASCO notifications scheduled');
      }

      // Schedule Rovinieta notifications
      if (state.expirationDateRovinieta != null &&
          state.notificationsRovinieta.isNotEmpty) {
        await NotificationHelper.scheduleNotificationsFromCollapsed(
          documentType: 'Rovinieta',
          documentInfo: vehicleInfo,
          expirationDate: state.expirationDateRovinieta!,
          notifications: state.notificationsRovinieta,
          userEmail: userEmail,
          userName: userName,
        );
        print('✅ Rovinieta notifications scheduled');
      }

      // Schedule Tahograf notifications
      if (state.expirationDateTahograf != null &&
          state.notificationsTahograf.isNotEmpty) {
        await NotificationHelper.scheduleNotificationsFromCollapsed(
          documentType: 'Tahograf',
          documentInfo: vehicleInfo,
          expirationDate: state.expirationDateTahograf!,
          notifications: state.notificationsTahograf,
          userEmail: userEmail,
          userName: userName,
        );
        print('✅ Tahograf notifications scheduled');
      }

      // Debug: Check pending notifications
      final pending = await NotificationHelper.getPendingNotifications();
      print('📱 Total pending notifications: ${pending.length}');
    } catch (e) {
      print('❌ Error scheduling notifications: $e');
    }

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
