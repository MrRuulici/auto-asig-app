import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      emit(ForgotPasswordError('Please enter an email'));
      return;
    }

    emit(ForgotPasswordLoading());

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      emit(ForgotPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      emit(ForgotPasswordError(e.message ?? 'An error occurred'));
    } catch (e) {
      emit(ForgotPasswordError('An unknown error occurred'));
    }
  }
}
