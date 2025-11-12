import 'package:auto_asig/core/app/app_data.dart';
import 'package:auto_asig/core/data/assistants.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/data/server_constants.dart';
import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/core/models/reminder.dart';
import 'package:auto_asig/core/models/vehicle_jorunal_model.dart';
import 'package:auto_asig/core/models/vehicle_reminder.dart';
import 'package:auto_asig/core/widgets/vehicle_journal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> addReminderForUser(
  String userId,
  Map<String, dynamic> ids,
  ReminderType type,
) async {
  String collectionName = 'id_cards';

  switch (type) {
    case ReminderType.idCard:
      collectionName = 'id_cards';
      // theDocRef = idCardDocument!;
      break;
    case ReminderType.passport:
      collectionName = 'passports';
      // theDocRef = passportDocument!;
      break;
    case ReminderType.drivingLicense:
      collectionName = 'driving_lic';
      // theDocRef = driversLicenseDocument!;
      break;
  }

  // Create a new document reference with an auto-generated ID
  final docRef = userCollection!.doc(userId).collection(collectionName).doc();
  // final docRef = theDocRef.collection(userId).doc();

  // Set the document data
  await docRef.set(ids);

  // Return the generated document ID
  return docRef.id;
}

Future<void> updateTheReminderForUser(
  String userId,
  String documentId,
  Map<String, dynamic> updatedData,
  ReminderType type,
) async {
  String collectionName = 'id_cards';

  switch (type) {
    case ReminderType.idCard:
      collectionName = 'id_cards';
      break;
    case ReminderType.passport:
      collectionName = 'passports';
      break;
    case ReminderType.drivingLicense:
      collectionName = 'driving_lic';
      break;
  }

  // Reference to the specific document in the id_cards collection
  final docRef =
      userCollection!.doc(userId).collection(collectionName).doc(documentId);

  // Update the document with the provided data
  await docRef.update(updatedData);
}

Future<bool> deleteReminderForUser(
  String userId,
  String documentId,
  ReminderType type,
) async {
  String collectionName = 'id_cards';
  // DocumentReference theDocRef;

  switch (type) {
    case ReminderType.idCard:
      collectionName = 'id_cards';
      break;
    case ReminderType.passport:
      collectionName = 'passports';
      break;
    case ReminderType.drivingLicense:
      collectionName = 'driving_lic';
      break;
  }

  try {
    // Reference to the specific document in the id_cards collection
    final docRef =
        userCollection!.doc(userId).collection(collectionName).doc(documentId);
    // final docRef = theDocRef.collection(userId).doc(documentId);

    // Delete the document
    await docRef.delete();
    return true;
  } catch (e) {
    print('Error deleting reminder: $e');
    return false;
  }
}

Future<void> addVehicleDataForUser({
  required String userId,
  required Map<String, dynamic> carInfo,
  Map<String, dynamic> distributionJournal = const {},
  Map<String, dynamic> breaksJournal = const {},
  Map<String, dynamic> serviceJournal = const {},
}) async {
  // Add the timestamp
  carInfo['timestamp'] = FieldValue.serverTimestamp();

  // remove the white spaces from carInfo['carName']
  String carName = carInfo['vehicleModel'].toString().replaceAll(' ', '');

  // Add the car info to the user's vehicles collection
  await userCollection!
      .doc(userId)
      .collection('vehicles')
      .doc('${carInfo['carNr']}-$carName')
      .set(carInfo)
      .then((value) async {
    if (distributionJournal.isNotEmpty) {
      // Add the timestamp
      distributionJournal['timestamp'] = FieldValue.serverTimestamp();

      // Add the journal to the user's vehicles collection
      await userCollection!
          .doc(userId)
          .collection('vehicles')
          .doc('${carInfo['carNr']}-$carName')
          .collection(distributionJournalConst)
          .add(distributionJournal);
    }

    if (breaksJournal.isNotEmpty) {
      // Add the timestamp
      breaksJournal['timestamp'] = FieldValue.serverTimestamp();

      // Add the journal to the user's vehicles collection
      await userCollection!
          .doc(userId)
          .collection('vehicles')
          .doc('${carInfo['carNr']}-$carName')
          .collection(breaksJournalConst)
          .add(breaksJournal);
    }

    if (serviceJournal.isNotEmpty) {
      // Add the timestamp
      serviceJournal['timestamp'] = FieldValue.serverTimestamp();

      // Add the journal to the user's vehicles collection
      // await vehicleDocument!
      //     .collection(userId)
      //     .doc('${carInfo['carNr']}-$carName')
      //     .collection(serviceJournalConst)
      //     .add(serviceJournal);
      await userCollection!
          .doc(userId)
          .collection('vehicles')
          .doc('${carInfo['carNr']}-$carName')
          .collection(serviceJournalConst)
          .add(serviceJournal);
    }
  });
}

