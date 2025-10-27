import 'package:equatable/equatable.dart';

abstract class RegistrationState extends Equatable {
  @override
  List<Object> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {} //clasa noua

class RegistrationCheckboxState extends RegistrationState {
  final bool isChecked;

  RegistrationCheckboxState(this.isChecked);

  @override
  List<Object> get props => [isChecked];
}

class RegistrationSuccess extends RegistrationState {}

class RegistrationGoogleSuccess extends RegistrationState {}

class RegistrationVerificationEmailSent extends RegistrationState {} //clasa noua

class RegistrationFailure extends RegistrationState {
  final String errorMessage;

  RegistrationFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

