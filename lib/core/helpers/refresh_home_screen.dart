import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/feature/home/presentation/cubit/home_screen_cubit.dart';
import 'package:auto_asig/feature/home/presentation/cubit/reminder_cubit.dart';
import 'package:auto_asig/feature/home/presentation/cubit/unified_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Refreshes the home screen data based on the active tab
Future<void> refreshHomeScreenData(BuildContext context) async {
  final userId = context.read<UserDataCubit>().state.member.id;
  final homeCubit = context.read<HomeScreenCubit>();
  final reminderCubit = context.read<ReminderCubit>();
  final unifiedCubit = context.read<UnifiedCubit>();

  // Refresh based on which tab is active
  if (homeCubit.state.activeTab == HomeScreenTabState.home) {
    await unifiedCubit.initialize(userId);
  } else if (homeCubit.state.activeTab == HomeScreenTabState.personal) {
    await reminderCubit.fetchReminders(userId);
  } else if (homeCubit.state.activeTab == HomeScreenTabState.vehicles) {
    await reminderCubit.fetchVehicleReminders(userId);
  }
}