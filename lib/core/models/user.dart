class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  String email;
  String phone;
  String country;

  UserModel(
    this.id, {
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.country,
  });

  // @override
  List<Object> get props => [
        firstName,
        id,
        email,
        phone,
        country,
      ];

  static UserModel empty = UserModel(
    '',
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    country: '',
  );

  Map<String, dynamic> toJson() {
    return {
      'firstName':
          firstName, // Todo: Trebuie actualizat deoarece nu exista parametrul firstName

      'id': id,
      'email': email,
      'phone': phone,
      'country': country,
    };
  }

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      json['id']
          as String, // Todo: Trebuie actualizat deoarece nu exista parametrul id
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      country: json['country'] as String,
    );
  }
}
