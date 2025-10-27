// authentication_state.dart
import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {}

class AuthenticationFailure extends AuthenticationState {
  final String errorMessage;

  AuthenticationFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// Extinde AuthenticationState pentru a include starea vizibilității parolei
class PasswordVisibilityState extends AuthenticationState {
  final bool isPasswordVisible;

  PasswordVisibilityState(this.isPasswordVisible);

  @override
  List<Object> get props => [isPasswordVisible];
}
