import 'package:auto_asig/core/data/http_data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:auto_asig/core/models/notification_model.dart';

part 'bottom_sheet_details_state.dart';

class BottomSheetDetailsCubit extends Cubit<BottomSheetDetailsState> {
  final String userId;
  final String reminderId;
  final String notificationType;

  BottomSheetDetailsCubit(
    List<NotificationModel> notifications, {
    required this.userId,
    required this.reminderId,
    required this.notificationType,
  }) : super(BottomSheetDetailsState(notifications));

  void updateNotification(int index, NotificationModel updatedNotification) {
    final updatedNotifications =
        List<NotificationModel>.from(state.notifications);
    updatedNotifications[index] = updatedNotification;
    emit(state.copyWith(notifications: updatedNotifications));
  }

  Future<void> removeNotification(int index) async {
    final updatedNotifications =
        List<NotificationModel>.from(state.notifications);

    if (index >= 0 && index < updatedNotifications.length) {
      final notificationToRemove = updatedNotifications[index];

      try {
        // Attempt to remove the notification from Firestore
        await removeNotificationFromFirestore(
          notification: notificationToRemove,
          userId: userId,
          reminderId: reminderId,
          notificationType: notificationType,
        );

        // If successful, update the local state
        updatedNotifications.removeAt(index);
        // Clear error message on success
        emit(
          state.copyWith(
            notifications: updatedNotifications,
            errorMessage: null,
          ),
        );
      } catch (e) {
        // Set the error message in the state if removal fails
        emit(state.copyWith(
            errorMessage:
                "Nu s-a putut șterge notificarea. Încearcă din nou."));
      }
    }
  }

  void clearErrorMessage() {
    state.copyWith(errorMessage: null);
  }
}
