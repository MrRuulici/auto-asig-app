part of 'bottom_sheet_details_cubit.dart';

class BottomSheetDetailsState extends Equatable {
  final List<NotificationModel> notifications;
  final String? errorMessage; // Add error message field

  const BottomSheetDetailsState(this.notifications, {this.errorMessage});

  @override
  List<Object?> get props =>
      [notifications, errorMessage]; // Include errorMessage in props

  BottomSheetDetailsState copyWith({
    List<NotificationModel>? notifications,
    String? errorMessage,
  }) {
    return BottomSheetDetailsState(
      notifications ?? this.notifications,
      errorMessage: errorMessage,
    );
  }
}
