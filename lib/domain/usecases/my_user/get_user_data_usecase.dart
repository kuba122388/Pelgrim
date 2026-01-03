import 'package:pelgrim/domain/entities/my_user.dart';
import 'package:pelgrim/domain/repositories/user_repository.dart';

class GetUserDataUseCase {
  final UserRepository _repository;

  GetUserDataUseCase(this._repository);

  Future<MyUser> execute(String email) async {
    final group = await _repository.getUserGroup(email);
    return await _repository.getUserData(email, group);
  }
}
