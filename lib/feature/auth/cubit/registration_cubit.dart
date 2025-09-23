import 'package:auto_asig/core/data/http_user_data.dart';
import 'package:auto_asig/feature/auth/cubit/registration_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/src/models/country_code.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final FirebaseAuth _firebaseAuth;

  RegistrationCubit(this._firebaseAuth) : super(RegistrationInitial());

  void toggleCheckbox(bool isChecked) {
    emit(RegistrationCheckboxState(isChecked));
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required CountryCode country,
  })


  async {

    emit(RegistrationLoading()); //Emite o stare de încărcare

    try {
      // Create the user with Firebase Authentication
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        try {
          // Register user details in Firestore after account creation
          await registerUser(
            user.uid,
            email,
            firstName,
            lastName,
            phone,
            country,
          );

          // Emit success if registration completes without issues
          await user.sendEmailVerification();
          print('Email de verificare trimis la ${user.email}');
          emit(RegistrationVerificationEmailSent());

        } catch (error) {
          // Catch and handle errors from the registerUser function
          print('Error registering user in Firestore: $error');
          emit(RegistrationFailure(
            'Eroare necunoscută la înregistrare. Te rugăm să contactezi suportul tehnic.',
          ));
        }
      }
    }

    on FirebaseAuthException catch (e) {
      print('Firebase Authentication Error: ${e.code} - ${e.message}');
      String errorMessage;
      switch (e.code) {

        case 'weak-password': //TODO: NU MERGE
          errorMessage = 'Parola este prea slabă.';
          break;
        case 'email-already-in-use':
          errorMessage = 'Există deja un cont cu acest email.';
          break;
        case 'invalid-email': //TODO: NU MERGE
          errorMessage = 'Adresa de email nu este validă.';
          break;
        default:
          errorMessage = e.message ?? 'Eroare necunoscută la înregistrare.';
          break;
      }
      emit(RegistrationFailure(errorMessage));
    }



  }
}
