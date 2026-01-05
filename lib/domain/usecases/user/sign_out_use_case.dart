import 'package:pelgrim/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  Future<void> execute() async {
    await _authRepository.signOut();

    // TODO: WYCZYŚCIĆ PROVIDERY!
  }
}
