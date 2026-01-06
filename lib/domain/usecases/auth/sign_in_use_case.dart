import 'package:pelgrim/domain/entities/user_session.dart';
import 'package:pelgrim/domain/repositories/auth_repository.dart';
import 'package:pelgrim/domain/repositories/group_repository.dart';
import 'package:pelgrim/domain/repositories/user_repository.dart';

class SignInUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final GroupRepository _groupRepository;

  SignInUseCase(
    this._authRepository,
    this._userRepository,
    this._groupRepository,
  );

  Future<UserSession> execute({
    required String email,
    required String password,
  }) async {
    final userId = await _authRepository.signIn(
      email: email,
      password: password,
    );

    final user = await _userRepository.getUserById(userId);

    final group = await _groupRepository.getGroup(user.groupId);

    return UserSession(user: user, group: group);
  }
}
