import 'package:auto_asig/core/models/vehicle_reminder.dart';
import 'package:equatable/equatable.dart';

class EditVehicleReminderState extends Equatable {
  final VehicleReminder? vehicleReminder;

  const EditVehicleReminderState({required this.vehicleReminder});

  /// Creates a copy of the state with optional updates
  EditVehicleReminderState copyWith({VehicleReminder? vehicleReminder}) {
    return EditVehicleReminderState(
      vehicleReminder: vehicleReminder ?? this.vehicleReminder,
    );
  }

  @override
  List<Object?> get props => [vehicleReminder];
}