Future<void> updateVehicleData({
  required String userId,
  required String id,
  required Map<String, dynamic> carInfos,
  Map<String, dynamic> distributionJournal = const {},
  Map<String, dynamic> breaksJournal = const {},
  Map<String, dynamic> serviceJournal = const {},
}) async {
  // Add the timestamp
  carInfos['timestamp'] = FieldValue.serverTimestamp();

  await userCollection!
      .doc(userId)
      .collection('vehicles')
      .doc(id)
      .update(carInfos);

  // Update the car info in the user's vehicles collection
  // await vehicleDocument!
  //     .collection(userId)
  //     .doc(id)
  //     .set(carInfos, SetOptions(merge: true));

  // Update the journal in the user's vehicles collection
  if (distributionJournal.isNotEmpty) {
    // Add the timestamp
    distributionJournal['timestamp'] = FieldValue.serverTimestamp();

    // Add the journal to the user's vehicles collection
    // await vehicleDocument!
    //     .collection(userId)
    //     .doc(id)
    //     .collection(distributionJournalConst)
    //     .add(distributionJournal);

    await userCollection!
        .doc(userId)
        .collection('vehicles')
        .doc(id)
        .collection(distributionJournalConst)
        .add(distributionJournal);
  }

  if (breaksJournal.isNotEmpty) {
    // Add the timestamp
    breaksJournal['timestamp'] = FieldValue.serverTimestamp();

    // Add the journal to the user's vehicles collection
    // await vehicleDocument!
    //     .collection(userId)
    //     .doc(id)
    //     .collection(breaksJournalConst)
    //     .add(breaksJournal);

    await userCollection!
        .doc(userId)
        .collection('vehicles')
        .doc(id)
        .collection(breaksJournalConst)
        .add(breaksJournal);
  }

  if (serviceJournal.isNotEmpty) {
    // Add the timestamp
    serviceJournal['timestamp'] = FieldValue.serverTimestamp();

    // Add the journal to the user's vehicles collection
    // await vehicleDocument!
    //     .collection(userId)
    //     .doc(id)
    //     .collection(serviceJournalConst)
    //     .add(serviceJournal);

    await userCollection!
        .doc(userId)
        .collection('vehicles')
        .doc(id)
        .collection(serviceJournalConst)
        .add(serviceJournal);
  }
}

Future<void> deleteVehicleData({
  required String userId,
  required String vehicleId,
}) async {
  if (userId.isEmpty || vehicleId.isEmpty) return;
  await userCollection!
      .doc(userId)
      .collection('vehicles')
      .doc(vehicleId)
      .delete();

  // await vehicleDocument!.collection(userId).doc(vehicleId).delete();
}

