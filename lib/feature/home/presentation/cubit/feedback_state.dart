// feature/feedback/presentation/cubit/feedback_state.dart

class FeedbackState {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final String? successMessage;

  FeedbackState({
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.successMessage,
  });

  List<Object?> get props => [
        isLoading,
        hasError,
        errorMessage,
        successMessage,
      ];

  FeedbackState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    String? successMessage,
  }) {
    return FeedbackState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}