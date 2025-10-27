import 'package:auto_asig/core/data/constants.dart';
import 'package:auto_asig/core/data/http_user_data.dart';
import 'package:auto_asig/core/models/car_info.dart';
import 'package:auto_asig/core/models/id_model.dart';
import 'package:auto_asig/core/models/user.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  UserDataCubit()
      : super(UserDataInitial(
          member: emptyMember,
          carInfo: const [],
          idInfo: const [],
        ));

  // Use copyWith to set a new member
  void setMember(UserModel member) {
    // print('Setting member: ${member.id}');
    emit(state.copyWith(member: member));
  }

  // Clear the user data by setting the member to emptyMember
  void clearUserData() {
    emit(state.copyWith(member: emptyMember));
  }

  // Update email and phone, use copyWith for state changes
  void updateEmailAndPhone(String email, String phone) {
    final UserModel member = state.member;

    // Update the member's email and phone
    member.email = email;
    member.phone = phone;

    // Update the backend
    updateEmailAndPhoneForUser(member.id, email, phone);

    // Emit the updated state with the modified member
    emit(state.copyWith(member: member));
  }

  // Update the member using copyWith
  void updateMember(UserModel updatedMember) {
    print('🟢 UserDataCubit.updateMember called');
    print('🟢 New profilePictureUrl: ${updatedMember.profilePictureUrl}');    
    emit(state.copyWith(member: updatedMember));
  }

  // Add a new car to the carInfo list
  void addCar(CarInfo car) {
    final List<CarInfo> carInfo = state.carInfo;

    // Add the new car to the list
    carInfo.add(car);

    // Emit the updated state with the new carInfo list
    emit(state.copyWith(carInfo: carInfo));
  }

  // Remove a car from the carInfo list
  void removeCar(CarInfo car) {
    final List<CarInfo> carInfo = state.carInfo;

    // Remove the car from the list
    carInfo.remove(car);

    // Emit the updated state with the new carInfo list
    emit(state.copyWith(carInfo: carInfo));
  }

  // Update a car in the carInfo list
  void updateCar(CarInfo updatedCar) {
    final List<CarInfo> carInfo = state.carInfo;

    // Find the index of the car to update
    final int index = carInfo.indexWhere((car) => car.id == updatedCar.id);

    // Update the car at the index
    carInfo[index] = updatedCar;

    // Emit the updated state with the modified carInfo list
    emit(state.copyWith(carInfo: carInfo));
  }

  // Add a new ID to the idInfo list
  void addId(IdModel id) {
    final List<IdModel> idInfo = state.idInfo;

    // Add the new ID to the list
    idInfo.add(id);

    // Emit the updated state with the new idInfo list
    emit(state.copyWith(idInfo: idInfo));
  }

  // Remove an ID from the idInfo list
  void removeId(IdModel id) {
    final List<IdModel> idInfo = state.idInfo;

    // Remove the ID from the list
    idInfo.remove(id);

    // Emit the updated state with the new idInfo list
    emit(state.copyWith(idInfo: idInfo));
  }

  // Update an ID in the idInfo list
  void updateId(IdModel updatedId) {
    final List<IdModel> idInfo = state.idInfo;

    // Find the index of the ID to update
    final int index = idInfo.indexWhere((id) => id.id == updatedId.id);

    // Update the ID at the index
    idInfo[index] = updatedId;

    // Emit the updated state with the modified idInfo list
    emit(state.copyWith(idInfo: idInfo));
  }
}
