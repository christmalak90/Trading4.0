class User {
  late String firstName;
  late String surName;
  late String email;
  late String? phone;
  late String password;

  User({
    required this.firstName,
    required this.surName,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": this.firstName,
      "surName": this.surName,
      "email": this.email,
      "phone": this.phone,
      "password": this.password,
    };
  }
}