Future<List<VehicleReminder>> getAllVehiclesForUser(String userId) async {
  String vehicleId = '';

  // Fetch the user's vehicles subcollection
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('users')
      .doc(userId)
      .collection('vehicles')
      .get();

  // QuerySnapshot<Map<String, dynamic>> snapshot =
  //     await vehicleDocument!.collection(userId).get();

  // Convert each document to a VehicleReminder
  List<VehicleReminder> vehicles = snapshot.docs.map((doc) {
    final data = doc.data();

    // Helper function to parse notifications
    List<NotificationModel> parseNotifications(
        List<dynamic>? notificationData) {
      if (notificationData == null) return [];
      return notificationData.map((notif) {
        return NotificationModel(
          date: (notif['date'] as Timestamp).toDate(),
          sms: notif['sms'] ?? false,
          email: notif['email'] ?? false,
          push: notif['push'] ?? false,
          notificationId: notif['notifId'] ?? 99999,
          monthBefore: notif['monthBefore'] ?? false,
          weekBefore: notif['weekBefore'] ?? false,
          dayBefore: notif['dayBefore'] ?? false,
        );
      }).toList();
    }

    print('Vehicle id: ${doc.id}');

    vehicleId = doc.id;

    return VehicleReminder(
      id: doc.id,
      registrationNumber: data['carNr'] ?? '',
      carModel: data['vehicleModel'] ?? '',
      expirationDateITP:
          (data['expirationDates']['ITP']['date'] as Timestamp?)?.toDate(),
      notificationsITP:
          parseNotifications(data['expirationDates']['ITP']['notifications']),
      expirationDateRCA:
          (data['expirationDates']['RCA']['date'] as Timestamp?)?.toDate(),
      notificationsRCA:
          parseNotifications(data['expirationDates']['RCA']['notifications']),
      expirationDateCASCO:
          (data['expirationDates']['CASCO']['date'] as Timestamp?)?.toDate(),
      notificationsCASCO:
          parseNotifications(data['expirationDates']['CASCO']['notifications']),
      expirationDateRovinieta:
          (data['expirationDates']['Rovinieta']['date'] as Timestamp?)
              ?.toDate(),
      notificationsRovinieta: parseNotifications(
          data['expirationDates']['Rovinieta']['notifications']),
      expirationDateTahograf:
          (data['expirationDates']['Tahograf']['date'] as Timestamp?)?.toDate(),
      notificationsTahograf: parseNotifications(
          data['expirationDates']['Tahograf']['notifications']),
      // vehicleDistributionJournal: data[distributionJournalConst] != null
      //     ? VehicleJournal.fromJson(data[distributionJournalConst], doc.id)
      //     : null,
      // vehicleBreaksJournal: data[breaksJournalConst] != null
      //     ? VehicleJournal.fromJson(data[breaksJournalConst], doc.id)
      //     : null,
      // vehicleServiceJournal: data[serviceJournalConst] != null
      //     ? VehicleJournal.fromJson(data[serviceJournalConst], doc.id)
      //     : null,
      vehicleBreaksJournal: null,
      vehicleDistributionJournal: null,
      vehicleServiceJournal: null,
    );
  }).toList();

  final breaksJournal =
      await getJournalsForVehicle(userId, vehicleId, JournalEntryType.breaks);
  final distributionJournal = await getJournalsForVehicle(
      userId, vehicleId, JournalEntryType.distribution);
  final serviceJournal =
      await getJournalsForVehicle(userId, vehicleId, JournalEntryType.service);

  return vehicles;
}

Future<void> removeNotificationFromFirestore({
  required String userId,
  required String reminderId,
  required NotificationModel notification,
  required String notificationType,
}) async {
  if (userId.isEmpty || reminderId.isEmpty || notificationType.isEmpty) return;

  if (notificationType == 'ITP' ||
      notificationType == 'RCA' ||
      notificationType == 'CASCO' ||
      notificationType == 'Rovinieta' ||
      notificationType == 'Tahograf') {
    await _removeVehicleNotificationFromFirestore(
      userId: userId,
      reminderId: reminderId,
      notification: notification,
      notificationType: notificationType,
    );
  } else {
    await _removeReminderNotificationFromFirestore(
      userId: userId,
      reminderId: reminderId,
      notification: notification,
      notificationType: notificationType,
    );
  }
}

