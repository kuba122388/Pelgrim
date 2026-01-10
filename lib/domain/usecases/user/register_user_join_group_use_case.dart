import 'package:pelgrim/core/errors/use_case_exception.dart';
import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/domain/entities/user_session.dart';
import 'package:pelgrim/domain/repositories/auth_repository.dart';
import 'package:pelgrim/domain/repositories/group_repository.dart';
import 'package:pelgrim/domain/repositories/user_repository.dart';

class RegisterUserJoinGroupUseCase {
  final AuthRepository _authRepository;
  final GroupRepository _groupRepository;
  final UserRepository _userRepository;

  RegisterUserJoinGroupUseCase(
    this._authRepository,
    this._groupRepository,
    this._userRepository,
  );

  Future<UserSession> execute({
    required String email,
    required String password,
    required String groupId,
    required String firstName,
    required String lastName,
    required String phone,
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
        groupId: groupId,
      );

      final Group group = await _groupRepository.getGroupById(groupId);

      await _userRepository.createUser(user);

      await _groupRepository.joinUserToGroup(groupId: groupId, userId: userId, isAdmin: false);

      return UserSession(user: user, group: group);
    } catch (e) {
      if (userId != null) {
        await _authRepository.deleteAccount(userId);
      }
      throw UseCaseException('Rejestracja użytkownika nie powiodła się');
    }
  }
}
