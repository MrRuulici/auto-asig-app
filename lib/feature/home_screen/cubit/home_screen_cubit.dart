import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/feature/home_screen/cubit/home_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit() : super(HomeScreenState());

  void selectTab(HomeScreenTabState tab) {
    // Update the state to indicate loading for the selected tab
    emit(state.copyWith(
        activeTab: tab, isLoading: true, hasError: false, errorMessage: null));

    // Simulate data fetching or other async operations
    fetchDataForTab(tab);
  }

  void initialize() {
    emit(state.copyWith(isInitialized: true));
  }

  void fetchDataForTab(HomeScreenTabState tab) async {
    try {
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate a data fetch delay

      // Set loading to false after fetching data
      emit(state.copyWith(isLoading: false, hasError: false));
    } catch (error) {
      emit(state.copyWith(
          isLoading: false, hasError: true, errorMessage: error.toString()));
    }
  }

  void showError(String message) {
    emit(state.copyWith(
        hasError: true, errorMessage: message, isLoading: false));
  }

  void changeState(HomeScreenState newState) {
    emit(newState);
  }
}
