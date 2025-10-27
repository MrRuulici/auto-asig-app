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
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isPasswordVisible = false;
  bool _isGoogleSignInInitialized = false;

  AuthenticationCubit(this._firebaseAuth) : super(AuthenticationInitial()) {
    _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize();
      _isGoogleSignInInitialized = true;
    } catch (e) {
      print('Failed to initialize Google Sign-In: $e');
    }
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await _initializeGoogleSignIn();
    }
  }

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
          print('THE PICTURE PROFILE: ${member.profilePictureUrl}');

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

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      emit(AuthenticationLoading());

      // Ensure Google Sign-In is initialized
      await _ensureGoogleSignInInitialized();

      // Authenticate with Google (v7 uses authenticate() instead of signIn())
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email'],
      );

      // Get authentication tokens (synchronous in v7, not async)
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Get authorization for scopes
      final authClient = _googleSignIn.authorizationClient;
      final authorization = await authClient.authorizationForScopes(['email']);

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: authorization?.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user != null) {
        // Load user data from Firestore
        UserModel? member = await loadUserData(
          user,
          () => context.go(LoginScreen.absolutePath),
        );

        if (member != null) {
          // Set the member in the cubit
          context.read<UserDataCubit>().setMember(member);

          print('THE MEMBER: ${member.id}');

          // Fetch reminders
          await context.read<ReminderCubit>().fetchAllReminders(member.id);

          print('Logged in with Google');

          emit(AuthenticationSuccess());
        } else {
          print('Member data is missing');
          await _firebaseAuth.signOut();
          context.go(OnboardingScreen.path);
          emit(AuthenticationFailure('Eroare la încărcarea datelor utilizatorului'));
        }
      }
    } on GoogleSignInException catch (e) {
      String errorMessage;
      switch (e.code) {
        case GoogleSignInExceptionCode.canceled:
          errorMessage = 'Autentificarea a fost anulată';
          break;
        case GoogleSignInExceptionCode.clientConfigurationError:
          errorMessage = 'Eroare de configurare. Contactați suportul.';
          break;
        case GoogleSignInExceptionCode.interrupted:
          errorMessage = 'Autentificarea a fost întreruptă';
          break;
        default:
          errorMessage = e.description ?? 'Eroare Google Sign-In';
          break;
      }
      emit(AuthenticationFailure(errorMessage));
    } on FirebaseAuthException catch (e) {
      print('Firebase Error: ${e.code} - ${e.message}');
      emit(AuthenticationFailure(
        e.message ?? 'Eroare necunoscută la autentificare',
      ));
    } catch (e) {
      print('Error during Google Sign-In: $e');
      emit(AuthenticationFailure('A apărut o eroare: $e'));
    }
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    emit(PasswordVisibilityState(_isPasswordVisible));
  }

  bool get isPasswordVisible => _isPasswordVisible;

  void signOut() {
    _firebaseAuth.signOut();
    _googleSignIn.signOut(); // Also sign out from Google
    emit(AuthenticationInitial());
  }
}