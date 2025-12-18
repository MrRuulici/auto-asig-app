import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/core/widgets/vehicle_journal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleReminder {
  final String id;
  final String registrationNumber;
  final String carModel;
  final DateTime? expirationDateITP;
  final List<NotificationModel> notificationsITP;

  final DateTime? expirationDateRCA;
  final List<NotificationModel> notificationsRCA;

  final DateTime? expirationDateCASCO;
  final List<NotificationModel> notificationsCASCO;

  final DateTime? expirationDateRovinieta;
  final List<NotificationModel> notificationsRovinieta;

  final DateTime? expirationDateTahograf;
  final List<NotificationModel> notificationsTahograf;

  final VehicleJournal? vehicleDistributionJournal;
  final VehicleJournal? vehicleServiceJournal;
  final VehicleJournal? vehicleBreaksJournal;

  VehicleReminder({
    required this.id,
    required this.registrationNumber,
    required this.carModel,
    required this.expirationDateITP,
    required this.notificationsITP,
    required this.expirationDateRCA,
    required this.notificationsRCA,
    required this.expirationDateCASCO,
    required this.notificationsCASCO,
    required this.expirationDateRovinieta,
    required this.notificationsRovinieta,
    required this.expirationDateTahograf,
    required this.notificationsTahograf,
    required this.vehicleDistributionJournal,
    required this.vehicleServiceJournal,
    required this.vehicleBreaksJournal,
  });

  VehicleReminder copyWith({
    String? id,
    String? registrationNumber,
    String? carModel,
    DateTime? expirationDateITP,
    bool clearExpirationDateITP = false,
    List<NotificationModel>? notificationsITP,
    DateTime? expirationDateRCA,
    bool clearExpirationDateRCA = false,
    List<NotificationModel>? notificationsRCA,
    DateTime? expirationDateCASCO,
    bool clearExpirationDateCASCO = false,
    List<NotificationModel>? notificationsCASCO,
    DateTime? expirationDateRovinieta,
    bool clearExpirationDateRovinieta = false,
    List<NotificationModel>? notificationsRovinieta,
    DateTime? expirationDateTahograf,
    bool clearExpirationDateTahograf = false,
    List<NotificationModel>? notificationsTahograf,
    VehicleJournal? vehicleDistributionJournal,
    VehicleJournal? vehicleServiceJournal,
    VehicleJournal? vehicleBreaksJournal,
  }) {
    return VehicleReminder(
      id: id ?? this.id,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      carModel: carModel ?? this.carModel,
      expirationDateITP: clearExpirationDateITP
          ? null
          : (expirationDateITP ?? this.expirationDateITP),
      notificationsITP: notificationsITP ?? this.notificationsITP,
      expirationDateRCA: clearExpirationDateRCA
          ? null
          : (expirationDateRCA ?? this.expirationDateRCA),
      notificationsRCA: notificationsRCA ?? this.notificationsRCA,
      expirationDateCASCO: clearExpirationDateCASCO
          ? null
          : (expirationDateCASCO ?? this.expirationDateCASCO),
      notificationsCASCO: notificationsCASCO ?? this.notificationsCASCO,
      expirationDateRovinieta: clearExpirationDateRovinieta
          ? null
          : (expirationDateRovinieta ?? this.expirationDateRovinieta),
      notificationsRovinieta:
          notificationsRovinieta ?? this.notificationsRovinieta,
      expirationDateTahograf: clearExpirationDateTahograf
          ? null
          : (expirationDateTahograf ?? this.expirationDateTahograf),
      notificationsTahograf:
          notificationsTahograf ?? this.notificationsTahograf,
      vehicleDistributionJournal:
          vehicleDistributionJournal ?? this.vehicleDistributionJournal,
      vehicleServiceJournal:
          vehicleServiceJournal ?? this.vehicleServiceJournal,
      vehicleBreaksJournal: vehicleBreaksJournal ?? this.vehicleBreaksJournal,
    );
  }

  // Add this toMap method
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'registrationNumber': registrationNumber,
      'carModel': carModel,
      'expirationDateITP': expirationDateITP != null
          ? Timestamp.fromDate(expirationDateITP!)
          : null,
      'notificationsITP': notificationsITP.map((n) => n.toMap()).toList(),
      'expirationDateRCA': expirationDateRCA != null
          ? Timestamp.fromDate(expirationDateRCA!)
          : null,
      'notificationsRCA': notificationsRCA.map((n) => n.toMap()).toList(),
      'expirationDateCASCO': expirationDateCASCO != null
          ? Timestamp.fromDate(expirationDateCASCO!)
          : null,
      'notificationsCASCO': notificationsCASCO.map((n) => n.toMap()).toList(),
      'expirationDateRovinieta': expirationDateRovinieta != null
          ? Timestamp.fromDate(expirationDateRovinieta!)
          : null,
      'notificationsRovinieta':
          notificationsRovinieta.map((n) => n.toMap()).toList(),
      'expirationDateTahograf': expirationDateTahograf != null
          ? Timestamp.fromDate(expirationDateTahograf!)
          : null,
      'notificationsTahograf':
          notificationsTahograf.map((n) => n.toMap()).toList(),
      'vehicleDistributionJournal': vehicleDistributionJournal?.toMap(),
      'vehicleServiceJournal': vehicleServiceJournal?.toMap(),
      'vehicleBreaksJournal': vehicleBreaksJournal?.toMap(),
    };
  }

  // Add fromMap method if you don't have it
  factory VehicleReminder.fromMap(Map<String, dynamic> map) {
    return VehicleReminder(
      id: map['id'] ?? '',
      registrationNumber: map['registrationNumber'] ?? '',
      carModel: map['carModel'] ?? '',
      expirationDateITP: map['expirationDateITP'] != null
          ? (map['expirationDateITP'] as Timestamp).toDate()
          : null,
      notificationsITP: (map['notificationsITP'] as List?)
              ?.map((n) => NotificationModel.fromMap(n))
              .toList() ??
          [],
      expirationDateRCA: map['expirationDateRCA'] != null
          ? (map['expirationDateRCA'] as Timestamp).toDate()
          : null,
      notificationsRCA: (map['notificationsRCA'] as List?)
              ?.map((n) => NotificationModel.fromMap(n))
              .toList() ??
          [],
      expirationDateCASCO: map['expirationDateCASCO'] != null
          ? (map['expirationDateCASCO'] as Timestamp).toDate()
          : null,
      notificationsCASCO: (map['notificationsCASCO'] as List?)
              ?.map((n) => NotificationModel.fromMap(n))
              .toList() ??
          [],
      expirationDateRovinieta: map['expirationDateRovinieta'] != null
          ? (map['expirationDateRovinieta'] as Timestamp).toDate()
          : null,
      notificationsRovinieta: (map['notificationsRovinieta'] as List?)
              ?.map((n) => NotificationModel.fromMap(n))
              .toList() ??
          [],
      expirationDateTahograf: map['expirationDateTahograf'] != null
          ? (map['expirationDateTahograf'] as Timestamp).toDate()
          : null,
      notificationsTahograf: (map['notificationsTahograf'] as List?)
              ?.map((n) => NotificationModel.fromMap(n))
              .toList() ??
          [],
      vehicleDistributionJournal: map['vehicleDistributionJournal'] != null
          ? VehicleJournal.fromMap(map['vehicleDistributionJournal'])
          : null,
      vehicleServiceJournal: map['vehicleServiceJournal'] != null
          ? VehicleJournal.fromMap(map['vehicleServiceJournal'])
          : null,
      vehicleBreaksJournal: map['vehicleBreaksJournal'] != null
          ? VehicleJournal.fromMap(map['vehicleBreaksJournal'])
          : null,
    );
  }
}
