import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/models/notification_model.dart';

class Reminder {
  final String id;
  final String title;
  final DateTime expirationDate;
  final List<NotificationModel> notificationDates;
  final DateTime creationDate;
  final ReminderType type;

  Reminder({
    this.id = '',
    required this.title,
    required this.expirationDate,
    required this.notificationDates,
    required this.creationDate,
    required this.type,
  });
}
