import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const int appVersion = 0;
bool isOldVersion = true;
bool isMaintenance = false;
String updateUrl = '';

int currentNrOfMembers = 0;
int currentNrOfUsers = 0;

bool sendsEmail = false;

late FirebaseFirestore db;
CollectionReference? appDataCollection;
CollectionReference? userCollection;
// CollectionReference? userDataCollection;
// DocumentReference? vehicleDocument;
// DocumentReference? idCardDocument;
// DocumentReference? passportDocument;
// DocumentReference? driversLicenseDocument;
// DocumentReference? otherDocument;

// CollectionReference? vehicleCollection;
// CollectionReference? driversLicenseCollection;
// CollectionReference? passportCollection;
// CollectionReference? idCardCollection;
FlutterSecureStorage? secureStorage;

FirebaseMessaging? messaging;
