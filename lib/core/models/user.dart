class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  String email;
  String phone;
  String country;
  String profilePictureUrl;

  UserModel(
    this.id, {
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.country,
    this.profilePictureUrl = '',
  });

  List<Object> get props => [
        firstName,
        id,
        email,
        phone,
        country,
        profilePictureUrl,
      ];

  static UserModel empty = UserModel(
    '',
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    country: '',
    profilePictureUrl: '',
  );

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'id': id,
      'email': email,
      'phone': phone,
      'country': country,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      country: json['country'] as String,
      profilePictureUrl: json['profilePictureUrl'] as String? ?? '',
    );
  }
}