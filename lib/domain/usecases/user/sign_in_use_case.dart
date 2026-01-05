import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/domain/repositories/auth_repository.dart';
import 'package:pelgrim/domain/repositories/user_repository.dart';

class SignInUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  SignInUseCase(this._authRepository, this._userRepository);

  Future<User> execute({
    required String email,
    required String password,
  }) async {
    final userId = await _authRepository.signIn(
      email: email,
      password: password,
    );

    return await _userRepository.getUserById(userId);
  }
}
