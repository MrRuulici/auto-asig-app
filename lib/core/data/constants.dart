import 'package:auto_asig/core/models/user.dart';
import 'package:flutter/material.dart';

double? screenWidth;
double? screenHeight;
const double padding = 32;
const double theFontSize = 16;

const int maxNrOfNotifications = 3;
const int maxNrOfDocuments = 3;
const int maxNrOfVehicles = 3;

const Color logoBlue = Color.fromRGBO(24, 72, 151, 1);
const Color buttonBlue = Colors.indigoAccent;
const Color primaryBlue = Color.fromRGBO(2, 74, 173, 1);
const Color primaryRed = Color.fromRGBO(255, 0, 0, 0.83);
const Color blueAccent = Colors.blueAccent;
const Color primaryYellow = Color.fromRGBO(255, 194, 21, 1);
const Color colorGreen = Color.fromRGBO(45, 182, 50, 1);
const Color progressYellow = Color.fromRGBO(254, 185, 44, 1);
const Color backgroundGreyColor = Color.fromARGB(255, 247, 248, 250);
const Color lightRedColor = Color.fromARGB(255, 255, 171, 164);
const Color textFieldGrey = Color.fromRGBO(217, 217, 217, 1);

// TODO - DELETE THESE
const String defaultProfilePictureUrl =
    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';

String currentUserId = '';
String? fCMToken;

const List<String> weekdays = [
  'Luni',
  'Marți',
  'Miercuri',
  'Joi',
  'Vineri',
  'Sâmbătă',
  'Duminică'
];

enum ReminderType {
  idCard,
  drivingLicense,
  passport,
}

// Enum for notification type
enum VehicleNotificationType {
  ITP,
  RCA,
  CASCO,
  Rovinieta,
  Tahograf,
}

enum PaymentType {
  monthly,
  anual,
}

enum HomeScreenTabState {
  home,
  personal,
  vehicles,
  addNew,
  support,
}

enum JournalEntryType {
  // none,
  service,
  distribution,
  breaks,
  other,
}

JournalEntryType convertStringToJournalEntryType(String? type) {
  switch (type) {
    case 'distributionJournal':
      return JournalEntryType.distribution;
    case 'serviceJournal':
      return JournalEntryType.service;
    case 'breaksJournal':
      return JournalEntryType.breaks;
    default:
      return JournalEntryType.other;
    // return JournalEntryType.none;
  }
}

extension PaymentTypeExtension on PaymentType {
  static PaymentType fromString(String type) {
    return type == 'anual' ? PaymentType.anual : PaymentType.monthly;
  }
}

enum Months {
  Ianuarie,
  Februarie,
  Martie,
  Aprilie,
  Mai,
  Iunie,
  Iulie,
  August,
  Septembrie,
  Octombrie,
  Noiembrie,
  Decembrie
}

List<UserModel> allMembersGlobal = [];

// Member? currentMember;

UserModel emptyMember = UserModel(
  'NULL',
  firstName: '',
  lastName: '',
  email: '',
  phone: '',
  country: '',
);
