import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/data/http_data.dart';
import 'package:auto_asig/core/data/http_user_data.dart';
import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/core/models/reminder.dart';
import 'package:auto_asig/core/models/vehicle_reminder.dart';
import 'package:auto_asig/feature/home/presentation/cubit/reminder_state.dart';
import 'package:auto_asig/feature/home/presentation/cubit/unified_cubit.dart';
import 'package:bloc/bloc.dart';

class ReminderCubit extends Cubit<ReminderState> {
  ReminderCubit() : super(ReminderInitial());

  // Initialize with general reminders
  void initializeWithReminders(List<Reminder> reminders) {
    if (state is ReminderLoaded) {
      final currentState = state as ReminderLoaded;
      emit(currentState.copyWith(reminders: reminders));
    } else {
      emit(ReminderLoaded(reminders: reminders));
    }
  }

  // Fetch general reminders (for "Personal" tab)
  Future<void> fetchReminders(String userId,
      {UnifiedCubit? unifiedCubit}) async {
    try {
      emit(ReminderLoading());

      // Fetch general reminders
      final reminders = await getRemindersFromDB(userId);

      if (state is ReminderLoaded) {
        final currentState = state as ReminderLoaded;
        if (unifiedCubit != null) {
          unifiedCubit.loadReminders(reminders);
        }
        emit(currentState.copyWith(reminders: reminders));
      } else {
        emit(ReminderLoaded(reminders: reminders));
      }
    } catch (e) {
      emit(ReminderError('Failed to load reminders: ${e.toString()}'));
    }
  }

  // Fetch vehicle-specific reminders
  Future<void> fetchVehicleReminders(String userId,
      {UnifiedCubit? unifiedCubit}) async {
    try {
      emit(ReminderLoading());

      // Fetch vehicle-specific reminders
      final vehicleReminders = await getAllVehiclesForUser(userId);

      if (state is ReminderLoaded) {
        final currentState = state as ReminderLoaded;
        emit(currentState.copyWith(vehicleReminders: vehicleReminders));
        if (unifiedCubit != null) {
          unifiedCubit.loadVehicleReminders(vehicleReminders);
        }
      } else {
        emit(ReminderLoaded(vehicleReminders: vehicleReminders));
      }
    } catch (e) {
      emit(ReminderError(
          'Nu s-a reușit încărcarea notificărilor pentru vehicule: ${e.toString()}'));
    }
  }

  Future<void> fetchAllReminders(String userId) async {
    try {
      emit(ReminderLoading());

      // Get all data for the user and separate the reminders
      final fullReminders = await getFullUserData(userId);
      final reminders =
          (fullReminders['reminders'] as List<dynamic>).cast<Reminder>();
      final vehicleReminders =
          (fullReminders['vehicleReminders'] as List<dynamic>)
              .cast<VehicleReminder>();

      emit(ReminderLoaded(
        reminders: reminders,
        vehicleReminders: vehicleReminders,
      ));
    } catch (e) {
      emit(ReminderError('Ups... Eroare: ${e.toString()}'));
    }
  }

  // Add a new general reminder
  void addNewReminder(
    String id,
    String title,
    DateTime expirationDate,
    List<NotificationModel> notificationDates,
    ReminderType type,
  ) {
    if (state is ReminderLoaded) {
      final currentState = state as ReminderLoaded;
      final updatedReminders = <Reminder>[
        ...(currentState.reminders ?? []),
        Reminder(
          id: id,
          title: title,
          expirationDate: expirationDate,
          notificationDates: notificationDates,
          creationDate: DateTime.now(),
          type: type,
        )
      ];

      emit(currentState.copyWith(reminders: updatedReminders));
    } else {
      emit(ReminderError(
          'Nu se poate adăuga notificarea: notificările nu au fost încărcate.'));
    }
  }

  // Update an existing general reminder
  void updateReminder(
    String title,
    DateTime newExpirationDate,
    List<NotificationModel> newNotificationDates,
  ) {
    if (state is ReminderLoaded) {
      final currentState = state as ReminderLoaded;

      // Update the specific reminder
      final updatedReminders = <Reminder>[
        ...(currentState.reminders ?? []).map((reminder) {
          if (reminder.title == title) {
            return Reminder(
              id: reminder.id,
              title: title,
              expirationDate: newExpirationDate,
              notificationDates: newNotificationDates,
              creationDate:
                  reminder.creationDate, // Keep original creation date
              type: reminder.type, // Keep original type
            );
          }
          return reminder;
        })
      ];

      emit(currentState.copyWith(reminders: updatedReminders));
    } else {
      emit(ReminderError(
          'Nu se poate actualiza notificarea: notificările nu au fost încărcate.'));
    }
  }

  // Delete a vehicle reminder
  Future<void> deleteVehicleReminder(
    String userId,
    VehicleReminder vehicleReminder,
  ) async {
    try {
      await deleteVehicleData(vehicleId: vehicleReminder.id, userId: userId);

      if (state is ReminderLoaded) {
        final currentState = state as ReminderLoaded;

        // Remove the specific vehicle reminder
        final updatedVehicleReminders = (currentState.vehicleReminders ?? [])
            .where((vr) => vr.id != vehicleReminder.id)
            .toList();

        emit(currentState.copyWith(vehicleReminders: updatedVehicleReminders));
      }
    } catch (e) {
      emit(ReminderError(
          'Nu se poate șterge notificarea: notificările nu au fost încărcate.'));
    }
  }

  void addOrUpdateReminder(
    String name,
    DateTime expirationDate,
    List<NotificationModel> notificationDates,
    ReminderType idCard,
    bool isEditing,
    String id,
  ) {
    // TODO - Implement logic to add or update a reminder
    if (!isEditing) {
      // Add new reminder
      addNewReminder(
        id,
        name,
        expirationDate,
        notificationDates,
        idCard,
      );
    } else {
      // Update existing reminder
      updateReminder(
        name,
        expirationDate,
        notificationDates,
      );
    }
  }
}
