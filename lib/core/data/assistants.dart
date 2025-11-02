import 'dart:math';

import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/models/notification_model.dart';
import 'package:auto_asig/feature/home/presentation/widgets/notification_details_bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

int selectedGroup = 0;

String getDayOfWeek(DateTime date) {
  final dayOfWeek = date.weekday;

  switch (dayOfWeek) {
    case DateTime.monday:
      return "Luni";
    case DateTime.tuesday:
      return "Marți";
    case DateTime.wednesday:
      return "Miercuri";
    case DateTime.thursday:
      return "Joi";
    case DateTime.friday:
      return "Vineri";
    case DateTime.saturday:
      return "Sâmbătă";
    case DateTime.sunday:
      return "Duminică";
    default:
      return "Zi necunoscută";
  }
}

String getMonthNameFromEnum(Months month) {
  switch (month) {
    case Months.Ianuarie:
      return 'Ianuarie';
    case Months.Februarie:
      return 'Februarie';
    case Months.Martie:
      return 'Martie';
    case Months.Aprilie:
      return 'Aprilie';
    case Months.Mai:
      return 'Mai';
    case Months.Iunie:
      return 'Iunie';
    case Months.Iulie:
      return 'Iulie';
    case Months.August:
      return 'August';
    case Months.Septembrie:
      return 'Septembrie';
    case Months.Octombrie:
      return 'Octombrie';
    case Months.Noiembrie:
      return 'Noiembrie';
    case Months.Decembrie:
      return 'Decembrie';
    default:
      return 'Error';
  }
}

String translateMonthName(String monthEnglish) {
  switch (monthEnglish) {
    case 'January':
      return 'Ianuarie';
    case 'February':
      return 'Februarie';
    case 'March':
      return 'Martie';
    case 'April':
      return 'Aprilie';
    case 'May':
      return 'Mai';
    case 'June':
      return 'Iunie';
    case 'July':
      return 'Iulie';
    case 'August':
      return 'August';
    case 'September':
      return 'Septembrie';
    case 'October':
      return 'Octombrie';
    case 'November':
      return 'Noiembrie';
    case 'December':
      return 'Decembrie';
    default:
      return 'Error';
  }
}

bool validateEmail(String email) {
  // Regulă de validare a adresei de email
  RegExp emailRegex =
      RegExp(r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,})$");

  // Verifică dacă adresa de email respectă regula
  return emailRegex.hasMatch(email);
}

bool validatePhoneNumber(String countryCode, String phoneNumber) {
  // Remove spaces, dashes, or any extra symbols from the phone number
  final sanitizedPhoneNumber = phoneNumber.replaceAll(RegExp(r'\s+|-'), '');

  // Combine country code and phone number
  final fullNumber = '$countryCode$sanitizedPhoneNumber';

  // Basic regex for international numbers (supports country codes +10 digits)
  const phonePattern = r'^\+\d{1,3}\d{10,14}$';
  final regex = RegExp(phonePattern);

  // Validate with regex
  return regex.hasMatch(fullNumber);
}

void showDeletionConfirmation(
  BuildContext context, {
  required String title,
  required String content,
  required Null Function() onConfirm,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: const Icon(
          Icons.warning,
          color: Colors.red,
          size: 40,
        ),
        content: Text(
          content,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Anulează'),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
            child: const Text('Da'),
          ),
        ],
      );
    },
  );
}

void showConfirmationDialog(
  BuildContext context,
  String title,
  String message,
  void Function()? onConfirm,
) {
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: Text(title),
        content: Text(
          message,
          style: const TextStyle(fontSize: theFontSize),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Închide popup-ul
            },
            child: const Text(
              'Nu',
              style: TextStyle(fontSize: theFontSize),
            ),
          ),
          TextButton(
            onPressed: () {
              if (onConfirm != null) {
                onConfirm();
              }
              Navigator.of(context).pop(); // Închide popup-ul după confirmare
            },
            child: const Text(
              'Da',
              style: TextStyle(fontSize: theFontSize),
            ),
          ),
        ],
      );
    },
  );
}

void showInfoDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: Text(title),
        content: Text(
          message,
          style: const TextStyle(fontSize: theFontSize),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Închide popup-ul
            },
            child: const Text(
              'OK',
              style: TextStyle(fontSize: theFontSize),
            ),
          ),
        ],
      );
    },
  );
}

String convertMonth(int month) {
  switch (month) {
    case 1:
      return 'Ianuarie';
    case 2:
      return 'Februarie';
    case 3:
      return 'Martie';
    case 4:
      return 'Aprilie';
    case 5:
      return 'Mai';
    case 6:
      return 'Iunie';
    case 7:
      return 'Iulie';
    case 8:
      return 'August';
    case 9:
      return 'Septembrie';
    case 10:
      return 'Octombrie';
    case 11:
      return 'Noiembrie';
    case 12:
      return 'Decembrie';
    default:
      return 'Error';
  }
}

String convertMonthType(Months month) {
  switch (month) {
    case Months.Ianuarie:
      return 'Ianuarie';
    case Months.Februarie:
      return 'Februarie';
    case Months.Martie:
      return 'Martie';
    case Months.Aprilie:
      return 'Aprilie';
    case Months.Mai:
      return 'Mai';
    case Months.Iunie:
      return 'Iunie';
    case Months.Iulie:
      return 'Iulie';
    case Months.August:
      return 'August';
    case Months.Septembrie:
      return 'Septembrie';
    case Months.Octombrie:
      return 'Octombrie';
    case Months.Noiembrie:
      return 'Noiembrie';
    case Months.Decembrie:
      return 'Decembrie';
    default:
      return 'Error';
  }
}