_removeReminderNotificationFromFirestore({
  required String userId,
  required String reminderId,
  required NotificationModel notification,
  required String notificationType,
}) {
  // TODO - OLD code to be replaced
  final docRef =
      userCollection!.doc(userId).collection(notificationType).doc(reminderId);

  docRef.update({
    'notifications': FieldValue.arrayRemove([
      {
        'date': Timestamp.fromDate(notification.date),
        'sms': notification.sms,
        'email': notification.email,
        'push': notification.push,
        'notifId': notification.notificationId,
        'monthBefore': notification.monthBefore,
        'weekBefore': notification.weekBefore,
        'dayBefore': notification.dayBefore,
      }
    ])
  });
}

Future<void> _removeVehicleNotificationFromFirestore(
    {required String userId,
    required String reminderId,
    required NotificationModel notification,
    required String notificationType}) async {
  final docRef =
      userCollection!.doc(userId).collection('vehicles').doc(reminderId);
  // final docRef = vehicleDocument!.collection(userId).doc(reminderId);

  await docRef.update({
    'expirationDates.$notificationType.notifications': FieldValue.arrayRemove([
      {
        'date': Timestamp.fromDate(notification.date),
        'sms': notification.sms,
        'email': notification.email,
        'push': notification.push,
        'notifId': notification.notificationId,
        'monthBefore': notification.monthBefore,
        'weekBefore': notification.weekBefore,
        'dayBefore': notification.dayBefore,
      }
    ])
  });
}

Future<List<Reminder>> getRemindersFromDB(String userId) async {
  List<Reminder> reminders = [];

  // var querySnapshot =
  //     await userCollection!.doc(userId).collection('id_cards').get();

  // var querySnapshot = await idCardDocument!.collection(userId).get();
  var querySnapshot =
      await userCollection!.doc(userId).collection('id_cards').get();
  extractDataFromSnapshot(querySnapshot, reminders);

  querySnapshot =
      await userCollection!.doc(userId).collection('driving_lic').get();
  // querySnapshot = await driversLicenseDocument!.collection(userId).get();
  extractDataFromSnapshot(querySnapshot, reminders,
      type: ReminderType.drivingLicense);

  querySnapshot =
      await userCollection!.doc(userId).collection('passports').get();

  // querySnapshot = await passportDocument!.collection(userId).get();
  extractDataFromSnapshot(querySnapshot, reminders,
      type: ReminderType.passport);

  return reminders;
}

Future<List<VehicleReminder>> getVehicleRemindersFromDB(String userId) async {
  List<VehicleReminder> vehicleReminders = [];

  // Fetch the user's vehicles subcollection
  QuerySnapshot<Map<String, dynamic>> snapshot =
      await userCollection!.doc(userId).collection('vehicles').get();

  // QuerySnapshot<Map<String, dynamic>> snapshot =
  //     await vehicleDocument!.collection(userId).get();

  // Convert each document to a VehicleReminder
  if (snapshot.docs.isNotEmpty) {
    for (var doc in snapshot.docs) {
      final data = doc.data();

      // Helper function to parse notifications
      List<NotificationModel> parseNotifications(
          List<dynamic>? notificationData) {
        if (notificationData == null) return [];
        return notificationData.map((notif) {
          return NotificationModel(
            date: (notif['date'] as Timestamp).toDate(),
            sms: notif['sms'] ?? false,
            email: notif['email'] ?? false,
            push: notif['push'] ?? false,
            notificationId: notif['notifId'] ?? 99999,
          );
        }).toList();
      }

      vehicleReminders.add(
        VehicleReminder(
          id: doc.id,
          registrationNumber: data['carNr'] ?? '',
          carModel: data['vehicleModel'] ?? '',
          expirationDateITP:
              (data['expirationDates']['ITP']['date'] as Timestamp?)?.toDate(),
          notificationsITP: parseNotifications(
              data['expirationDates']['ITP']['notifications']),
          expirationDateRCA:
              (data['expirationDates']['RCA']['date'] as Timestamp?)?.toDate(),
          notificationsRCA: parseNotifications(
              data['expirationDates']['RCA']['notifications']),
          expirationDateCASCO:
              (data['expirationDates']['CASCO']['date'] as Timestamp?)
                  ?.toDate(),
          notificationsCASCO: parseNotifications(
              data['expirationDates']['CASCO']['notifications']),
          expirationDateRovinieta:
              (data['expirationDates']['Rovinieta']['date'] as Timestamp?)
                  ?.toDate(),
          notificationsRovinieta: parseNotifications(
              data['expirationDates']['Rovinieta']['notifications']),
          expirationDateTahograf:
              (data['expirationDates']['Tahograf']['date'] as Timestamp?)
                  ?.toDate(),
          notificationsTahograf: parseNotifications(
              data['expirationDates']['Tahograf']['notifications']),
          vehicleDistributionJournal: data[distributionJournalConst] != null
              ? VehicleJournal.fromJson(data[distributionJournalConst], doc.id)
              : null,
          vehicleBreaksJournal: data[breaksJournalConst] != null
              ? VehicleJournal.fromJson(data[breaksJournalConst], doc.id)
              : null,
          vehicleServiceJournal: data[serviceJournalConst] != null
              ? VehicleJournal.fromJson(data[serviceJournalConst], doc.id)
              : null,
        ),
      );
    }
  }

  return vehicleReminders;
}

