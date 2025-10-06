import 'package:auto_asig/core/models/notification_model.dart';

class VehicleNotificationModel {
  final String title;
  final List<NotificationModel> notifications;

  VehicleNotificationModel({
    required this.title,
    required this.notifications,
  });
}
