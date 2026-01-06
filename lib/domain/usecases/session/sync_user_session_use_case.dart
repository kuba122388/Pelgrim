import 'package:pelgrim/domain/entities/user_session.dart';
import 'package:pelgrim/domain/repositories/group_repository.dart';
import 'package:pelgrim/domain/repositories/user_repository.dart';
import 'package:pelgrim/domain/repositories/user_session_repository.dart';

class SyncUserSessionUseCase {
  final UserRepository _userRepository;
  final GroupRepository _groupRepository;
  final UserSessionRepository _sessionRepository;

  SyncUserSessionUseCase(this._userRepository, this._groupRepository, this._sessionRepository);

  Future<UserSession> execute(String userId) async {
    final user = await _userRepository.getUserById(userId);
    final group = await _groupRepository.getGroup(user.groupId);

    final updatedSession = UserSession(user: user, group: group);

    await _sessionRepository.saveLocalSession(updatedSession);

    return updatedSession;
  }
}