Future<bool> updateVehicleReminder(
  String userId,
  String vehicleId,
  VehicleReminder vehicleReminder,
) async {
  try {
    // Reference to the specific vehicle document in Firestore
    final DocumentReference<Map<String, dynamic>> vehicleDocRef =
        userCollection!.doc(userId).collection('vehicles').doc(vehicleId);

    // Updated data to write to Firestore
    final updatedVehicleData = {
      'expirationDates': {
        'ITP': {
          'date': vehicleReminder.expirationDateITP != null
              ? Timestamp.fromDate(vehicleReminder.expirationDateITP!)
              : null,
          'notifications': vehicleReminder.notificationsITP
              .map((notif) => {
                    'date': Timestamp.fromDate(notif.date),
                    'sms': notif.sms,
                    'email': notif.email,
                    'push': notif.push,
                    'notifId': notif.notificationId,
                    'monthBefore': notif.monthBefore,
                    'weekBefore': notif.weekBefore,
                    'dayBefore': notif.dayBefore,
                  })
              .toList(),
        },
        'RCA': {
          'date': vehicleReminder.expirationDateRCA != null
              ? Timestamp.fromDate(vehicleReminder.expirationDateRCA!)
              : null,
          'notifications': vehicleReminder.notificationsRCA
              .map((notif) => {
                    'date': Timestamp.fromDate(notif.date),
                    'sms': notif.sms,
                    'email': notif.email,
                    'push': notif.push,
                    'notifId': notif.notificationId,
                    'monthBefore': notif.monthBefore,
                    'weekBefore': notif.weekBefore,
                    'dayBefore': notif.dayBefore,
                  })
              .toList(),
        },
        'CASCO': {
          'date': vehicleReminder.expirationDateCASCO != null
              ? Timestamp.fromDate(vehicleReminder.expirationDateCASCO!)
              : null,
          'notifications': vehicleReminder.notificationsCASCO
              .map((notif) => {
                    'date': Timestamp.fromDate(notif.date),
                    'sms': notif.sms,
                    'email': notif.email,
                    'push': notif.push,
                    'notifId': notif.notificationId,
                    'monthBefore': notif.monthBefore,
                    'weekBefore': notif.weekBefore,
                    'dayBefore': notif.dayBefore,
                  })
              .toList(),
        },
        'Rovinieta': {
          'date': vehicleReminder.expirationDateRovinieta != null
              ? Timestamp.fromDate(vehicleReminder.expirationDateRovinieta!)
              : null,
          'notifications': vehicleReminder.notificationsRovinieta
              .map((notif) => {
                    'date': Timestamp.fromDate(notif.date),
                    'sms': notif.sms,
                    'email': notif.email,
                    'push': notif.push,
                    'notifId': notif.notificationId,
                    'monthBefore': notif.monthBefore,
                    'weekBefore': notif.weekBefore,
                    'dayBefore': notif.dayBefore,
                  })
              .toList(),
        },
        'Tahograf': {
          'date': vehicleReminder.expirationDateTahograf != null
              ? Timestamp.fromDate(vehicleReminder.expirationDateTahograf!)
              : null,
          'notifications': vehicleReminder.notificationsTahograf
              .map((notif) => {
                    'date': Timestamp.fromDate(notif.date),
                    'sms': notif.sms,
                    'email': notif.email,
                    'push': notif.push,
                    'notifId': notif.notificationId,
                    'monthBefore': notif.monthBefore,
                    'weekBefore': notif.weekBefore,
                    'dayBefore': notif.dayBefore,
                  })
              .toList(),
        },
      }
    };

    // Attempt to update the vehicle document in Firestore
    await vehicleDocRef.update(updatedVehicleData);

    // Log success (optional)
    print('Vehicle reminder updated successfully for vehicleId: $vehicleId');

    return true;
  } catch (e) {
    // Log the error
    print('Error updating vehicle reminder: $e');

    // Optionally rethrow the error to be handled further up
    // throw Exception('Failed to update vehicle reminder. Please try again.');
    return false;
  }
}

