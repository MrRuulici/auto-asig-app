part of 'user_data_cubit.dart';

sealed class UserDataState extends Equatable {
  const UserDataState({
    required this.member,
    required this.carInfo,
    required this.idInfo,
  });

  final UserModel member;
  final List<CarInfo> carInfo;
  final List<IdModel> idInfo;

  @override
  List<Object> get props => [
        member,
        carInfo,
        idInfo,
      ];

  // write a copyWith method to copy the current state with some new values
  UserDataState copyWith({
    UserModel? member,
    List<CarInfo>? carInfo,
    List<IdModel>? idInfo,
  }) {
    return UserDataInitial(
      member: member ?? this.member,
      carInfo: carInfo ?? this.carInfo,
      idInfo: idInfo ?? this.idInfo,
    );
  }
}

class UserDataInitial extends UserDataState {
  const UserDataInitial({
    required super.member,
    required super.carInfo,
    required super.idInfo,
  });
}
