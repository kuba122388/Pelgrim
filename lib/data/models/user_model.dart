import 'package:pelgrim/domain/entities/user.dart';

class UserModel {
  final String id; // uid
  final String? groupId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final bool isAdmin;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.groupId,
    required this.isAdmin,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'groupId': groupId,
      'isAdmin': isAdmin,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map["id"],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      groupId: map['groupId'],
      isAdmin: map['isAdmin'],
    );
  }

  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      groupId: entity.groupId,
      isAdmin: entity.isAdmin,
      phone: entity.phone,
    );
  }

  User toEntity() {
    return User(
      id: id,
      groupId: groupId,
      firstName: firstName,
      lastName: lastName,
      isAdmin: isAdmin,
      email: email,
      phone: phone,
    );
  }
}
