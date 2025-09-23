import 'package:auto_asig/core/data/constants.dart';

class HomeScreenState {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final HomeScreenTabState activeTab;
  final bool isInitialized;

  HomeScreenState({
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.activeTab = HomeScreenTabState.home,
    this.isInitialized = false,
  });

  List<Object?> get props => [
        isLoading,
        hasError,
        errorMessage,
        activeTab,
        isInitialized,
      ];

  // The copyWith function allows us to create a new instance of HomeScreenState
  // with modified values while keeping other properties unchanged.
  HomeScreenState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    HomeScreenTabState? activeTab,
    bool? isInitialized,
  }) {
    return HomeScreenState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      activeTab: activeTab ?? this.activeTab,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}
