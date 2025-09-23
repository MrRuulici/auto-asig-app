import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/widgets/auto_asig_appbar.dart';
import 'package:auto_asig/core/widgets/auto_asig_drawer.dart';
import 'package:auto_asig/feature/add_screen/screens/add_screen.dart';
import 'package:auto_asig/feature/home_screen/cubit/home_screen_cubit.dart';
import 'package:auto_asig/feature/home_screen/cubit/home_screen_state.dart';
import 'package:auto_asig/feature/home_screen/cubit/reminder_cubit.dart';
import 'package:auto_asig/feature/home_screen/cubit/reminder_state.dart';
import 'package:auto_asig/feature/home_screen/cubit/unified_cubit.dart';
import 'package:auto_asig/feature/home_screen/screens/reminder_list.dart';
import 'package:auto_asig/feature/home_screen/screens/vehicle_reminder_list.dart';
import 'package:auto_asig/feature/home_screen/widgets/home_bottom_navigation_bar.dart';
import 'package:auto_asig/feature/home_screen/widgets/unified_reminder_list.dart';
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

    // Fetch reminders based on the initial active tab when the widget first builds
    if (homeCubit.state.activeTab == HomeScreenTabState.home &&
        !homeCubit.state.isInitialized) {
      final unifiedCubit = context.read<UnifiedCubit>();
      reminderCubit.fetchReminders(userId, unifiedCubit: unifiedCubit);
      // reminderCubit.fetchVehicleReminders(userId);
      homeCubit.initialize();
    } else if (homeCubit.state.activeTab == HomeScreenTabState.personal &&
        !homeCubit.state.isInitialized) {
      reminderCubit.fetchReminders(userId);
      homeCubit.initialize();
    } else if (homeCubit.state.activeTab == HomeScreenTabState.vehicles &&
        !homeCubit.state.isInitialized) {
      reminderCubit.fetchVehicleReminders(userId);
      homeCubit.initialize();
    }

    return Scaffold(
      backgroundColor: backgroundGreyColor,
      appBar: AlliatAppBar(),
      drawer: const AutoAsigDrawer(),
      body: BlocListener<HomeScreenCubit, HomeScreenState>(
        listener: (context, state) async {
          if (state.activeTab == HomeScreenTabState.personal) {
            reminderCubit.fetchReminders(userId);
          } else if (state.activeTab == HomeScreenTabState.vehicles) {
            reminderCubit.fetchVehicleReminders(userId);
          } else if (state.activeTab == HomeScreenTabState.support) {
            // Todo - load the support chat screen
          } else if (state.activeTab == HomeScreenTabState.home) {
            // Todo - load the home screen
            // reminderCubit.fetchVehicleReminders(userId);
            final unifiedCubit = context.read<UnifiedCubit>();
            await unifiedCubit.initialize(userId);
          }
        },
        child: BlocBuilder<ReminderCubit, ReminderState>(
          builder: (context, reminderState) {
            if (reminderState is ReminderLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (reminderState is ReminderError) {
              return Center(child: Text(reminderState.message));
            } else if (reminderState is ReminderLoaded) {
              return BlocBuilder<HomeScreenCubit, HomeScreenState>(
                builder: (context, homeState) {
                  if (homeState.activeTab == HomeScreenTabState.personal) {
                    return const ReminderList();
                  } else if (homeState.activeTab ==
                      HomeScreenTabState.vehicles) {
                    return const VehicleReminderList();
                  } else if (homeState.activeTab ==
                      HomeScreenTabState.support) {
                    return const Center(child: Text('Chat support'));
                  } else if (homeState.activeTab == HomeScreenTabState.home) {
                    // return const Center(child: Text('Home'));
                    return const UnifiedReminderList();
                  } else {
                    return const Center(child: Text('Eroare necunoscuta.'));
                  }
                },
              );
            } else {
              return const Center(
                child: Text('Eroare necunoscuta.'),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: HomeBottomNavigationBar(homeCubit: homeCubit),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // FAB logic
          context.push(AddScreen.absolutePath);
        },
        backgroundColor: logoBlue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