void extractDataFromSnapshot(
    QuerySnapshot<Map<String, dynamic>> querySnapshot, List<Reminder> reminders,
    {ReminderType type = ReminderType.idCard}) {
  for (var doc in querySnapshot.docs) {
    final data = doc.data();

    // Convert Firestore Timestamp to DateTime for the expiration date, handle nulls
    final DateTime? expiringDate =
        data['exp'] != null ? convertTimestampToDateTime(data['exp']) : null;

    // Null check for the notifications field before casting
    final List<NotificationModel> notifications = data['notifications'] != null
        ? (data['notifications'] as List<dynamic>).map((notificationData) {
            return NotificationModel(
              date: (notificationData['date'] as Timestamp).toDate(),
              sms: notificationData['sms'] ?? false,
              email: notificationData['email'] ?? false,
              push: notificationData['push'] ?? false,
              notificationId: notificationData['notifId'] ?? 99999,
              monthBefore: notificationData['monthBefore'] ?? false,
              weekBefore: notificationData['weekBefore'] ?? false,
              dayBefore: notificationData['dayBefore'] ?? false,
            );
          }).toList()
        : [];

    // Handle nulls for the title and creation date
    final String title = data['name'] ?? 'Unknown Name';
    final DateTime creationDate = data['timestamp'] != null
        ? (data['timestamp'] as Timestamp).toDate()
        : DateTime.now(); // Provide a default value if 'timestamp' is null

    if (expiringDate != null) {
      reminders.add(
        Reminder(
          id: doc.id,
          title: title,
          expirationDate: expiringDate,
          notificationDates: notifications,
          creationDate: creationDate,
          type: type,
        ),
      );
    }
  }
}

/// Adds a new journal entry for a specific vehicle of a given user to Firestore.
Future<String> addJournalEntry({
  required String userId,
  required String vehicleId,
  required JournalEntry newEntry,
}) async {
  try {
    String journal = '';

    switch (newEntry.type) {
      case JournalEntryType.breaks:
        journal = breaksJournalConst;
        break;
      case JournalEntryType.distribution:
        journal = distributionJournalConst;
        break;
      case JournalEntryType.service:
        journal = serviceJournalConst;
        break;
      case JournalEntryType.other:
        journal = otherJournalConst;
        break;
      default:
        journal = otherJournalConst;
        break;
    }

    print('Collection path: vehicles/$vehicleId/$journal');

    // Reference to the specific journal collection in Firestore
    final CollectionReference<Map<String, dynamic>> journalCollection =
        userCollection!
            .doc(userId)
            .collection('vehicles')
            .doc(vehicleId)
            .collection(journal);

    // Convert the JournalEntry object to a map
    final newEntryData = {
      'name': newEntry.name,
      'createdAt': Timestamp.now(),
      'editedAt': Timestamp.now(),
      'date': Timestamp.fromDate(newEntry.date),
      'kms': newEntry.kms,
    };

    // Add the new journal entry to Firestore
    // await journalCollection.add(newEntryData);

    // Add the new journal entry to Firestore and get the DocumentReference
    DocumentReference<Map<String, dynamic>> newDocRef =
        await journalCollection.add(newEntryData);

// Retrieve the ID of the new document
    String newEntryId = newDocRef.id;

// Optional: Update the document to include the generated ID in the document data
    print('Journal entry added successfully.');
    await newDocRef.update({'entryId': newEntryId});

    return newEntryId;

    // return true;
  } catch (e) {
    print('entry name: ${newEntry.name}');
    print('entry id: ${newEntry.entryId}');
    print('entry type: ${newEntry.type}');
    print('Error adding journal entry: $e');
    // return false;
    return '';
  }
}

