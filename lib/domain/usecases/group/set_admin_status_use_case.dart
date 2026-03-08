import 'package:pelgrim/core/errors/use_case_exception.dart';
import 'package:pelgrim/domain/repositories/group_repository.dart';
import 'package:pelgrim/domain/repositories/user_repository.dart';

import '../../entities/user.dart';

class SetAdminStatusUseCase {
  final GroupRepository _groupRepository;
  final UserRepository _userRepository;

  SetAdminStatusUseCase(
    this._groupRepository,
    this._userRepository,
  );

  Future<void> execute({
    required String currentUserId,
    required String groupId,
    required User targetUser,
    required bool isAdmin,
  }) async {
    final currentUser = await _userRepository.getUserById(currentUserId);

    if (!currentUser.isAdmin || currentUser.groupId != groupId) {
      throw UseCaseException('Brak uprawnień do zmiany roli użytkownika');
    }

    await _groupRepository.setAdminStatus(
      groupId: groupId,
      user: targetUser,
      isAdmin: isAdmin,
    );
  }
}
