import 'package:auto_asig/core/cubit/user_data_cubit.dart';
import 'package:auto_asig/core/data/http_user_data.dart';
import 'package:auto_asig/core/models/user.dart';
import 'package:auto_asig/feature/authentication/presentation/cubit/auth_state.dart';
import 'package:auto_asig/feature/authentication/presentation/screens/login_screen.dart';
import 'package:auto_asig/feature/authentication/presentation/screens/onboarding_screen.dart';
import 'package:auto_asig/feature/home/presentation/cubit/reminder_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final FirebaseAuth _firebaseAuth;
  bool _isPasswordVisible = false;

  AuthenticationCubit(this._firebaseAuth) : super(AuthenticationInitial());

  Future<bool> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Perform login
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        await user.reload(); //reincarca starea pt. emailVerified


        // acces doar cu email verificat
        if (user != null && !user.emailVerified) {
          print('Login respins: Emailul nu este verificat pentru ${user.email}');
          await _firebaseAuth.signOut();
          emit(AuthenticationFailure('Emailul tău nu este verificat. Te rugăm să-ți verifici inbox-ul.'));
          return false; // Nu permite continuarea login-ului
        }

        // Dacă emailul este verificat, continuă cu logica ta existentă:
        UserModel? member = await loadUserData(
          user, // Trimite obiectul Firebase User
              () => context.go(LoginScreen.absolutePath),
        );


        if (member != null) {
          // Set the member in the cubit only after loading the data successfully
          context.read<UserDataCubit>().setMember(member);

          print('THE MEMBER: ${member.id}');

          // Fetch reminders only after setting the member successfully
          await context.read<ReminderCubit>().fetchAllReminders(member.id);

          print('Logged in with email');
        } else {
          print('Member data is missing');
          // Logout and navigate to login if member data is missing
          await _firebaseAuth.signOut();
          context.go(OnboardingScreen.path);
          return false;
        }
      }



      emit(AuthenticationSuccess());
      return true;
    } on FirebaseAuthException catch (e) {
      print('Firebase Error: ${e.code} - ${e.message}');
      emit(AuthenticationFailure(
        e.message ?? 'Unknown error during authentication',
      ));
      return false;
    }
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    emit(PasswordVisibilityState(_isPasswordVisible));
  }

  bool get isPasswordVisible => _isPasswordVisible;

  void signOut() {
    _firebaseAuth.signOut();
    emit(AuthenticationInitial());
  }
}
