import 'package:equatable/equatable.dart';
import 'package:auto_asig/core/models/reminder.dart';
import 'package:auto_asig/core/models/vehicle_reminder.dart';

class UnifiedState extends Equatable {
  final List<Reminder>? reminders;
  final List<VehicleReminder>? vehicleReminders;
  final bool showDocuments;
  final bool showVehicles;

  const UnifiedState({
    this.reminders,
    this.vehicleReminders,
    this.showDocuments = true,
    this.showVehicles = true,
  });

  UnifiedState copyWith({
    List<Reminder>? reminders,
    List<VehicleReminder>? vehicleReminders,
    bool? showDocuments,
    bool? showVehicles,
  }) {
    return UnifiedState(
      reminders: reminders ?? this.reminders,
      vehicleReminders: vehicleReminders ?? this.vehicleReminders,
      showDocuments: showDocuments ?? this.showDocuments,
      showVehicles: showVehicles ?? this.showVehicles,
    );
  }

  @override
  List<Object?> get props => [
        reminders,
        vehicleReminders,
        showDocuments,
        showVehicles,
      ];
}
