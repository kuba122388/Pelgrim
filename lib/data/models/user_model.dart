import 'package:pelgrim/domain/entities/user.dart';

class UserModel {
  final String id; // uid
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String groupName;
  final bool isAdmin;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.groupName,
    required this.isAdmin,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'FirstName': firstName,
      'LastName': lastName,
      'Email': email,
      'Phone': phone,
      'GroupName': groupName,
      'Admin': isAdmin,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map["id"],
      firstName: map['FirstName'],
      lastName: map['LastName'],
      email: map['Email'],
      phone: map['Phone'],
      groupName: map['GroupName'],
      isAdmin: map['Admin'],
    );
  }

  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      groupName: entity.groupName,
      isAdmin: entity.isAdmin,
      phone: entity.phone,
    );
  }

  User toEntity() {
    return User(
      id: id,
      groupName: groupName,
      firstName: firstName,
      lastName: lastName,
      isAdmin: isAdmin,
      email: email,
      phone: phone,
    );
  }
}