/// Fetches all journal entries for a specific vehicle of a given user from Firestore.
/// Converts Firestore documents to VehicleJournal objects and returns the list.
/// If an error occurs, prints the error and stack trace, and returns null.
Future<List<VehicleJournal>> getJournalsForVehicle(
  String userId,
  String vehicleId,
  JournalEntryType journalType,
) async {
  try {
    // Define the collection name based on the journal type
    String collectionName;
    switch (journalType) {
      case JournalEntryType.breaks:
        collectionName = breaksJournalConst;
        break;
      case JournalEntryType.distribution:
        collectionName = distributionJournalConst;
        break;
      case JournalEntryType.service:
        collectionName = serviceJournalConst;
        break;
      case JournalEntryType.other:
        collectionName = otherJournalConst;
        break;
      default:
        collectionName = otherJournalConst;
        break;
    }

    // Fetch journal entries for the specific collection
    final journalSnapshot = await userCollection!
        .doc(userId)
        .collection('vehicles')
        .doc(vehicleId)
        .collection(collectionName)
        .get();

    // Map Firestore documents to `VehicleJournal` and `JournalEntry` objects
    final journals = journalSnapshot.docs.map((doc) {
      final data = doc.data();

      // Create a JournalEntry for the current document
      final entry = JournalEntry(
        entryId: doc.id,
        name: data['name'] ?? '---',
        createdAt: data['createdAt'] ?? Timestamp.now(),
        editedAt: data['editedAt'] ?? Timestamp.now(),
        // type: _getJournalEntryType(data['type']),
        type: journalType,
        date: (data['date'] as Timestamp).toDate(),
        kms: data['kms'] ?? 0,
      );

      // Create a VehicleJournal with the single entry
      return VehicleJournal(
        journalId: doc.id,
        vehicleId: vehicleId,
        entries: [entry],
      );
    }).toList();

    print(
        "Journals: ${journals.length} for vehicle: $vehicleId and journal type: $journalType");

    for (var journal in journals) {
      print('Journal ID: ${journal.journalId}');
      for (var entry in journal.entries) {
        // print entry name and entry type
        print('Entry name: ${entry.name} of type ${entry.type}');
      }
    }

    return journals;
  } catch (e, stackTrace) {
    print('Error fetching journals for vehicle: $e');
    print('Stack trace: $stackTrace');
    return [];
  }
}

JournalEntryType _getJournalEntryType(dynamic type) {
  if (type is int) {
    switch (type) {
      case 0:
        return JournalEntryType.other;
      case 1:
        return JournalEntryType.service;
      case 2:
        return JournalEntryType.breaks;
      case 3:
        return JournalEntryType.distribution;
      // default:
      //   return JournalEntryType.none;
    }
  }
  return JournalEntryType.other;
}

