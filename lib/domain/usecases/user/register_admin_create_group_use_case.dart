import 'dart:ui';

import 'package:pelgrim/core/errors/use_case_exception.dart';
import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/domain/entities/user_session.dart';
import 'package:pelgrim/domain/repositories/auth_repository.dart';
import 'package:pelgrim/domain/repositories/group_repository.dart';
import 'package:pelgrim/domain/repositories/user_repository.dart';

class RegisterAdminCreateGroupUseCase {
  final AuthRepository _authRepository;
  final GroupRepository _groupRepository;
  final UserRepository _userRepository;

  RegisterAdminCreateGroupUseCase(
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

      Group groupToCreate = Group(
        id: null,
        color: color,
        secondColor: secondColor,
        groupColor: groupColor,
        groupCity: groupCity,
      );

      final createdGroup = await _groupRepository.createGroup(groupToCreate);
      groupId = createdGroup.id!;

      User user = User(
        id: userId,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        isAdmin: true,
        groupId: groupId,
      );

      await _userRepository.createUser(user);

      await _groupRepository.joinUserToGroup(
        groupId: groupId,
        user: user,
      );
      return UserSession(user: user, group: createdGroup);
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
