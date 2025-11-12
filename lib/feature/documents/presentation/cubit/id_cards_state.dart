import 'package:auto_asig/core/models/notification_model.dart';
import 'package:equatable/equatable.dart';

class IdCardsState extends Equatable {
  const IdCardsState({
    required this.name,
    required this.expirationDate,
    required this.notificationDates,
    this.id = '',
  });

  final String name;
  final DateTime expirationDate;
  final List<NotificationModel> notificationDates;
  final String id;

  @override
  List<Object> get props => [
        id,
        name,
        expirationDate,
        notificationDates,
      ];

  IdCardsState copyWith({
    String? id,
    String? name,
    DateTime? expirationDate,
    List<NotificationModel>? notificationDates,
  }) {
    return IdCardsState(
      id: id ?? this.id,
      name: name ?? this.name,
      expirationDate: expirationDate ?? this.expirationDate,
      notificationDates: notificationDates ?? this.notificationDates,
    );
  }
}

class IdCardsInitial extends IdCardsState {
  IdCardsInitial()
      : super(
          name: '',
          expirationDate: DateTime.now(),
          notificationDates: [], // Start with empty list
        );
}
