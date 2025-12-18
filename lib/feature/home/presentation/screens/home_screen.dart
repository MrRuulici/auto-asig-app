// feature/home/presentation/screens/home_screen.dart

import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/widgets/auto_asig_appbar.dart';
import 'package:auto_asig/core/widgets/auto_asig_drawer.dart';
import 'package:auto_asig/feature/add/presentation/screens/add_screen.dart';
import 'package:auto_asig/feature/home/presentation/cubit/feedback_cubit.dart';
import 'package:auto_asig/feature/home/presentation/cubit/home_screen_cubit.dart';
import 'package:auto_asig/feature/home/presentation/cubit/home_screen_state.dart';
import 'package:auto_asig/feature/home/presentation/cubit/reminder_cubit.dart';
import 'package:auto_asig/feature/home/presentation/cubit/reminder_state.dart';
import 'package:auto_asig/feature/home/presentation/cubit/unified_cubit.dart';
import 'package:auto_asig/feature/home/presentation/cubit/unified_state.dart';
import 'package:auto_asig/feature/home/presentation/screens/feedback_screen.dart';
import 'package:auto_asig/feature/home/presentation/screens/reminder_list.dart';
import 'package:auto_asig/feature/home/presentation/screens/vehicle_reminder_list.dart';
import 'package:auto_asig/feature/home/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:auto_asig/feature/home/presentation/widgets/unified_reminder_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const path = '/home_screen';

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserDataCubit>().state.member.id;
    final homeCubit = context.read<HomeScreenCubit>();
    final reminderCubit = context.read<ReminderCubit>();

    // Initial load only
    if (!homeCubit.state.isInitialized) {
      if (homeCubit.state.activeTab == HomeScreenTabState.home) {
        final unifiedCubit = context.read<UnifiedCubit>();
        unifiedCubit.initialize(userId);
      } else if (homeCubit.state.activeTab == HomeScreenTabState.personal) {
        reminderCubit.fetchReminders(userId);
      } else if (homeCubit.state.activeTab == HomeScreenTabState.vehicles) {
        reminderCubit.fetchVehicleReminders(userId);
      }
      homeCubit.initialize();
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FeedbackCubit(),
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundGreyColor,
        appBar: AlliatAppBar(),
        body: BlocListener<HomeScreenCubit, HomeScreenState>(
          listenWhen: (previous, current) {
            // Only listen when the tab actually changes
            return previous.activeTab != current.activeTab;
          },
          listener: (context, state) async {
            // This only fires when switching tabs, not on initial load
            if (state.activeTab == HomeScreenTabState.personal) {
              reminderCubit.fetchReminders(userId);
            } else if (state.activeTab == HomeScreenTabState.vehicles) {
              reminderCubit.fetchVehicleReminders(userId);
            } else if (state.activeTab == HomeScreenTabState.home) {
              final unifiedCubit = context.read<UnifiedCubit>();
              await unifiedCubit.initialize(userId);
            }
          },
          child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
            builder: (context, homeState) {
              if (homeState.activeTab == HomeScreenTabState.home) {
                return BlocBuilder<UnifiedCubit, UnifiedState>(
                  builder: (context, unifiedState) {
                    if (unifiedState.reminders == null &&
                        unifiedState.vehicleReminders == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return const UnifiedReminderList();
                  },
                );
              } else if (homeState.activeTab == HomeScreenTabState.support) {
                return const ChatPage();
              }

              return BlocBuilder<ReminderCubit, ReminderState>(
                builder: (context, reminderState) {
                  if (reminderState is ReminderLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (reminderState is ReminderError) {
                    return Center(child: Text(reminderState.message));
                  } else if (reminderState is ReminderLoaded) {
                    if (homeState.activeTab == HomeScreenTabState.personal) {
                      return const ReminderList();
                    } else if (homeState.activeTab ==
                        HomeScreenTabState.vehicles) {
                      return const VehicleReminderList();
                    } else {
                      return const Center(child: Text('Eroare necunoscuta.'));
                    }
                  } else {
                    return const Center(
                      child: Text('Eroare necunoscuta.'),
                    );
                  }
                },
              );
            },
          ),
        ),
        bottomNavigationBar: HomeBottomNavigationBar(homeCubit: homeCubit),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push(AddScreen.absolutePath);
          },
          backgroundColor: logoBlue,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}