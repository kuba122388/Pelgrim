class User {
  final String id; // uid
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String groupName;
  final bool isAdmin;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.groupName,
    required this.isAdmin,
  });
}
