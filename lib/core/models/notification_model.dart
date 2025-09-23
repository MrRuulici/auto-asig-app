class NotificationModel {
  final DateTime date;
  final bool sms;
  final bool email;
  final bool push;
  final int notificationId;

  NotificationModel({
    required this.date,
    required this.sms,
    required this.email,
    required this.push,
    required this.notificationId,
  });

  // CopyWith method to create a new instance with modified values
  NotificationModel copyWith({
    DateTime? date,
    bool? sms,
    bool? email,
    bool? push,
    int? notificationId,
  }) {
    return NotificationModel(
      date: date ?? this.date,
      sms: sms ?? this.sms,
      email: email ?? this.email,
      push: push ?? this.push,
      notificationId: notificationId ?? this.notificationId,
    );
  }
}
