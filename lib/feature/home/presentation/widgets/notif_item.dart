import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/assistants.dart';
import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/data/http_data.dart';
import 'package:auto_asig/core/models/reminder.dart';
import 'package:auto_asig/core/widgets/progress_colored_bar.dart';
import 'package:auto_asig/feature/documents/presentation/screens/id_cards_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/src/intl/date_format.dart';

class NotifItem extends StatelessWidget {
  const NotifItem({
    super.key,
    required this.reminder,
    required this.isExpired,
    required this.days,
    required this.dateFormatter,
    required this.timeFormatter,
    required this.remainingTime,
    this.padding,
  });

  final Reminder reminder;
  final bool isExpired;
  final int days;
  final DateFormat dateFormatter;
  final DateFormat timeFormatter;
  final int remainingTime;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    // Convert reminder type to string for display
    final String type = convertReminderTypeToString(reminder.type);

    // check if the remaining time is 0
    bool isZero = remainingTime == 0;

    // Determine the progress bar color based on remaining time
    Color progressColor = getProgressColor(remainingTime);
    final int absDays = remainingTime.abs();

    // Format expiration date
    final String expirationDate = dateFormatter.format(reminder.expirationDate);

    // Calculate remaining years, months, and days
    final int years = absDays ~/ 365;
    final int months = (absDays % 365) ~/ 30;
    final int remainingDays = absDays % 30;

// Build the time remaining text dynamically, showing only non-zero values
    List<String> timeComponents = [];
    if (years > 0) timeComponents.add('$years ani');
    if (months > 0) timeComponents.add('$months luni'); // No padding for months
    if (remainingDays > 0) {
      timeComponents.add('$remainingDays zile'); // No padding for days
    }

// Join the components with a space and separator
    final String timeRemainingText = timeComponents.join(' ');

// Build the combined expiration text based on whether the reminder is expired
    final String expirationText = isZero
        ? 'Documentul expiră astăzi'
        : isExpired
            ? 'Expirat de: $expirationDate  |  $timeRemainingText'
            : 'Expiră în: $expirationDate  |  $timeRemainingText';

    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: Card(
        color: isExpired || isZero ? lightRedColor : null,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4,
        child: ListTile(
          contentPadding: const EdgeInsets.only(
            left: 16,
            bottom: 16,
            right: 3,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Expanded(
              //   child: Text(
              //     isExpired
              //         ? '$type - Expirat aaaa sasd asdasdasdawee ae asdahjksgd ajshdgasjkhdga sjkhdga sgd'
              //         : type,
              //     style: const TextStyle(
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold,
              //       color: logoBlue,
              //     ),
              //     softWrap: true, // Allows the text to wrap to the next line
              //     maxLines:
              //         2, // Limits the text to a maximum of 2 lines (optional)
              //   ),
              // ),
              Expanded(
                child: Text(
                  isExpired ? '$type - Expirat' : type,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: logoBlue,
                  ),
                  softWrap: true,
                ),
              ),

              TextButton(
                onPressed: () {
                  String notificationType = '';
                  switch (reminder.type) {
                    case ReminderType.drivingLicense:
                      notificationType = 'driving_lic';
                      break;
                    case ReminderType.idCard:
                      notificationType = 'id_cards';
                      break;
                    case ReminderType.passport:
                      notificationType = 'passports';
                      break;
                    default:
                      notificationType = 'vehicles';
                      break;
                  }

                  showDetailsBottomSheet(
                    context: context,
                    title: reminder.title,
                    isExpired: isExpired,
                    reminderId: reminder.id,
                    notificationType: notificationType,
                    progressValue: days,
                    initialNotifications: reminder.notificationDates,
                    onEditCallback: (p0) {
                      // Todo - Handle edit callback, e.g., update reminder
                      context.push(
                        '${ReminderScreen.absolutePath}/idCard',
                        extra: reminder,
                      );
                    },
                    onDeleteCallback: () async {
                      // show loading dialog
                      showLoadingDialog(context);

                      final userId =
                          context.read<UserDataCubit>().state.member.id;

                      bool deleted = await deleteReminderForUser(
                          userId, reminder.id, reminder.type);

                      // close loading dialog
                      context.pop();

                      if (deleted) {
                        // close the bottom sheet
                        Navigator.of(context).pop();

                        // show success snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Notificarea a fost ștearsă cu succes',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        // show error snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'A apărut o eroare la ștergerea documentului',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      'Detalii',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        color: logoBlue,
                      ),
                    ),
                    SizedBox(width: 4), // Space between text and icon
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: logoBlue,
                    ),
                  ],
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the reminder title in italic and bold
              Text(
                '(${reminder.title})',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true, // Wraps the title text
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Combined expiration text with date and remaining time, wrapped to avoid overflow
              Wrap(
                children: [
                  Text(
                    expirationText,
                    style: TextStyle(
                      color: isExpired || remainingTime < 7
                          ? Colors.red[700]
                          : primaryBlue,
                      fontWeight: remainingTime < 7
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Display progress bar based on remaining time
              isZero
                  ? const SizedBox(height: 0)
                  : Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: ProgressColoredBar(
                        progressValue: absDays,
                        progressColor: progressColor,
                        isExpired: isExpired,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  static fromJson(Map<String, dynamic> jsonDecode) {
    List<NotifItem> notifItems = [];

    return notifItems;
  }
}
