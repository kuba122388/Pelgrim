import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/domain/repositories/user_repository.dart';

class GetAllUsersByGroupUseCase {
  final UserRepository _userRepository;

  GetAllUsersByGroupUseCase(this._userRepository);

  Future<List<User>> execute(String groupId) async {
    return _userRepository.getAllUsersByGroup(groupId);
  }
}
