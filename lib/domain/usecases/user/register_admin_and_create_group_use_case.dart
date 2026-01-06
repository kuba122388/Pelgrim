import 'dart:ui';

import 'package:pelgrim/core/errors/use_case_exception.dart';
import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/domain/entities/user_session.dart';
import 'package:pelgrim/domain/repositories/auth_repository.dart';
import 'package:pelgrim/domain/repositories/group_repository.dart';
import 'package:pelgrim/domain/repositories/user_repository.dart';

class RegisterAdminAndCreateGroupUseCase {
  final AuthRepository _authRepository;
  final GroupRepository _groupRepository;
  final UserRepository _userRepository;

  RegisterAdminAndCreateGroupUseCase(
    this._authRepository,
    this._groupRepository,
    this._userRepository,
  );

  Future<UserSession> execute({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String groupColor,
    required String groupCity,
    required Color color,
    required Color secondColor,
  }) async {
    String? userId;
    String? groupId;

    try {
      userId = await _authRepository.register(
        email: email,
        password: password,
      );

      Group group = Group(
        color: color,
        secondColor: secondColor,
        groupColor: groupColor,
        groupCity: groupCity,
      );

      groupId = group.id;
      await _groupRepository.createGroup(group);

      User user = User(
        id: userId,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        isAdmin: true,
        groupId: group.id,
      );

      await _userRepository.createUser(user);

      await _groupRepository.joinUserToGroup(
        groupId: group.id,
        userId: userId,
        isAdmin: true,
      );
      return UserSession(user: user, group: group);
    } catch (e) {
      if (userId != null) {
        await _authRepository.deleteAccount(userId);
      }
      if (groupId != null) {
        await _groupRepository.deleteGroup(groupId);
      }
      throw UseCaseException('Rejestracja administratora i utworzenie grupy nie powiodły się');
    }
  }
}
