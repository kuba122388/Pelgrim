import 'package:pelgrim/domain/entities/my_user.dart';

class MyUserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String groupName;
  final bool isAdmin;

  MyUserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.groupName,
    required this.isAdmin,
  });

  Map<String, dynamic> toMap() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'Email': email,
      'Phone': phone,
      'GroupName': groupName,
      'Admin': isAdmin,
    };
  }

  factory MyUserModel.fromMap(Map<String, dynamic> map) {
    return MyUserModel(
      firstName: map['FirstName'],
      lastName: map['LastName'],
      email: map['Email'],
      phone: map['Phone'],
      groupName: map['GroupName'],
      isAdmin: map['Admin'],
    );
  }

  factory MyUserModel.fromEntity(MyUser entity) {
    return MyUserModel(
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      groupName: entity.groupName,
      isAdmin: entity.isAdmin,
      phone: entity.phone,
    );
  }

  MyUser toEntity() {
    return MyUser(
      groupName: groupName,
      firstName: firstName,
      lastName: lastName,
      isAdmin: isAdmin,
      email: email,
      phone: phone,
    );
  }
}
