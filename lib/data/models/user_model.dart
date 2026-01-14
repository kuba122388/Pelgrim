import 'package:hive/hive.dart';

import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id; // UID

  @HiveField(1)
  final String groupId;

  @HiveField(2)
  final String firstName;

  @HiveField(3)
  final String lastName;

  @HiveField(4)
  final String email;

  @HiveField(5)
  final String phone;

  @HiveField(6)
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
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'group_id': groupId,
      'is_admin': isAdmin,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map["id"],
      firstName: map['first_name'],
      lastName: map['last_name'],
      email: map['email'] ?? "",
      phone: map['phone'] ?? "",
      groupId: map['group_id'] ?? "",
      isAdmin: map['is_admin'] ?? "",
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
