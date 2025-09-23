import 'package:auto_asig/core/data/http_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'unified_state.dart';
import 'package:auto_asig/core/models/reminder.dart';
import 'package:auto_asig/core/models/vehicle_reminder.dart';

class UnifiedCubit extends Cubit<UnifiedState> {
  UnifiedCubit() : super(const UnifiedState());

  // Load reminders and vehicle reminders
  Future<void> loadData(
      List<Reminder> reminders, List<VehicleReminder> vehicleReminders) async {
    emit(
      state.copyWith(
        reminders: reminders,
        vehicleReminders: vehicleReminders,
      ),
    );
  }

  Future<void> loadReminders(List<Reminder> reminders) async {
    // sort by expiration date, ascending
    reminders.sort((a, b) => a.expirationDate.compareTo(b.expirationDate));

    emit(state.copyWith(reminders: reminders));
  }

  Future<void> loadVehicleReminders(
      List<VehicleReminder> vehicleReminders) async {
    // sort the vehicle lists by expiration date, ascending
    vehicleReminders
        .sort((a, b) => a.expirationDateITP!.compareTo(b.expirationDateITP!));
    vehicleReminders
        .sort((a, b) => a.expirationDateRCA!.compareTo(b.expirationDateRCA!));
    vehicleReminders.sort(
        (a, b) => a.expirationDateCASCO!.compareTo(b.expirationDateCASCO!));
    vehicleReminders.sort((a, b) =>
        a.expirationDateRovinieta!.compareTo(b.expirationDateRovinieta!));
    vehicleReminders.sort((a, b) =>
        a.expirationDateTahograf!.compareTo(b.expirationDateTahograf!));

    emit(state.copyWith(vehicleReminders: vehicleReminders));
  }

  // Toggle visibility of "Documente" section
  void toggleDocuments() {
    emit(state.copyWith(showDocuments: !state.showDocuments));
  }

  // Toggle visibility of "Vehicule" section
  void toggleVehicles() {
    emit(state.copyWith(showVehicles: !state.showVehicles));
  }

  Future<void> initialize(String userId) async {
    final reminders = await getRemindersFromDB(userId);
    final vehicleReminders = await getAllVehiclesForUser(userId);

    loadData(reminders, vehicleReminders);
  }
}
