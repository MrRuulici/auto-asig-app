import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/core/widgets/vehicle_journal.dart';

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
    List<NotificationModel>? notificationsITP,
    DateTime? expirationDateRCA,
    List<NotificationModel>? notificationsRCA,
    DateTime? expirationDateCASCO,
    List<NotificationModel>? notificationsCASCO,
    DateTime? expirationDateRovinieta,
    List<NotificationModel>? notificationsRovinieta,
    DateTime? expirationDateTahograf,
    List<NotificationModel>? notificationsTahograf,
    VehicleJournal? vehicleDistributionJournal,
    VehicleJournal? vehicleServiceJournal,
    VehicleJournal? vehicleBreaksJournal,
  }) {
    return VehicleReminder(
      id: id ?? this.id,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      carModel: carModel ?? this.carModel,
      expirationDateITP: expirationDateITP ?? this.expirationDateITP,
      notificationsITP: notificationsITP ?? this.notificationsITP,
      expirationDateRCA: expirationDateRCA ?? this.expirationDateRCA,
      notificationsRCA: notificationsRCA ?? this.notificationsRCA,
      expirationDateCASCO: expirationDateCASCO ?? this.expirationDateCASCO,
      notificationsCASCO: notificationsCASCO ?? this.notificationsCASCO,
      expirationDateRovinieta:
          expirationDateRovinieta ?? this.expirationDateRovinieta,
      notificationsRovinieta:
          notificationsRovinieta ?? this.notificationsRovinieta,
      expirationDateTahograf:
          expirationDateTahograf ?? this.expirationDateTahograf,
      notificationsTahograf:
          notificationsTahograf ?? this.notificationsTahograf,
      vehicleDistributionJournal:
          vehicleDistributionJournal ?? this.vehicleDistributionJournal,
      vehicleServiceJournal:
          vehicleServiceJournal ?? this.vehicleServiceJournal,
      vehicleBreaksJournal: vehicleBreaksJournal ?? this.vehicleBreaksJournal,
    );
  }
}
