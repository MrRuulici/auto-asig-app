import 'package:auto_asig/core/models/reminder.dart';
import 'package:auto_asig/core/models/vehicle_reminder.dart';
import 'package:equatable/equatable.dart';

abstract class ReminderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReminderInitial extends ReminderState {}

class ReminderLoading extends ReminderState {}

class ReminderLoaded extends ReminderState {
  final List<Reminder>? reminders;
  final List<VehicleReminder>? vehicleReminders;

  ReminderLoaded({this.reminders, this.vehicleReminders});

  // CopyWith function
  ReminderLoaded copyWith({
    List<Reminder>? reminders,
    List<VehicleReminder>? vehicleReminders,
  }) {
    return ReminderLoaded(
      reminders: reminders ?? this.reminders,
      vehicleReminders: vehicleReminders ?? this.vehicleReminders,
    );
  }

  @override
  List<Object?> get props => [reminders, vehicleReminders];
}

class ReminderError extends ReminderState {
  final String message;

  ReminderError(this.message);

  @override
  List<Object?> get props => [message];
}
