import 'package:auto_asig/core/app/app_data.dart';
import 'package:auto_asig/core/data/http_data.dart';
import 'package:auto_asig/core/models/reminder.dart';
import 'package:auto_asig/core/models/user.dart';
import 'package:auto_asig/core/models/vehicle_reminder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';

Future<UserModel?> readUserData(String id) async {
  // print('Reading user data for accountId: $id');
  var querySnapshot = await userCollection!.doc(id).get();

  UserModel? currentMember;

  // Check if the document exists
  if (querySnapshot.exists) {
    // Get the first matching document
    var snapshot = querySnapshot;

    final data = snapshot.data() as Map<String, dynamic>;

    currentMember = UserModel(
      snapshot.id, // Use the Firestore document ID for member ID
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      country: data['country'] ?? '',
    );

    // print('User data: $data');
  } else {
    print('No user found with accountId: $id');

    // Todo - Log the user out????
  }

  return currentMember;
}

Future<void> updateEmailAndPhoneForUser(
  String id,
  String email,
  String phone,
) async {
  await userCollection!.doc(id).update({
    'email': email,
    'phone': phone,
  });
}

Future<bool> registerUser(
  String uid,
  String email,
  String firstName,
  String lastName,
  String phone,
  CountryCode country,
) async {
  try {
    // Reference to the user's document in Firestore
    DocumentReference userDoc = userCollection!.doc(uid);

    // Combine country dial code with the phone number
    String fullPhoneNr = '${country.dialCode}$phone';

    // User data to be written to Firestore
    Map<String, dynamic> userData = {
      'timestamp': FieldValue.serverTimestamp(),
      'email': email,
      'lastName': lastName,
      'firstName': firstName,
      'phone': fullPhoneNr,
      'country': country.name,
    };

    // Write the data to Firestore and await the completion
    await userDoc.set(userData);

    return true; // Return true if the operation is successful
  } catch (e) {
    // Log any errors that occur
    print('Error writing user data to Firestore: $e');

    return false; // Return false if an error occurs
  }
}

Future<UserModel?> loadUserData(
  User user,
  void Function() navigateTo,
) async {
  UserModel? member = await readUserData(user.uid);
  if (member != null) {
    UserModel userModel = UserModel(
      member.id,
      firstName: member.firstName,
      lastName: member.lastName,
      email: member.email,
      phone: member.phone,
      country: member.country,
    );

    return userModel;
  } else {
    // Logout and navigate to login if member data is missing
    await FirebaseAuth.instance.signOut();
    // loadLoginScreen!();
    navigateTo();
    return null;
  }
}

Future<Map<String, dynamic>> getFullUserData(String userId) async {
  Map<String, dynamic> fullReminders = {};

  // Get the reminders for the user
  List<Reminder> reminders = await getRemindersFromDB(userId);
  List<VehicleReminder> vehicleReminders = await getAllVehiclesForUser(userId);

  fullReminders['reminders'] = reminders;
  fullReminders['vehicleReminders'] = vehicleReminders;

  return fullReminders;
}
