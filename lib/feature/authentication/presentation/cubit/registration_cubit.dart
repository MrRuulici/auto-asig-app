import 'package:auto_asig/core/data/http_user_data.dart';
import 'package:auto_asig/feature/authentication/presentation/cubit/registration_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/src/models/country_code.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;

  RegistrationCubit(this._firebaseAuth) : super(RegistrationInitial()) {
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
  }) async {
    emit(RegistrationLoading());

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
          print('Error registering user in Firestore: $error');
          emit(RegistrationFailure(
            'Eroare necunoscută la înregistrare. Te rugăm să contactezi suportul tehnic.',
          ));
        }
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Authentication Error: ${e.code} - ${e.message}');
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Parola este prea slabă.';
          break;
        case 'email-already-in-use':
          errorMessage = 'Există deja un cont cu acest email.';
          break;
        case 'invalid-email':
          errorMessage = 'Adresa de email nu este validă.';
          break;
        default:
          errorMessage = e.message ?? 'Eroare necunoscută la înregistrare.';
          break;
      }
      emit(RegistrationFailure(errorMessage));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(RegistrationLoading());

      // Ensure Google Sign-In is initialized
      await _ensureGoogleSignInInitialized();

      // Authenticate with Google (v7 uses authenticate() instead of signIn())
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email'], // Specify required scopes
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
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // Check if this is a new user
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        // Register new user in Firestore
        final user = userCredential.user!;

        // Extract name parts
        String firstName = googleUser.displayName?.split(' ').first ?? '';
        String lastName = googleUser.displayName?.split(' ').skip(1).join(' ') ?? '';

        bool success = await registerUser(
          user.uid,
          user.email ?? '',
          firstName,
          lastName,
          '', // Phone number is empty for Google sign-in
          const CountryCode(
            name: 'Romania',
            code: 'RO',
            dialCode: '+40',
          ),
        );

        if (success) {
          emit(RegistrationGoogleSuccess());
        } else {
          emit(RegistrationFailure('Eroare la crearea profilului'));
        }
      } else {
        // Existing user, just emit success
        emit(RegistrationGoogleSuccess());
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
      emit(RegistrationFailure(errorMessage));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        emit(RegistrationFailure('Există deja un cont cu acest email'));
      } else if (e.code == 'invalid-credential') {
        emit(RegistrationFailure('Credențiale invalide'));
      } else {
        emit(RegistrationFailure(e.message ?? 'Autentificare eșuată'));
      }
    } catch (e) {
      emit(RegistrationFailure('A apărut o eroare: $e'));
      print(e);
    }
  }
}