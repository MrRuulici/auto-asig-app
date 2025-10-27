part of 'profile_cubit.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final UserModel user;

  const ProfileLoaded({required this.user});

  ProfileLoaded copyWith({
    UserModel? user,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);
}