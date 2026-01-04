import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/domain/repositories/user_repository.dart';

class GetUserDataUseCase {
  final UserRepository _repository;

  GetUserDataUseCase(this._repository);

  Future<User> execute(String email) async {}
}
