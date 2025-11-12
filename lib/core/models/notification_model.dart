import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final DateTime date;
  final bool sms;
  final bool email;
  final bool push;
  final int notificationId;
  final bool monthBefore;
  final bool weekBefore;
  final bool dayBefore;

  NotificationModel({
    required this.date,
    required this.sms,
    required this.email,
    required this.push,
    required this.notificationId,
    this.monthBefore = false,
    this.weekBefore = false,
    this.dayBefore = false,
  });

  // CopyWith method to create a new instance with modified values
  NotificationModel copyWith({
    DateTime? date,
    bool? sms,
    bool? email,
    bool? push,
    int? notificationId,
    bool? monthBefore,
    bool? weekBefore,
    bool? dayBefore,
  }) {
    return NotificationModel(
      date: date ?? this.date,
      sms: sms ?? this.sms,
      email: email ?? this.email,
      push: push ?? this.push,
      notificationId: notificationId ?? this.notificationId,
      monthBefore: monthBefore ?? this.monthBefore,
      weekBefore: weekBefore ?? this.weekBefore,
      dayBefore: dayBefore ?? this.dayBefore,
    );
  }

  // Convert NotificationModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'sms': sms,
      'email': email,
      'push': push,
      'notifId': notificationId,
      'monthBefore': monthBefore,
      'weekBefore': weekBefore,
      'dayBefore': dayBefore,
    };
  }

  // Create a NotificationModel from a Firestore Map
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      date: (map['date'] as Timestamp).toDate(),
      sms: map['sms'] ?? false,
      email: map['email'] ?? false,
      push: map['push'] ?? false,
      notificationId: map['notifId'] ?? 0,
      monthBefore: map['monthBefore'] ?? false,
      weekBefore: map['weekBefore'] ?? false,
      dayBefore: map['dayBefore'] ?? false,
    );
  }
}