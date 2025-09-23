import 'package:auto_asig/feature/home_screen/cubit/reminder_cubit.dart';
import 'package:auto_asig/feature/home_screen/cubit/reminder_state.dart';
import 'package:auto_asig/feature/home_screen/widgets/no_elements.dart';
import 'package:auto_asig/feature/home_screen/widgets/notif_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ReminderList extends StatelessWidget {
  const ReminderList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderCubit, ReminderState>(
      builder: (context, state) {
        if (state is ReminderInitial) {
          return const Center(child: Text('Se încarcă...'));
        } else if (state is ReminderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReminderError) {
          return Center(child: Text(state.message));
        } else if (state is ReminderLoaded) {
          final reminders = state.reminders;

          if (reminders == null || reminders.isEmpty) {
            return const NoElements();
          }

          // Sort the reminders by expiration date
          reminders
              .sort((a, b) => a.expirationDate.compareTo(b.expirationDate));

          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminders[index];

              final DateFormat dateFormatter = DateFormat('dd.MM.yyyy');
              final DateFormat timeFormatter = DateFormat('HH:mm');

              final remainingTime =
                  reminder.expirationDate.difference(DateTime.now()).inDays;
              bool isExpired = remainingTime < 0;
              final days = remainingTime.abs();

              if (index == reminders.length - 1) {
                return NotifItem(
                  reminder: reminder,
                  isExpired: isExpired,
                  days: days,
                  dateFormatter: dateFormatter,
                  timeFormatter: timeFormatter,
                  remainingTime: remainingTime,
                  padding: const EdgeInsets.only(bottom: 40),
                );
              }

              return NotifItem(
                reminder: reminder,
                isExpired: isExpired,
                days: days,
                dateFormatter: dateFormatter,
                timeFormatter: timeFormatter,
                remainingTime: remainingTime,
              );
            },
          );
        } else {
          return const Center(child: Text('Eroare necunoscută.'));
        }
      },
    );
  }
}
