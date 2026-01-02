class MyUser {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final bool admin;

  MyUser({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.admin,
  });

  Map<String, dynamic> toMap() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'Email': email,
      'Phone': phone,
      'Admin': admin
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
        admin: map['Admin'],
        email: map['Email'],
        firstName: map['FirstName'],
        lastName: map['LastName'],
        phone: map['Phone']);
  }
}
