import 'package:auto_asig/core/data/http_data.dart';
import 'package:auto_asig/core/data/http_user_data.dart';
import 'package:auto_asig/core/models/user.dart';
import 'package:bloc/bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  // Initialize with current user data
  void initializeWithUser(UserModel user) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(user: user));
    } else {
      emit(ProfileLoaded(user: user));
    }
  }

  // Fetch user profile data
  Future<void> fetchProfile(String userId) async {
    try {
      emit(ProfileLoading());

      final user = await readUserData(userId);

      if (user != null) {
        emit(ProfileLoaded(user: user));
      } else {
        emit(const ProfileError('Failed to load profile'));
      }
    } catch (e) {
      emit(ProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

Future<void> updateProfile({
  required String userId,
  required String firstName,
  required String lastName,
  required String email,
  required String phone,
  required String country,
  String? profilePictureUrl,
}) async {
  try {
    final currentState = state;
    
    emit(ProfileLoading());

    if (currentState is ProfileLoaded) {
      await updateUserData(
        userId,
        firstName,
        lastName,
        email,
        phone,
        country,
        profilePictureUrl,
      );

      final updatedUser = UserModel(
        currentState.user.id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        country: country,
        profilePictureUrl: profilePictureUrl ?? currentState.user.profilePictureUrl,
      );

      emit(currentState.copyWith(user: updatedUser));
    }
  } catch (e) {
    emit(ProfileError('Failed to update profile: ${e.toString()}'));
  }
}

  // Update individual fields
  void updateFirstName(String firstName) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedUser = UserModel(
        currentState.user.id,
        firstName: firstName,
        lastName: currentState.user.lastName,
        email: currentState.user.email,
        phone: currentState.user.phone,
        country: currentState.user.country,
      );
      emit(currentState.copyWith(user: updatedUser));
    }
  }

  void updateLastName(String lastName) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedUser = UserModel(
        currentState.user.id,
        firstName: currentState.user.firstName,
        lastName: lastName,
        email: currentState.user.email,
        phone: currentState.user.phone,
        country: currentState.user.country,
      );
      emit(currentState.copyWith(user: updatedUser));
    }
  }

  void updateEmail(String email) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      currentState.user.email = email;
      emit(currentState.copyWith(user: currentState.user));
    }
  }

  void updatePhone(String phone) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      currentState.user.phone = phone;
      emit(currentState.copyWith(user: currentState.user));
    }
  }

  void updateCountry(String country) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      currentState.user.country = country;
      emit(currentState.copyWith(user: currentState.user));
    }
  }
}