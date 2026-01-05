import 'dart:ui';

import 'package:pelgrim/core/errors/use_case_exception.dart';
import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/entities/user.dart';
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

  Future<void> execute({
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

    try {
      userId = await _authRepository.register(
        email: email,
        password: password,
      );

      User user = User(
        id: userId,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        isAdmin: false,
        groupId: null,
      );

      await _userRepository.createUser(user);

      Group group = Group(
        color: color,
        secondColor: secondColor,
        groupColor: groupColor,
        groupCity: groupCity,
      );

      await _groupRepository.createGroup(group);

      await _groupRepository.joinUserToGroup(groupId: group.id, userId: userId, isAdmin: true);
    } catch (e) {
      if (userId != null) {
        await _authRepository.deleteAccount(userId);
      }
      throw UseCaseException('Rejestracja administratora i utworzenie grupy nie powiodły się');
    }
  }
}