/// Updates a specific journal entry for a given user and vehicle in Firestore.
/// Converts the JournalEntry object to a map and updates the Firestore document.
/// If an error occurs, prints the error and returns false.
Future<bool> editJournalEntry({
  required String userId,
  required String vehicleId,
  required JournalEntry updatedEntry,
}) async {
  try {
    String journal = '';

    switch (updatedEntry.type) {
      case JournalEntryType.breaks:
        journal = breaksJournalConst;
        break;
      case JournalEntryType.distribution:
        journal = distributionJournalConst;
        break;
      case JournalEntryType.service:
        journal = serviceJournalConst;
        break;
      case JournalEntryType.other:
        journal = otherJournalConst;
        break;
      default:
        journal = otherJournalConst;
        break;
    }

    // Reference to the specific journal document in Firestore
    final DocumentReference<Map<String, dynamic>> journalDocRef =
        userCollection!
            .doc(userId)
            .collection('vehicles')
            .doc(vehicleId)
            .collection(journal)
            .doc(updatedEntry.entryId);

    // Updated data to write to Firestore
    final updatedEntryData = {
      'name': updatedEntry.name,
      'createdAt': updatedEntry.createdAt, // Assuming this should not change
      'editedAt': Timestamp.now(), // Updated to current timestamp
      'date': Timestamp.fromDate(updatedEntry.date),
      'kms': updatedEntry.kms,
    };

    // Update the specific document in Firestore
    await journalDocRef.update(updatedEntryData);

    print('Journal entry updated successfully.');
    return true;
  } catch (e) {
    print('Error updating journal entry: $e');
    return false;
  }
}

/// Fetches a list of journal entries of a specific type for a given user and vehicle from Firestore.
/// Converts the JournalEntryType enum to a string and queries the Firestore collection based on the type.
/// Maps the Firestore documents to JournalEntry objects and returns the list.
/// If an error occurs, prints the error and returns an empty list.
Future<List<JournalEntry>> getJournalEntriesByType({
  required String userId,
  required String vehicleId,
  required JournalEntryType journalType,
}) async {
  try {
    // Convert the JournalEntryType enum to a string
    String journal = '';

    switch (journalType) {
      case JournalEntryType.breaks:
        journal = breaksJournalConst;
        break;
      case JournalEntryType.distribution:
        journal = distributionJournalConst;
        break;
      case JournalEntryType.service:
        journal = serviceJournalConst;
        break;
      case JournalEntryType.other:
        journal = otherJournalConst;
        break;
      default:
        journal = otherJournalConst;
        break;
    }

    // Reference to the journal collection in Firestore
    final QuerySnapshot<Map<String, dynamic>> journalSnapshot =
        await userCollection!
            .doc(userId)
            .collection('vehicles')
            .doc(vehicleId)
            .collection(journal)
            .get();

    // Map each document to a JournalEntry
    final List<JournalEntry> journalEntries = journalSnapshot.docs.map((doc) {
      final data = doc.data();

      // Create a JournalEntry object from the document data
      return JournalEntry(
        entryId: doc.id,
        name: data['name'] ?? '---',
        createdAt: data['createdAt'] ?? Timestamp.now(),
        editedAt: data['editedAt'] ?? Timestamp.now(),
        type: journalType,
        date: (data['date'] as Timestamp).toDate(),
        kms: data['kms'] ?? 0,
      );
    }).toList();

    // Return the list of journal entries
    return journalEntries;
  } catch (e) {
    // Print an error message and return an empty list if an exception occurs
    print('Error fetching journal entries by type: $e');
    return [];
  }
}

Future<bool> deleteJournalEntry({
  required String userId,
  required String vehicleId,
  required JournalEntry entry,
}) async {
  try {
    String journal = '';

    switch (entry.type) {
      case JournalEntryType.breaks:
        journal = breaksJournalConst;
        break;
      case JournalEntryType.distribution:
        journal = distributionJournalConst;
        break;
      case JournalEntryType.service:
        journal = serviceJournalConst;
        break;
      case JournalEntryType.other:
        journal = otherJournalConst;
        break;
      default:
        journal = otherJournalConst;
        break;
    }

    // Reference to the specific journal document in Firestore
    final DocumentReference<Map<String, dynamic>> journalDocRef =
        userCollection!
            .doc(userId)
            .collection('vehicles')
            .doc(vehicleId)
            .collection(journal)
            .doc(entry.entryId);

    // Delete the specific document in Firestore
    await journalDocRef.delete();

    print('Journal entry deleted successfully.');
    return true;
  } catch (e) {
    print('Error deleting journal entry: $e');
    return false;
  }
}