Months pickNextMonth(String monthName) {
  switch (monthName) {
    case 'Ianuarie':
      return Months.Februarie;
    case 'Februarie':
      return Months.Martie;
    case 'Martie':
      return Months.Aprilie;
    case 'Aprilie':
      return Months.Mai;
    case 'Mai':
      return Months.Iunie;
    case 'Iunie':
      return Months.Iulie;
    case 'Iulie':
      return Months.August;
    case 'August':
      return Months.Septembrie;
    case 'Septembrie':
      return Months.Octombrie;
    case 'Octombrie':
      return Months.Noiembrie;
    case 'Noiembrie':
      return Months.Decembrie;
    case 'Decembrie':
      return Months.Ianuarie;
    default:
      return Months.Ianuarie;
  }
}

String convertPaymentType(PaymentType type) {
  switch (type) {
    case PaymentType.monthly:
      return 'Lunar';
    case PaymentType.anual:
      return 'Anual';
    default:
      return 'Error';
  }
}

PaymentType getPaymentType(String period) {
  switch (period.toLowerCase()) {
    case 'anual':
      return PaymentType.anual;
    default:
      return PaymentType.monthly;
  }
}

void showInfoSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.grey[850],
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: const TextStyle(fontSize: theFontSize, color: Colors.white),
      ),
    ),
  );
}

void showErrorSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: const TextStyle(fontSize: theFontSize, color: Colors.white),
      ),
    ),
  );
}

String convertDateToDay(DateTime date) {
  return weekdays[date.weekday - 1];
}

Timestamp convertStringToTimestamp(String dateString) {
  // Separă componentele datei
  List<String> parts = dateString.split('-');
  if (parts.length != 3) {
    throw FormatException('Formatul datei nu este corect: $dateString');
  }

  // Creează un obiect DateTime
  int day = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int year = int.parse(parts[2]);
  DateTime dateTime = DateTime(year, month, day);

  // Converteste DateTime în Timestamp
  return Timestamp.fromDate(dateTime);
}

DateTime convertStringToDateTime(String dateString) {
  // Separă componentele datei
  List<String> parts = dateString.split('-');
  if (parts.length != 3) {
    throw FormatException('Formatul datei nu este corect: $dateString');
  }

  // Converteste componentele separate în numere întregi
  int day = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int year = int.parse(parts[2]);

  // Creează un obiect DateTime
  return DateTime(year, month, day);
}

String removeDiacritics(String str) {
  var withDiacritics =
      'ăâîșțĂÂÎȘȚáéíóúýÁÉÍÓÚÝäëïöüÿÄËÏÖÜŸàèìòùÀÈÌÒÙãñõÃÑÕåÅęłńśźżĘŁŃŚŹŻçÇđĐøØßğĞşŞţŢ';
  var withoutDiacritics =
      'aaistAAISTaeiouyAEIOUYaeiouyAEIOUYaeiouAEIOUanoANOaAelnSzzELNSZZcCdDoOsgGsStT';

  for (int i = 0; i < withDiacritics.length; i++) {
    str = str.replaceAll(withDiacritics[i], withoutDiacritics[i]);
  }

  return str;
}

void showLoadingOverlay(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

void hideLoadingOverlay(BuildContext context) {
  Navigator.of(context).pop();
}

String generateRandomString() {
  const characters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  String randomString = '';

  for (int i = 0; i < 20; i++) {
    int randomIndex = random.nextInt(characters.length);
    randomString += characters[randomIndex];
  }

  return randomString;
}

bool checkIfDateIsInFuture(DateTime date) {
  DateTime now = DateTime.now();
  return date.isAfter(now);
}

DateTime? convertTimestampToDateTime(Timestamp? timestamp) {
  if (timestamp == null) {
    return null;
  }

  return timestamp.toDate();
}

String convertReminderTypeToString(ReminderType type) {
  switch (type) {
    case ReminderType.idCard:
      return 'Card de identitate';
    case ReminderType.drivingLicense:
      return 'Permis de conducere';
    case ReminderType.passport:
      return 'Pașaport';
    default:
      return 'Error';
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

Color getProgressColor(int progressValue) {
  if (progressValue > 60) {
    return Colors.green;
  } else if (progressValue > 20) {
    return const Color.fromARGB(255, 254, 185, 44);
  } else {
    return Colors.red;
  }
}

void showDetailsBottomSheet({
  required BuildContext context,
  required int progressValue,
  required String title,
  required bool isExpired,
  required String reminderId,
  required String notificationType,
  required List<NotificationModel> initialNotifications,
  required void Function(List<NotificationModel>) onEditCallback,
  void Function()? onDeleteCallback,
  String? subtitle,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return NotificationDetailsBottomSheet(
        progressValue: progressValue,
        title: title,
        initialNotifications: initialNotifications,
        onEditCallback: onEditCallback,
        onDeleteCallback: onDeleteCallback,
        isExpired: isExpired,
        subtitle: subtitle,
        reminderId: reminderId,
        notificationType: notificationType,
      );
    },
  );
}
